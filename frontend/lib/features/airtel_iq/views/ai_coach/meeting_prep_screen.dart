import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';
import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/meetings/providers/meeting_provider.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:frontend/features/airtel_iq/services/meeting_prep_intelligence_engine.dart';
import 'package:frontend/features/airtel_iq/knowledge/airtel_iq_knowledge_service.dart';
import 'package:frontend/features/airtel_iq/widgets/ai_loading_indicator.dart';
import 'package:frontend/features/airtel_iq/knowledge/product_enrichment_repository.dart';
import 'package:frontend/features/airtel_iq/services/meeting_prep_enablement_service.dart';

enum _PrepMode { scenario, history }

class MeetingPrepScreen extends ConsumerStatefulWidget {
  const MeetingPrepScreen({super.key});

  @override
  ConsumerState<MeetingPrepScreen> createState() => _MeetingPrepScreenState();
}

class _MeetingPrepScreenState extends ConsumerState<MeetingPrepScreen> {
  _PrepMode _prepMode = _PrepMode.scenario;

  // ── Scenario mode inputs ──────────────────────────────────────────────────
  String? _industry;
  String? _meetingType;
  String? _companySize;
  List<String> _painPoints = [];
  String? _objective;

  // Phase 2 — Scenario Mode extra context
  // ignore: prefer_final_fields
  List<String> _existingProducts = [];
  final TextEditingController _notesController = TextEditingController();
  bool _showExtraContext = false;

  // ── History mode inputs ───────────────────────────────────────────────────
  Customer? _selectedCustomer;
  Meeting? _selectedMeeting;

  // Enrich Context (optional — does not block generation)
  String? _enrichIndustry;
  String? _enrichMeetingType;
  String? _enrichCompanySize;
  List<String> _enrichPainPoints = [];

  // Phase 2 — History Mode extra context
  // ignore: prefer_final_fields
  List<String> _enrichExistingProducts = [];
  final TextEditingController _enrichNotesController = TextEditingController();

  // ── State ─────────────────────────────────────────────────────────────────
  bool _isLoading = false;
  MeetingPrepV3Result? _result;
  final MeetingPrepIntelligenceEngine _engine = MeetingPrepIntelligenceEngine();
  final AirtelIqKnowledgeService _knowledge = AirtelIqKnowledgeService();

  // ── Reference data ────────────────────────────────────────────────────────
  static const List<String> _industries = [
    'Automotive',
    'Banking & Financial Services',
    'E-Commerce',
    'Education',
    'Energy & Utilities',
    'Government',
    'Healthcare',
    'Hospitality',
    'IT & ITES',
    'Logistics',
    'Manufacturing',
    'Media & Entertainment',
    'Retail',
    'Telecom & Carriers',
    'Travel & Tourism',
  ];

  static const List<String> _meetingTypes = [
    'Discovery Meeting',
    'Proposal Meeting',
    'Renewal Meeting',
    'Executive Alignment Meeting',
    'Technical Workshop',
    'Solution Demonstration',
    'Renewal Negotiation',
    'Upsell Review',
    'Quarterly Business Review',
    'Stakeholder Mapping Session',
  ];

  static const List<String> _companySizes = [
    'Small Business (1–50)',
    'Mid-Market (51–250)',
    'Large Enterprise (251–1000)',
    'Enterprise (1000+)',
  ];

  /// Fallback used when no industry is selected.
  static const List<String> _fallbackPainPoints = [
    'Rising Telecom Costs',
    'Branch Connectivity',
    'Workforce Communication',
    'Remote Work',
    'Security & Compliance',
    'Customer Engagement',
    'Digital Transformation',
    'Operational Efficiency',
    'Business Continuity',
    'Legacy Systems',
  ];

  static const List<String> _objectives = [
    'Understand Requirements',
    'Identify Pain Points',
    'Present Airtel Solutions',
    'Validate Solution Fit',
    'Handle Objections',
    'Secure Next Meeting',
    'Drive Pilot Adoption',
    'Support Renewal',
    'Explore Upsell Opportunities',
  ];

