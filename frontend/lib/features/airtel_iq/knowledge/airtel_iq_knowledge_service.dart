import 'knowledge_models.dart';
import 'product_intelligence.dart';
import 'industry_intelligence.dart';
import 'sales_methodology.dart';
import 'product_aliases.dart';

class AirtelIqKnowledgeService {
  /// Returns all available products in the knowledge repository
  List<ProductIntelligence> getAllProducts() {
    return productIntelligenceRepo;
  }

  /// Returns a specific product by its ID
  ProductIntelligence? getProductById(String id) {
    try {
      return productIntelligenceRepo.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Returns products that match a specific industry name
  List<ProductIntelligence> getProductsForIndustry(String industryName) {
    return productIntelligenceRepo
        .where((p) => p.industries.contains(industryName))
        .toList();
  }

  /// Returns a specific industry by its ID
  IndustryIntelligence? getIndustryById(String id) {
    try {
      return industryIntelligenceRepo.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Returns a specific industry by its name
  IndustryIntelligence? getIndustryByName(String name) {
    try {
      return industryIntelligenceRepo.firstWhere(
        (i) => i.industryName.toLowerCase() == name.toLowerCase()
      );
    } catch (_) {
      return null;
    }
  }

  /// Returns the sales methodology for a specific meeting type
  MeetingMethodology? getMethodologyByMeetingType(String meetingType) {
    try {
      return salesMethodologyRepo.firstWhere(
        (m) => m.meetingType.toLowerCase() == meetingType.toLowerCase()
      );
    } catch (_) {
      return null;
    }
  }

  /// Returns discovery questions mapped to a specific industry
  List<String> getDiscoveryQuestionsForIndustry(String industryName) {
    final industry = getIndustryByName(industryName);
    return industry?.discoveryQuestions ?? [];
  }

  /// Returns recommended products mapped to a specific industry
  List<String> getRecommendedProductsForIndustry(String industryName) {
    final industry = getIndustryByName(industryName);
    return canonicalizeProductNames(industry?.recommendedProducts ?? const []);
  }

  /// Returns likely objections and their responses for a specific product
  List<String> getObjectionsForProduct(String productId) {
    final product = getProductById(productId);
    return product?.objections ?? [];
  }
}
