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
    print('Primary Recommendation:');
    print(' ' + output.primaryRecommendation.productName);
    print('\\nSupporting Recommendations:');
    for (var r in output.supportingRecs) {
      print(' - ' + r.productName);
    }
    print('\\n');
  }

  // A) Banking (No pain points)
  final inputA = MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoints: [],
    existingAirtelProducts: [],
  );
  printResult('Scenario A: Banking (No pain points)', await engine.generate(inputA));

  // B) Banking + Data Sovereignty
  final inputB = MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoints: ['Data Sovereignty'],
    existingAirtelProducts: [],
  );
  printResult('Scenario B: Banking + Data Sovereignty', await engine.generate(inputB));

  // C) Banking + Cloud Migration Risk
  final inputC = MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoints: ['Cloud Migration Risk'],
    existingAirtelProducts: [],
  );
  printResult('Scenario C: Banking + Cloud Migration Risk', await engine.generate(inputC));

  // D) Banking + Security & Compliance
  final inputD = MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoints: ['Security & Compliance'],
    existingAirtelProducts: [],
  );
  printResult('Scenario D: Banking + Security & Compliance', await engine.generate(inputD));

  // E) Banking + Data Sovereignty + Cloud Migration Risk + Security & Compliance
  final inputE = MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoints: ['Data Sovereignty', 'Cloud Migration Risk', 'Security & Compliance'],
    existingAirtelProducts: [],
  );
  printResult('Scenario E: Banking + Data Sovereignty + Cloud Migration Risk + Security & Compliance', await engine.generate(inputE));
}
