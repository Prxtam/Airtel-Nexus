import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';
import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/meetings/providers/meeting_provider.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:frontend/features/airtel_iq/services/sales_intelligence_service.dart';
import 'package:frontend/features/airtel_iq/widgets/ai_loading_indicator.dart';
import 'package:frontend/features/airtel_iq/widgets/ai_result_card.dart';

class MeetingPrepScreen extends ConsumerStatefulWidget {
  const MeetingPrepScreen({super.key});

  @override
  ConsumerState<MeetingPrepScreen> createState() => _MeetingPrepScreenState();
}

class _MeetingPrepScreenState extends ConsumerState<MeetingPrepScreen> {
  Customer? _selectedCustomer;
  Meeting? _selectedMeeting;
  bool _isLoading = false;
  MeetingPreparationResult? _result;

  final SalesIntelligenceService _service = SalesIntelligenceService();

  void _generatePrep() async {
    if (_selectedCustomer == null || _selectedMeeting == null) return;

    setState(() {
      _isLoading = true;
      _result = null;
    });

    final allMeetings = ref.read(meetingListProvider).value ?? [];
    final pastMeetings = allMeetings.where((m) => m.customerId == _selectedCustomer!.id).toList();

    try {
      final res = await _service.prepareForMeeting(_selectedCustomer!, _selectedMeeting!, pastMeetings);
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
        title: const Text('Meeting Preparation'),
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
                const Text('Select Context', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                // Customer Dropdown
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
                      _selectedMeeting = null; // Reset meeting when customer changes
                      _result = null;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Meeting Dropdown
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
                  onPressed: (_selectedCustomer != null && _selectedMeeting != null && !_isLoading) ? _generatePrep : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Generate Preparation Brief', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 32),

                if (_isLoading)
                  const AiLoadingIndicator(message: 'Analyzing customer history and preparing brief...')
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
        const Text('AI Sales Coach Insights', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        AiResultCard(
          title: 'Meeting Brief',
          icon: Icons.article_outlined,
          iconColor: Colors.blue,
          content: Text(_result!.meetingBrief, style: TextStyle(color: Colors.grey.shade800, height: 1.5)),
        ),

        AiResultCard(
          title: 'Suggested Discussion Topics',
          icon: Icons.chat_bubble_outline,
          iconColor: Colors.orange,
          content: _buildList(_result!.discussionTopics),
        ),

        AiResultCard(
          title: 'Discovery Questions',
          icon: Icons.search,
          iconColor: Colors.purple,
          content: _buildList(_result!.discoveryQuestions),
        ),

        AiResultCard(
          title: 'Recommended Solutions',
          icon: Icons.lightbulb_outline,
          iconColor: Colors.green,
          content: _buildList(_result!.recommendedSolutions.map((p) => '${p.name}: ${p.shortDescription}').toList()),
        ),

        AiResultCard(
          title: 'Potential Risks',
          icon: Icons.warning_amber_rounded,
          iconColor: Colors.red,
          content: _buildList(_result!.potentialRisks),
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
