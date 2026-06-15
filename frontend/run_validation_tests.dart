import 'dart:convert';
import 'package:frontend/features/airtel_iq/knowledge/knowledge_models.dart';
import 'package:frontend/features/airtel_iq/services/meeting_prep_intelligence_engine.dart';
import 'dart:io';

void main() async {
  final engine = MeetingPrepIntelligenceEngine();

  void printResult(String testName, MeetingPrepV3Result output) {
    print('=======================================');
    print('TEST: ' + testName);
    print('=======================================');
    print('Validate Statement:');
    print(' ' + output.meetingStrategy.validate);
    print('\\nTop Challenges:');
    for (var c in output.topChallenges) {
      print(' - ' + c);
    }
    print('\\nPrimary Recommendation:');
    print(' ' + output.primaryRecommendation.productName);
    print('\\nSupporting Recommendations:');
    for (var r in output.supportingRecs) {
      print(' - ' + r.productName);
    }
    print('\\n');
  }

  // Test A
  final inputA = MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoints: ['Data Sovereignty'],
  );
  final outputA = await engine.generate(inputA);
  printResult('Test A: Banking + Data Sovereignty', outputA);

  // Test B
  final inputB = MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoints: ['Data Sovereignty', 'Cloud Migration Risk', 'Security & Compliance'],
  );
  final outputB = await engine.generate(inputB);
  printResult('Test B: Banking + 3 Pain Points', outputB);

  // Test C
  final inputC = MeetingPrepV3Input(
    industry: 'Manufacturing',
    painPoints: ['Smart Factory'],
  );
  final outputC = await engine.generate(inputC);
  printResult('Test C: Manufacturing + Smart Factory', outputC);

  // Test D - check placeholders
  print('=======================================');
  print('TEST: Test D: Repository Integrity');
  print('=======================================');
  
  final engineContent = File('lib/features/airtel_iq/services/meeting_prep_intelligence_engine.dart').readAsStringSync();
  final indContent = File('lib/features/airtel_iq/knowledge/industry_intelligence.dart').readAsStringSync();
  final prodContent = File('lib/features/airtel_iq/knowledge/product_intelligence.dart').readAsStringSync();
  
  final allContent = engineContent + indContent + prodContent;
  
  // Count placeholders
  final p1 = RegExp(r'Demonstrate Airtel.*specific solution fit').allMatches(allContent).length;
  final p2 = RegExp(r'Engage with the Airtel enterprise team for a tailored response').allMatches(allContent).length;
  final totalPlaceholders = p1 + p2;
  
  print('Number of placeholder objection responses remaining: \$totalPlaceholders');
  
  // Generic products in specialist scenarios
  int genericLeaks = 0;
  if (outputA.primaryRecommendation.productName.contains('Corporate Postpaid') || outputA.supportingRecs.any((r) => r.productName.contains('Corporate Postpaid'))) {
    genericLeaks++;
  }
  if (outputB.primaryRecommendation.productName.contains('Corporate Postpaid') || outputB.supportingRecs.any((r) => r.productName.contains('Corporate Postpaid'))) {
    genericLeaks++;
  }
  if (outputC.primaryRecommendation.productName.contains('Corporate Postpaid') || outputC.supportingRecs.any((r) => r.productName.contains('Corporate Postpaid'))) {
    genericLeaks++;
  }
  print('Number of generic products leaking into specialist scenarios: \$genericLeaks');
}
