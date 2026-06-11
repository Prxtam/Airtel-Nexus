import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';
import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/meetings/providers/meeting_provider.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:frontend/features/airtel_iq/services/meeting_prep_context_engine.dart';
import 'package:frontend/features/airtel_iq/widgets/ai_loading_indicator.dart';
import 'package:frontend/features/airtel_iq/widgets/ai_result_card.dart';

enum PrepMode { scenario, history }

class MeetingPrepScreen extends ConsumerStatefulWidget {
  const MeetingPrepScreen({super.key});

  @override
  ConsumerState<MeetingPrepScreen> createState() => _MeetingPrepScreenState();
}

class _MeetingPrepScreenState extends ConsumerState<MeetingPrepScreen> {
  PrepMode _prepMode = PrepMode.scenario;
  
  // History Mode State
  Customer? _selectedCustomer;
  Meeting? _selectedMeeting;
  
  // Scenario Mode State
  String? _industry;
  String? _companySize;
  String? _meetingType;
  String? _painPoint;
  String? _objective;

  bool _isLoading = false;
  MeetingPrepContextResult? _result;

  final MeetingPrepContextEngine _engine = MeetingPrepContextEngine();

  final List<String> _industries = [
    'Banking & Financial Services',
    'Retail',
    'Manufacturing',
    'Logistics',
    'Healthcare',
    'IT Services',
    'Education',
    'Telecom',
    'Government',
  ];

  final List<String> _companySizes = [
    'Small Business (1–50)',
    'Mid-Market (51–250)',
    'Large Enterprise (251–1000)',
    'Enterprise (1000+)',
  ];

  final List<String> _meetingTypes = [
    'Discovery Meeting',
    'Proposal Discussion',
    'Quarterly Business Review',
    'Renewal Discussion',
    'Escalation Meeting',
    'Relationship Building Meeting',
  ];

  final List<String> _painPoints = [
    'High Communication Costs',
    'Workforce Communication',
    'Remote Team Coordination',
    'Employee Mobility',
    'Roaming Management',
    'Branch Connectivity',
    'Customer Engagement',
    'Operational Efficiency',
    'Digital Transformation',
    'Security & Compliance',
  ];

