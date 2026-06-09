enum RiskSeverity { low, medium, high }

enum RiskCategory {
  commercial,
  competitive,
  technical,
  decision,
}

class DetectedRisk {
  final RiskCategory category;
  final RiskSeverity severity;
  final String description;

  DetectedRisk({
    required this.category,
    required this.severity,
    required this.description,
  });
}

class RiskDetectionService {
  /// Analyzes meeting notes to deterministically extract risks based on keywords
  List<DetectedRisk> analyzeRisks(String notes) {
    if (notes.isEmpty) return [];

    final String lowerNotes = notes.toLowerCase();
    final List<DetectedRisk> risks = [];

    // Commercial Risk
    if (lowerNotes.contains('expensive') || lowerNotes.contains('price') || lowerNotes.contains('budget') || lowerNotes.contains('cost')) {
      risks.add(DetectedRisk(
        category: RiskCategory.commercial,
        severity: lowerNotes.contains('too expensive') || lowerNotes.contains('no budget') ? RiskSeverity.high : RiskSeverity.medium,
        description: 'Pricing or budget concerns detected in the discussion.',
      ));
    }

    // Competitive Risk
    if (lowerNotes.contains('jio') || lowerNotes.contains('vi') || lowerNotes.contains('competitor') || lowerNotes.contains('other vendor')) {
      risks.add(DetectedRisk(
        category: RiskCategory.competitive,
        severity: RiskSeverity.high,
        description: 'Competitor presence mentioned. High risk of account churn or split share.',
      ));
    }

    // Technical Risk
    if (lowerNotes.contains('integration') || lowerNotes.contains('security') || lowerNotes.contains('compliance') || lowerNotes.contains('api')) {
      risks.add(DetectedRisk(
        category: RiskCategory.technical,
        severity: lowerNotes.contains('blocker') || lowerNotes.contains('security issue') ? RiskSeverity.high : RiskSeverity.medium,
        description: 'Technical or compliance constraints discussed. Engineering alignment may be required.',
      ));
    }

    // Decision Risk
    if (lowerNotes.contains('delayed') || lowerNotes.contains('postpone') || lowerNotes.contains('q3') || lowerNotes.contains('q4') || lowerNotes.contains('hold')) {
      risks.add(DetectedRisk(
        category: RiskCategory.decision,
        severity: RiskSeverity.medium,
        description: 'Decision timeline appears to be delayed or on hold.',
      ));
    }

    return risks;
  }
}
