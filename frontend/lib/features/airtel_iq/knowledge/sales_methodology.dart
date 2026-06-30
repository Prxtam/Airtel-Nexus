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
      'Who are the key stakeholders involved in this transformation?',
      'What happens if we do nothing and maintain the status quo?',
    ],
    focusAreas: ['Business context', 'Pain points', 'Desired outcomes'],
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
    nextBestActions: ['Document findings', 'Draft initial value proposition'],
  ),
  const MeetingMethodology(
    id: 'meth_proposal',
    meetingType: 'Proposal Meeting',
    purpose: 'Align Airtel solutions to customer requirements.',
    primaryGoal: 'Align Airtel solutions to customer requirements.',
    keyQuestions: [
      'How does this solution align with your timeline?',
      'Are there any technical dependencies we need to address?',
      'Who needs to sign off on this proposal?',
    ],
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
    nextBestActions: [
      'Send revised proposal',
      'Schedule technical deep dive if needed',
    ],
  ),
  const MeetingMethodology(
    id: 'meth_renewal',
    meetingType: 'Renewal Meeting',
    purpose: 'Retain and expand the relationship.',
    primaryGoal: 'Retain and expand the relationship.',
    keyQuestions: [
      'How has our service impacted your business over the last term?',
      'Are there any areas where we fell short of expectations?',
      'What new initiatives are you planning for the upcoming year?',
    ],
    focusAreas: [
      'Satisfaction',
      'Open issues',
      'Growth opportunities',
      'Additional Airtel solutions',
    ],
    risks: ['Competitor presence', 'Pricing pressure', 'Unresolved concerns'],
    successIndicators: [
      'Positive sentiment',
      'Renewal intent',
      'Upsell opportunity identified',
    ],
    nextBestActions: ['Send renewal contract', 'Address any escalated issues'],
  ),
  const MeetingMethodology(
    id: 'meth_exec_alignment',
    meetingType: 'Executive Alignment Meeting',
    purpose:
        'Ensure strategic alignment between Airtel leadership and customer executives.',
    primaryGoal:
        'Establish Airtel as a strategic business partner rather than a vendor.',
    keyQuestions: [
      'What are your top 3 strategic priorities for the next 18 months?',
      'How is digital transformation reshaping your competitive landscape?',
      'Where do you see the biggest risk to your operational continuity?',
    ],
    focusAreas: [
      'Strategic partnership',
      'Long-term vision',
      'Market trends',
      'Business impact',
    ],
    risks: [
      'Getting dragged into tactical/technical weeds',
      'Focusing too much on pricing',
      'Failing to connect solutions to boardroom priorities',
    ],
    successIndicators: [
      'Executive sponsorship secured',
      'Strategic alignment confirmed',
      'Top-down mandate given for technical teams to engage',
    ],
    nextBestActions: [
      'Send executive summary',
      'Initiate technical workshops with operational teams',
    ],
  ),
  const MeetingMethodology(
    id: 'meth_tech_workshop',
    meetingType: 'Technical Workshop',
    purpose:
        'Deep dive into solution architecture, integration, and deployment.',
    primaryGoal: 'Validate technical feasibility and secure technical win.',
    keyQuestions: [
      'What does your current architecture diagram look like?',
      'What are your specific security and compliance requirements?',
      'How do you plan to handle integration with legacy systems?',
      'What is your expected timeline for deployment?',
    ],
    focusAreas: [
      'Architecture',
      'Security',
      'Integration',
      'Deployment phases',
    ],
    risks: [
      'Uncovering insurmountable technical blockers',
      'Scope creep',
      'Losing focus on the business outcome',
    ],
    successIndicators: [
      'Technical architecture approved',
      'Security concerns addressed',
      'Implementation roadmap agreed',
    ],
    nextBestActions: [
      'Provide technical documentation',
      'Scope statement of work (SOW)',
    ],
  ),
  const MeetingMethodology(
    id: 'meth_solution_demo',
    meetingType: 'Solution Demonstration',
    purpose: 'Showcase product capabilities mapped to customer pain points.',
    primaryGoal:
        'Prove the solution can deliver the promised business outcomes.',
    keyQuestions: [
      'Does this workflow address the challenge you mentioned earlier?',
      'How would your team use this feature day-to-day?',
      'Is there anything missing from this flow that you absolutely need?',
    ],
    focusAreas: [
      'User experience',
      'Key features solving pain points',
      'Ease of use',
      'Reporting and analytics',
    ],
    risks: [
      'Demo environment failing',
      'Showing features instead of value (feature dumping)',
      'Not tailoring the demo to the specific customer',
    ],
    successIndicators: [
      'Customer verbalizes how it helps them',
      'Engagement and questions during the demo',
      'Request for pricing or pilot',
    ],
    nextBestActions: ['Send tailored proposal', 'Discuss pilot/POC terms'],
  ),
  const MeetingMethodology(
    id: 'meth_renewal_negotiation',
    meetingType: 'Renewal Negotiation',
    purpose: 'Finalize terms for contract renewal and secure signature.',
    primaryGoal:
        'Protect current revenue and finalize renewal without massive discounting.',
    keyQuestions: [
      'What is required to get this approved by procurement today?',
      'If we can meet this timeline, are you ready to sign?',
      'How does this pricing align with your current budget constraints?',
    ],
    focusAreas: [
      'Value delivered over past term',
      'Pricing structure',
      'Contract terms',
      'Future roadmap',
    ],
    risks: [
      'Procurement demanding steep discounts',
      'Competitor aggressive pricing',
      'Legal redlining delays',
    ],
    successIndicators: [
      'Verbal agreement on terms',
      'Contract sent for signature',
      'No major legal blockers',
    ],
    nextBestActions: [
      'Route contract for signature',
      'Schedule kickoff for any new services',
    ],
  ),
  const MeetingMethodology(
    id: 'meth_upsell_review',
    meetingType: 'Upsell Review',
    purpose: 'Introduce new solutions to an existing happy customer.',
    primaryGoal:
        'Expand share of wallet by solving adjacent business problems.',
    keyQuestions: [
      'Now that we have solved X, how are you handling Y?',
      'Have you considered consolidating your vendors for this new initiative?',
      'What is the impact of keeping these systems disconnected?',
    ],
    focusAreas: [
      'Adjacent pain points',
      'Vendor consolidation benefits',
      'Integration with existing Airtel services',
    ],
    risks: [
      'Customer feeling nickeled and dimed',
      'Distracting from core service delivery',
      'Lack of budget for new initiatives',
    ],
    successIndicators: [
      'Interest in new solution confirmed',
      'Pain point acknowledged',
      'Demo scheduled',
    ],
    nextBestActions: [
      'Provide detailed product info',
      'Schedule technical deep dive',
    ],
  ),
  const MeetingMethodology(
    id: 'meth_qbr',
    meetingType: 'Quarterly Business Review',
    purpose: 'Review performance, SLA adherence, and strategic alignment.',
    primaryGoal:
        'Demonstrate continuous value and identify new operational challenges.',
    keyQuestions: [
      'How has our service performed against your expectations this quarter?',
      'What upcoming projects do you have in the next 3-6 months?',
      'How can we better support your evolving business needs?',
    ],
    focusAreas: [
      'SLA performance',
      'Usage metrics',
      'Support ticket review',
      'Strategic roadmap',
    ],
    risks: [
      'Turning the meeting into a tactical support complaining session',
      'Lack of executive attendance',
      'Failing to show quantifiable ROI',
    ],
    successIndicators: [
      'Value acknowledged by customer',
      'Operational issues resolved',
      'Strategic initiatives identified for next quarter',
    ],
    nextBestActions: [
      'Send QBR summary report',
      'Action any pending support items',
    ],
  ),
  const MeetingMethodology(
    id: 'meth_stakeholder_mapping',
    meetingType: 'Stakeholder Mapping Session',
    purpose: 'Identify and align with all key decision-makers and influencers.',
    primaryGoal:
        'Navigate the organizational structure to build a winning consensus.',
    keyQuestions: [
      'Who else needs to weigh in on this decision?',
      'What are the primary concerns of the CFO regarding this project?',
      'Who typically champions this type of transformation internally?',
    ],
    focusAreas: [
      'Decision criteria',
      'Buying center',
      'Internal politics',
      'Individual motivations',
    ],
    risks: [
      'Being blocked by an unknown detractor',
      'Relying on a champion with no purchasing power',
      'Offending the primary contact by asking to go over their head',
    ],
    successIndicators: [
      'Complete org chart mapped',
      'Detractors and champions identified',
      'Strategy to engage economic buyer formulated',
    ],
    nextBestActions: [
      'Draft engagement plan for key stakeholders',
      'Request introductions to secondary decision-makers',
    ],
  ),
];