  // Products are loaded dynamically from AirtelIqKnowledgeService

  // ── Logic ─────────────────────────────────────────────────────────────────

  /// Derives a dynamic, industry-specific pain point list from repository data.
  ///
  /// Sources:
  ///   1. [ProductIntelligence.painPointsSolved] from all products serving the industry
  ///      — short tags already aligned to engine scoring.
  ///   2. [IndustryIntelligence.businessChallenges] + [technologyChallenges]
  ///      — rich, specific phrases (e.g. Fleet Visibility, Fraud Detection).
  ///
  /// Falls back to [_fallbackPainPoints] when no industry is provided or recognised.
  List<String> _derivePainPoints(String? industry) {
    if (industry == null) return _fallbackPainPoints;

    final industryData = _knowledge.getIndustryByName(industry);
    if (industryData == null) return _fallbackPainPoints;

    final Set<String> combined = {};

    // Source 1: painPointsSolved from products that explicitly serve this industry
    for (final product in _knowledge.getAllProducts()) {
      if (product.industries.contains(industry)) {
        combined.addAll(product.painPointsSolved);
      }
    }

    // Source 2: business and technology challenges from IndustryIntelligence
    // These are the rich, sector-specific phrases the AM actually thinks in
    combined.addAll(industryData.businessChallenges);
    combined.addAll(industryData.technologyChallenges);

    final sorted = combined.toList()..sort();
    return sorted;
  }

  // ── Logic ─────────────────────────────────────────────────────────────────

  bool get _canGenerate {
    if (_isLoading) return false;
    if (_prepMode == _PrepMode.scenario) {
      // Phase 4: Industry is the ONLY mandatory field.
      // Meeting Type and all other fields are optional enrichment.
      return _industry != null;
    }
    // History: customer + meeting required; industry/context are optional
    return _selectedCustomer != null && _selectedMeeting != null;
  }


  String _inferMeetingType(Meeting meeting) {
    final title = (meeting.title ?? '').toLowerCase();
    if (title.contains('proposal')) return 'Proposal Meeting';
    if (title.contains('renewal') && title.contains('negot')) return 'Renewal Negotiation';
    if (title.contains('renewal')) return 'Renewal Meeting';
    if (title.contains('qbr') || title.contains('quarterly')) return 'Quarterly Business Review';
    if (title.contains('technical') || title.contains('workshop')) return 'Technical Workshop';
    if (title.contains('demo')) return 'Solution Demonstration';
    if (title.contains('executive')) return 'Executive Alignment Meeting';
    if (title.contains('upsell')) return 'Upsell Review';
    return 'Discovery Meeting';
  }

