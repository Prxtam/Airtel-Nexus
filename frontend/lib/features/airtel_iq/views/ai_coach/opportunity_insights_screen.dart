import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/airtel_iq/knowledge/airtel_iq_knowledge_service.dart';
import 'package:frontend/features/airtel_iq/models/opportunity_insights_models.dart';
import 'package:frontend/features/airtel_iq/services/opportunity_insights_engine.dart';
import 'package:frontend/features/airtel_iq/widgets/ai_loading_indicator.dart';

class OpportunityInsightsScreen extends StatefulWidget {
  const OpportunityInsightsScreen({super.key});

  @override
  State<OpportunityInsightsScreen> createState() =>
      _OpportunityInsightsScreenState();
}

class _OpportunityInsightsScreenState extends State<OpportunityInsightsScreen> {
  // ── Engine & services ──────────────────────────────────────────────────────
  final OpportunityInsightsEngine _engine = OpportunityInsightsEngine();
  final AirtelIqKnowledgeService _knowledge = AirtelIqKnowledgeService();

  // ── Inputs ─────────────────────────────────────────────────────────────────
  String? _industry;
  List<String> _selectedPainPoints = [];
  // ignore: prefer_final_fields
  List<String> _selectedExistingProducts = [];
  final TextEditingController _notesController = TextEditingController();
  bool _showExtraContext = false;

  // ── State ──────────────────────────────────────────────────────────────────
  bool _isLoading = false;
  OpportunityInsightsResult? _result;

  // ── Reference data (matches Meeting Prep exactly) ──────────────────────────
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

  static const List<String> _fallbackPainPoints = [
    'Branch Connectivity',
    'Business Continuity',
    'Customer Engagement',
    'Digital Transformation',
    'Legacy Systems',
    'Mobility Management',
    'Operational Efficiency',
    'Remote Work',
    'Rising Telecom Costs',
    'Security & Compliance',
  ];

  // ── Derived pain points ────────────────────────────────────────────────────
  List<String> get _painPoints {
    if (_industry == null) return _fallbackPainPoints;
    final industryData = _knowledge.getIndustryByName(_industry!);
    if (industryData == null) return _fallbackPainPoints;
    final Set<String> combined = {};
    for (final product in _knowledge.getAllProducts()) {
      if (product.industries.contains(_industry)) {
        combined.addAll(product.painPointsSolved);
      }
    }
    combined.addAll(industryData.businessChallenges);
    combined.addAll(industryData.technologyChallenges);
    final sorted = combined.toList()..sort();
    return sorted;
  }

  // All Airtel products for "Existing Products" multi-select
  List<String> get _allProductNames =>
      _knowledge.getAllProducts().map((p) => p.name).toList()..sort();

  bool get _canGenerate => !_isLoading && _industry != null;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // ── Generate ───────────────────────────────────────────────────────────────
  void _generateInsights() {
    if (_industry == null) return;
    setState(() {
      _isLoading = true;
      _result = null;
    });

    // Simulate brief processing delay (engine is synchronous)
    Future.delayed(const Duration(milliseconds: 600), () {
      final input = OpportunityInsightsInput(
        industry: _industry!,
        painPoints: List.from(_selectedPainPoints),
        situationNotes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        existingProducts: List.from(_selectedExistingProducts),
      );
      final result = _engine.generate(input);
      if (mounted) {
        setState(() {
          _result = result;
          _isLoading = false;
        });
      }
    });
  }

