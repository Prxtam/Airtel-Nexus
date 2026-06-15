import '../knowledge/airtel_iq_knowledge_service.dart';
import 'meeting_prep_intelligence_engine.dart';
import '../models/meeting_prep_v3_models.dart';
import 'dart:convert';

void main() async {
  final knowledge = AirtelIqKnowledgeService();
  final engine = MeetingPrepIntelligenceEngine(knowledge);
  
  final allIndustries = knowledge.getAllIndustries();
  final allProducts = knowledge.getAllProducts();
  
  // Extract all possible pain points from products to use as the universe of pain points
  final allPainPoints = <String>{};
  for (final p in allProducts) {
    allPainPoints.addAll(p.painPointsSolved);
  }
  
  final results = <String, Map<String, List<String>>>{};
  final productUsage = <String, int>{};
  
  for (final ind in allIndustries) {
    results[ind.industryName] = {};
    for (final pp in allPainPoints) {
      final input = MeetingPrepV3Input(
        industry: ind.industryName,
        painPoints: [pp],
        existingAirtelProducts: [],
      );
      
      final output = await engine.generate(input);
      final recommended = <String>[];
      
      for (final p in output.recommendedProducts) {
        recommended.add(p.productName);
        productUsage[p.productName] = (productUsage[p.productName] ?? 0) + 1;
      }
      results[ind.industryName]![pp] = recommended;
    }
  }
  
  final out = {
    'matrix': results,
    'usage': productUsage,
  };
  
  print(jsonEncode(out));
}