  Future<void> _generatePrep() async {
    setState(() {
      _isLoading = true;
      _result = null;
    });

    try {
      MeetingPrepV3Input input;

      if (_prepMode == _PrepMode.scenario) {
        input = MeetingPrepV3Input(
          industry: _industry,
          meetingType: _meetingType,
          companySize: _companySize,
          painPoints: _painPoints,
          objective: _objective,
          existingAirtelProducts: _existingProducts,
          situationNotes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );
      } else {
        // History mode: prefer enriched values, fall back to inferred
        final effectiveMeetingType =
            _enrichMeetingType ?? _inferMeetingType(_selectedMeeting!);
        final allMeetings = ref.read(meetingListProvider).value ?? [];
        final previousCount =
            allMeetings.where((m) => m.customerId == _selectedCustomer!.id).length;

        input = MeetingPrepV3Input(
          industry: _enrichIndustry,
          meetingType: effectiveMeetingType,
          companySize: _enrichCompanySize,
          painPoints: _enrichPainPoints,
          customerName: _selectedCustomer!.name,
          previousMeetingCount: previousCount,
          existingAirtelProducts: _enrichExistingProducts,
          situationNotes: _enrichNotesController.text.trim().isEmpty
              ? null
              : _enrichNotesController.text.trim(),
        );
      }

      final result = await _engine.generate(input);
      if (mounted) {
        setState(() {
          _result = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _copyBriefToClipboard() {
    final r = _result;
    if (r == null) return;
    final sb = StringBuffer();
    sb.writeln('MEETING PREPARATION BRIEF');
    sb.writeln();
    sb.writeln('CONTEXT');
    sb.writeln(r.contextSummary);
    sb.writeln();
    sb.writeln('TOP CHALLENGES');
    for (var i = 0; i < r.topChallenges.length; i++) {
      sb.writeln('${i + 1}. ${r.topChallenges[i]}');
    }
    sb.writeln();
    sb.writeln('DISCOVERY QUESTIONS');
    for (var i = 0; i < r.discoveryQuestions.length; i++) {
      sb.writeln('${i + 1}. ${r.discoveryQuestions[i]}');
    }
    sb.writeln();
    sb.writeln('PRIMARY RECOMMENDATION');
    sb.writeln(r.primaryRecommendation.productName);
    sb.writeln('Why: ${r.primaryRecommendation.selectionReason}');
    if (r.supportingRecs.isNotEmpty) {
      sb.writeln();
      sb.writeln('SUPPORTING RECOMMENDATIONS');
      for (final p in r.supportingRecs) {
        sb.writeln('• ${p.productName}');
        sb.writeln('  Why: ${p.selectionReason}');
      }
    }
    sb.writeln();
    if (r.topObjections.isNotEmpty) {
      sb.writeln('LIKELY OBJECTIONS & RESPONSES');
      for (var i = 0; i < r.topObjections.length; i++) {
        sb.writeln('${i + 1}. ${r.topObjections[i].objection}');
        sb.writeln('   → ${r.topObjections[i].response}');
        sb.writeln();
      }
    }
    sb.writeln('MEETING STRATEGY');
    sb.writeln('Lead With: ${r.meetingStrategy.leadWith}');
    sb.writeln('Avoid: ${r.meetingStrategy.avoid}');
    sb.writeln('Validate: ${r.meetingStrategy.validate}');
    sb.writeln('Close With: ${r.meetingStrategy.closeWith}');
    sb.writeln();
    sb.writeln('NEXT BEST ACTION');
    sb.writeln(r.nextBestAction);

    Clipboard.setData(ClipboardData(text: sb.toString().trimRight()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meeting brief copied to clipboard')),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Meeting Preparation'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildModeSelector(),
            const SizedBox(height: 24),
            if (_prepMode == _PrepMode.scenario)
              _buildScenarioMode()
            else
              _buildHistoryMode(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _canGenerate ? _generatePrep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Generate Preparation Brief',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),
            if (_isLoading)
              const AiLoadingIndicator(
                  message: 'Analysing context and generating brief...')
            else if (_result != null)
              _buildV3Results(),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return SegmentedButton<_PrepMode>(
      segments: const [
        ButtonSegment(
            value: _PrepMode.scenario,
            label: Text('Scenario Mode'),
            icon: Icon(Icons.psychology_outlined)),
        ButtonSegment(
            value: _PrepMode.history,
            label: Text('Customer History'),
            icon: Icon(Icons.history)),
      ],
      selected: {_prepMode},
      onSelectionChanged: (s) => setState(() {
        _prepMode = s.first;
        _result = null;
      }),
    );
  }

  // ── Scenario Mode ─────────────────────────────────────────────────────────

  Widget _buildScenarioMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDropdown(
          label: 'Industry *',
          value: _industry,
          items: _industries,
          onChanged: (v) => setState(() {
            _industry = v;
            // Clear pain point when industry changes — previous selection may not be in new list
            _painPoints.clear();
            _result = null;
          }),
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: 'Meeting Type (optional — improves specificity)',
          value: _meetingType,
          items: _meetingTypes,
          isOptional: true,
          onChanged: (v) => setState(() {
            _meetingType = v;
            _result = null;
          }),
        ),
        const SizedBox(height: 16),
        _buildPainPointsSection(
          industry: _industry,
          selected: _painPoints,
          onToggle: (v) => setState(() {
            if (_painPoints.contains(v)) {
              _painPoints.remove(v);
            } else if (_painPoints.length < 3) {
              _painPoints.add(v);
            }
            _result = null;
          }),
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: 'Company Size (optional)',
          value: _companySize,
          items: _companySizes,
          isOptional: true,
          onChanged: (v) => setState(() {
            _companySize = v;
            _result = null;
          }),
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: 'Meeting Objective (optional)',
          value: _objective,
          items: _objectives,
          isOptional: true,
          onChanged: (v) => setState(() {
            _objective = v;
            _result = null;
          }),
        ),
        const SizedBox(height: 16),

        // Phase 2 -- expandable extra context
        _buildExtraContextSection(
          existingProducts: _existingProducts,
          notesController: _notesController,
          expanded: _showExtraContext,
          onToggle: () => setState(() => _showExtraContext = !_showExtraContext),
          onProductToggle: (name) => setState(() {
            _existingProducts.contains(name)
                ? _existingProducts.remove(name)
                : _existingProducts.add(name);
            _result = null;
          }),
          onNoteChanged: (_) => setState(() => _result = null),
        ),
      ],
    );
  }

  // Phase 2 -- collapsible "Add more context" section (shared by Scenario + Enrich)
  Widget _buildExtraContextSection({
    required List<String> existingProducts,
    required TextEditingController notesController,
    required bool expanded,
    required VoidCallback onToggle,
    required void Function(String) onProductToggle,
    required void Function(String) onNoteChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Toggle header
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    expanded ? Icons.expand_less : Icons.add,
                    size: 18,
                    color: AppConstants.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    expanded ? 'Hide extra context' : 'Add more context (optional)',
                    style: TextStyle(
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  if (!expanded && (existingProducts.isNotEmpty || notesController.text.isNotEmpty))
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'context added',
                        style: TextStyle(
                            fontSize: 11, color: AppConstants.primaryColor),
                      ),
                    ),
                ],
              ),
            ),
          ),

          if (expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Existing products label
                  const Text(
                    'Existing Airtel Products',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select what the customer already has — boosts cross-sell recommendations.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 10),

                  // Product chip grid
                  Builder(
                    builder: (context) {
                      final allProductNames = AirtelIqKnowledgeService().getAllProducts().map((p) => p.name).toList();
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: allProductNames.map((name) {
                          final selected = existingProducts.contains(name);
                          // Shorten display name for chips
                          final label = name.replaceAll('Airtel ', '');
                          return FilterChip(
                            label: Text(label,
                              style: TextStyle(
                                fontSize: 12,
                                color: selected ? Colors.white : Colors.grey.shade700,
                                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                            selected: selected,
                            onSelected: (_) => onProductToggle(name),
                            selectedColor: AppConstants.primaryColor,
                            checkmarkColor: Colors.white,
                            backgroundColor: Colors.grey.shade100,
                            side: BorderSide(
                              color: selected
                                  ? AppConstants.primaryColor
                                  : Colors.grey.shade300,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                          );
                        }).toList(),
                      );
                    }
                  ),
                  const SizedBox(height: 16),

                  // Situation notes
                  const Text(
                    'Situation Notes',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Optional free-text — e.g. "branch outages last quarter, evaluating SD-WAN".',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: notesController,
                    maxLines: 3,
                    onChanged: onNoteChanged,
                    decoration: InputDecoration(
                      hintText:
                          'e.g. branch outages, evaluating SD-WAN alternatives, MPLS renewal coming up',
                      hintStyle: TextStyle(
                          fontSize: 12, color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPainPointsSection({
    required String? industry,
    required List<String> selected,
    required void Function(String) onToggle,
  }) {
    final items = _derivePainPoints(industry);
    final label = industry != null
        ? 'Pain Points — specific to ${industry.split(' ').first} sector (optional, max 3)'
        : 'Pain Points (select industry first for targeted options)';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((name) {
            final isSelected = selected.contains(name);
            final isDisabled = !isSelected && selected.length >= 3;
            return FilterChip(
              label: Text(name,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected 
                      ? Colors.white 
                      : (isDisabled ? Colors.grey.shade400 : Colors.grey.shade700),
                  )),
              selected: isSelected,
              onSelected: isDisabled ? null : (_) => onToggle(name),
              selectedColor: AppConstants.primaryColor,
              checkmarkColor: Colors.white,
              backgroundColor: Colors.white,
              disabledColor: Colors.grey.shade100,
              side: BorderSide(
                color: isSelected
                    ? AppConstants.primaryColor
                    : (isDisabled ? Colors.grey.shade200 : Colors.grey.shade300),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isOptional = false,
  }) {
    // When isOptional, "Not Known" is the first item and maps to null.
    // This allows users to always return to an unspecified state after
    // opening a dropdown, keeping optional fields truly optional.
    const notKnown = 'Not Known';
    final displayItems = isOptional ? [notKnown, ...items] : items;
    final displayValue = isOptional ? (value ?? notKnown) : value;

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      initialValue: displayValue,
      isExpanded: true,
      items: displayItems
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: isOptional
          ? (v) => onChanged(v == notKnown ? null : v)
          : onChanged,
    );
  }

  // ── History Mode ──────────────────────────────────────────────────────────

  Widget _buildHistoryMode() {
    final customersAsync = ref.watch(customerListProvider);
    final meetingsAsync = ref.watch(meetingListProvider);

    return customersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error loading customers: $err')),
      data: (customers) {
        final customerMeetings =
            (_selectedCustomer != null && meetingsAsync.value != null)
                ? meetingsAsync.value!
                    .where((m) => m.customerId == _selectedCustomer!.id)
                    .toList()
                : <Meeting>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Customer dropdown
            DropdownButtonFormField<Customer>(
              decoration: InputDecoration(
                labelText: 'Select Customer *',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
              ),
              initialValue: _selectedCustomer,
              isExpanded: true,
              items: customers
                  .map((c) =>
                      DropdownMenuItem(value: c, child: Text(c.name)))
                  .toList(),
              onChanged: (v) => setState(() {
                _selectedCustomer = v;
                _selectedMeeting = null;
                _result = null;
              }),
            ),
            const SizedBox(height: 16),

            // Meeting dropdown
            DropdownButtonFormField<Meeting>(
              decoration: InputDecoration(
                labelText: 'Select Meeting *',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
              ),
              initialValue: _selectedMeeting,
              isExpanded: true,
              items: customerMeetings
                  .map((m) => DropdownMenuItem(
                      value: m,
                      child: Text(m.title ?? 'Untitled Meeting')))
                  .toList(),
              onChanged: _selectedCustomer == null
                  ? null
                  : (v) => setState(() {
                        _selectedMeeting = v;
                        _result = null;
                      }),
            ),
            const SizedBox(height: 24),

            // Enrich Context panel
            _buildEnrichContextPanel(),
          ],
        );
      },
    );
  }

  Widget _buildEnrichContextPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.blue.shade700, size: 18),
              const SizedBox(width: 8),
              Text(
                'Enrich Context',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.blue.shade800,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'optional — improves intelligence',
                  style: TextStyle(
                      fontSize: 11, color: Colors.blue.shade700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Without industry context, preparation is based on meeting methodology defaults.',
            style:
                TextStyle(fontSize: 12, color: Colors.blue.shade600),
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'Industry',
            value: _enrichIndustry,
            items: _industries,
            isOptional: true,
            onChanged: (v) => setState(() {
              _enrichIndustry = v;
              // Clear pain point when industry changes
              _enrichPainPoints.clear();
              _result = null;
            }),
          ),
          const SizedBox(height: 12),
          _buildDropdown(
            label: 'Meeting Type',
            value: _enrichMeetingType,
            items: _meetingTypes,
            isOptional: true,
            onChanged: (v) => setState(() {
              _enrichMeetingType = v;
              _result = null;
            }),
          ),
          const SizedBox(height: 12),
          _buildPainPointsSection(
            industry: _enrichIndustry,
            selected: _enrichPainPoints,
            onToggle: (v) => setState(() {
              if (_enrichPainPoints.contains(v)) {
                _enrichPainPoints.remove(v);
              } else if (_enrichPainPoints.length < 3) {
                _enrichPainPoints.add(v);
              }
              _result = null;
            }),
          ),
          const SizedBox(height: 12),
          _buildDropdown(
            label: 'Company Size',
            value: _enrichCompanySize,
            items: _companySizes,
            isOptional: true,
            onChanged: (v) => setState(() {
              _enrichCompanySize = v;
              _result = null;
            }),
          ),
          const SizedBox(height: 12),

          // Phase 2 -- extra context in History Mode
          _buildExtraContextSection(
            existingProducts: _enrichExistingProducts,
            notesController: _enrichNotesController,
            expanded: _showExtraContext,
            onToggle: () => setState(() => _showExtraContext = !_showExtraContext),
            onProductToggle: (name) => setState(() {
              _enrichExistingProducts.contains(name)
                  ? _enrichExistingProducts.remove(name)
                  : _enrichExistingProducts.add(name);
              _result = null;
            }),
            onNoteChanged: (_) => setState(() => _result = null),
          ),
        ],
      ),
    );
  }

  // ── V3 Results ────────────────────────────────────────────────────────────

  Widget _buildV3Results() {
    final r = _result!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(),
        const SizedBox(height: 16),

        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Meeting Brief',
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.copy, size: 16),
              label: const Text('Copy Brief'),
              style: TextButton.styleFrom(
                foregroundColor: AppConstants.primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onPressed: _copyBriefToClipboard,
            ),
          ],
        ),