  void _copyToClipboard() {
    final r = _result;
    if (r == null) return;
    final sb = StringBuffer();
    sb.writeln('OPPORTUNITY INSIGHTS — ${_industry ?? ''}');
    sb.writeln();
    sb.writeln('OPPORTUNITY POTENTIAL: ${r.growthPotential.label}');
    for (final d in r.growthPotential.drivers) sb.writeln('• $d');
    sb.writeln();
    sb.writeln('SUGGESTED NEXT MOVE');
    sb.writeln(r.suggestedNextMove);
    sb.writeln();
    sb.writeln('BEST OPPORTUNITIES');
    for (final o in r.bestOpportunities) {
      sb.writeln('${o.confidence.label} — ${o.productName}');
      sb.writeln('  ${o.shortReason}');
    }
    sb.writeln();
    sb.writeln('EXISTING AIRTEL FOOTPRINT');
    if (r.currentStack.isEmpty) {
      sb.writeln('None recorded');
    } else {
      for (final p in r.currentStack) sb.writeln('✅ $p');
    }
    sb.writeln();
    sb.writeln('EXPANSION OPPORTUNITIES');
    for (final p in r.expansionOpportunities) sb.writeln('🚨 $p');
    sb.writeln();
    sb.writeln('STRATEGIC RISKS');
    for (final risk in r.strategicRisks) sb.writeln('• $risk');
    sb.writeln();
    sb.writeln('CONVERSATION AREAS');
    for (final a in r.conversationAreas) sb.writeln('• $a');

    Clipboard.setData(ClipboardData(text: sb.toString().trimRight()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Insights copied to clipboard')),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Opportunity Insights'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (_result != null)
            TextButton.icon(
              icon: const Icon(Icons.copy, size: 16, color: Colors.white70),
              label: const Text(
                'Copy',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              onPressed: _copyToClipboard,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Input Form ───────────────────────────────────────────────────
            _buildInputForm(),
            const SizedBox(height: 24),

            // ── Generate Button ──────────────────────────────────────────────
            ElevatedButton(
              onPressed: _canGenerate ? _generateInsights : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Generate Growth Insights',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),

            // ── Results ──────────────────────────────────────────────────────
            if (_isLoading)
              const AiLoadingIndicator(
                message: 'Analyzing account growth opportunities...',
              )
            else if (_result != null)
              _buildResults(_result!),
          ],
        ),
      ),
    );
  }

  // ── Input Form ─────────────────────────────────────────────────────────────

  Widget _buildInputForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Industry (mandatory)
        _buildSectionLabel('Industry *', 'Required to generate insights'),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _industry,
          decoration: InputDecoration(
            hintText: 'Select industry',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          items: _industries
              .map(
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(i, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: (val) {
            setState(() {
              _industry = val;
              _selectedPainPoints = [];
              _result = null;
            });
          },
        ),
        const SizedBox(height: 20),

        // Pain Points (optional, max 3)
        _buildSectionLabel(
          'Pain Points',
          'Select up to 3 pain points — improves recommendations',
        ),
        const SizedBox(height: 8),
        _buildPainPointChips(),
        const SizedBox(height: 20),

        // Extra context (collapsible)
        _buildExtraContextSection(),
      ],
    );
  }

