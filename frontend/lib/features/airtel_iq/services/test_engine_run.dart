import 'package:frontend/features/airtel_iq/services/meeting_prep_intelligence_engine.dart';

void main() async {
  final engine = MeetingPrepIntelligenceEngine();

  Future<void> runScenario(String name, MeetingPrepV3Input input) async {
    print('===============================================================');
    print('SCENARIO: $name');
    print('Industry: ${input.industry}');
    print('Pain Points: ${input.painPoints}');
    print('Meeting Type: ${input.meetingType}');
    print('Existing Products: ${input.existingAirtelProducts}');
    print('Situation Notes: ${input.situationNotes}');
    print('---------------------------------------------------------------');
    
    final result = await engine.generate(input);
    
    print('CONTEXT SUMMARY:');
    print(result.contextSummary);
    print('\nSTRATEGY:');
    print('Lead With: ${result.meetingStrategy.leadWith}');
    print('Avoid: ${result.meetingStrategy.avoid}');
    print('Close With: ${result.meetingStrategy.closeWith}');
    print('\nQUESTIONS (${result.discoveryQuestions.length}):');
    for (var q in result.discoveryQuestions) {
      print(' - $q');
    }
    print('\nPRODUCTS:');
    print(' 1. ${result.primaryRecommendation.productName}');
    print('    ${result.primaryRecommendation.selectionReason}');
    for (int i = 0; i < result.supportingRecs.length; i++) {
      print(' ${i + 2}. ${result.supportingRecs[i].productName}');
      print('    ${result.supportingRecs[i].selectionReason}');
    }
    print('\n');
  }

  // 1. Industry only (Banking)
  await runScenario('A - Industry Only', const MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
  ));

  // 2. Industry + 2 pain points (Data Sovereignty + Cloud Migration Risk)
  await runScenario('B - Two Pain Points', const MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoints: ['Data Sovereignty', 'Cloud Migration Risk'],
  ));

  // 3. Industry + 3 pain points (Data Sovereignty + Cloud Migration Risk + Security & Compliance)
  await runScenario('C - Three Pain Points', const MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoints: ['Data Sovereignty', 'Cloud Migration Risk', 'Security & Compliance'],
  ));

  // 4. Industry + Meeting Type + Multiple Pain Points
  await runScenario('D - With Meeting Type', const MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    meetingType: 'Discovery Meeting',
    painPoints: ['Data Sovereignty', 'Cloud Migration Risk'],
  ));

  // 5. Industry + Multiple Pain Points + Existing Airtel Products
  await runScenario('E - With Existing Products', const MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoints: ['Data Sovereignty', 'Cloud Migration Risk'],
    existingAirtelProducts: ['Airtel Secure Internet', 'Airtel Corporate Postpaid'],
  ));

  // 6. Mandatory Scenario F
  await runScenario('F - Mandatory Validation Scenario', const MeetingPrepV3Input(
    industry: 'Banking & Financial Services',
    painPoints: ['Data Sovereignty', 'Cloud Migration Risk', 'Security & Compliance'],
    situationNotes: 'RBI audit raised concerns around data residency and cloud governance.',
  ));
}
