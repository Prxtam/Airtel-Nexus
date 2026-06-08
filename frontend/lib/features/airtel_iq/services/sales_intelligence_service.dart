import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:frontend/features/airtel_iq/services/recommendation_engine.dart';
import 'package:frontend/features/airtel_iq/models/airtel_iq_models.dart';

class MeetingPreparationResult {
  final String meetingBrief;
  final List<String> discussionTopics;
  final List<String> discoveryQuestions;
  final List<AirtelProduct> recommendedSolutions;
  final List<String> potentialRisks;

  MeetingPreparationResult({
    required this.meetingBrief,
    required this.discussionTopics,
    required this.discoveryQuestions,
    required this.recommendedSolutions,
    required this.potentialRisks,
  });
}

class FollowUpResult {
  final String executiveSummary;
  final List<String> keyDecisions;
  final List<String> actionItems;
  final String emailDraft;

  FollowUpResult({
    required this.executiveSummary,
    required this.keyDecisions,
    required this.actionItems,
    required this.emailDraft,
  });
}

class SalesIntelligenceService {
  final RecommendationEngine _recommendationEngine = RecommendationEngine();

  /// Deterministically generate meeting prep based on customer context
  Future<MeetingPreparationResult> prepareForMeeting(Customer customer, Meeting meeting, List<Meeting> pastMeetings) async {
    // Simulate slight processing delay
    await Future.delayed(const Duration(seconds: 1));

    final recommendations = _recommendationEngine.generateOpportunityInsights(customer, pastMeetings);
    
    // Deterministic rules based on customer/meeting state
    final bool isTech = customer.name.toLowerCase().contains('tech');
    
    return MeetingPreparationResult(
      meetingBrief: "Customer '${customer.name}' has had ${pastMeetings.length} previous engagements. The upcoming meeting '${meeting.title ?? 'Sync'}' is a prime opportunity to align Airtel Enterprise solutions with their current business needs.",
      discussionTopics: [
        "Review current connectivity infrastructure.",
        "Discuss remote workforce management challenges.",
        isTech ? "Introduce API integrations with Airtel IQ." : "Discuss cost-saving through unified billing.",
      ],
      discoveryQuestions: [
        "How are you currently managing communications for your distributed teams?",
        "What happens to client continuity when a field agent leaves the company?",
        "Are you experiencing any security concerns with employees using personal devices for corporate tasks?",
      ],
      recommendedSolutions: recommendations.recommendedProducts,
      potentialRisks: [
        "Decision-maker might push back on perceived migration costs.",
        "Competitor lock-in on existing mobility contracts.",
      ],
    );
  }

  /// Deterministically generate follow-ups based on meeting context
  Future<FollowUpResult> generateFollowUp(Meeting meeting, Customer customer) async {
    // Simulate slight processing delay
    await Future.delayed(const Duration(seconds: 1));

    final String meetingTitle = meeting.title ?? "Recent Discussion";

    return FollowUpResult(
      executiveSummary: "Productive meeting with ${customer.name} focusing on streamlining their communication channels. Client expressed interest in upgrading their mobility plans provided we can demonstrate cost savings on GST and roaming.",
      keyDecisions: [
        "Agreed to pilot Airtel Corporate Postpaid for 50 field agents.",
        "Decided to hold off on Airtel IQ Business Connect until Q3.",
      ],
      actionItems: [
        "Send formal proposal for 50 Corporate Postpaid connections.",
        "Schedule a technical demo of the Perplexity Pro AI integration.",
        "Provide a roaming cost comparison vs their current provider.",
      ],
      emailDraft: """Subject: Follow-up from our meeting regarding $meetingTitle

Hi Team,

Thank you for the productive discussion today regarding your enterprise connectivity needs. We are excited about the opportunity to help ${customer.name} streamline communications and reduce overhead.

As discussed, I will be preparing a formal proposal for 50 Airtel Corporate Postpaid connections. I will also schedule a brief technical demonstration of the Perplexity Pro AI integration next week.

Please let me know if you have any questions in the meantime.

Best regards,
Airtel Account Manager""",
    );
  }

  /// Expose the recommendation engine for standalone insights
  Future<RecommendationResult> getOpportunityInsights(Customer customer, List<Meeting> pastMeetings) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _recommendationEngine.generateOpportunityInsights(customer, pastMeetings);
  }
}
