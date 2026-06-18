import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/airtel_iq/knowledge/airtel_iq_knowledge_service.dart';
import 'package:frontend/features/airtel_iq/services/follow_up_engine.dart';
import 'package:frontend/features/airtel_iq/widgets/ai_loading_indicator.dart';

class FollowUpGeneratorScreen extends StatefulWidget {
  const FollowUpGeneratorScreen({super.key});

  @override
  State<FollowUpGeneratorScreen> createState() =>
      _FollowUpGeneratorScreenState();
}

class _FollowUpGeneratorScreenState extends State<FollowUpGeneratorScreen> {
  // ── Engine & services ─────────────────────────────────────────────────────
  final FollowUpEngine _engine = FollowUpEngine();
  final AirtelIqKnowledgeService _knowledge = AirtelIqKnowledgeService();

  // ── Inputs ────────────────────────────────────────────────────────────────
  String? _industry;
  final List<String> _selectedProducts = [];
  final List<String> _selectedConcerns = [];
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  bool _showOptionalFields = false;

  // ── State ─────────────────────────────────────────────────────────────────
  bool _isLoading = false;
  FollowUpOutput? _result;

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

  static const List<String> _commonConcerns = [
    'Budget / Cost',
    'Data Sovereignty',
    'Migration Complexity',
    'Downtime Risk',
    'Integration with existing systems',
    'Security & Compliance',
    'Vendor lock-in',
    'Pricing transparency',
    'SLA guarantees',
    'Implementation timeline',
  ];

  List<String> get _allProductNames =>
      _knowledge.getAllProducts().map((p) => p.name).toList()..sort();

  bool get _canGenerate => !_isLoading && _industry != null;

  @override
  void dispose() {
    _summaryController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  // ── Generate ──────────────────────────────────────────────────────────────
  void _generate() {
    if (_industry == null) return;
    setState(() {
      _isLoading = true;
      _result = null;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      final result = _engine.generate(
        industry: _industry!,
        productsDiscussed: List.from(_selectedProducts),
        customerConcerns: List.from(_selectedConcerns),
        meetingSummary: _summaryController.text.trim(),
        agreedNextSteps: _stepsController.text.trim(),
      );
      if (mounted) {
        setState(() {
          _result = result;
          _isLoading = false;
        });
      }
    });
  }

  void _copyAll() {
    final r = _result;
    if (r == null) return;
    final sb = StringBuffer();
    sb.writeln('FOLLOW-UP — ${_industry ?? ''}');
    sb.writeln('📝 CRM NOTES');
    for (final n in r.crmNotes) sb.writeln('• $n');
    sb.writeln();
    sb.writeln('✅ ACTION ITEMS');
    for (var i = 0; i < r.actionItems.length; i++) {
      sb.writeln('${i + 1}. ${r.actionItems[i]}');
    }
    sb.writeln();
    sb.writeln('📅 NEXT MEETING AGENDA');
    for (var i = 0; i < r.nextAgenda.length; i++) {
      sb.writeln('${i + 1}. ${r.nextAgenda[i]}');
    }
    sb.writeln();
    sb.writeln('📧 FOLLOW-UP EMAIL');
    sb.writeln('Subject: ${r.emailSubject}');
    sb.writeln();
    sb.writeln(r.emailBody);
    sb.writeln();
    sb.writeln('🚦 RECOMMENDED FOLLOW-UP TIMELINE');
    r.recommendedTimeline.forEach((timeframe, actions) {
      sb.writeln(timeframe);
      for (final action in actions) {
        sb.writeln('• $action');
      }
      sb.writeln();
    });
    Clipboard.setData(ClipboardData(text: sb.toString().trimRight()));
    _showSnack('All output copied to clipboard');
  }

  void _copySection(String content) {
    Clipboard.setData(ClipboardData(text: content.trimRight()));
    _showSnack('Copied to clipboard');
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Follow-Up Generator'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (_result != null)
            TextButton.icon(
              icon: const Icon(Icons.copy, size: 16, color: Colors.white70),
              label: const Text(
                'Copy All',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              onPressed: _copyAll,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Explainer chip ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppConstants.primaryColor.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: AppConstants.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Post-meeting? Generate your email, CRM note, action items and next agenda in seconds.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppConstants.primaryColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Industry (mandatory) ─────────────────────────────────────────
            _labelText('Industry *', 'Required'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _industry,
              decoration: InputDecoration(
                hintText: 'Select customer industry',
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
              onChanged: (val) => setState(() {
                _industry = val;
                _result = null;
              }),
            ),
            const SizedBox(height: 20),

            // ── Optional fields (collapsible) ────────────────────────────────
            _buildOptionalSection(),
            const SizedBox(height: 24),

            // ── Generate button ──────────────────────────────────────────────
            ElevatedButton(
              onPressed: _canGenerate ? _generate : null,
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
                'Generate Follow-Up',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),

            // ── Results ───────────────────────────────────────────────────────
            if (_isLoading)
              const AiLoadingIndicator(
                message: 'Generating follow-up materials...',
              )
            else if (_result != null)
              _buildResults(_result!),
          ],
        ),
      ),
    );
  }

  // ── Optional fields section ───────────────────────────────────────────────

