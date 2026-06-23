import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/airtel_iq/knowledge/product_enrichment_repository.dart';
import 'package:frontend/features/airtel_iq/services/objection_coach_engine.dart';

enum CoachMode { prepare, handle }

class ObjectionHandlingScreen extends StatefulWidget {
  const ObjectionHandlingScreen({super.key});

  @override
  State<ObjectionHandlingScreen> createState() =>
      _ObjectionHandlingScreenState();
}

class _ObjectionHandlingScreenState extends State<ObjectionHandlingScreen> {
  final ObjectionCoachEngine _engine = ObjectionCoachEngine();
  final TextEditingController _objectionController = TextEditingController();

  CoachMode _mode = CoachMode.prepare;
  String? _selectedProduct;
  String? _industry;

  List<ObjectionOutput>? _prepareResult;
  ObjectionOutput? _handleResult;
  bool _isLoading = false;

  final List<String> _industries = [
    'Banking & Financial Services',
    'Manufacturing',
    'Retail & eCommerce',
    'Healthcare',
    'IT & ITES',
    'Logistics & Distribution',
  ];

  @override
  void dispose() {
    _objectionController.dispose();
    super.dispose();
  }

  void _generate() {
    if (_selectedProduct == null) {
      _showSnack('Please select a product');
      return;
    }

    if (_mode == CoachMode.handle && _objectionController.text.trim().isEmpty) {
      _showSnack('Please enter a customer objection');
      return;
    }

    setState(() {
      _isLoading = true;
      _prepareResult = null;
      _handleResult = null;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (_mode == CoachMode.prepare) {
        final res = _engine.generateTop5(
          productName: _selectedProduct!,
          industryName: _industry ?? '',
        );
        if (mounted) {
          setState(() {
            _prepareResult = res;
            _isLoading = false;
          });
        }
      } else {
        final res = _engine.generate(
          productName: _selectedProduct!,
          objectionText: _objectionController.text.trim(),
          industryName: _industry ?? '',
        );
        if (mounted) {
          setState(() {
            _handleResult = res;
            _isLoading = false;
          });
        }
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final allProducts =
        productEnrichmentData.values.map((e) => e.productName).toList()..sort();

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Objection Coach'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mode Toggle
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SegmentedButton<CoachMode>(
                  segments: const [
                    ButtonSegment(
                      value: CoachMode.prepare,
                      label: Text('Prepare For Meeting'),
                      icon: Icon(Icons.shield_outlined),
                    ),
                    ButtonSegment(
                      value: CoachMode.handle,
                      label: Text('Handle Customer Objection'),
                      icon: Icon(Icons.forum_outlined),
                    ),
                  ],
                  selected: {_mode},
                  onSelectionChanged: (Set<CoachMode> newSelection) {
                    setState(() {
                      _mode = newSelection.first;
                      _prepareResult = null;
                      _handleResult = null;
                    });
                  },
                ),
              ),
            ),
            Container(height: 1, color: Colors.grey.shade200),

            // Inputs Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _labelText(
                    'Product (Required)',
                    'Which product is being pitched?',
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedProduct,
                    hint: const Text('Select a Product'),
                    isExpanded: true,
                    decoration: _inputDecoration(),
                    items: allProducts.map((p) {
                      return DropdownMenuItem(value: p, child: Text(p));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedProduct = val;
                        _prepareResult = null;
                        _handleResult = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _labelText(
                    'Industry (Optional)',
                    'Tailors the likelihood and responses',
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _industry,
                    hint: const Text('Select Industry'),
                    isExpanded: true,
                    decoration: _inputDecoration(),
                    items: _industries.map((ind) {
                      return DropdownMenuItem(value: ind, child: Text(ind));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _industry = val;
                        _prepareResult = null;
                        _handleResult = null;
                      });
                    },
                  ),
                  if (_mode == CoachMode.handle) ...[
                    const SizedBox(height: 16),
                    _labelText(
                      'Customer Objection (Required)',
                      'What exact objection was raised?',
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _objectionController,
                      maxLines: 2,
                      decoration: _inputDecoration().copyWith(
                        hintText:
                            'e.g. "We already use AWS and are happy with it."',
                      ),
                      onChanged: (_) => setState(() => _handleResult = null),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _isLoading ? null : _generate,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _mode == CoachMode.prepare
                                  ? 'Generate Top 5 Objections'
                                  : 'Generate Objection Strategy',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            // Outputs Section
            if (_prepareResult != null && _mode == CoachMode.prepare)
              _buildPrepareResults(),
            if (_handleResult != null && _mode == CoachMode.handle)
              Padding(
                padding: const EdgeInsets.all(20),
                child: _buildAssistantFields(_handleResult!),
              ),
            if (_prepareResult == null && _handleResult == null && !_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _mode == CoachMode.prepare
                            ? 'Prepare For Meeting'
                            : 'Handle Customer Objection',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _mode == CoachMode.prepare
                            ? 'Generate the top 5 likely objections.'
                            : 'Enter an objection to generate a strategy.',
                        style: TextStyle(color: Colors.grey.shade400),
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

  Widget _buildPrepareResults() {
    final results = _prepareResult!;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Heatmap
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('🎯', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Text(
                      'Objection Heatmap',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...results.map((r) {
                  final isVery = r.likelihood == 'Very Likely';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isVery ? '🔥' : '🟡',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            r.objectionText,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade800,
                              fontWeight: isVery
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Top 5 Likely Objections',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...results.map((r) => _buildExpandableCard(r)),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildExpandableCard(ObjectionOutput r) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: ExpansionTile(
        title: Text(
          r.objectionText,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              Text(
                r.likelihood == 'Very Likely' ? '🔥' : '🟡',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 4),
              Text(
                r.likelihood,
                style: TextStyle(
                  fontSize: 12,
                  color: r.likelihood == 'Very Likely'
                      ? Colors.red.shade700
                      : Colors.orange.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        childrenPadding: const EdgeInsets.all(16),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_buildAssistantFields(r)],
      ),
    );
  }

  Widget _buildAssistantFields(ObjectionOutput r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Core Concern
        _buildOutputCard(
          emoji: '🎯',
          title: 'Core Concern',
          accentColor: const Color(0xFF6B7280),
          onCopy: () => _copySection(r.coreConcern),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              r.coreConcern,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // 2. Recommended Response
        _buildOutputCard(
          emoji: '💬',
          title: 'Recommended Response',
          accentColor: const Color(0xFF10B981),
          onCopy: () => _copySection(r.recommendedResponse),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: Text(
              r.recommendedResponse,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF065F46),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // 3. Questions To Ask
        _buildOutputCard(
          emoji: '❓',
          title: 'Questions To Ask',
          accentColor: const Color(0xFF3B82F6),
          onCopy: () =>
              _copySection(r.questionsToAsk.map((q) => '• $q').join('\n')),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: r.questionsToAsk.map((q) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3B82F6),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        q,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),

        // 4. How To Position Airtel
        _buildOutputCard(
          emoji: '💡',
          title: 'How To Position Airtel',
          accentColor: const Color(0xFFF59E0B),
          onCopy: () =>
              _copySection(r.positionAirtel.map((b) => '• $b').join('\n')),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: r.positionAirtel.map((b) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: const Icon(
                        Icons.check_circle,
                        size: 14,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        b,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),

        // 5. Reframe The Conversation
        _buildOutputCard(
          emoji: '🔄',
          title: 'Reframe The Conversation',
          accentColor: const Color(0xFF8B5CF6),
          onCopy: () => _copySection(r.reframe),
          child: Text(
            r.reframe,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // 6. Avoid Saying This
        _buildOutputCard(
          emoji: '🚫',
          title: 'Avoid Saying This',
          accentColor: const Color(0xFFEF4444),
          onCopy: () =>
              _copySection(r.avoidSaying.map((b) => '• $b').join('\n')),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: r.avoidSaying.map((b) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: const Icon(
                        Icons.cancel,
                        size: 14,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        b,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF991B1B),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

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
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 14,
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
                    const SizedBox(height: 12),
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

  Widget _labelText(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppConstants.primaryColor),
      ),
    );
  }
}
