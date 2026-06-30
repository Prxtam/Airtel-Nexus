import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:frontend/features/airtel_iq/mock_data/airtel_iq_mock_data.dart';
import 'package:frontend/features/airtel_iq/models/airtel_iq_models.dart';

enum ConfidenceLevel { high, medium, low }

class RecommendedProductItem {
  final AirtelProduct product;
  final ConfidenceLevel confidence;
  final String evidence;
  final String reasoning;

  RecommendedProductItem({
    required this.product,
    required this.confidence,
    required this.evidence,
    required this.reasoning,
  });
}

class RecommendationResult {
  final List<RecommendedProductItem> recommendedProducts;
  final String overallReasoning;

  RecommendationResult({
    required this.recommendedProducts,
    required this.overallReasoning,
  });
}

class RecommendationEngine {
  /// Deterministically suggest products based on simple rules including meeting notes
  RecommendationResult generateOpportunityInsights(
    Customer customer,
    List<Meeting> pastMeetings, {
    String? currentMeetingNotes,
  }) {
    final bool isTechOrBanking =
        customer.name.toLowerCase().contains('tech') ||
        customer.name.toLowerCase().contains('bank') ||
        customer.name.toLowerCase().contains('finance');

    final bool hasManyMeetings = pastMeetings.length > 2;

    final String combinedNotes = currentMeetingNotes ?? '';
    final String lowerNotes = combinedNotes.toLowerCase();

    List<RecommendedProductItem> recommended = [];
    String overallReasoning =
        "Based on customer profile and engagement history.";

    // Logic for Business Connect
    if (lowerNotes.contains('field sales') ||
        lowerNotes.contains('tracking') ||
        lowerNotes.contains('communication continuity') ||
        lowerNotes.contains('omni')) {
      recommended.add(
        RecommendedProductItem(
          product: AirtelIqMockData.products.firstWhere(
            (p) => p.id == 'p1',
            orElse: () => AirtelIqMockData.products.first,
          ),
          confidence: ConfidenceLevel.high,
          evidence:
              'Meeting notes mentioned: "field sales", "tracking", or "continuity".',
          reasoning:
              'Airtel IQ Business Connect provides omni-channel tracking and continuity for field teams.',
        ),
      );
    } else if (isTechOrBanking) {
      recommended.add(
        RecommendedProductItem(
          product: AirtelIqMockData.products.firstWhere(
            (p) => p.id == 'p1',
            orElse: () => AirtelIqMockData.products.first,
          ),
          confidence: ConfidenceLevel.medium,
          evidence: 'Customer operates in tech/banking sector.',
          reasoning:
              'High compliance sectors benefit from the tracking and recording capabilities of Business Connect.',
        ),
      );
    }

    // Logic for Corporate Postpaid
    if (lowerNotes.contains('roaming') ||
        lowerNotes.contains('travel') ||
        lowerNotes.contains('data limit')) {
      recommended.add(
        RecommendedProductItem(
          product: AirtelIqMockData.products.firstWhere(
            (p) => p.id == 'p2',
            orElse: () => AirtelIqMockData.products.first,
          ),
          confidence: ConfidenceLevel.high,
          evidence: 'Meeting notes mentioned: "roaming" or "travel".',
          reasoning:
              'Airtel Corporate Postpaid includes Airtel World Pass (184 countries) and Perplexity Pro AI for traveling executives.',
        ),
      );
    } else if (hasManyMeetings) {
      // Avoid duplicates if we already added a product, but let's assume we can add multiple
      recommended.add(
        RecommendedProductItem(
          product: AirtelIqMockData.products.firstWhere(
            (p) => p.id == 'p2',
            orElse: () => AirtelIqMockData.products.first,
          ),
          confidence: ConfidenceLevel.low,
          evidence:
              'Frequent engagement history (${pastMeetings.length} meetings).',
          reasoning:
              'Growing relationship indicates potential to consolidate mobile connections under a unified billing plan.',
        ),
      );
    }

    // Logic for Trace Mate (mock product)
    if (lowerNotes.contains('logistics') ||
        lowerNotes.contains('fleet') ||
        lowerNotes.contains('delivery')) {
      // Since we might not have Trace Mate in mock data, just use the first product as a fallback or add it
      recommended.add(
        RecommendedProductItem(
          product: AirtelIqMockData.products.firstWhere(
            (p) => p.name.contains('Trace'),
            orElse: () => AirtelProduct(
              id: 'p_trace',
              name: 'Airtel Trace Mate',
              category: 'IoT & Tracking',
              overview: 'Advanced asset and workforce tracking.',
              shortDescription:
                  'Real-time location intelligence for fleet and workforce.',
              businessBenefits: [],
              idealCustomerTypes: [],
              keyDifferentiators: [],
              typicalUseCases: [],
            ),
          ),
          confidence: ConfidenceLevel.high,
          evidence: 'Meeting notes mentioned logistics/delivery tracking.',
          reasoning:
              'Trace Mate provides precise location intelligence natively integrated with Airtel connectivity.',
        ),
      );
    }

    // Fallback
    if (recommended.isEmpty) {
      recommended.add(
        RecommendedProductItem(
          product: AirtelIqMockData.products.first,
          confidence: ConfidenceLevel.low,
          evidence: 'Standard cross-sell baseline.',
          reasoning:
              'Unified communications consistently reduce OPEX for mid-to-large enterprises.',
        ),
      );
    }

    return RecommendationResult(
      recommendedProducts: recommended,
      overallReasoning: overallReasoning,
    );
  }
}
