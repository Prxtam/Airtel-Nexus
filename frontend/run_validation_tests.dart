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

  // Scenario A
  final inputA = MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoints: ['Data Sovereignty'],
  );
  printResult('Scenario A: Banking + Data Sovereignty', await engine.generate(inputA));

  // Scenario B
  final inputB = MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoints: ['Cloud Migration Risk'],
  );
  printResult('Scenario B: Banking + Cloud Migration Risk', await engine.generate(inputB));

  // Scenario C
  final inputC = MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoints: ['Security & Compliance'],
  );
  printResult('Scenario C: Banking + Security & Compliance', await engine.generate(inputC));

  // Scenario D
  final inputD = MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoints: ['Data Sovereignty', 'Cloud Migration Risk'],
  );
  printResult('Scenario D: Banking + Data Sovereignty + Cloud Migration Risk', await engine.generate(inputD));

  // Scenario E
  final inputE = MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoints: ['Data Sovereignty', 'Cloud Migration Risk', 'Security & Compliance'],
  );
  printResult('Scenario E: Banking + 3 Pain Points', await engine.generate(inputE));
}
