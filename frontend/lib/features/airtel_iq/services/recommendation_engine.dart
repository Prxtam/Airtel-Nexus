import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:frontend/features/airtel_iq/mock_data/airtel_iq_mock_data.dart';
import 'package:frontend/features/airtel_iq/models/airtel_iq_models.dart';

class RecommendationResult {
  final List<AirtelProduct> recommendedProducts;
  final String reasoning;

  RecommendationResult({required this.recommendedProducts, required this.reasoning});
}

class RecommendationEngine {
  /// Deterministically suggest products based on simple rules
  RecommendationResult generateOpportunityInsights(Customer customer, List<Meeting> pastMeetings) {
    // In a real application, we would evaluate customer.industry or current subscriptions.
    // For this deterministic mock, we will use the customer name or a simple heuristic.
    
    final bool isTechOrBanking = customer.name.toLowerCase().contains('tech') || 
                                 customer.name.toLowerCase().contains('bank') ||
                                 customer.name.toLowerCase().contains('finance');
                                 
    final bool hasManyMeetings = pastMeetings.length > 2;

    List<AirtelProduct> recommended = [];
    String reasoning = "";

    if (isTechOrBanking) {
      recommended.add(AirtelIqMockData.products.firstWhere((p) => p.id == 'p1')); // Business Connect
      reasoning = "Customer '${customer.name}' operates in a high-compliance/tech sector. Recommend Airtel IQ Business Connect to ensure communication continuity and compliance tracking.";
    } else if (hasManyMeetings) {
      recommended.add(AirtelIqMockData.products.firstWhere((p) => p.id == 'p2')); // Corporate Postpaid
      reasoning = "Frequent interactions suggest a growing remote or field team. Pitch Airtel Corporate Postpaid for Data Rollover and built-in Perplexity Pro AI.";
    } else {
      // Default cross-sell
      recommended = AirtelIqMockData.products;
      reasoning = "Customer profile indicates potential for enterprise mobility and unified communications. Pitching both Corporate Postpaid and Business Connect could uncover new use cases.";
    }

    return RecommendationResult(
      recommendedProducts: recommended,
      reasoning: reasoning,
    );
  }
}
