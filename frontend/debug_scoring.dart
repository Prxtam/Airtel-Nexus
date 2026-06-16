import 'dart:convert';
import 'package:frontend/features/airtel_iq/knowledge/knowledge_models.dart';
import 'package:frontend/features/airtel_iq/services/meeting_prep_intelligence_engine.dart';
import 'dart:io';

void main() async {
  final engine = MeetingPrepIntelligenceEngine();

  // B) Banking + Data Sovereignty
  final inputB = MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoints: ['Cloud Migration Risk'],
    existingAirtelProducts: [],
  );
  
  final res = await engine.generate(inputB);
  
  print('Scenario C: Banking + Cloud Migration Risk');
  print('Primary: \${res.primaryRecommendation.productName}');
  for (var r in res.supportingRecs) {
    print('Supporting: \${r.productName}');
  }

  // To print raw scores, let's just make engine generate something that dumps the score, or we can copy the scoring logic here.
  // Actually, I can just patch meeting_prep_intelligence_engine.dart to print the scored list before it picks.
}
