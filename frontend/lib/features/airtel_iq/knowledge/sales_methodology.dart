import 'knowledge_models.dart';

final List<MeetingMethodology> salesMethodologyRepo = [
  const MeetingMethodology(
    id: 'meth_discovery',
    meetingType: 'Discovery Meeting',
    purpose: 'Understand business challenges before discussing products.',
    primaryGoal: 'Understand business challenges before discussing products.',
    keyQuestions: [
      'What business problem are you trying to solve?',
      'What is the current process?',
      'What challenges exist today?',
      'What would success look like?',
    ],
    focusAreas: [],
    risks: [
      'Talking about products too early',
      'Assuming pain points',
      'Missing decision makers',
    ],
    successIndicators: [
      'Clear pain points identified',
      'Stakeholders identified',
      'Follow-up meeting scheduled',
    ],
    nextBestActions: [],
  ),
  const MeetingMethodology(
    id: 'meth_proposal',
    meetingType: 'Proposal Meeting',
    purpose: 'Align Airtel solutions to customer requirements.',
    primaryGoal: 'Align Airtel solutions to customer requirements.',
    keyQuestions: [],
    focusAreas: [
      'Business outcomes',
      'ROI',
      'Implementation approach',
      'Risk mitigation',
    ],
    risks: [
      'Feature dumping',
      'Overcomplicating the discussion',
      'Lack of business justification',
    ],
    successIndicators: [
      'Customer sees business value',
      'Objections surfaced',
      'Next steps agreed',
    ],
    nextBestActions: [],
  ),
  const MeetingMethodology(
    id: 'meth_renewal',
    meetingType: 'Renewal Meeting',
    purpose: 'Retain and expand the relationship.',
    primaryGoal: 'Retain and expand the relationship.',
    keyQuestions: [],
    focusAreas: [
      'Satisfaction',
      'Open issues',
      'Growth opportunities',
      'Additional Airtel solutions',
    ],
    risks: [
      'Competitor presence',
      'Pricing pressure',
      'Unresolved concerns',
    ],
    successIndicators: [
      'Positive sentiment',
      'Renewal intent',
      'Upsell opportunity identified',
    ],
    nextBestActions: [],
  ),
];
