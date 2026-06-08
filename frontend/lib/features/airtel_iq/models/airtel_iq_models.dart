class AirtelProduct {
  final String id;
  final String name;
  final String category;
  final String shortDescription;
  final String overview;
  final List<String> businessBenefits;
  final List<String> idealCustomerTypes;
  final List<String> keyDifferentiators;
  final List<String> typicalUseCases;

  const AirtelProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.shortDescription,
    required this.overview,
    required this.businessBenefits,
    required this.idealCustomerTypes,
    required this.keyDifferentiators,
    required this.typicalUseCases,
  });
}

class KnowledgeArticle {
  final String id;
  final String title;
  final String category;
  final String summary;
  final String readTime;
  final String content;
  final List<String> keyTakeaways;

  const KnowledgeArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.readTime,
    required this.content,
    required this.keyTakeaways,
  });
}

class FaqItem {
  final String id;
  final String category;
  final String question;
  final String answer;

  const FaqItem({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
  });
}

class SalesPlaybook {
  final String id;
  final String industry;
  final String overview;
  final List<String> painPoints;
  final List<String> recommendedSolutions;
  final List<String> discoveryQuestions;
  final List<String> crossSellOpportunities;

  const SalesPlaybook({
    required this.id,
    required this.industry,
    required this.overview,
    required this.painPoints,
    required this.recommendedSolutions,
    required this.discoveryQuestions,
    required this.crossSellOpportunities,
  });
}

class Objection {
  final String id;
  final String category;
  final String objection;
  final String recommendedResponse;
  final String suggestedFollowUp;

  const Objection({
    required this.id,
    required this.category,
    required this.objection,
    required this.recommendedResponse,
    required this.suggestedFollowUp,
  });
}
