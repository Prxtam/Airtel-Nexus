import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/widgets/app_error_widget.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';
import 'package:frontend/features/meeting_notes/providers/meeting_note_provider.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:frontend/features/meetings/providers/meeting_provider.dart';
import 'package:frontend/features/airtel_iq/services/meeting_intelligence_service.dart';
import 'package:frontend/features/airtel_iq/services/risk_detection_service.dart';
import 'package:frontend/features/airtel_iq/services/recommendation_engine.dart';
import 'package:frontend/features/airtel_iq/widgets/ai_loading_indicator.dart';
import 'package:frontend/features/airtel_iq/widgets/ai_result_card.dart';

class MeetingIntelligenceScreen extends ConsumerStatefulWidget {
  final String meetingId;

  const MeetingIntelligenceScreen({super.key, required this.meetingId});

  @override
  ConsumerState<MeetingIntelligenceScreen> createState() => _MeetingIntelligenceScreenState();
}

class _MeetingIntelligenceScreenState extends ConsumerState<MeetingIntelligenceScreen> {
  final MeetingIntelligenceService _service = MeetingIntelligenceService();
  MeetingIntelligenceReport? _report;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Schedule intelligence generation after the initial build so we can read providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateIntelligence();
    });
  }

  Future<void> _generateIntelligence() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // 1. Fetch Meeting
      final meetingAsync = ref.read(meetingDetailProvider(widget.meetingId));
      if (!meetingAsync.hasValue || meetingAsync.value == null) {
        throw Exception("Could not load meeting details.");
      }
      final meeting = meetingAsync.value!;

      // 2. Fetch Customer
      final customerAsync = ref.read(customerDetailProvider(meeting.customerId));
      if (!customerAsync.hasValue || customerAsync.value == null) {
        throw Exception("Could not load customer details.");
      }
      final customer = customerAsync.value!;

      // 3. Fetch All Meetings for Timeline
      final allMeetingsAsync = ref.read(meetingListProvider);
      final pastMeetings = allMeetingsAsync.hasValue && allMeetingsAsync.value != null
          ? allMeetingsAsync.value!.where((m) => m.customerId == customer.id && m.id != meeting.id).toList()
          : <Meeting>[];

      // 4. Fetch Notes
      final notesAsync = ref.read(meetingNoteListProvider(widget.meetingId));
      final notesList = notesAsync.hasValue && notesAsync.value != null ? notesAsync.value! : [];
      final notesText = notesList.map((n) => n.noteText).join('\n\n');

      // 5. Generate Report
      final report = await _service.generateIntelligence(customer, meeting, pastMeetings, notesText);

      if (mounted) {
        setState(() {
          _report = report;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _copyReport() {
    if (_report == null) return;
    
    final sb = StringBuffer();
    sb.writeln("MEETING INTELLIGENCE REPORT");
    sb.writeln("===========================\n");
    
    sb.writeln("EXECUTIVE SUMMARY");
    sb.writeln(_report!.executiveSummary);
    sb.writeln("\nNEXT BEST ACTION");
    sb.writeln(_report!.nextBestAction);
    
    sb.writeln("\nRISKS DETECTED");
    if (_report!.risks.isEmpty) sb.writeln("None detected.");
    for (var r in _report!.risks) {
      sb.writeln("- [${r.severity.name.toUpperCase()}] ${r.category.name.toUpperCase()}: ${r.description}");
    }
    
    sb.writeln("\nCUSTOMER ACTION ITEMS");
    final customerTasks = _report!.actionItems['Customer'] ?? [];
    if (customerTasks.isEmpty) sb.writeln("None");
    for (var t in customerTasks) {
      sb.writeln("- $t");
    }

    sb.writeln("\nAIRTEL ACTION ITEMS");
    final airtelTasks = _report!.actionItems['Airtel'] ?? [];
    if (airtelTasks.isEmpty) sb.writeln("None");
    for (var t in airtelTasks) {
      sb.writeln("- $t");
    }

    sb.writeln("\nRECOMMENDED PRODUCTS");
    if (_report!.recommendations.isEmpty) sb.writeln("None");
    for (var r in _report!.recommendations) {
      sb.writeln("- ${r.product.name} (Confidence: ${r.confidence.name.toUpperCase()})");
      sb.writeln("  Reasoning: ${r.reasoning}");
    }

    Clipboard.setData(ClipboardData(text: sb.toString()));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report copied to clipboard!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Meeting Intelligence'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: _report != null && !_isLoading
          ? FloatingActionButton.extended(
              onPressed: _copyReport,
              icon: const Icon(Icons.copy),
              label: const Text('Copy Report'),
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
            )
          : null,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const AiLoadingIndicator(message: 'Generating deterministic intelligence report...');
    }

    if (_error != null) {
      return AppErrorWidget(
        message: _error!,
        onRetry: _generateIntelligence,
      );
    }

    if (_report == null) {
      return const Center(child: Text('Failed to generate report.'));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeroSnapshot(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildExecutiveSummary(),
                _buildRisks(),
                _buildActionItems(),
                _buildRecommendations(),
                _buildFollowUpEmail(),
                _buildTimeline(),
                const SizedBox(height: 80), // FAB padding
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSnapshot() {
    final score = _report!.score;
    final maxRisk = _report!.risks.isEmpty 
        ? RiskSeverity.low 
        : _report!.risks.map((r) => r.severity).reduce((a, b) => a.index > b.index ? a : b);
        
    Color riskColor = Colors.green;
    String riskLabel = "LOW";
    if (maxRisk == RiskSeverity.medium) {
      riskColor = Colors.orange;
      riskLabel = "MEDIUM";
    } else if (maxRisk == RiskSeverity.high) {
      riskColor = Colors.red;
      riskLabel = "HIGH";
    }

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Intelligence Snapshot', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildScoreGauge('Health', score.relationshipHealth, Colors.blue),
              _buildScoreGauge('Upsell', score.upsellPotential, Colors.purple),
              _buildTextGauge('Risk', riskLabel, riskColor),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.directions_run, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Next Best Action', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                      const SizedBox(height: 4),
                      Text(_report!.nextBestAction, style: TextStyle(color: Colors.blue.shade900, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreGauge(String label, int value, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(
                value: value / 100,
                color: color,
                backgroundColor: Colors.grey.shade200,
                strokeWidth: 6,
              ),
            ),
            Text(
              '$value',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTextGauge(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 6),
          ),
          child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color),
          ),
        ),
        const SizedBox(height: 12),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
      ],
    );
  }

  Widget _buildExecutiveSummary() {
    return AiResultCard(
      title: 'Executive Summary',
      icon: Icons.summarize,
      iconColor: Colors.blue,
      content: Text(_report!.executiveSummary, style: const TextStyle(fontSize: 15, height: 1.5)),
    );
  }

  Widget _buildRisks() {
    if (_report!.risks.isEmpty) {
      return const AiResultCard(
        title: 'Risk Detection',
        icon: Icons.shield_outlined,
        iconColor: Colors.green,
        content: Text('No significant risks detected in the notes.'),
      );
    }

    return AiResultCard(
      title: 'Detected Risks',
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.red,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _report!.risks.map((r) {
          Color bg = Colors.green.shade50;
          Color txt = Colors.green.shade700;
          if (r.severity == RiskSeverity.high) {
            bg = Colors.red.shade50;
            txt = Colors.red.shade700;
          } else if (r.severity == RiskSeverity.medium) {
            bg = Colors.orange.shade50;
            txt = Colors.orange.shade700;
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: txt.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      r.category.name.toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.bold, color: txt, fontSize: 12, letterSpacing: 1.2),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: txt,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        r.severity.name.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(r.description, style: TextStyle(color: Colors.grey.shade900)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionItems() {
    final customerActions = _report!.actionItems['Customer'] ?? [];
    final airtelActions = _report!.actionItems['Airtel'] ?? [];

    return AiResultCard(
      title: 'Action Items',
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Customer Action Items', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          if (customerActions.isEmpty) const Text('None', style: TextStyle(color: Colors.grey)),
          ...customerActions.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(child: Text(a)),
                ]),
              )),
          
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          
          const Text('Airtel Action Items', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          if (airtelActions.isEmpty) const Text('None', style: TextStyle(color: Colors.grey)),
          ...airtelActions.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(child: Text(a)),
                ]),
              )),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return AiResultCard(
      title: 'Product Recommendations',
      icon: Icons.lightbulb_outline,
      iconColor: Colors.amber.shade700,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _report!.recommendations.map((r) {
          Color confColor = Colors.green;
          if (r.confidence == ConfidenceLevel.medium) confColor = Colors.orange;
          if (r.confidence == ConfidenceLevel.low) confColor = Colors.grey;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(r.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: confColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: confColor.withValues(alpha: 0.5)),
                        ),
                        child: Text(
                          '${r.confidence.name.toUpperCase()} CONFIDENCE',
                          style: TextStyle(color: confColor, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Evidence:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  Text(r.evidence, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 8),
                  const Text('Reasoning:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  Text(r.reasoning, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFollowUpEmail() {
    return AiResultCard(
      title: 'Follow-Up Draft',
      icon: Icons.email_outlined,
      iconColor: Colors.purple,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: SelectableText(
              _report!.emailDraft,
              style: TextStyle(fontFamily: 'monospace', color: Colors.grey.shade800, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return AiResultCard(
      title: 'Customer Timeline',
      icon: Icons.history,
      iconColor: Colors.teal,
      content: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Engagement History', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          // We keep this compact as per instructions. Just a simple visual list for the mock.
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.circle, size: 12, color: Colors.grey),
            title: Text('Meeting: Q2 Review'),
            subtitle: Text('No significant risks flagged.'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.circle, size: 12, color: Colors.grey),
            title: Text('Meeting: Connectivity Setup'),
            subtitle: Text('Action Item: Sent Corporate Postpaid proposal.'),
          ),
        ],
      ),
    );
  }
}
