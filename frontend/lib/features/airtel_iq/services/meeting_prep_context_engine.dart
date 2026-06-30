import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:frontend/features/airtel_iq/knowledge/airtel_iq_knowledge_service.dart';

class MeetingPrepContextResult {
  final String executiveBrief;
  final List<String> discussionTopics;
  final List<String> discoveryQuestions;
  final List<String> recommendedProducts;
  final List<String> likelyObjections;
  final List<String> suggestedResponses;
  final String nextBestAction;

  MeetingPrepContextResult({
    required this.executiveBrief,
    required this.discussionTopics,
    required this.discoveryQuestions,
    required this.recommendedProducts,
    required this.likelyObjections,
    required this.suggestedResponses,
    required this.nextBestAction,
  });
}

class MeetingPrepContextEngine {
  final AirtelIqKnowledgeService _knowledgeService = AirtelIqKnowledgeService();

  Future<MeetingPrepContextResult> generateScenarioBrief({
    required String industry,
    required String meetingType,
    required String painPoint,
    String? companySize,
    String? objective,
  }) async {
    // Simulate AI processing
    await Future.delayed(const Duration(seconds: 1));

    final indKnowledge = _knowledgeService.getIndustryByName(industry);
    final methKnowledge = _knowledgeService.getMethodologyByMeetingType(
      meetingType,
    );
    final products = _knowledgeService.getAllProducts();

    // 1. Executive Brief
    String execBrief =
        "Industry Context: $industry organizations often struggle with ${indKnowledge?.businessChallenges.join(', ') ?? painPoint}.\n\n";
    if (companySize != null)
      execBrief +=
          "Target Segment: $companySize enterprises require scalable solutions.\n";
    if (objective != null) execBrief += "Primary Objective: $objective.\n";
    execBrief +=
        "Meeting Focus: This $meetingType is an opportunity to position Airtel as a strategic partner addressing '$painPoint'.";

    // 2. Discussion Topics
    List<String> topics = [];
    if (methKnowledge != null && methKnowledge.focusAreas.isNotEmpty) {
      topics.addAll(methKnowledge.focusAreas);
    } else {
      topics.add("Review current strategies related to $painPoint.");
      topics.add("Discuss Airtel solutions for $industry.");
    }

    // 3. Discovery Questions
    List<String> discovery = [];
    if (indKnowledge != null && indKnowledge.discoveryQuestions.isNotEmpty) {
      discovery.addAll(indKnowledge.discoveryQuestions);
    }
    if (methKnowledge != null && methKnowledge.keyQuestions.isNotEmpty) {
      discovery.addAll(methKnowledge.keyQuestions);
    }
    if (discovery.isEmpty) {
      discovery.add("How is your team currently handling $painPoint?");
      discovery.add(
        "What would a successful resolution to this challenge look like?",
      );
    }

    // 4. Recommended Airtel Products
    List<String> recs = [];
    // Filter products that solve the pain point or belong to the industry
    for (var p in products) {
      if (p.painPointsSolved.any(
            (pp) => pp.toLowerCase().contains(
              painPoint.toLowerCase().split(' ').last,
            ),
          ) ||
          p.industries.contains(industry)) {
        recs.add(p.name);
      }
    }
    if (recs.isEmpty) {
      recs.add("Airtel Corporate Postpaid");
      recs.add("Airtel IQ Business Connect");
    }

    // 5 & 6. Likely Objections & Responses
    List<String> objections = [];
    List<String> responses = [];

    // Gather from recommended products
    for (var pName in recs) {
      final p = products.firstWhere(
        (prod) => prod.name == pName,
        orElse: () => products.first,
      );
      objections.addAll(p.objections);
      responses.addAll(p.objectionResponses);
    }
    if (objections.isEmpty) {
      objections.add("Budget constraints for new solutions.");
      responses.add("Focus on ROI and total cost of ownership reduction.");
    }

    // 7. Next Best Action
    String nba =
        "Uncover root causes of $painPoint and secure commitment for a follow-up demonstration.";
    if (methKnowledge != null && methKnowledge.successIndicators.isNotEmpty) {
      nba =
          "Goal: ${methKnowledge.successIndicators.first}. Ensure all stakeholders agree on next steps.";
    }

    return MeetingPrepContextResult(
      executiveBrief: execBrief,
      discussionTopics: topics.toSet().toList(),
      discoveryQuestions: discovery.toSet().toList(),
      recommendedProducts: recs.toSet().toList(),
      likelyObjections: objections.toSet().toList(),
      suggestedResponses: responses.toSet().toList(),
      nextBestAction: nba,
    );
  }

