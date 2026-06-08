import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';
import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/meetings/providers/meeting_provider.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:frontend/features/airtel_iq/services/sales_intelligence_service.dart';
import 'package:frontend/features/airtel_iq/widgets/ai_loading_indicator.dart';
import 'package:frontend/features/airtel_iq/widgets/ai_result_card.dart';

class FollowUpGeneratorScreen extends ConsumerStatefulWidget {
  const FollowUpGeneratorScreen({super.key});

  @override
  ConsumerState<FollowUpGeneratorScreen> createState() => _FollowUpGeneratorScreenState();
}

class _FollowUpGeneratorScreenState extends ConsumerState<FollowUpGeneratorScreen> {
  Customer? _selectedCustomer;
  Meeting? _selectedMeeting;
  bool _isLoading = false;
  FollowUpResult? _result;

  final SalesIntelligenceService _service = SalesIntelligenceService();

  void _generateFollowUp() async {
    if (_selectedCustomer == null || _selectedMeeting == null) return;

    setState(() {
      _isLoading = true;
      _result = null;
    });

    try {
      final res = await _service.generateFollowUp(_selectedMeeting!, _selectedCustomer!);
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

  @override
  Widget build(BuildContext context) {
    final customersState = ref.watch(customerListProvider);
    final meetingsState = ref.watch(meetingListProvider);

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Follow-Up Generator'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: customersState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (customers) {
          final customerMeetings = _selectedCustomer != null && meetingsState.value != null
              ? meetingsState.value!.where((m) => m.customerId == _selectedCustomer!.id).toList()
              : <Meeting>[];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Select Past Meeting', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<Customer>(
                  decoration: InputDecoration(
                    labelText: 'Select Customer',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  initialValue: _selectedCustomer,
                  items: customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCustomer = val;
                      _selectedMeeting = null;
                      _result = null;
                    });
                  },
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<Meeting>(
                  decoration: InputDecoration(
                    labelText: 'Select Meeting',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  initialValue: _selectedMeeting,
                  items: customerMeetings.map((m) => DropdownMenuItem(value: m, child: Text(m.title ?? 'Untitled Meeting'))).toList(),
                  onChanged: _selectedCustomer == null
                      ? null
                      : (val) {
                          setState(() {
                            _selectedMeeting = val;
                            _result = null;
                          });
                        },
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: (_selectedCustomer != null && _selectedMeeting != null && !_isLoading) ? _generateFollowUp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Generate Follow-Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 32),

                if (_isLoading)
                  const AiLoadingIndicator(message: 'Analyzing meeting notes...')
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
        const Text('Generated Output', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        AiResultCard(
          title: 'Executive Summary',
          icon: Icons.summarize_outlined,
          iconColor: Colors.blue,
          content: Text(_result!.executiveSummary, style: TextStyle(color: Colors.grey.shade800, height: 1.5)),
        ),

        AiResultCard(
          title: 'Key Decisions',
          icon: Icons.gavel_outlined,
          iconColor: Colors.orange,
          content: _buildList(_result!.keyDecisions),
        ),

        AiResultCard(
          title: 'Action Items',
          icon: Icons.check_circle_outline,
          iconColor: Colors.green,
          content: _buildList(_result!.actionItems),
        ),

        AiResultCard(
          title: 'Suggested Email Draft',
          icon: Icons.mark_email_unread_outlined,
          iconColor: Colors.purple,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SelectableText(
                  _result!.emailDraft,
                  style: TextStyle(fontFamily: 'monospace', color: Colors.grey.shade800, height: 1.5),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _result!.emailDraft));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email copied to clipboard!')));
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy to Clipboard'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppConstants.primaryColor,
                  side: const BorderSide(color: AppConstants.primaryColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Expanded(child: Text(item, style: TextStyle(color: Colors.grey.shade800, height: 1.4))),
          ],
        ),
      )).toList(),
    );
  }
}