  final List<String> _objectives = [
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

  void _generatePrep() async {
    setState(() {
      _isLoading = true;
      _result = null;
    });

    try {
      MeetingPrepContextResult res;
      if (_prepMode == PrepMode.scenario) {
        if (_industry == null || _meetingType == null || _painPoint == null) {
          throw Exception("Please fill in all mandatory scenario fields.");
        }
        res = await _engine.generateScenarioBrief(
          industry: _industry!,
          meetingType: _meetingType!,
          painPoint: _painPoint!,
          companySize: _companySize,
          objective: _objective,
        );
      } else {
        if (_selectedCustomer == null || _selectedMeeting == null) {
          throw Exception("Please select a customer and meeting.");
        }
        final allMeetings = ref.read(meetingListProvider).value ?? [];
        final pastMeetings = allMeetings.where((m) => m.customerId == _selectedCustomer!.id).toList();
        res = await _engine.generateHistoryBrief(
          customer: _selectedCustomer!,
          meeting: _selectedMeeting!,
          previousMeetings: pastMeetings,
        );
      }

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

  bool get _canGenerate {
    if (_isLoading) return false;
    if (_prepMode == PrepMode.scenario) {
      return _industry != null && _meetingType != null && _painPoint != null;
    } else {
      return _selectedCustomer != null && _selectedMeeting != null;
    }
  }

  void _copyBriefToClipboard() {
    if (_result == null) return;
    final sb = StringBuffer();
    sb.writeln('MEETING PREPARATION BRIEF');
    sb.writeln();
    sb.writeln('EXECUTIVE BRIEF');
    sb.writeln(_result!.executiveBrief);
    sb.writeln();
    _appendList(sb, 'DISCUSSION TOPICS', _result!.discussionTopics);
    _appendList(sb, 'DISCOVERY QUESTIONS', _result!.discoveryQuestions);
    _appendList(sb, 'RECOMMENDED SOLUTIONS', _result!.recommendedProducts);
    _appendList(sb, 'LIKELY OBJECTIONS', _result!.likelyObjections);
    _appendList(sb, 'SUGGESTED RESPONSES', _result!.suggestedResponses);
    sb.writeln('NEXT BEST ACTION');
    sb.writeln(_result!.nextBestAction);
    
    Clipboard.setData(ClipboardData(text: sb.toString().trimRight()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meeting brief copied to clipboard')),
    );
  }

  void _appendList(StringBuffer sb, String title, List<String> items) {
    sb.writeln(title);
    if (items.isEmpty) {
      sb.writeln('None identified for this context.');
    } else {
      for (var item in items) {
        sb.writeln('• $item');
      }
    }
    sb.writeln();
  }

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
            const Text('Preparation Mode', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SegmentedButton<PrepMode>(
              segments: const [
                ButtonSegment(value: PrepMode.scenario, label: Text('Scenario Mode'), icon: Icon(Icons.psychology)),
                ButtonSegment(value: PrepMode.history, label: Text('Customer History'), icon: Icon(Icons.history)),
              ],
              selected: {_prepMode},
              onSelectionChanged: (Set<PrepMode> newSelection) {
                setState(() {
                  _prepMode = newSelection.first;
                  _result = null;
                });
              },
            ),
            const SizedBox(height: 24),
            
            if (_prepMode == PrepMode.scenario) _buildScenarioMode() else _buildHistoryMode(),
            
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _canGenerate ? _generatePrep : null,
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
              const AiLoadingIndicator(message: 'Analyzing context and generating brief...')
            else if (_result != null)
              _buildResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildScenarioMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDropdown(
          label: 'Industry *',
          value: _industry,
          items: _industries,
          onChanged: (val) => setState(() { _industry = val; _result = null; }),
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: 'Meeting Type *',
          value: _meetingType,
          items: _meetingTypes,
          onChanged: (val) => setState(() { _meetingType = val; _result = null; }),
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: 'Primary Pain Point *',
          value: _painPoint,
          items: _painPoints,
          onChanged: (val) => setState(() { _painPoint = val; _result = null; }),
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: 'Company Size (Optional)',
          value: _companySize,
          items: _companySizes,
          onChanged: (val) => setState(() { _companySize = val; _result = null; }),
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: 'Meeting Objective (Optional)',
          value: _objective,
          items: _objectives,
          onChanged: (val) => setState(() { _objective = val; _result = null; }),
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
      ),
      value: value,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildHistoryMode() {
    final customersState = ref.watch(customerListProvider);
    final meetingsState = ref.watch(meetingListProvider);

    return customersState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => const Center(child: Text('Error loading customers')),
      data: (customers) {
        final customerMeetings = _selectedCustomer != null && meetingsState.value != null
            ? meetingsState.value!.where((m) => m.customerId == _selectedCustomer!.id).toList()
            : <Meeting>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<Customer>(
              decoration: InputDecoration(
                labelText: 'Select Customer *',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              value: _selectedCustomer,
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
                labelText: 'Select Meeting *',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              value: _selectedMeeting,
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
          ],
        );
      },
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
            const Text('AI Sales Coach Insights', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton.icon(
              icon: const Icon(Icons.copy, size: 16),
              label: const Text('Copy Brief'),
              style: TextButton.styleFrom(
                foregroundColor: AppConstants.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onPressed: _copyBriefToClipboard,
            ),
          ],
        ),
        const SizedBox(height: 16),

        SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AiResultCard(
                title: 'Executive Brief',
                icon: Icons.article_outlined,
                iconColor: Colors.blue,
                content: Text(_result!.executiveBrief, style: TextStyle(color: Colors.grey.shade800, height: 1.5)),
              ),
              AiResultCard(
                title: 'Discussion Topics',
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
                content: _buildList(_result!.recommendedProducts),
              ),
              AiResultCard(
                title: 'Likely Objections',
                icon: Icons.warning_amber_rounded,
                iconColor: Colors.red,
                content: _buildList(_result!.likelyObjections),
              ),
              AiResultCard(
                title: 'Suggested Responses',
                icon: Icons.reply,
                iconColor: Colors.teal,
                content: _buildList(_result!.suggestedResponses),
              ),
              AiResultCard(
                title: 'Next Best Action',
                icon: Icons.stars,
                iconColor: AppConstants.primaryColor,
                content: Text(_result!.nextBestAction, style: TextStyle(color: Colors.grey.shade800, height: 1.5, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildList(List<String> items) {
    if (items.isEmpty) {
      return Text('None identified for this context.', style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic));
    }
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