        // Methodology-only notice
        if (r.isMethodologyOnlyMode) ...[
          const SizedBox(height: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: Colors.amber.shade700, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Brief based on meeting methodology defaults. '
                    'Add industry in Enrich Context for full intelligence.',
                    style: TextStyle(
                        fontSize: 12, color: Colors.amber.shade800),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),

        SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Context Summary
              _V3Card(
                title: 'Context Summary',
                icon: Icons.article_outlined,
                iconColor: Colors.blue,
                child: Text(
                  r.contextSummary,
                  style: TextStyle(
                      color: Colors.grey.shade800, height: 1.55),
                ),
              ),

              // Top Challenges (always rendered first regardless of mode)
              _V3Card(
                title: 'Top Likely Challenges',
                icon: Icons.radar,
                iconColor: Colors.deepOrange,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: r.topChallenges
                      .asMap()
                      .entries
                      .map((e) => _numberedRow(e.key + 1, e.value))
                      .toList(),
                ),
              ),

              // Phase 1: objectionsDominant — Objections rendered BEFORE questions
              // when meeting type is negotiation/objection-heavy (e.g. Renewal Negotiation)
              if (r.objectionsDominant && r.topObjections.isNotEmpty)
                _V3Card(
                  title: 'Handle These Objections First',
                  icon: Icons.shield_outlined,
                  iconColor: Colors.red,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: r.topObjections
                        .asMap()
                        .entries
                        .map((e) => _ObjectionRow(
                            index: e.key + 1, item: e.value))
                        .toList(),
                  ),
                ),

              // Discovery Questions
              if (r.discoveryQuestions.isNotEmpty)
                _V3Card(
                  title: 'Discovery Questions',
                  icon: Icons.search,
                  iconColor: Colors.purple,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: r.discoveryQuestions
                        .asMap()
                        .entries
                        .map((e) => _numberedRow(e.key + 1, e.value))
                        .toList(),
                  ),
                ),

              // Primary Recommendation
              _PrimaryProductCard(
                product: r.primaryRecommendation,
                enablement: MeetingPrepEnablementService().getEnablementForProduct(r.primaryRecommendation.productName),
              ),

              // Supporting Recommendations
              if (r.supportingRecs.isNotEmpty)
                _V3Card(
                  title: 'Supporting Recommendations',
                  icon: Icons.add_circle_outline,
                  iconColor: Colors.teal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: r.supportingRecs
                        .asMap()
                          .entries
                          .map((e) => _SupportingProductRow(
                                product: e.value,
                                enablement: MeetingPrepEnablementService().getEnablementForProduct(e.value.productName),
                              ))
                          .toList(),
                  ),
                ),

              // Phase 1: Expansion Opportunities — Renewal, Upsell, QBR only
              if (r.expansionOpportunities != null &&
                  r.expansionOpportunities!.isNotEmpty)
                _V3Card(
                  title: 'Expansion Opportunities',
                  icon: Icons.trending_up,
                  iconColor: Colors.green.shade700,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: r.expansionOpportunities!
                        .asMap()
                        .entries
                        .map((e) => _numberedRow(e.key + 1, e.value))
                        .toList(),
                  ),
                ),

              // Objections (standard position — not dominant mode)
              if (!r.objectionsDominant && r.topObjections.isNotEmpty)
                _V3Card(
                  title: 'Likely Objections',
                  icon: Icons.shield_outlined,
                  iconColor: Colors.red,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: r.topObjections
                        .asMap()
                        .entries
                        .map((e) => _ObjectionRow(
                            index: e.key + 1, item: e.value))
                        .toList(),
                  ),
                ),

              // Meeting Strategy
              _MeetingStrategyCard(strategy: r.meetingStrategy),

              // Next Best Action
              _NextBestActionCard(action: r.nextBestAction),
            ],
          ),
        ),
      ],
    );
  }

  Widget _numberedRow(int n, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(right: 10, top: 1),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$n',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(text,
                  style: TextStyle(
                      color: Colors.grey.shade800, height: 1.4)),
            ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable V3 Card Components
