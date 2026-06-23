/// Data models for the Opportunity Insights engine.
/// Phase 8.7 – Strategic Account Growth Assistant.
/// 100% deterministic, no LLM, no external calls.
library;

enum OpportunityConfidence {
  quickWin,
  mediumTerm,
  strategicBet;

  String get label {
    switch (this) {
      case quickWin:
        return '🟢 Quick Win';
      case mediumTerm:
        return '🟡 Medium-Term Opportunity';
      case strategicBet:
        return '🔵 Strategic Bet';
    }
  }
}

class OpportunityInsightsInput {
  final String industry; // Mandatory
  final List<String> painPoints; // 0-3, optional
  final String? situationNotes; // Optional freetext
  final List<String> existingProducts; // Optional

  const OpportunityInsightsInput({
    required this.industry,
    this.painPoints = const [],
    this.situationNotes,
    this.existingProducts = const [],
  });
}

class GrowthPotential {
  final int score; // 0-100
  final String
  label; // 'Low Potential' / 'Moderate Potential' / 'High Potential'
  final List<String> drivers;

  const GrowthPotential({
    required this.score,
    required this.label,
    required this.drivers,
  });
}

class BestOpportunity {
  final String productName;
  final OpportunityConfidence confidence;
  final String shortReason;
  final List<String> opportunityDrivers; // "Why this opportunity exists"

  const BestOpportunity({
    required this.productName,
    required this.confidence,
    required this.shortReason,
    required this.opportunityDrivers,
  });
}

class OpportunityInsightsResult {
  final GrowthPotential growthPotential;
  final List<BestOpportunity> bestOpportunities; // Max 3
  final List<String> currentStack; // Existing Airtel Footprint
  final List<String> expansionOpportunities; // Max 4 whitespace products
  final List<String> strategicRisks;
  final List<String> conversationAreas;
  final String suggestedNextMove; // 1 deterministic sentence

  const OpportunityInsightsResult({
    required this.growthPotential,
    required this.bestOpportunities,
    required this.currentStack,
    required this.expansionOpportunities,
    required this.strategicRisks,
    required this.conversationAreas,
    required this.suggestedNextMove,
  });
}