  Future<MeetingPrepContextResult> generateHistoryBrief({
    required Customer customer,
    required Meeting meeting,
    required List<Meeting> previousMeetings,
  }) async {
    // If we don't have explicit industry/size from the customer, or if they are just strings we can't reliably map,
    // we fall back to a generic Scenario call. The prompt says:
    // "Do NOT infer industry from customer names. Never use logic such as 'ABC Bank' -> Banking. This behavior must be removed."
    // "If sufficient customer context does not exist, use explicit user-selected Scenario inputs instead."
    // Since our Customer model does not have a reliable `industry` or `painPoint` field right now,
    // we will generate a baseline brief using the meeting type and fallback values.

    // We can extract meeting type from the title loosely, or just default to Discovery Meeting
    String meetingType = 'Discovery Meeting';
    if (meeting.title != null) {
      if (meeting.title!.toLowerCase().contains('proposal'))
        meetingType = 'Proposal Discussion';
      if (meeting.title!.toLowerCase().contains('renewal'))
        meetingType = 'Renewal Discussion';
    }

    // Since we can't infer industry, we will rely purely on Meeting Methodology and generic product intelligence
    await Future.delayed(const Duration(seconds: 1));

    final methKnowledge = _knowledgeService.getMethodologyByMeetingType(
      meetingType,
    );
    final products = _knowledgeService.getAllProducts();

    String execBrief = "Customer: ${customer.name}\n";
    execBrief += "Meeting: ${meeting.title ?? 'Sync'}\n";
    execBrief +=
        "History: ${previousMeetings.length} previous engagements.\n\n";
    execBrief +=
        "Note: Explicit industry context is unavailable. Relying on baseline meeting methodology. Consider using Scenario Mode for more targeted intelligence.";

    List<String> topics = [];
    if (methKnowledge != null && methKnowledge.focusAreas.isNotEmpty) {
      topics.addAll(methKnowledge.focusAreas);
    } else {
      topics.add("Review current engagement and identify open challenges.");
    }

    List<String> discovery = [];
    if (methKnowledge != null && methKnowledge.keyQuestions.isNotEmpty) {
      discovery.addAll(methKnowledge.keyQuestions);
    } else {
      discovery.add(
        "What are your primary operational priorities this quarter?",
      );
      discovery.add(
        "How can Airtel better support your communication infrastructure?",
      );
    }

    List<String> recs = [
      "Airtel Corporate Postpaid",
      "Airtel IQ Business Connect",
    ];

    List<String> objections = [];
    List<String> responses = [];
    for (var p in products) {
      objections.addAll(p.objections);
      responses.addAll(p.objectionResponses);
    }

    String nba =
        "Identify explicit pain points and industry requirements to unlock deeper Airtel IQ recommendations.";
    if (methKnowledge != null && methKnowledge.successIndicators.isNotEmpty) {
      nba = "Goal: ${methKnowledge.successIndicators.first}.";
    }

    return MeetingPrepContextResult(
      executiveBrief: execBrief,
      discussionTopics: topics.toSet().toList(),
      discoveryQuestions: discovery.toSet().toList(),
      recommendedProducts: recs.toSet().toList(),
      likelyObjections: objections.toSet().toList(),
      suggestedResponses: responses.toSet().toList(),
      nextBestAction: nba,
    );
  }
}
