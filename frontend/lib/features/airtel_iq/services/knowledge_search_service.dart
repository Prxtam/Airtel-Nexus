import 'package:frontend/features/airtel_iq/mock_data/airtel_iq_mock_data.dart';
import 'package:frontend/features/airtel_iq/models/airtel_iq_models.dart';

class KnowledgeSearchResult {
  final List<AirtelProduct> products;
  final List<FaqItem> faqs;
  final List<KnowledgeArticle> articles;
  final List<SalesPlaybook> playbooks;
  final List<Objection> objections;

  KnowledgeSearchResult({
    required this.products,
    required this.faqs,
    required this.articles,
    required this.playbooks,
    required this.objections,
  });

  bool get isEmpty =>
      products.isEmpty &&
      faqs.isEmpty &&
      articles.isEmpty &&
      playbooks.isEmpty &&
      objections.isEmpty;
}

class KnowledgeSearchService {
  /// Deterministically searches across all Airtel IQ content
  KnowledgeSearchResult search(String query) {
    if (query.trim().isEmpty) {
      return KnowledgeSearchResult(
        products: [],
        faqs: [],
        articles: [],
        playbooks: [],
        objections: [],
      );
    }

    final lowerQuery = query.toLowerCase();

    final products = AirtelIqMockData.products
        .where(
          (p) =>
              p.name.toLowerCase().contains(lowerQuery) ||
              p.category.toLowerCase().contains(lowerQuery) ||
              p.overview.toLowerCase().contains(lowerQuery),
        )
        .toList();

    final faqs = AirtelIqMockData.faqs
        .where(
          (f) =>
              f.question.toLowerCase().contains(lowerQuery) ||
              f.answer.toLowerCase().contains(lowerQuery),
        )
        .toList();

    final articles = AirtelIqMockData.articles
        .where(
          (a) =>
              a.title.toLowerCase().contains(lowerQuery) ||
              a.summary.toLowerCase().contains(lowerQuery),
        )
        .toList();

    final playbooks = AirtelIqMockData.playbooks
        .where(
          (pb) =>
              pb.industry.toLowerCase().contains(lowerQuery) ||
              pb.overview.toLowerCase().contains(lowerQuery),
        )
        .toList();

    final objections = AirtelIqMockData.objections
        .where(
          (o) =>
              o.objection.toLowerCase().contains(lowerQuery) ||
              o.category.toLowerCase().contains(lowerQuery) ||
              o.recommendedResponse.toLowerCase().contains(lowerQuery),
        )
        .toList();

    return KnowledgeSearchResult(
      products: products,
      faqs: faqs,
      articles: articles,
      playbooks: playbooks,
      objections: objections,
    );
  }
}