  Widget _buildPainPointChips() {
    final painPoints = _painPoints;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: painPoints.map((pp) {
        final isSelected = _selectedPainPoints.contains(pp);
        final isDisabled = !isSelected && _selectedPainPoints.length >= 3;
        return FilterChip(
          label: Text(
            pp,
            style: TextStyle(
              fontSize: 12,
              color: isSelected
                  ? Colors.white
                  : isDisabled
                  ? Colors.grey.shade400
                  : Colors.grey.shade700,
            ),
          ),
          selected: isSelected,
          onSelected: isDisabled
              ? null
              : (val) {
                  setState(() {
                    if (val) {
                      _selectedPainPoints.add(pp);
                    } else {
                      _selectedPainPoints.remove(pp);
                    }
                    _result = null;
                  });
                },
          selectedColor: AppConstants.primaryColor,
          checkmarkColor: Colors.white,
          backgroundColor: Colors.grey.shade100,
          side: BorderSide(
            color: isSelected
                ? AppConstants.primaryColor
                : Colors.grey.shade300,
          ),
          showCheckmark: true,
        );
      }).toList(),
    );
  }

  Widget _buildExtraContextSection() {
    final hasContent =
        _selectedExistingProducts.isNotEmpty ||
        _notesController.text.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _showExtraContext = !_showExtraContext),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(Icons.tune, size: 18, color: AppConstants.primaryColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Account Context',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (!_showExtraContext && hasContent)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'context added',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppConstants.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Icon(
                    _showExtraContext ? Icons.expand_less : Icons.add,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
          if (_showExtraContext)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 16),

                  // Existing Products
                  Text(
                    'Existing Airtel Products',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select products this customer already uses',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _allProductNames.map((prod) {
                      final isSelected = _selectedExistingProducts.contains(
                        prod,
                      );
                      return FilterChip(
                        label: Text(
                          prod,
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade700,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              _selectedExistingProducts.add(prod);
                            } else {
                              _selectedExistingProducts.remove(prod);
                            }
                            _result = null;
                          });
                        },
                        selectedColor: AppConstants.primaryColor,
                        checkmarkColor: Colors.white,
                        backgroundColor: Colors.grey.shade100,
                        side: BorderSide(
                          color: isSelected
                              ? AppConstants.primaryColor
                              : Colors.grey.shade300,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Situation Notes
                  Text(
                    'Situation Notes',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Brief context about the account (improves risk detection and next move)',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText:
                          'e.g. "Customer has AWS dependency, exploring hybrid cloud..."',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    onChanged: (_) => setState(() => _result = null),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ── Results ────────────────────────────────────────────────────────────────

  Widget _buildResults(OpportunityInsightsResult r) {
    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Growth Potential ───────────────────────────────────────────────
          _buildGrowthPotentialCard(r.growthPotential),
          const SizedBox(height: 12),

          // ── Suggested Next Move ────────────────────────────────────────────
          _buildNextMoveCard(r.suggestedNextMove),
          const SizedBox(height: 12),

          // ── Best Opportunities ─────────────────────────────────────────────
          if (r.bestOpportunities.isNotEmpty) ...[
            _buildResultSectionHeader('🎯 Best Opportunities'),
            const SizedBox(height: 8),
            ...r.bestOpportunities.map(_buildOpportunityCard),
            const SizedBox(height: 12),
          ],

          // ── White Space Analysis ───────────────────────────────────────────
          _buildWhiteSpaceCard(r),
          const SizedBox(height: 12),

          // ── Strategic Risks ────────────────────────────────────────────────
          if (r.strategicRisks.isNotEmpty) ...[
            _buildResultSectionHeader('⚠️ Strategic Risks'),
            const SizedBox(height: 8),
            _buildRisksCard(r.strategicRisks),
            const SizedBox(height: 12),
          ],

          // ── Conversation Areas ─────────────────────────────────────────────
          if (r.conversationAreas.isNotEmpty) ...[
            _buildResultSectionHeader('🗣️ Conversation Areas'),
            const SizedBox(height: 8),
            _buildConversationAreasCard(r.conversationAreas),
            const SizedBox(height: 32),
          ],
        ],
      ),
    );
  }

  Widget _buildGrowthPotentialCard(GrowthPotential gp) {
    // Derive color and emoji purely from the label string — score is never shown.
    final Color accentColor;
    final String emoji;
    if (gp.label.contains('High')) {
      accentColor = const Color(0xFF16A34A); // green
      emoji = '🟢';
    } else if (gp.label.contains('Medium')) {
      accentColor = const Color(0xFFD97706); // amber
      emoji = '🟡';
    } else {
      accentColor = const Color(0xFFDC2626); // red
      emoji = '🔴';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Colored left accent bar — only visual indicator of level
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header
                    Row(
                      children: [
                        const Text('📈', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        const Text(
                          'Opportunity Potential',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Label — emoji + text, no number
                    Row(
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Text(
                          gp.label,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: accentColor,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Drivers
                    Text(
                      'DRIVERS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade500,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...gp.drivers.map(
                      (d) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 14,
                              color: accentColor,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                d,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextMoveCard(String nextMove) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.arrow_circle_right_outlined,
              color: AppConstants.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suggested Next Move',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppConstants.primaryColor,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  nextMove,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpportunityCard(BestOpportunity opp) {
    final Color chipColor;
    switch (opp.confidence) {
      case OpportunityConfidence.quickWin:
        chipColor = const Color(0xFF16A34A);
        break;
      case OpportunityConfidence.mediumTerm:
        chipColor = const Color(0xFFD97706);
        break;
      case OpportunityConfidence.strategicBet:
        chipColor = const Color(0xFF2563EB);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Expanded(
                child: Text(
                  opp.productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: chipColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: chipColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  opp.confidence.label,
                  style: TextStyle(
                    color: chipColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            opp.shortReason,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          // Why this opportunity exists
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WHY THIS OPPORTUNITY EXISTS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 6),
                ...opp.opportunityDrivers.map(
                  (d) => Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '•  ',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            d,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteSpaceCard(OpportunityInsightsResult r) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🚨', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              const Text(
                'White Space Analysis',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Existing Airtel Footprint
          Text(
            '✅  EXISTING AIRTEL FOOTPRINT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF16A34A),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          if (r.currentStack.isEmpty)
            Text(
              'No existing Airtel products recorded',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: r.currentStack
                  .map(
                    (p) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF86EFAC)),
                      ),
                      child: Text(
                        p,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF15803D),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Expansion Opportunities
          Text(
            '🚨  EXPANSION OPPORTUNITIES',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.orange.shade700,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            'Industry-relevant products not yet adopted',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 8),
          if (r.expansionOpportunities.isEmpty)
            Text(
              'No additional whitespace identified for this industry',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: r.expansionOpportunities
                  .map(
                    (p) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 12,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            p,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildRisksCard(List<String> risks) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: risks
            .map(
              (risk) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: Colors.red.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        risk,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red.shade800,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildConversationAreasCard(List<String> areas) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: areas
            .map(
              (area) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        area,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _buildSectionLabel(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildResultSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}
