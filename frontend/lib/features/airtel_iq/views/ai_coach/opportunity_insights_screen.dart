import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';
import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/meetings/providers/meeting_provider.dart';
import 'package:frontend/features/airtel_iq/services/sales_intelligence_service.dart';
import 'package:frontend/features/airtel_iq/services/recommendation_engine.dart';
import 'package:frontend/features/airtel_iq/widgets/ai_loading_indicator.dart';
import 'package:frontend/features/airtel_iq/widgets/ai_result_card.dart';

class OpportunityInsightsScreen extends ConsumerStatefulWidget {
  const OpportunityInsightsScreen({super.key});

  @override
  ConsumerState<OpportunityInsightsScreen> createState() => _OpportunityInsightsScreenState();
}

class _OpportunityInsightsScreenState extends ConsumerState<OpportunityInsightsScreen> {
  Customer? _selectedCustomer;
  bool _isLoading = false;
  RecommendationResult? _result;

  final SalesIntelligenceService _service = SalesIntelligenceService();

  void _generateInsights() async {
    if (_selectedCustomer == null) return;

    setState(() {
      _isLoading = true;
      _result = null;
    });

    final allMeetings = ref.read(meetingListProvider).value ?? [];
    final pastMeetings = allMeetings.where((m) => m.customerId == _selectedCustomer!.id).toList();

    try {
      final res = await _service.getOpportunityInsights(_selectedCustomer!, pastMeetings);
      setState(() {
        _result = res;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _copyInsightsToClipboard() {
    if (_result == null) return;
    final sb = StringBuffer();
    sb.writeln('OPPORTUNITY INSIGHTS');
    sb.writeln();
    sb.writeln('REASONING & CONTEXT');
    sb.writeln(_result!.overallReasoning);
    sb.writeln();
    sb.writeln('SUGGESTED PRODUCTS');
    if (_result!.recommendedProducts.isEmpty) {
      sb.writeln('None');
    } else {
      for (var p in _result!.recommendedProducts) {
        sb.writeln('• ${p.product.name}: ${p.product.shortDescription}');
      }
    }
    
    Clipboard.setData(ClipboardData(text: sb.toString().trimRight()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Insights copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customersState = ref.watch(customerListProvider);

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Opportunity Insights'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: customersState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (customers) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Select Customer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<Customer>(
                  decoration: InputDecoration(
                    labelText: 'Customer',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  initialValue: _selectedCustomer,
                  items: customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCustomer = val;
                      _result = null;
                    });
                  },
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: (_selectedCustomer != null && !_isLoading) ? _generateInsights : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Analyze Opportunities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 32),

                if (_isLoading)
                  const AiLoadingIndicator(message: 'Analyzing customer history and product fit...')
                else if (_result != null)
                  _buildResults(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('AI Recommendations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton.icon(
              icon: const Icon(Icons.copy, size: 16),
              label: const Text('Copy Insights'),
              style: TextButton.styleFrom(
                foregroundColor: AppConstants.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onPressed: _copyInsightsToClipboard,
            ),
          ],
        ),
        const SizedBox(height: 16),

        SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AiResultCard(
                title: 'Reasoning & Context',
                icon: Icons.analytics_outlined,
                iconColor: Colors.blue,
                content: Text(_result!.overallReasoning, style: TextStyle(color: Colors.grey.shade800, height: 1.5, fontSize: 15)),
              ),

              const SizedBox(height: 8),
              const Text('Suggested Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              ..._result!.recommendedProducts.map((product) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.amber.shade200),
                ),
                elevation: 0,
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber.shade700, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              product.product.name,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber.shade900),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(product.product.shortDescription, style: TextStyle(color: Colors.amber.shade900)),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}
