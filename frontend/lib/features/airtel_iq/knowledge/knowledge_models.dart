class ProductIntelligence {
  final String id;
  final String name;
  final String overview;
  final List<String> idealCustomers;
  final List<String> industries;
  final List<String> painPointsSolved;
  final List<String> businessOutcomes;
  final List<String> discoveryQuestions;
  final List<String> objections;
  final List<String> objectionResponses;
  final List<String> crossSellOpportunities;
  final String elevatorPitch;
  final String executivePitch;
  final List<String> meetingTalkingPoints;

  const ProductIntelligence({
    required this.id,
    required this.name,
    required this.overview,
    required this.idealCustomers,
    required this.industries,
    required this.painPointsSolved,
    required this.businessOutcomes,
    required this.discoveryQuestions,
    required this.objections,
    required this.objectionResponses,
    required this.crossSellOpportunities,
    required this.elevatorPitch,
    required this.executivePitch,
    required this.meetingTalkingPoints,
  });
}

class IndustryIntelligence {
  final String id;
  final String industryName;
  final List<String> businessChallenges;
  final List<String> technologyChallenges;
  final List<String> recommendedProducts;
  final List<String> discoveryQuestions;
  final List<String> objections;
  final List<String> salesOpportunities;

  const IndustryIntelligence({
    required this.id,
    required this.industryName,
    required this.businessChallenges,
    required this.technologyChallenges,
    required this.recommendedProducts,
    required this.discoveryQuestions,
    required this.objections,
    required this.salesOpportunities,
  });
}

class MeetingMethodology {
  final String id;
  final String meetingType;
  final String purpose;
  final String primaryGoal;
  final List<String> keyQuestions;
  final List<String> focusAreas; // Included to match provided dataset
  final List<String> risks;
  final List<String> successIndicators;
  final List<String> nextBestActions;

  const MeetingMethodology({
    required this.id,
    required this.meetingType,
    required this.purpose,
    required this.primaryGoal,
    required this.keyQuestions,
    this.focusAreas = const [],
    required this.risks,
    required this.successIndicators,
    required this.nextBestActions,
  });
}
