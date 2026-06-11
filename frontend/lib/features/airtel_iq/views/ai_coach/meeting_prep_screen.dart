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
  String? _painPoint;
  String? _objective;

  // ── History mode inputs ───────────────────────────────────────────────────
  Customer? _selectedCustomer;
  Meeting? _selectedMeeting;

  // Enrich Context (optional — does not block generation)
  String? _enrichIndustry;
  String? _enrichMeetingType;
  String? _enrichCompanySize;
  String? _enrichPainPoint;

  // ── State ─────────────────────────────────────────────────────────────────
  bool _isLoading = false;
  MeetingPrepV3Result? _result;
  final MeetingPrepIntelligenceEngine _engine = MeetingPrepIntelligenceEngine();
  final AirtelIqKnowledgeService _knowledge = AirtelIqKnowledgeService();

  // ── Reference data ────────────────────────────────────────────────────────
  static const List<String> _industries = [
    'Banking & Financial Services',
    'Retail',
    'Manufacturing',
    'Logistics',
    'Healthcare',
    'IT & ITES',
    'E-Commerce',
    'Education',
    'Hospitality',
    'Government',
    'Energy & Utilities',
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
      return _industry != null && _meetingType != null;
    }
    // History: only customer + meeting required; industry is optional
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
          meetingType: _meetingType!,
          companySize: _companySize,
          painPoint: _painPoint,
          objective: _objective,
        );
      } else {
        // History mode: prefer enriched values, fall back to inferred
        final effectiveMeetingType =
            _enrichMeetingType ?? _inferMeetingType(_selectedMeeting!);
        final allMeetings = ref.read(meetingListProvider).value ?? [];
        final previousCount =
            allMeetings.where((m) => m.customerId == _selectedCustomer!.id).length;

        input = MeetingPrepV3Input(
          industry: _enrichIndustry, // null → methodology-only fallback
          meetingType: effectiveMeetingType,
          companySize: _enrichCompanySize,
          painPoint: _enrichPainPoint,
          customerName: _selectedCustomer!.name,
          previousMeetingCount: previousCount,
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
            _painPoint = null;
            _result = null;
          }),
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: 'Meeting Type *',
          value: _meetingType,
          items: _meetingTypes,
          onChanged: (v) => setState(() {
            _meetingType = v;
            _result = null;
          }),
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: _industry != null
              ? 'Pain Point — specific to ${_industry!.split(' ').first} sector (optional)'
              : 'Pain Point (select industry first for targeted options)',
          value: _painPoint,
          items: _derivePainPoints(_industry),
          onChanged: (v) => setState(() {
            _painPoint = v;
            _result = null;
          }),
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: 'Company Size (optional)',
          value: _companySize,
          items: _companySizes,
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
          onChanged: (v) => setState(() {
            _objective = v;
            _result = null;
          }),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      initialValue: value,
      isExpanded: true,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
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
            onChanged: (v) => setState(() {
              _enrichIndustry = v;
              // Clear pain point when industry changes
              _enrichPainPoint = null;
              _result = null;
            }),
          ),
          const SizedBox(height: 12),
          _buildDropdown(
            label: 'Meeting Type',
            value: _enrichMeetingType,
            items: _meetingTypes,
            onChanged: (v) => setState(() {
              _enrichMeetingType = v;
              _result = null;
            }),
          ),
          const SizedBox(height: 12),
          _buildDropdown(
            label: _enrichIndustry != null
                ? 'Pain Point — specific to ${_enrichIndustry!.split(' ').first} sector'
                : 'Pain Point',
            value: _enrichPainPoint,
            items: _derivePainPoints(_enrichIndustry),
            onChanged: (v) => setState(() {
              _enrichPainPoint = v;
              _result = null;
            }),
          ),
          const SizedBox(height: 12),
          _buildDropdown(
            label: 'Company Size',
            value: _enrichCompanySize,
            items: _companySizes,
            onChanged: (v) => setState(() {
              _enrichCompanySize = v;
              _result = null;
            }),
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

              // Top Challenges
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

              // Discovery Questions
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
              _PrimaryProductCard(product: r.primaryRecommendation),

              // Supporting Recommendations
              if (r.supportingRecs.isNotEmpty)
                _V3Card(
                  title: 'Supporting Recommendations',
                  icon: Icons.add_circle_outline,
                  iconColor: Colors.teal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: r.supportingRecs
                        .map((p) => _SupportingProductRow(product: p))
                        .toList(),
                  ),
                ),

              // Objections
              if (r.topObjections.isNotEmpty)
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
  const _PrimaryProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppConstants.primaryColor, AppConstants.primaryColor.withValues(alpha: 0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.stars_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Primary Recommendation',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            product.productName,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              product.selectionReason,
              style: const TextStyle(
                  color: Colors.white, fontSize: 13, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportingProductRow extends StatelessWidget {
  final RankedProduct product;
  const _SupportingProductRow({required this.product});

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