// ─────────────────────────────────────────────────────────────────────────────

class _V3Card extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  const _V3Card({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _PrimaryProductCard extends StatelessWidget {
  final RankedProduct product;
  final EnrichedProduct? enablement;
  const _PrimaryProductCard({required this.product, this.enablement});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars_rounded, color: AppConstants.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Primary Recommendation',
                style: TextStyle(
                    color: AppConstants.primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            product.productName,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              product.selectionReason,
              style: TextStyle(
                  color: Colors.grey.shade800, fontSize: 14, height: 1.5),
            ),
          ),
          if (enablement != null) _AmCopilotCard(enablement: enablement!, isDark: false),
        ],
      ),
    );
  }
}

class _SupportingProductRow extends StatelessWidget {
  final RankedProduct product;
  final EnrichedProduct? enablement;
  const _SupportingProductRow({required this.product, this.enablement});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.productName,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            product.selectionReason,
            style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
                height: 1.4),
          ),
          if (enablement != null) _AmCopilotCard(enablement: enablement!, isDark: false),
        ],
      ),
    );
  }
}

class _ObjectionRow extends StatelessWidget {
  final int index;
  final ScoredObjection item;
  const _ObjectionRow({required this.index, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 22,
                height: 22,
                margin: const EdgeInsets.only(right: 8, top: 1),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  item.objection,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            margin: const EdgeInsets.only(left: 30),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.reply, color: Colors.green.shade700, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.response,
                    style: TextStyle(
                        color: Colors.green.shade900,
                        fontSize: 13,
                        height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MeetingStrategyCard extends StatelessWidget {
  final MeetingStrategy strategy;
  const _MeetingStrategyCard({required this.strategy});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      const Icon(Icons.map_outlined, color: Colors.indigo, size: 18),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Meeting Strategy',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              children: [
                _StrategyRow(
                    label: 'Lead With',
                    text: strategy.leadWith,
                    color: Colors.green),
                _StrategyRow(
                    label: 'Avoid',
                    text: strategy.avoid,
                    color: Colors.red),
                _StrategyRow(
                    label: 'Validate',
                    text: strategy.validate,
                    color: Colors.orange),
                _StrategyRow(
                    label: 'Close With',
                    text: strategy.closeWith,
                    color: Colors.blue,
                    isLast: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StrategyRow extends StatelessWidget {
  final String label;
  final String text;
  final Color color;
  final bool isLast;

  const _StrategyRow({
    required this.label,
    required this.text,
    required this.color,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.grey.shade800,
                  height: 1.4,
                  fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextBestActionCard extends StatelessWidget {
  final String action;
  const _NextBestActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.arrow_circle_right,
              color: Colors.amber.shade700, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next Best Action',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.amber.shade800),
                ),
                const SizedBox(height: 4),
                Text(
                  action,
                  style: TextStyle(
                      color: Colors.amber.shade900,
                      height: 1.4,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AmCopilotCard extends StatefulWidget {
  final EnrichedProduct enablement;
  final bool isDark;
  const _AmCopilotCard({required this.enablement, required this.isDark});
  @override
  State<_AmCopilotCard> createState() => _AmCopilotCardState();
}

class _AmCopilotCardState extends State<_AmCopilotCard> {
  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade50;
    final textColor = widget.isDark ? Colors.white : Colors.grey.shade900;
    final titleColor = widget.isDark ? Colors.white : AppConstants.primaryColor;
    final dividerColor = widget.isDark ? Colors.white.withValues(alpha: 0.2) : Colors.grey.shade300;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: widget.isDark ? null : Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: Text('▶ How to Pitch This', style: TextStyle(fontWeight: FontWeight.bold, color: titleColor, fontSize: 13)),
        iconColor: titleColor,
        collapsedIconColor: titleColor,
        childrenPadding: const EdgeInsets.all(16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('💬 Conversation Starter', titleColor),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.isDark ? Colors.blue.withValues(alpha: 0.1) : Colors.blue.shade50,
              border: Border(left: BorderSide(color: Colors.blue.shade400, width: 4)),
            ),
            child: _textContent('"${widget.enablement.openingHook}"', textColor, isItalic: true),
          ),
          Divider(height: 24, color: dividerColor),

          _sectionTitle('🎯 Business Value', titleColor),
          ...widget.enablement.businessOutcomes.map((b) => _bulletPoint(b, textColor)),
          Divider(height: 24, color: dividerColor),

          _sectionTitle('🧠 Position It As', titleColor),
          _textContent(widget.enablement.positioningStatement, textColor),
          Divider(height: 24, color: dividerColor),

          _sectionTitle('❓ Discovery Questions', titleColor),
          ...widget.enablement.discoveryHooks.map((q) => _bulletPoint(q, textColor)),
          Divider(height: 24, color: dividerColor),

          _sectionTitle('🤝 Cross-Sell Opportunities', titleColor),
          ...widget.enablement.crossSellProducts.map((c) => _bulletPoint(c, textColor)),
          
          if (widget.enablement.whenNotToPitch.isNotEmpty) ...[
            Divider(height: 24, color: dividerColor),
            _sectionTitle('⚠️ When NOT To Pitch This', Colors.red.shade400),
            ...widget.enablement.whenNotToPitch.map((q) => _bulletPoint(q, textColor, iconColor: Colors.red.shade400, icon: Icons.close)),
          ],
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: color,
        ),
      ),
    );
  }

  Widget _textContent(String content, Color color, {bool isItalic = false}) {
    return Text(
      content,
      style: TextStyle(
        fontSize: 13,
        height: 1.4,
        color: color,
        fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      ),
    );
  }

  Widget _bulletPoint(String content, Color color, {Color? iconColor, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 6, top: 2),
              child: Icon(icon, size: 14, color: iconColor ?? color),
            )
          else
            Text('• ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: iconColor ?? color)),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
