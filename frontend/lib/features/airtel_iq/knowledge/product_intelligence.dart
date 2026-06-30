import 'knowledge_models.dart';

final List<ProductIntelligence> productIntelligenceRepo = [
  const ProductIntelligence(
    id: 'prod_corp_postpaid',
    name: 'Airtel Corporate Postpaid',
    overview:
        'Enterprise mobile connectivity solution designed for organizations that require centralized management of employee mobile usage, roaming, communication expenses, and workforce connectivity.',
    idealCustomers: [
      'Banking & Financial Services',
      'Retail Chains',
      'Manufacturing Companies',
      'Logistics Organizations',
      'IT Services Firms',
      'Enterprises with 100+ employees',
    ],
    industries: [
      'Banking & Financial Services',
      'Retail',
      'Manufacturing',
      'Logistics',
      'IT & ITES',
      'Healthcare',
      'Hospitality',
      'Energy & Utilities',
    ],
    painPointsSolved: [
      'Distributed Workforce',
      'Roaming Management',
      'Mobility Management',
    ],
    businessOutcomes: [
      'Centralized telecom management',
      'Reduced administrative overhead',
      'Better cost visibility',
      'Improved workforce productivity',
      'Simplified roaming management',
    ],
    discoveryQuestions: [
      'How are mobile expenses currently tracked and reconciled across departments?',
      'What percentage of your workforce requires international roaming capabilities?',
      'How do you manage device provisioning for new hires?',
    ],
    objections: [
      'Pricing concerns: "Our current provider offered a cheaper per-GB rate."',
      'Contract lock-in concerns: "We are locked into a multi-year deal with another telco."',
      'Migration complexity: "Porting thousands of numbers will cause massive downtime."',
    ],
    objectionResponses: [
      'Focus on Total Cost of Ownership (TCO) including management portal efficiency and pooled data benefits, not just raw GB pricing.',
      'Propose a phased rollout strategy for new hires or specific departments while waiting for existing contracts to expire.',
      'Highlight Airtel\'s dedicated enterprise onboarding team that manages the entire MNP (Mobile Number Portability) process with zero operational downtime.',
    ],
    crossSellOpportunities: [
      'Airtel IQ Business Connect',
      'Airtel Work From Anywhere Solutions',
      'Airtel IoT Connectivity',
    ],
    elevatorPitch:
        'Airtel Corporate Postpaid simplifies enterprise mobility through centralized management, better visibility, and seamless workforce communication.',
    executivePitch:
        'Help your organization manage employee connectivity at scale while reducing administrative effort and improving visibility into telecom spending.',
    meetingTalkingPoints: [],
  ),
  const ProductIntelligence(
    id: 'prod_biz_connect',
    name: 'Airtel IQ Business Connect',
    overview:
        'A unified communication and engagement platform enabling organizations to connect with employees, customers, and distributed teams more effectively.',
    idealCustomers: [
      'Retail Organizations',
      'Banking Institutions',
      'Logistics Companies',
      'Large Field Sales Organizations',
      'Government',
    ],
    industries: [
      'Retail',
      'Banking & Financial Services',
      'Logistics',
      'Government',
      'Hospitality',
      'Education',
    ],
    painPointsSolved: [
      'Customer Engagement',
      'Workforce Communication',
      'Remote Work',
      'Call Routing Complexity',
      'Agent Productivity',
    ],
    businessOutcomes: [
      'Better communication consistency',
      'Faster information dissemination',
      'Improved workforce engagement',
      'Increased operational efficiency',
    ],
    discoveryQuestions: [
      'How are you currently managing communications between HQ and your distributed field teams?',
      'What tools do your customer-facing employees use to communicate with clients securely?',
      'How are you ensuring compliance and recording for voice calls made by field staff?',
    ],
    objections: [
      'Adoption concerns: "Employees are used to WhatsApp; they won\'t download a new app."',
      'Budget concerns: "We don\'t have budget for another enterprise communication tool."',
    ],
    objectionResponses: [
      'Emphasize that Airtel IQ integrates seamlessly with existing workflows and ensures corporate data governance which WhatsApp lacks.',
      'Highlight the cost savings from consolidating disparate legacy communication tools into a single platform.',
    ],
    crossSellOpportunities: [
      'Airtel Corporate Postpaid',
      'Airtel Contact Center as a Service',
      'Airtel CPaaS',
    ],
    elevatorPitch:
        'Business Connect helps organizations communicate consistently across distributed teams while improving engagement and operational effectiveness.',
    executivePitch:
        'Create a single, enterprise-ready communication layer that scales across your workforce and locations securely.',
    meetingTalkingPoints: [],
  ),
  const ProductIntelligence(
    id: 'prod_sdwan',
    name: 'Airtel SD-WAN',
    overview:
        'Software-Defined Wide Area Network solution providing intelligent routing, centralized management, and secure connectivity across distributed enterprise branches.',
    idealCustomers: [
      'Multi-branch Retailers',
      'Banking & Financial Institutions',
      'Manufacturing Companies with multiple plants',
      'Logistics Hubs',
    ],
    industries: [
      'Banking & Financial Services',
      'Retail',
      'Manufacturing',
      'Logistics',
      'IT & ITES',
      'Government',
    ],
    painPointsSolved: [
      'Multi-Site Networking',
      'Application Performance',
      'Network Visibility',
      'Rising Telecom Costs',
      'Hardware Sprawl',
    ],
    businessOutcomes: [
      'Reduced MPLS dependency and costs',
      'Optimized cloud application performance',
      'Centralized network visibility and control',
      'Rapid branch provisioning',
    ],
    discoveryQuestions: [
      'How are you currently routing traffic from your branches to cloud applications (e.g., Office 365, AWS)?',
      'What is your average timeline to provision network connectivity for a new branch location?',
      'How much visibility do you have into branch-level application performance and bandwidth utilization?',
    ],
    objections: [
      'Migration complexity: "Ripping out our MPLS routers is too risky for branch uptime."',
      'Security concerns: "Using broadband internet for branch traffic isn\'t secure enough for our data."',
      'Vendor consolidation: "We prefer to buy SD-WAN hardware directly from OEM vendors like Cisco/Fortinet."',
    ],
    objectionResponses: [
      'Acknowledge their stability, then pivot to bandwidth constraints and cloud-readiness. Ask: "As you migrate more workloads to AWS/Azure, are you finding the MPLS bandwidth costs scaling too quickly?" Position SD-WAN as a hybrid overlay rather than a rip-and-replace.',
      'Highlight built-in Next-Generation Firewall (NGFW) and IPsec encryption capabilities securing broadband links.',
      'Acknowledge their preference for OEMs, then pivot to the management burden. Ask: "How much time does your team spend troubleshooting underlay vs overlay issues across different vendors?" Position Airtel as a single-SLA managed service provider.',
    ],
    crossSellOpportunities: [
      'Airtel Secure Internet',
      'Airtel Public Cloud',
      'Airtel Leased Line (ILL)',
    ],
    elevatorPitch:
        'Airtel SD-WAN intelligently routes your branch traffic to optimize application performance while reducing reliance on expensive legacy links.',
    executivePitch:
        'Modernize your enterprise network architecture to be cloud-first, gaining centralized visibility and agility while driving down total network costs.',
    meetingTalkingPoints: [],
  ),

  const ProductIntelligence(
    id: 'prod_sip_trunking',
    name: 'Airtel SIP Trunking',
    overview:
        'Scalable and secure IP-based voice connectivity solution replacing legacy ISDN/PRI lines for enterprise PBX and contact centers.',
    idealCustomers: [
      'BPO & Call Centers',
      'Large Corporate Offices',
      'Hospitality Chains',
      'Educational Institutions',
    ],
    industries: [
      'IT & ITES',
      'Hospitality',
      'Education',
      'Banking & Financial Services',
      'Retail',
    ],
    painPointsSolved: [
      'Rising Telecom Costs',
      'Legacy Systems',
      'Contact Center Modernization',
      'Business Continuity',
    ],
    businessOutcomes: [
      'Significant reduction in voice calling costs',
      'Elimination of physical PRIs and hardware maintenance',
      'Rapid scalability of voice channels during peak seasons',
      'Improved disaster recovery with IP routing',
    ],
    discoveryQuestions: [
      'Are you still managing physical ISDN/PRI lines across your multiple office locations?',
      'How difficult is it to scale up your voice channels during a sudden spike in call center traffic?',
      'What is your disaster recovery plan if the physical phone lines to your main building are cut?',
    ],
    objections: [
      'Quality concerns: "Voice over IP (VoIP) drops calls and has jitter."',
      'Legacy PBX constraints: "Our current PBX system doesn\'t support SIP."',
      'Regulatory concerns: "Is SIP routing compliant with DoT/TRAI regulations?"',
    ],
    objectionResponses: [
      'Airtel SIP Trunking runs over dedicated enterprise leased lines with strict Quality of Service (QoS) guarantees, unlike internet-based VoIP.',
      'Airtel can provide a managed gateway (SBC) to convert SIP signals to legacy formats until you upgrade your PBX.',
      'Airtel SIP Trunking is fully compliant with Indian telecom regulations, including logical partitioning requirements for OSP/BPOs.',
    ],
    crossSellOpportunities: [
      'Airtel Contact Center as a Service',
      'Airtel Leased Line (ILL)',
      'Airtel SD-WAN',
    ],
    elevatorPitch:
        'Airtel SIP Trunking modernizes your enterprise voice infrastructure, cutting costs and enabling instant scalability.',
    executivePitch:
        'Retire expensive legacy phone lines and migrate to a resilient, IP-based voice architecture that scales dynamically with your business needs.',
    meetingTalkingPoints: [],
  ),
  const ProductIntelligence(
    id: 'prod_ccaas',
    name: 'Airtel Contact Center as a Service',
    overview:
        'Cloud-based omnichannel contact center solution that eliminates the need for on-premise dialers and PBX hardware.',
    idealCustomers: [
      'E-Commerce Support Teams',
      'Banking Helpdesks',
      'Healthcare Appointment Centers',
      'Outsourced BPOs',
    ],
    industries: [
      'E-Commerce',
      'Banking & Financial Services',
      'Healthcare',
      'IT & ITES',
      'Retail',
    ],
    painPointsSolved: [
      'Contact Center Modernization',
      'Customer Engagement',
      'Remote Work',
      'Legacy Systems',
    ],
    businessOutcomes: [
      'Enable agents to work from anywhere with just a browser',
      'Omnichannel integration (Voice, Chat, Email, Social)',
      'Zero CAPEX on dialer hardware',
      'Advanced analytics and AI-driven call routing',
    ],
    discoveryQuestions: [
      'How are you currently managing customer support queries across voice, email, and social media?',
      'What were the challenges you faced transitioning your call center agents to work-from-home?',
      'How much are you spending on annual maintenance contracts (AMCs) for your on-premise dialer?',
    ],
    objections: [
      'Voice quality for remote agents: "Home broadband isn\'t reliable enough for voice support."',
      'Data security: "We can\'t have customer data accessible from agents\' personal laptops."',
    ],
    objectionResponses: [
      'Bundle CCaaS with Airtel Work From Anywhere solutions (dedicated broadband/LTE routers) to guarantee QoS.',
      'The cloud platform is strictly role-based and data remains centralized; no customer data is stored locally on the agent\'s machine.',
    ],
    crossSellOpportunities: [
      'Airtel SIP Trunking',
      'Airtel Work From Anywhere Solutions',
      'Airtel CPaaS',
    ],
    elevatorPitch:
        'Airtel CCaaS moves your contact center to the cloud, enabling an omnichannel customer experience and empowering agents to work from anywhere.',
    executivePitch:
        'Modernize customer service by replacing rigid on-premise hardware with an agile, scalable cloud contact center that reduces CAPEX and improves customer satisfaction.',
    meetingTalkingPoints: [],
  ),
  const ProductIntelligence(
    id: 'prod_managed_wifi',
    name: 'Airtel Managed Wi-Fi',
    overview:
        'Enterprise-grade, fully managed wireless networking solution covering hardware provisioning, deployment, monitoring, and guest analytics.',
    idealCustomers: [
      'Universities and Campuses',
      'Hotel Chains and Resorts',
      'Large Retail Chains',
      'Warehousing and Logistics Facilities',
    ],
    industries: [
      'Education',
      'Hospitality',
      'Retail',
      'Logistics',
      'Healthcare',
    ],
    painPointsSolved: [
      'Operational Efficiency',
      'Guest Experience',
      'Network Visibility',
    ],
    businessOutcomes: [
      'Seamless, dead-zone-free campus connectivity',
      'Monetizable guest Wi-Fi portals with analytics',
      'Zero IT overhead for managing access points',
      'Secure segregation of corporate and guest traffic',
    ],
    discoveryQuestions: [
      'How much time does your IT team spend troubleshooting Wi-Fi dead zones and complaints?',
      'Are you able to capture marketing data or run promotions through your current guest Wi-Fi portal?',
      'How do you manage the massive density of connected devices during large events or in lecture halls?',
    ],
    objections: [
      'Cost: "We prefer to buy consumer-grade routers locally to save money."',
      'Control: "Our IT team wants full administrative control over the network hardware."',
    ],
    objectionResponses: [
      'Consumer routers fail under enterprise density and lack security protocols, resulting in high hidden maintenance costs and security breaches.',
      'Airtel provides a comprehensive cloud dashboard giving your IT team full visibility and control, while we handle the underlying hardware SLAs.',
    ],
    crossSellOpportunities: [
      'Airtel Leased Line (ILL)',
      'Airtel SD-WAN',
      'Airtel Secure Internet',
    ],
    elevatorPitch:
        'Airtel Managed Wi-Fi delivers a flawless wireless experience for employees and guests without burdening your IT staff.',
    executivePitch:
        'Transform your campus or retail spaces with secure, high-density Wi-Fi that provides actionable customer analytics and operates under a single SLA.',
    meetingTalkingPoints: [],
  ),
  const ProductIntelligence(
    id: 'prod_mpls',
    name: 'Airtel VPN/MPLS',
    overview:
        'Highly secure, private Multiprotocol Label Switching (MPLS) network connecting enterprise branches with guaranteed latency and Quality of Service (QoS).',
    idealCustomers: [
      'Government Departments',
      'Banks and Financial Institutions',
      'Large Manufacturing Conglomerates',
    ],
    industries: [
      'Government',
      'Banking & Financial Services',
      'Manufacturing',
      'Energy & Utilities',
      'Healthcare',
    ],
    painPointsSolved: [
      'Security & Compliance',
      'Application Performance',
      'Branch Connectivity',
      'Regulatory Compliance',
    ],
    businessOutcomes: [
      'Absolute data privacy isolated from the public internet',
      'Guaranteed bandwidth for mission-critical applications (e.g., SAP, Core Banking)',
      'Predictable latency across regional branches',
      'High network availability',
    ],
    discoveryQuestions: [
      'How are you ensuring the absolute privacy of data transmitted between your core data center and regional branches?',
      'Do you experience application timeouts with your ERP or core banking software over standard internet connections?',
      'What are your compliance mandates regarding data transmission over public networks?',
    ],
    objections: [
      'Cost and rigidity: "MPLS is too expensive and takes months to provision compared to broadband SD-WAN."',
      'Cloud shift: "Most of our apps are in the public cloud now, we don\'t need private branch-to-branch routing."',
    ],
    objectionResponses: [
      'Position a hybrid architecture: Keep MPLS for the highly sensitive/critical core sites and use Airtel SD-WAN over broadband for smaller, agile branches.',
      'Airtel MPLS integrates seamlessly with Airtel Public Cloud and direct hyperscaler connects to support private cloud access.',
    ],
    crossSellOpportunities: [
      'Airtel SD-WAN',
      'Airtel Data Center Services',
      'Airtel SIP Trunking',
    ],
    elevatorPitch:
        'Airtel MPLS provides the most secure, predictable, and private network backbone for your mission-critical enterprise applications.',
    executivePitch:
        'Protect your sensitive data and guarantee ERP performance by running your core business operations on India\'s most robust private enterprise network.',
    meetingTalkingPoints: [],
  ),
  const ProductIntelligence(
    id: 'prod_wfa',
    name: 'Airtel Work From Anywhere Solutions',
    overview:
        'Integrated connectivity and security bundles (4G/LTE routers, secure broadband, endpoint security) enabling a secure remote workforce.',
    idealCustomers: [
      'IT & ITES (BPOs, KPOs)',
      'Consulting Firms',
      'Financial Services Call Centers',
    ],
    industries: [
      'IT & ITES',
      'Banking & Financial Services',
      'Education',
      'Telecom',
    ],
    painPointsSolved: [
      'Remote Work',
      'Distributed Workforce',
      'Security & Compliance',
      'Business Continuity',
    ],
    businessOutcomes: [
      'Guaranteed productivity for remote employees',
      'Corporate-grade security enforced at the employee\'s home',
      'Centralized billing for remote connectivity stipends',
      'Rapid deployment for new remote hires',
    ],
    discoveryQuestions: [
      'How do you ensure reliable internet access for your critical remote support agents?',
      'Are you currently reimbursing employees for their personal home broadband, and is that difficult to manage?',
      'How do you prevent unauthorized devices in an employee\'s home from accessing the corporate network?',
    ],
    objections: [
      'Reimbursement is easier: "We just give employees a fixed allowance to buy their own internet."',
      'Coverage issues: "Not all employees have Airtel coverage at home."',
    ],
    objectionResponses: [
      'Allowances don\'t guarantee the employee purchases a reliable connection, leading to dropped client calls and security vulnerabilities.',
      'Airtel provides a mix of FTTH (Fiber) and enterprise-grade 4G/LTE routers to ensure connectivity regardless of fiber availability.',
    ],
    crossSellOpportunities: [
      'Airtel Contact Center as a Service',
      'Airtel Corporate Postpaid',
      'Airtel Secure Internet',
    ],
    elevatorPitch:
        'Airtel Work From Anywhere provides secure, managed connectivity directly to your employees\' homes, ensuring corporate security and productivity.',
    executivePitch:
        'Standardize your remote work infrastructure with enterprise-grade connectivity and security, eliminating the risks and inefficiencies of consumer home broadband.',
    meetingTalkingPoints: [],
  ),

  const ProductIntelligence(
    id: 'prod_private_5g',
    name: 'Airtel 5G for Enterprise',
    overview:
        'Captive Non-Public Network (Private 5G) providing ultra-reliable, low-latency, and high-bandwidth wireless connectivity tailored for industrial automation and IoT.',
    idealCustomers: [
      'Automotive Manufacturers',
      'Mining Operations',
      'Large Ports and Logistics Hubs',
      'Smart Factories (Industry 4.0)',
    ],
    industries: [
      'Manufacturing',
      'Logistics',
      'Energy & Utilities',
      'Government',
    ],
    painPointsSolved: [
      'Operational Efficiency',
      'Legacy Systems',
      'Network Visibility',
      'Business Continuity',
    ],
    businessOutcomes: [
      'Enable real-time robotics and Automated Guided Vehicles (AGVs)',
      'Wire-like reliability without the physical constraints of cabling',
      'Massive IoT sensor density on the factory floor',
      'Absolute data privacy (data never leaves the premises)',
    ],
    discoveryQuestions: [
      'Are your current Wi-Fi networks struggling with latency or interference on the factory floor?',
      'How are you planning to connect autonomous vehicles or robotics across your manufacturing campus?',
      'What is the cost of rewiring your facility every time you need to reconfigure the assembly line?',
    ],
    objections: [
      'Cost: "Private 5G is too expensive and experimental right now."',
      'Wi-Fi 6 alternative: "We are upgrading to Wi-Fi 6, which should solve our bandwidth issues."',
    ],
    objectionResponses: [
      'Frame the ROI around operational uptime and the flexibility to reconfigure assembly lines without cabling costs.',
      'Wi-Fi 6 struggles with handoffs for fast-moving objects (like AGVs) and suffers from interference in metal-heavy industrial environments; 5G handles this flawlessly.',
    ],
    crossSellOpportunities: [
      'Airtel IoT Connectivity',
      'Airtel Public Cloud',
      'Airtel SD-WAN',
    ],
    elevatorPitch:
        'Airtel Private 5G unleashes Industry 4.0 by providing ultra-low latency, secure, and interference-free wireless connectivity for your critical operations.',
    executivePitch:
        'Future-proof your industrial operations with a dedicated 5G network that enables advanced automation, robotics, and massive IoT scaling.',
    meetingTalkingPoints: [],
  ),
  const ProductIntelligence(
    id: 'prod_cpaas',
    name: 'Airtel CPaaS',
    overview:
        'Communications Platform as a Service providing API-driven SMS, Voice, and WhatsApp integration directly into enterprise applications and workflows.',
    idealCustomers: [
      'E-Commerce Applications',
      'Fintech and Banking Apps',
      'Aggregator Platforms (Ride-sharing, Food Delivery)',
      'Logistics Tracking Platforms',
    ],
    industries: [
      'E-Commerce',
      'Banking & Financial Services',
      'IT & ITES',
      'Logistics',
      'Retail',
    ],
    painPointsSolved: [
      'Customer Engagement',
      'Digital Transformation',
      'Real-Time Communication',
    ],
    businessOutcomes: [
      'Automated OTP delivery and transactional alerts',
      'Rich conversational commerce via WhatsApp Business API',
      'Call masking for privacy between delivery drivers and customers',
      'Direct-to-telco routing ensuring high delivery rates and low latency',
    ],
    discoveryQuestions: [
      'How are you currently sending OTPs, and what is your SMS delivery failure rate?',
      'Are you exploring WhatsApp as a channel for customer support or conversational commerce?',
      'How do you protect customer phone numbers when your delivery agents need to call them?',
    ],
    objections: [
      'Developer adoption concerns: "Our developers prefer using global APIs like Twilio."',
      'Integration concerns: "It will take too long to rewrite our communication logic."',
    ],
    objectionResponses: [
      'Airtel CPaaS offers modern, RESTful APIs identical in ease-of-use to global players, but with the distinct advantage of direct, zero-hop routing on the Airtel network for higher delivery success in India.',
      'We provide robust SDKs and comprehensive documentation, ensuring integration can be completed in days, not months.',
    ],
    crossSellOpportunities: [
      'Airtel IQ Business Connect',
      'Airtel Contact Center as a Service',
      'Airtel Secure Internet',
    ],
    elevatorPitch:
        'Airtel CPaaS embeds powerful SMS, Voice, and WhatsApp capabilities directly into your applications to automate and enhance customer engagement.',
    executivePitch:
        'Drive superior customer experiences and higher transaction completion rates by utilizing Airtel\'s direct, carrier-grade communication APIs.',
    meetingTalkingPoints: [],
  ),
  const ProductIntelligence(
    id: 'prod_leased_line',
    name: 'Airtel Leased Line (ILL)',
    overview:
        'Internet Leased Line providing dedicated, uncontended, and symmetric internet bandwidth with high uptime SLAs for enterprise offices.',
    idealCustomers: [
      'Corporate Headquarters',
      'Software Development Centers',
      'Media and Production Houses',
      'Hospitals',
    ],
    industries: [
      'IT & ITES',
      'Healthcare',
      'Education',
      'Banking & Financial Services',
      'Government',
      'Manufacturing',
    ],
    painPointsSolved: [
      'Application Performance',
      'Business Continuity',
      'Branch Connectivity',
    ],
    businessOutcomes: [
      'Symmetrical upload and download speeds for cloud applications',
      '1:1 dedicated bandwidth (no sharing with other businesses)',
      'Enterprise-grade Service Level Agreements (SLAs) for uptime',
      'Static IPs for hosting internal applications securely',
    ],
    discoveryQuestions: [
      'Are your employees experiencing lag or dropped connections during critical video conferences?',
      'How much productivity is lost when your office internet connection slows down during peak hours?',
      'Do you need high upload speeds for backing up large data sets to the cloud?',
    ],
    objections: [
      'Pricing concerns: "Business broadband is a fraction of the cost of a Leased Line."',
      'Redundancy concerns: "What happens if the fiber gets cut?"',
    ],
    objectionResponses: [
      'Broadband is heavily contended (shared) and asymmetrical (poor upload speeds). ILL is dedicated 1:1 bandwidth backed by financial SLAs.',
      'Airtel provisions dual-path redundancy with auto-failover (e.g., secondary RF link) to ensure uninterrupted connectivity even if primary fiber is cut.',
    ],
    crossSellOpportunities: [
      'Airtel Secure Internet',
      'Airtel SD-WAN',
      'Airtel SIP Trunking',
      'Airtel Managed Wi-Fi',
    ],
    elevatorPitch:
        'Airtel Internet Leased Line provides the dedicated, high-speed, and reliable foundation necessary for modern cloud-based enterprise operations.',
    executivePitch:
        'Ensure your business never stops running with enterprise-grade, dedicated internet access backed by industry-leading SLAs and dual-path redundancy.',
    meetingTalkingPoints: [],
  ),

  // â”€â”€ NEW PRODUCTS FROM AIRTEL B2B WEBSITE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const ProductIntelligence(
    id: 'prod_colocation',
    name: 'Airtel Colocation (Nxtra)',
    overview:
        'Enterprise-grade data center colocation services delivered through Nxtra by Airtel — one of India\'s largest DC networks with a broad footprint of large core facilities and edge data centers. Businesses host their servers and IT hardware in Airtel-managed, carrier-neutral facilities with guaranteed uptime, AI-enabled operations, and direct cloud on-ramps.',
    idealCustomers: [
      'Large enterprises with high infrastructure demands',
      'Financial institutions with data sovereignty requirements',
      'E-commerce platforms requiring low-latency edge presence',
      'Cloud service providers and hyperscalers',
      'Government and public sector organizations',
      'Healthcare institutions requiring HIPAA-equivalent controls',
    ],
    industries: [
      'Banking & Financial Services',
      'IT & ITES',
      'E-Commerce',
      'Government',
      'Healthcare',
      'Manufacturing',
      'Media & Entertainment',
    ],
    painPointsSolved: [
      'High Infrastructure CapEx',
      'Legacy Data Center Overhead',
      'Uptime & Redundancy',
      'Data Sovereignty',
      'Direct Hyperscaler Access',
      'Scalability Constraints',
    ],
    businessOutcomes: [
      'Eliminate capital expenditure on building or maintaining private data centers',
      'Support high availability through built-in redundancy and 24/7 monitoring',
      'Reduce energy costs with AI-driven power optimization and green infrastructure',
      'Access direct cloud on-ramps to AWS, Azure, Google Cloud, and Oracle',
      'Scale IT footprint rapidly without construction timelines',
    ],
    discoveryQuestions: [
      'Where is your primary data center currently hosted and who manages it?',
      'What is your current data center uptime SLA and how often is it breached?',
      'Are you planning to reduce infrastructure CapEx as part of your digital transformation strategy?',
      'Do you have regulatory requirements for data to remain within India?',
      'How do you manage cloud connectivity today — are latency or costs a concern?',
    ],
    objections: [
      'Security concerns: "We are worried about co-locating our servers with other companies."',
      'Cost perception: "Building our own data center long-term is cheaper."',
      'Migration complexity: "Moving our on-premise servers will cause downtime we cannot afford."',
    ],
    objectionResponses: [
      'Nxtra offers private cages, dedicated suites, and multi-factor access controls ensuring complete physical isolation from other tenants.',
      'TCO analysis consistently shows colocation saves 30"“40% over 5 years when factoring in power, cooling, staffing, and hardware refresh cycles.',
      'Airtel provides a structured migration plan with dedicated engineers and phased cutover to ensure zero unplanned downtime during transition.',
    ],
    crossSellOpportunities: [
      'Airtel SD-WAN',
      'Airtel Public Cloud',
      'Airtel Dedicated Internet (ILL)',
      'Airtel Secure Internet',
    ],
    elevatorPitch:
        'Nxtra by Airtel provides enterprise-grade colocation across India\'s largest data center network, helping businesses eliminate infrastructure CapEx while improving uptime and cloud access.',
    executivePitch:
        'Move your infrastructure to a carrier-neutral, AI-operated facility and redirect capital from data center management to your core business growth.',
    meetingTalkingPoints: [],
  ),

  const ProductIntelligence(
    id: 'prod_global_voice',
    name: 'Airtel Global Voice',
    overview:
        'International voice termination and numbering solution connecting enterprises to a broad international carrier footprint. Includes International Toll-Free Services (ITFS), Direct Inward Dialing (DID), intelligent call routing, and fraud protection — all managed through the unified Airtel Advantage platform.',
    idealCustomers: [
      'BPO and contact center operations with global reach',
      'Multinational corporations with offices in multiple countries',
      'IT/ITES companies managing international client calls',
      'E-commerce companies with global customer bases',
      'Financial services firms with international trading desks',
    ],
    industries: [
      'IT & ITES',
      'Banking & Financial Services',
      'E-Commerce',
      'Manufacturing',
      'Telecom & Carriers',
    ],
    painPointsSolved: [
      'High International Call Costs',
      'Poor International Voice Quality',
      'Global Customer Reach',
      'Call Routing Complexity',
      'International Fraud Risk',
    ],
    businessOutcomes: [
      'Reduce international calling costs through optimized AI-powered routing',
      'Establish local presence in new markets via DID numbers without physical offices',
      'Enable international customers to reach you toll-free through ITFS',
      'Protect revenue with best-in-class fraud detection blocking millions of fraudulent calls annually',
      'Centralize global voice management on a single platform with real-time analytics',
    ],
    discoveryQuestions: [
      'What percentage of your customer calls are international and how are they currently managed?',
      'Are your teams experiencing voice quality issues on international calls?',
      'Do you have operations or customers in multiple countries that require local presence numbers?',
      'How do you currently handle international toll-free or inbound calling for global customers?',
      'What is your annual international calling spend and how is it monitored?',
    ],
    objections: [
      'Price objection: "Our current international calling rates are already competitive."',
      'Quality skepticism: "Indian telecom companies don\'t provide the same quality as global carriers."',
      'Complexity concern: "Setting up international numbering is too complex for our IT team."',
    ],
    objectionResponses: [
      'Request a traffic analysis to understand routing opportunities and potential efficiency gains.',
      'Airtel uses carrier partnerships and managed routing to support international voice quality.',
      'The Airtel Advantage platform provides a fully self-service interface with SIP-based setup and 24/7 dedicated support for enterprise deployments.',
    ],
    crossSellOpportunities: [
      'Airtel SIP Trunking',
      'Airtel Contact Center as a Service',
      'Airtel CPaaS',
      'Airtel Corporate Postpaid',
    ],
    elevatorPitch:
        'Airtel Global Voice connects your enterprise to 140+ countries with premium quality, intelligent routing, and built-in fraud protection on a single managed platform.',
    executivePitch:
        'Establish global voice presence, reduce international communication costs, and protect your business from voice fraud — all from a single Airtel contract.',
    meetingTalkingPoints: [],
  ),

  const ProductIntelligence(
    id: 'prod_iot_connectivity',
    name: 'Airtel IoT Connectivity',
    overview:
        'End-to-end IoT connectivity and device management platform supporting 5G, 4G, NB-IoT, and 2G technologies. The Airtel IoT Hub provides enterprises a centralized dashboard for managing millions of connected devices across their lifecycle — from provisioning and activation to real-time monitoring, firmware updates, and diagnostics — with telco-grade security via private APNs.',
    idealCustomers: [
      'Manufacturing companies deploying predictive maintenance sensors',
      'Logistics and fleet management companies',
      'Energy and utility companies deploying smart meters',
      'Automotive OEMs requiring connected vehicle solutions',
      'Healthcare organizations monitoring remote patients',
      'Smart city and government infrastructure projects',
    ],
    industries: [
      'Manufacturing',
      'Logistics',
      'Energy & Utilities',
      'Automotive',
      'Healthcare',
      'Government',
    ],
    painPointsSolved: [
      'Asset Visibility',
      'Operational Downtime',
      'Fleet Management',
      'Remote Monitoring',
      'Predictive Maintenance',
      'Smart Metering',
    ],
    businessOutcomes: [
      'Reduce unplanned downtime through predictive maintenance monitoring',
      'Achieve real-time visibility across all connected assets and devices',
      'Eliminate manual on-site device management through remote firmware and configuration updates',
      'Improve route efficiency and fuel consumption through fleet telematics data',
      'Enable smart energy metering to detect theft and reduce distribution losses',
    ],
    discoveryQuestions: [
      'How many connected devices or machines do you currently manage and what is your biggest visibility challenge?',
      'How do you currently monitor equipment health across your production or field sites?',
      'What is the cost impact of unplanned downtime in your operations annually?',
      'Are you AIS-140 compliant for your commercial vehicle fleet?',
      'How are your remote assets currently connected and what happens when connectivity is lost?',
    ],
    objections: [
      'Coverage concern: "Your network may not cover all our remote industrial sites."',
      'Security concern: "We cannot allow IoT devices on our corporate network."',
      'ROI skepticism: "We are not sure the investment will pay off quickly enough."',
    ],
    objectionResponses: [
      'Airtel IoT uses private APNs and encrypted data flows to keep device traffic separated from the public internet.',
      'Airtel IoT uses private APNs and encrypted data flows completely isolated from the public internet — your IoT devices never touch the corporate network.',
      'Share a sector-specific business case that focuses on downtime reduction and maintenance efficiency.',
    ],
    crossSellOpportunities: [
      'Airtel 5G for Enterprise',
      'Airtel Precise Positioning',
      'Airtel Corporate Postpaid',
      'Airtel SD-WAN',
    ],
    elevatorPitch:
        'Airtel IoT Connectivity gives enterprises centralized control over millions of connected devices with telco-grade security, multi-technology support, and a unified management platform.',
    executivePitch:
        'Transform operational visibility — connect your assets, automate monitoring, and eliminate costly unplanned downtime with Airtel\'s enterprise IoT platform.',
    meetingTalkingPoints: [],
  ),

  const ProductIntelligence(
    id: 'prod_office_internet',
    name: 'Airtel Office Internet',
    overview:
        'High-speed broadband connectivity solution designed specifically for SMEs and small offices, bundling enterprise-grade features like DNS security (Cisco), device protection (Kaspersky), static IP, and unified voice + data in a single managed package. The service is positioned as business broadband with bundled connectivity and security features.',
    idealCustomers: [
      'Small and medium businesses (1"“250 employees)',
      'Branch offices of larger enterprises',
      'Professional services firms (CAs, law firms, consultancies)',
      'Retail stores requiring secure POS connectivity',
      'Healthcare clinics and diagnostic centers',
    ],
    industries: [
      'Retail',
      'Healthcare',
      'Education',
      'Hospitality',
      'Banking & Financial Services',
      'IT & ITES',
    ],
    painPointsSolved: [
      'Unreliable Connectivity',
      'Security Vulnerabilities',
      'Rising Costs',
      'Vendor Complexity',
      'Remote Access',
    ],
    businessOutcomes: [
      'Reliable business-grade internet with higher uptime than residential connections',
      'Built-in DNS and device security without additional vendor costs',
      'Potential tax advantages depending on the customer structure and accounting treatment',
      'Simplified billing by bundling voice and data in one plan',
      'Static IP enabling secure remote access and server hosting',
    ],
    discoveryQuestions: [
      'How many employees are currently sharing your internet connection and do you experience slowdowns during peak hours?',
      'Have you faced any security incidents — phishing, malware — on your office network?',
      'Do you need remote access to your office systems from outside the office?',
      'Are you currently claiming GST input tax credit on your telecom spend?',
      'How is your landline calling currently managed and is it integrated with your broadband?',
    ],
    objections: [
      'Price comparison: "Residential broadband is much cheaper and works fine for us."',
      'Perceived overkill: "Our office only has 10 people — we don\'t need enterprise internet."',
      'Incumbent loyalty: "We have been with our current provider for years."',
    ],
    objectionResponses: [
      'Residential broadband is shared with many nearby users and can slow down during busy hours. Office Internet is positioned for business use rather than home use.',
      'The bundled security features can reduce the need for separate third-party tools for a small team.',
      'Airtel offers a free speed and security audit of your current connection — let the results speak before you commit to anything.',
    ],
    crossSellOpportunities: [
      'Airtel Secure Internet',
      'Airtel Corporate Postpaid',
      'Airtel Managed Wi-Fi',
      'Airtel SIP Trunking',
    ],
    elevatorPitch:
        'Airtel Office Internet delivers enterprise-grade broadband with built-in security, static IP, and unified voice — designed specifically for SMEs at an affordable price point.',
    executivePitch:
        'Give your business reliable, secure connectivity with built-in protection and GST tax benefits — without the complexity of managing multiple vendors.',
    meetingTalkingPoints: [],
  ),

  const ProductIntelligence(
    id: 'prod_precise_positioning',
    name: 'Airtel Precise Positioning',
    overview:
        'High-precision location service built on Airtel\'s 4G/5G network in partnership with Swift Navigation\'s Skylark cloud platform. It is intended to improve standard GPS performance using GNSS correction signals delivered in real time for use cases such as autonomous vehicles, precision agriculture, drone delivery, and advanced fleet management.',
    idealCustomers: [
      'Automotive OEMs building ADAS and autonomous vehicles',
      'Logistics companies requiring precision fleet management',
      'Infrastructure and construction companies doing digital mapping',
      'Utility companies managing pipeline and asset location data',
      'Agricultural technology companies',
      'Drone delivery and autonomous robotics operators',
    ],
    industries: [
      'Automotive',
      'Logistics',
      'Energy & Utilities',
      'Manufacturing',
      'Government',
    ],
    painPointsSolved: [
      'GPS Inaccuracy',
      'Autonomous Navigation',
      'Asset Location Precision',
      'Fleet Route Optimization',
      'Compliance & Safety',
    ],
    businessOutcomes: [
      'Improve location accuracy for operational use cases that need more precision than standard GPS can offer',
      'Enable ADAS features like lane-keep assist and autonomous emergency braking',
      'Reduce toll leakage with satellite-based precision toll collection',
      'Support drone delivery operations with certified precision navigation',
      'Improve emergency response with exact address identification in complex urban environments',
    ],
    discoveryQuestions: [
      'Are any of your vehicles, assets, or equipment requiring GPS-based tracking or autonomous navigation?',
      'What level of location accuracy do your current operations require and where does standard GPS fall short?',
      'Are you working toward AIS-140 or any ADAS-related compliance for your vehicle fleet?',
      'Do you operate in construction, mining, or agriculture where higher location precision has operational value?',
      'Are you exploring drone operations or autonomous logistics in your supply chain roadmap?',
    ],
    objections: [
      'Niche concern: "This is only relevant for autonomous vehicles — we don\'t operate those."',
      'Technology maturity: "We are not sure the technology is mature enough for production use."',
      'Coverage concern: "Does this work in rural or semi-urban areas where we operate?"',
    ],
    objectionResponses: [
      'Beyond autonomous vehicles, precision positioning unlocks value in fleet management, construction surveying, precision agriculture, and utility infrastructure mapping.',
      'Swift Navigation\'s Skylark is a production-grade platform already deployed globally — Airtel is the exclusive Indian network partner, not a beta program.',
      'The correction service is delivered over Airtel\'s 4G/5G network for broad India coverage.',
    ],
    crossSellOpportunities: [
      'Airtel IoT Connectivity',
      'Airtel 5G for Enterprise',
      'Airtel Corporate Postpaid',
    ],
    elevatorPitch:
        'Airtel Precise Positioning delivers high-precision GPS assistance across India using network-assisted GNSS corrections for autonomous, precision, and safety-critical applications.',
    executivePitch:
        'Support fleet, logistics, and autonomous operations with materially better positioning than standard GPS, delivered over Airtel\'s network.',
    meetingTalkingPoints: [],
  ),

  const ProductIntelligence(
    id: 'prod_public_cloud',
    name: 'Airtel Public Cloud',
    overview:
        'Telco-grade cloud infrastructure built on Airtel\'s network backbone offering compute, storage, backup, and security. Designed with localized data residency to support sovereign requirements across industries. Includes a unified Cloud Management Platform (CMP) for multi-cloud visibility and TCO optimization.',
    idealCustomers: [
      'Enterprises seeking reliable cloud infrastructure and managed services',
      'Organizations with strict data residency and compliance requirements',
      'Enterprises migrating from on-premise infrastructure',
      'Companies requiring multi-cloud management and cost visibility',
      'Organizations needing elastic scalability for digital channels',
    ],
    industries: [
      'Banking & Financial Services',
      'Healthcare',
      'Government',
      'IT & ITES',
      'E-Commerce',
      'Manufacturing',
    ],
    painPointsSolved: [
      'Data Privacy & Sovereignty',
      'Regulatory Compliance',
      'Rising Infrastructure CapEx',
      'Cloud Migration Risk',
      'Multi-Cloud Complexity',
      'Scalability',
    ],
    businessOutcomes: [
      'Achieve strict data residency and compliance with India-hosted infrastructure',
      'Reduce infrastructure CapEx by shifting to an OpEx pay-as-you-go model',
      'Deploy new workloads quickly through automated provisioning',
      'Gain unified visibility across multi-cloud environments through a single dashboard',
      'Simplify vendor management with connectivity and cloud from a single provider',
    ],
    discoveryQuestions: [
      'Are you facing regulatory pressure to ensure your data remains within India?',
      'What is your current cloud strategy — are you using global hyperscalers and concerned about compliance?',
      'How are you currently managing multi-cloud costs and do you have full visibility into cloud spend?',
      'What workloads are you looking to migrate to cloud in the next 12 months?',
      'Do you have a cloud management platform today or are teams managing cloud environments independently?',
    ],
    objections: [
      'Hyperscaler preference: "We are already committed to AWS/Azure/Google Cloud."',
      'Feature gap concern: "Airtel Cloud may not have the same breadth of services as hyperscalers."',
      'Migration risk: "We cannot afford workload disruption during migration."',
    ],
    objectionResponses: [
      'Airtel Cloud is not a replacement for global hyperscalers — it is the compliant, India-sovereign layer for regulated workloads while you continue using hyperscalers for non-regulated ones.',
      'Airtel Cloud covers the full stack of compute, storage, backup, and security. For specialized hyperscaler services, Airtel\'s Multi Cloud Connect links your on-premise and Airtel Cloud environments to AWS/Azure with low latency.',
      'Airtel provides end-to-end migration support with certified cloud architects and phased cutover plans ensuring business continuity throughout the migration.',
    ],
    crossSellOpportunities: [
      'Airtel Colocation (Nxtra)',
      'Airtel Dedicated Internet (ILL)',
      'Airtel SD-WAN',
      'Airtel Secure Internet',
    ],
    elevatorPitch:
        'Airtel Public Cloud provides India-sovereign, regulatory-compliant cloud infrastructure with enterprise-grade compute, instant provisioning, and unified multi-cloud management.',
    executivePitch:
        'Move your regulated workloads to a compliant, India-hosted cloud and stop worrying about data residency violations — while cutting infrastructure costs significantly.',
    meetingTalkingPoints: [],
  ),

  const ProductIntelligence(
    id: 'prod_secure_internet',
    name: 'Airtel Secure Internet',
    overview:
        'Managed cybersecurity solution bundling Internet Leased Line connectivity with a Next-Generation Firewall (Fortinet NGFW) and 24/7 Security Operations Centre (SOC) monitoring. Provides Unified Threat Management (UTM) including intrusion prevention, content filtering, DDoS protection, botnet blocking, and deep packet inspection — all managed by Airtel\'s certified security professionals.',
    idealCustomers: [
      'Enterprises wanting to consolidate internet and security under one vendor',
      'Financial institutions requiring always-on security monitoring',
      'Healthcare organizations protecting sensitive patient data',
      'Manufacturing firms protecting OT/IT networks',
      'Retail chains requiring secure POS and multi-branch protection',
    ],
    industries: [
      'Banking & Financial Services',
      'Healthcare',
      'Manufacturing',
      'Retail',
      'Government',
      'IT & ITES',
    ],
    painPointsSolved: [
      'Distributed Network Security',
      'Security & Compliance',
      'Data Privacy & Breach Prevention',
      'Ransomware & DDoS Protection',
      'Legacy System Reliability',
    ],
    businessOutcomes: [
      'Eliminate the "two-vendor trap" by combining internet and security from Airtel',
      'Achieve 24/7 threat monitoring without hiring additional security staff',
      'Reduce incident response time through AI-driven threat detection and SOC escalation',
      'Meet compliance requirements with centralized audit logs and security dashboards',
      'Transition from CapEx firewall hardware investment to a predictable OpEx model',
    ],
    discoveryQuestions: [
      'How are you enforcing security controls across your increasingly distributed network edges?',
      'During compliance audits, how difficult is it to consolidate logs and prove continuous threat monitoring?',
      'Are you exploring zero-trust access architecture to replace vulnerable legacy VPNs?',
      'How much security vendor sprawl do you currently have between your connectivity, firewall, and endpoint security providers?',
      'How do you ensure rapid incident response to meet strict regulatory enforcement mandates?',
    ],
    objections: [
      'Existing security vendor: "We already have a firewall from Palo Alto / Check Point."',
      'Managed service skepticism: "We prefer to manage security in-house for full control."',
      'Cost concern: "Bundled solutions are usually more expensive than buying separately."',
    ],
    objectionResponses: [
      'Airtel Secure Internet can work alongside existing investments — the 24/7 SOC monitoring layer adds detection and response capability that standalone firewalls do not provide.',
      'In-house security teams often lack 24/7 coverage — our SOC provides round-the-clock monitoring, threat hunting, and incident response as an extension of your team.',
      'Total cost analysis across 3 years consistently shows the bundled model saves 25"“35% compared to separate internet + hardware + maintenance + staffing costs.',
    ],
    crossSellOpportunities: [
      'Airtel Dedicated Internet (ILL)',
      'Airtel SD-WAN',
      'Airtel Public Cloud',
      'Airtel VPN/MPLS',
    ],
    elevatorPitch:
        'Airtel Secure Internet combines enterprise connectivity with managed next-generation firewall and 24/7 SOC monitoring to reduce security and vendor complexity.',
    executivePitch:
        'Protect your business from cyber threats around the clock while simplifying your vendor landscape and converting security hardware into a managed service.',
    meetingTalkingPoints: [],
  ),

  const ProductIntelligence(
    id: 'prod_whatsapp_business',
    name: 'Airtel WhatsApp Business',
    overview:
        'Enterprise WhatsApp Business API solution delivered through Airtel IQ CPaaS platform, enabling businesses to engage customers at scale with rich media messaging, AI-powered chatbots, two-way conversations, and seamless CRM/ERP integration. Supports omnichannel orchestration alongside Voice and SMS with real-time analytics and ROI tracking.',
    idealCustomers: [
      'E-commerce companies managing order updates and delivery notifications',
      'Banking and financial institutions for transaction alerts and KYC',
      'Healthcare providers for appointment reminders and patient communication',
      'Retail chains running personalized marketing campaigns',
      'BPO and contact centers modernizing customer support',
    ],
    industries: [
      'E-Commerce',
      'Banking & Financial Services',
      'Healthcare',
      'Retail',
      'IT & ITES',
      'Travel & Tourism',
    ],
    painPointsSolved: [
      'Customer Engagement',
      'Support Costs',
      'Notification Delivery',
      'Marketing ROI',
      'Agent Productivity',
      'Channel Fragmentation',
    ],
    businessOutcomes: [
      'Reach customers on a channel that often sees strong engagement compared with email.',
      'Reduce repetitive support work through chatbot automation and structured messaging.',
      'Send real-time transactional notifications (OTPs, order updates, delivery alerts) on customers\' preferred channel',
      'Run personalized marketing campaigns with trackable ROI and audience segmentation',
      'Improve customer satisfaction scores through instant, 24/7 AI-assisted responses',
    ],
    discoveryQuestions: [
      'What channels are you currently using for customer notifications and what are the delivery/read rates?',
      'How many customer support queries does your team handle daily and what percentage are repetitive?',
      'Are you using WhatsApp personally but struggling to scale it for business communication?',
      'How do you currently measure the effectiveness of your customer communication campaigns?',
      'Do you have a CRM or helpdesk system that customer communication should integrate with?',
    ],
    objections: [
      'Cost concern: "WhatsApp Business API is expensive compared to SMS."',
      'Data privacy worry: "Customers may not want businesses messaging them on WhatsApp."',
      'Integration complexity: "We don\'t have the technical resources to integrate APIs."',
    ],
    objectionResponses: [
      'Per-conversation pricing can be efficient when teams need rich media, two-way communication, and better engagement than one-way channels.',
      'WhatsApp requires customer opt-in for business communication — you can only message customers who have consented, which actually improves trust and engagement quality.',
      'Airtel IQ can support integration with common CRM and helpdesk tools through Airtel\'s technical team.',
    ],
    crossSellOpportunities: [
      'Airtel CPaaS',
      'Airtel Contact Center as a Service',
      'Airtel IQ Business Connect',
      'Airtel Corporate Postpaid',
    ],
    elevatorPitch:
        'Airtel WhatsApp Business enables enterprises to engage millions of customers at scale with AI chatbots, rich messaging, and seamless CRM integration on India\'s most-used messaging platform.',
    executivePitch:
        'Convert WhatsApp from a personal app into your most powerful customer engagement channel — with enterprise-grade API access, automation, and measurable ROI.',
    meetingTalkingPoints: [],
  ),
];
