import 'knowledge_models.dart';

final List<IndustryIntelligence> industryIntelligenceRepo = [
  const IndustryIntelligence(
    id: 'ind_banking_finance',
    industryName: 'Banking & Financial Services',
    businessChallenges: [
      'Regulatory compliance',
      'Customer service expectations',
      'Distributed branch operations',
      'Workforce coordination',
    ],
    technologyChallenges: [
      'Secure communication',
      'Branch connectivity',
      'Workforce mobility',
      'Centralized management',
    ],
    recommendedProducts: [
      'Corporate Postpaid',
      'Business Connect',
    ],
    discoveryQuestions: [
      'How do branches communicate today?',
      'How is workforce mobility managed?',
      'What communication challenges exist between branches?',
      'Are communication costs centrally tracked?',
    ],
    objections: [
      'Security concerns',
      'Compliance concerns',
      'Integration complexity',
    ],
    salesOpportunities: [
      'Workforce communication',
      'Branch modernization',
      'Employee mobility',
    ],
  ),
  const IndustryIntelligence(
    id: 'ind_retail',
    industryName: 'Retail',
    businessChallenges: [
      'Multi-store operations',
      'Staff turnover',
      'Seasonal workforce spikes',
      'Customer engagement',
    ],
    technologyChallenges: [
      'Store communication',
      'Field workforce coordination',
      'Employee onboarding',
    ],
    recommendedProducts: [
      'Corporate Postpaid',
      'Business Connect',
    ],
    discoveryQuestions: [
      'How do stores communicate with headquarters?',
      'How are operational updates shared?',
      'How is communication managed during peak seasons?',
    ],
    objections: [],
    salesOpportunities: [
      'Store connectivity',
      'Employee communication',
      'Workforce coordination',
    ],
  ),
  const IndustryIntelligence(
    id: 'ind_manufacturing',
    industryName: 'Manufacturing',
    businessChallenges: [
      'Plant coordination',
      'Field workforce management',
      'Operational efficiency',
    ],
    technologyChallenges: [
      'Site communication',
      'Workforce mobility',
      'Multi-location operations',
    ],
    recommendedProducts: [
      'Corporate Postpaid',
      'Business Connect',
    ],
    discoveryQuestions: [
      'How are production sites coordinated?',
      'How do managers communicate with field teams?',
      'What communication delays impact operations?',
    ],
    objections: [],
    salesOpportunities: [],
  ),
  const IndustryIntelligence(
    id: 'ind_logistics',
    industryName: 'Logistics',
    businessChallenges: [
      'Fleet coordination',
      'Real-time communication',
      'Distributed operations',
    ],
    technologyChallenges: [
      'Driver connectivity',
      'Field workforce management',
      'Operational visibility',
    ],
    recommendedProducts: [
      'Corporate Postpaid',
      'Business Connect',
    ],
    discoveryQuestions: [
      'How do dispatch teams communicate with drivers?',
      'What communication challenges affect delivery operations?',
      'How is workforce connectivity managed?',
    ],
    objections: [],
    salesOpportunities: [],
  ),
];
