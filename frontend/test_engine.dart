import 'package:frontend/features/airtel_iq/knowledge/airtel_iq_knowledge_service.dart';
import 'package:frontend/features/airtel_iq/services/meeting_prep_intelligence_engine.dart';

void main() async {
  final engine = MeetingPrepIntelligenceEngine();

  Future<void> runScenario(String name, MeetingPrepV3Input input) async {
    print('====================================================');
    print('SCENARIO: $name');
    print('====================================================');
    final brief = await engine.generate(input);
    print('Top Product: ${brief.primaryRecommendation.productName}');
    print('Reason: ${brief.primaryRecommendation.selectionReason}');
    if (brief.supportingRecs.isNotEmpty) {
      print('Supporting: ${brief.supportingRecs.first.productName}');
      print('Reason: ${brief.supportingRecs.first.selectionReason}');
    } else {
      print('Supporting: NONE (Suppressed by Confidence Layer)');
    }
    print('----------------------------------------------------\\n');
  }

  // 1. Banking + Data Sovereignty
  await runScenario('Banking + Data Sovereignty', MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoint: 'Data Sovereignty',
  ));

  // 2. Banking + Cloud Migration Risk
  await runScenario('Banking + Cloud Migration Risk', MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoint: 'Cloud Migration Risk',
  ));

  // 3. Banking + Data Sovereignty + Situation Notes mentioning data residency
  await runScenario('Banking + Data Sovereignty + Notes', MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoint: 'Data Sovereignty',
    situationNotes: 'The client is extremely worried about data residency laws and requires local data center compliance.',
  ));

  // 4. Banking + Data Sovereignty + Existing Airtel Cloud
  await runScenario('Banking + Data Sovereignty + Existing Cloud', MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoint: 'Data Sovereignty',
    existingAirtelProducts: ['Airtel Public Cloud'],
  ));

  // 5. Banking + Data Sovereignty + Executive Alignment
  await runScenario('Banking + Data Sovereignty + Executive Alignment', MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoint: 'Data Sovereignty',
    meetingType: 'Executive Alignment Meeting',
  ));
}