  Widget _buildOptionalSection() {
    final hasContent =
        _selectedProducts.isNotEmpty ||
        _selectedConcerns.isNotEmpty ||
        _summaryController.text.isNotEmpty ||
        _stepsController.text.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Header row (always visible)
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () =>
                setState(() => _showOptionalFields = !_showOptionalFields),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(Icons.tune, size: 18, color: AppConstants.primaryColor),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Meeting Context',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (!_showOptionalFields && hasContent)
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
                    _showOptionalFields ? Icons.expand_less : Icons.add,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
          if (_showOptionalFields)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 16),

                  // Meeting summary
                  _labelText(
                    'Meeting Summary',
                    'Brief notes from the meeting — improves email quality',
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _summaryController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText:
                          'e.g. "Customer discussed cloud migration from AWS. Concerned about data sovereignty. Open to pilot."',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
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
                  const SizedBox(height: 16),

                  // Products discussed
                  _labelText(
                    'Products Discussed',
                    'Select all products covered in the meeting',
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _allProductNames.map((prod) {
                      final isSelected = _selectedProducts.contains(prod);
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
                        onSelected: (val) => setState(() {
                          if (val) {
                            _selectedProducts.add(prod);
                          } else {
                            _selectedProducts.remove(prod);
                          }
                          _result = null;
                        }),
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

                  // Customer concerns
                  _labelText(
                    'Customer Concerns',
                    'Select concerns the customer raised',
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _commonConcerns.map((concern) {
                      final isSelected = _selectedConcerns.contains(concern);
                      return FilterChip(
                        label: Text(
                          concern,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade700,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (val) => setState(() {
                          if (val) {
                            _selectedConcerns.add(concern);
                          } else {
                            _selectedConcerns.remove(concern);
                          }
                          _result = null;
                        }),
                        selectedColor: Colors.orange.shade700,
                        checkmarkColor: Colors.white,
                        backgroundColor: Colors.grey.shade100,
                        side: BorderSide(
                          color: isSelected
                              ? Colors.orange.shade700
                              : Colors.grey.shade300,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Agreed next steps
                  _labelText(
                    'Agreed Next Steps',
                    'What did you agree to do after the meeting?',
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _stepsController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText:
                          'e.g. "Send proposal by Friday. Schedule technical demo next week."',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
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

  // ── Results ───────────────────────────────────────────────────────────────

  Widget _buildResults(FollowUpOutput r) {
    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. CRM Note card
          _buildOutputCard(
            emoji: '📝',
            title: 'Internal CRM Note',
            accentColor: const Color(0xFF7C3AED),
            onCopy: () {
              final text = r.crmNotes.map((n) => '• $n').join('\n');
              _copySection(text);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: r.crmNotes
                  .map(
                    (note) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF7C3AED),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              note,
                              style: TextStyle(
                                fontSize: 13,
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
          ),
          const SizedBox(height: 12),

          // 2. Action Items card
          _buildOutputCard(
            emoji: '✅',
            title: 'Action Items',
            accentColor: const Color(0xFF16A34A),
            onCopy: () {
              final text = r.actionItems
                  .asMap()
                  .entries
                  .map((e) => '${e.key + 1}. ${e.value}')
                  .join('\n');
              _copySection(text);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: r.actionItems
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF16A34A,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF16A34A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 13,
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
          ),
          const SizedBox(height: 12),

          // 3. Next Meeting Agenda card
          _buildOutputCard(
            emoji: '📅',
            title: 'Next Meeting Agenda',
            accentColor: const Color(0xFFD97706),
            onCopy: () {
              final text = r.nextAgenda
                  .asMap()
                  .entries
                  .map((e) => '${e.key + 1}. ${e.value}')
                  .join('\n');
              _copySection(text);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: r.nextAgenda
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFD97706,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFD97706),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 13,
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
          ),
          const SizedBox(height: 12),

          // 4. Email card
          _buildOutputCard(
            emoji: '📧',
            title: 'Customer Follow-up Email',
            accentColor: const Color(0xFF2563EB),
            onCopy: () {
              final emailText = 'Subject: ${r.emailSubject}\n\n${r.emailBody}';
              _copySection(emailText);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject line
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SUBJECT',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue.shade700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        r.emailSubject,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Body
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    r.emailBody,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade800,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 5. Recommended Follow-up Timeline
          _buildOutputCard(
            emoji: '🚦',
            title: 'Recommended Follow-up Timeline',
            accentColor: const Color(0xFF0D9488),
            onCopy: () {
              final sb = StringBuffer();
              r.recommendedTimeline.forEach((timeframe, actions) {
                sb.writeln(timeframe);
                for (final action in actions) {
                  sb.writeln('• $action');
                }
                sb.writeln();
              });
              _copySection(sb.toString());
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: r.recommendedTimeline.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...entry.value.map(
                        (action) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  action,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade800,
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
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Shared card wrapper ───────────────────────────────────────────────────

  Widget _buildOutputCard({
    required String emoji,
    required String title,
    required Color accentColor,
    required VoidCallback onCopy,
    required Widget child,
  }) {
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
            // Left accent bar
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
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card header with copy button
                    Row(
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: onCopy,
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: accentColor.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.copy_outlined,
                                  size: 12,
                                  color: accentColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Copy',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: accentColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 14),
                    // Card content
                    child,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helper ────────────────────────────────────────────────────────────────

  Widget _labelText(String title, String subtitle) {
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
}
