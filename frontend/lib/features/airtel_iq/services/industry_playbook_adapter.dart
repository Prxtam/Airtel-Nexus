import 'package:frontend/features/airtel_iq/knowledge/knowledge_models.dart';

/// Adapter layer for Phase 9 – Industry Playbooks.
/// Maps [IndustryIntelligence] repository data into the 5 playbook sections
/// without duplicating any underlying data.
class IndustryPlaybook {
  final String id;
  final String industryName;
  final String? overview;

  /// 🎯 Business Priorities — derived from businessChallenges
  final List<String> businessPriorities;

  /// ⚠️ Common Concerns — derived from objections
  final List<String> commonConcerns;

  /// ❓ Discovery Questions — direct from discoveryQuestions
  final List<String> discoveryQuestions;

  /// 🛠️ Relevant Airtel Solutions — direct from recommendedProducts
  final List<String> relevantSolutions;

  /// 💡 Strategic Conversation Areas — derived from salesOpportunities
  final List<String> conversationAreas;

  /// Regulations (optional, surfaced for compliance-heavy industries)
  final List<String> keyRegulations;

  const IndustryPlaybook({
    required this.id,
    required this.industryName,
    this.overview,
    required this.businessPriorities,
    required this.commonConcerns,
    required this.discoveryQuestions,
    required this.relevantSolutions,
    required this.conversationAreas,
    required this.keyRegulations,
  });

  /// Factory constructor: converts an [IndustryIntelligence] directly.
  factory IndustryPlaybook.fromIndustry(IndustryIntelligence i) {
    return IndustryPlaybook(
      id: i.id,
      industryName: i.industryName,
      overview: i.overview,
      businessPriorities: i.businessChallenges,
      commonConcerns: i.objections,
      discoveryQuestions: i.discoveryQuestions,
      relevantSolutions: i.recommendedProducts,
      conversationAreas: i.salesOpportunities,
      keyRegulations: i.keyRegulations,
    );
  }
}
