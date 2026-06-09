import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:frontend/features/airtel_iq/services/recommendation_engine.dart';
import 'package:frontend/features/airtel_iq/services/risk_detection_service.dart';
import 'package:frontend/features/airtel_iq/services/action_item_service.dart';

class IntelligenceScore {
  final int meetingReadiness;
  final int relationshipHealth;
  final int upsellPotential;

  IntelligenceScore({
    required this.meetingReadiness,
    required this.relationshipHealth,
    required this.upsellPotential,
  });
}

class MeetingIntelligenceReport {
  final String executiveSummary;
  final IntelligenceScore score;
  final Map<String, List<String>> actionItems;
  final List<DetectedRisk> risks;
  final List<RecommendedProductItem> recommendations;
  final String emailDraft;
  final String nextBestAction;

  MeetingIntelligenceReport({
    required this.executiveSummary,
    required this.score,
    required this.actionItems,
    required this.risks,
    required this.recommendations,
    required this.emailDraft,
    required this.nextBestAction,
  });
}

class MeetingIntelligenceService {
  final RecommendationEngine _recommendationEngine = RecommendationEngine();
  final RiskDetectionService _riskService = RiskDetectionService();
  final ActionItemService _actionService = ActionItemService();

  Future<MeetingIntelligenceReport> generateIntelligence(
      Customer customer, Meeting meeting, List<Meeting> pastMeetings, String notes) async {
    
    // Simulate processing
    await Future.delayed(const Duration(seconds: 1));

    // 1. Analyze Risks
    final risks = _riskService.analyzeRisks(notes);
    
    // 2. Extract Action Items
    final actionItems = _actionService.extractActionItems(notes);
    
    // 3. Generate Recommendations
    final recResult = _recommendationEngine.generateOpportunityInsights(customer, pastMeetings, currentMeetingNotes: notes);
    
    // 4. Calculate Scores
    int health = 85;
    if (risks.any((r) => r.severity == RiskSeverity.high)) {
      health -= 25;
    } else if (risks.isNotEmpty) {
      health -= 10;
    }
    
    int readiness = 90; // Default high readiness assuming notes were taken
    int upsell = recResult.recommendedProducts.isNotEmpty ? 75 : 40;
    if (recResult.recommendedProducts.any((r) => r.confidence == ConfidenceLevel.high)) {
      upsell += 20;
    }
    
    final score = IntelligenceScore(
      meetingReadiness: readiness.clamp(0, 100),
      relationshipHealth: health.clamp(0, 100),
      upsellPotential: upsell.clamp(0, 100),
    );

    // 5. Generate Exec Summary
    final String summary = _generateExecutiveSummary(notes, customer.name);

    // 6. Generate Email Draft
    final String emailDraft = _generateEmailDraft(customer.name, meeting.title, summary, actionItems);

    // 7. Next Best Action
    String nba = "Schedule follow-up to discuss implementation.";
    if (risks.any((r) => r.severity == RiskSeverity.high)) {
      nba = "Immediately address high-severity risks with internal engineering/pricing teams.";
    } else if (recResult.recommendedProducts.isNotEmpty) {
      nba = "Prepare and send a proposal for ${recResult.recommendedProducts.first.product.name}.";
    }

    return MeetingIntelligenceReport(
      executiveSummary: summary,
      score: score,
      actionItems: actionItems,
      risks: risks,
      recommendations: recResult.recommendedProducts,
      emailDraft: emailDraft,
      nextBestAction: nba,
    );
  }

  String _generateExecutiveSummary(String notes, String customerName) {
    if (notes.isEmpty) {
      return "Meeting occurred with $customerName, but no detailed notes were provided.";
    }
    
    final lowerNotes = notes.toLowerCase();
    String topic = "general alignment";
    if (lowerNotes.contains('price') || lowerNotes.contains('cost')) {
      topic = "pricing and commercial terms";
    } else if (lowerNotes.contains('security') || lowerNotes.contains('integration')) {
      topic = "technical requirements and integration";
    } else if (lowerNotes.contains('renewal') || lowerNotes.contains('contract')) {
      topic = "contract renewal";
    }
    
    return "Customer discussed $topic. Key themes extracted indicate a focus on operational efficiency and infrastructure stability.";
  }

  String _generateEmailDraft(String customerName, String? meetingTitle, String summary, Map<String, List<String>> actionItems) {
    final title = meetingTitle ?? "our recent discussion";
    
    final StringBuffer sb = StringBuffer();
    sb.writeln("Subject: Follow-up from $title\n");
    sb.writeln("Hi Team,\n");
    sb.writeln("Thank you for your time today. $summary\n");
    
    final airtelTasks = actionItems['Airtel'] ?? [];
    if (airtelTasks.isNotEmpty) {
      sb.writeln("Next steps from our side:");
      for (var t in airtelTasks) {
        sb.writeln("- $t");
      }
      sb.writeln();
    }
    
    final customerTasks = actionItems['Customer'] ?? [];
    if (customerTasks.isNotEmpty) {
      sb.writeln("Pending items from your side:");
      for (var t in customerTasks) {
        sb.writeln("- $t");
      }
      sb.writeln();
    }
    
    sb.writeln("Please let me know if I missed anything.\n");
    sb.writeln("Best regards,\nAirtel Account Manager");
    
    return sb.toString();
  }
}
