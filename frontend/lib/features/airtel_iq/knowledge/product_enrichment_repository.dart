class ObjectionHandling {
  final String objection;
  final String response;

  const ObjectionHandling({required this.objection, required this.response});
}

class ObjectionGuidance {
  final String reframe;
  final String recommendedResponse;
  final List<String> avoidSaying;

  const ObjectionGuidance({
    required this.reframe,
    required this.recommendedResponse,
    required this.avoidSaying,
  });
}

class EnrichedProduct {
  final String productName;
  final String whatItIs;
  final String whenToPitch;

  // Phase 8.5 AM Playbook Fields
  final String openingHook;
  final String positioningStatement;
  final List<String> whenNotToPitch;

  // Phase 8.6 Knowledge Hub Fields
  final String category;
  final String pitchDifficulty; // Easy, Intermediate, Advanced
  final String primaryUseCase;
  final List<String> fiveThingsToRemember;

  // Phase 8.6.1 Key Differentiators
  final List<String> keyDifferentiators;

  // Phase 8.6.2 Official Product Knowledge
  final Map<String, List<String>> officialFeaturesAndBenefits;
  final List<String> technicalCapabilities;
  final List<String> deploymentModels;
  final List<String> integrations;

  final List<String> customerSignals;
  final List<String> businessOutcomes;
  final List<String> discoveryHooks;
  final List<ObjectionHandling> commonObjections;
  final List<String> crossSellProducts;
  final List<String> idealIndustries;
  final List<String> officialSourceUrls;
  final String verificationStatus;
  final Map<String, ObjectionGuidance>? objectionGuidance;

  const EnrichedProduct({
    required this.productName,
    required this.whatItIs,
    required this.whenToPitch,
    required this.openingHook,
    required this.positioningStatement,
    required this.whenNotToPitch,
    required this.category,
    required this.pitchDifficulty,
    required this.primaryUseCase,
    required this.fiveThingsToRemember,
    required this.keyDifferentiators,

    required this.officialFeaturesAndBenefits,
    required this.technicalCapabilities,
    required this.deploymentModels,
    required this.integrations,

    required this.customerSignals,
    required this.businessOutcomes,
    required this.discoveryHooks,
    required this.commonObjections,
    required this.crossSellProducts,
    required this.idealIndustries,
    required this.officialSourceUrls,
    required this.verificationStatus,
    this.objectionGuidance,
  });
}

final Map<String, EnrichedProduct> productEnrichmentData = {
  'prod_corporate_postpaid': const EnrichedProduct(
    productName: 'Airtel Corporate Postpaid',
    whatItIs:
        'A managed enterprise mobility solution offering centralized billing, dynamic data pooling, TraceMate workforce tracking, and Business Name Display.',
    whenToPitch:
        'Pitch when clients are expanding field teams, struggling with BYOD reimbursement overhead, or suffering low call answer rates.',
    openingHook:
        'How are you currently managing the financial overhead and data security of individual mobile reimbursements?',
    positioningStatement:
        'Position this as a centralized visibility and cost-optimization tool, not just a mobile plan.',
    whenNotToPitch: [
      'Customer has a strict, well-functioning BYOD policy.',
      'Workforce is 100% desk-bound with no field movement.',
      'Customer ignores OpEx benefits and is solely price-sensitive.',
    ],
    category: 'Mobility',
    pitchDifficulty: 'Easy',
    primaryUseCase: 'Centralized enterprise mobility billing and tracking',
    fiveThingsToRemember: [
      '18% GST input credit immediately lowers total cost',
      'Prevents data wastage via dynamic organizational data pooling',
      'Retains corporate contacts securely when employees leave',
      'Perfect entry-level product for any size enterprise',
      'Highly sticky when bundled with Work From Anywhere',
    ],
    officialFeaturesAndBenefits: {
      'Superfast Speed': ['Fast Lane Tech for a smoother experience.'],
      'Data Rollover': [
        'Dynamic data pooling allows access to aggregated data by individuals irrespective of their limits.',
      ],
      'International Roaming': [
        'Cost-effective and diverse international roaming plans spanning across 180 countries.',
      ],
      'Workforce Tracking': [
        'Easily track on-field team with TraceMate to enhance productivity & accountability.',
      ],
      'Contact Number Retention': [
        'Maintain valuable contact numbers even when employees leave the company.',
      ],
      'Easy Accounts Management': [
        'Pay bills, raise and track service requests, upgrade plans & update employee details.',
      ],
    },
    technicalCapabilities: [
      '5G Ready',
      'Dynamic Data Pooling',
      'TraceMate integration',
    ],
    deploymentModels: ['eSIM', 'Physical SIM'],
    integrations: ['Airtel Business Portal'],
    keyDifferentiators: [
      'Massive nationwide 5G network coverage',
      '18% GST input tax credit via official billing',
      'TraceMate tracking natively bundled without third-party apps',
      'Enterprise-grade central billing and lifecycle portal',
    ],
    customerSignals: [
      'Field agents using personal numbers',
      'Finance struggling with individual reimbursements',
      'Outbound calling teams suffering low pickup rates',
    ],
    businessOutcomes: [
      'Eliminate reimbursement overhead with centralized billing',
      'Save 18% via GST input credit',
      'Retain corporate contacts when employees leave',
    ],
    discoveryHooks: [
      'How does your finance team manage individual mobile reimbursements?',
      'What happens to client contacts when an account manager leaves?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Cost: "Reimbursing prepaid plans is cheaper."',
        response:
            'While individual reimbursements seem cheaper, you lose the 18% GST input credit and lack centralized visibility.',
      ),
      ObjectionHandling(
        objection: 'Adoption: "Employees prefer using their personal phones."',
        response:
            'Corporate Postpaid can be issued as an eSIM for their existing devices, separating personal and corporate data.',
      ),
      ObjectionHandling(
        objection: 'Admin: "Managing hundreds of SIMs is a nightmare."',
        response:
            'Airtel provides a centralized portal and dedicated relationship manager to handle all onboarding at scale.',
      ),
    ],
    crossSellProducts: [
      'Airtel Work From Anywhere Solutions',
      'Airtel IQ Business Connect',
    ],
    idealIndustries: [
      'Logistics',
      'Retail',
      'Banking & Financial Services',
      'Healthcare',
    ],
    officialSourceUrls: [
      'Airtel Business Website - Corporate Postpaid',
      'PRODUCTS.docx',
    ],
    verificationStatus: 'Fully Verified',
  ),

  'prod_iq_business_connect': const EnrichedProduct(
    productName: 'Airtel IQ Business Connect',
    whatItIs:
        'An omnichannel customer engagement platform providing verified caller identity (Business Name Display) natively integrated with the Airtel network.',
    whenToPitch:
        'Pitch when a business relies heavily on outbound calling and complains about low contact rates or spam flags.',
    openingHook:
        'How is your outbound calling team navigating the recent drop in customer answer rates?',
    positioningStatement:
        'Position this as a revenue-recovery tool to boost call answer rates natively.',
    whenNotToPitch: [
      'Customer does not rely on outbound voice calls.',
      'Customer already uses a deeply integrated omnichannel platform.',
      'Outbound volume is too low to justify verification overhead.',
    ],
    category: 'Customer Engagement',
    pitchDifficulty: 'Easy',
    primaryUseCase: 'Boost outbound answer rates with verified caller identity',
    fiveThingsToRemember: [
      'Operates natively on Airtel network without third-party apps',
      'Directly recovers lost revenue from ignored sales calls',
      'Works on existing numbers with no hardware changes',
      'Not comparable to Truecaller (network-level vs app-level)',
      'Excellent door-opener for BPOs and E-commerce',
    ],
    officialFeaturesAndBenefits: {
      'No Third-Party Dependence': [
        'Directly integrates with Airtel services, eliminating the need for additional apps or platforms.',
      ],
      'Easy Activation': [
        'No complex integrations—activate Business Name Display on existing Airtel numbers.',
      ],
      'Fraud Prevention': [
        'Helps distinguish your legitimate calls from spam or fraudulent ones, improving customer trust.',
      ],
      'Real-Time Business Identification': [
        'Your business name is displayed instantly as the call rings.',
      ],
      'Scalable Solution': [
        'Supports businesses of all sizes, from single numbers to large-scale operations with multiple lines.',
      ],
      'Improved Customer Insights': [
        'Gain analytics on call engagement, such as answer rates and interaction patterns.',
      ],
    },
    technicalCapabilities: [
      'Network-level caller ID verification',
      'Analytics Dashboard',
    ],
    deploymentModels: ['Cloud-based activation on existing numbers'],
    integrations: ['Airtel Network', 'CRM via API (optional)'],
    keyDifferentiators: [
      'Works natively at the telecom network level',
      'Zero reliance on third-party mobile apps like Truecaller',
      'Completely hardware agnostic (no PBX changes required)',
      'Instant PAN-India deployment on existing numbers',
    ],
    customerSignals: [
      'Drop in outbound sales conversion rates',
      'Delivery agents unable to reach customers due to spam blocking',
      'Isolated communication tools used across departments',
    ],
    businessOutcomes: [
      'Increase call answer rates with verified identity',
      'Eliminate third-party app dependencies for caller ID',
      'Protect brand reputation from fraudulent spam tags',
    ],
    discoveryHooks: [
      'How are you preventing legitimate calls from being flagged as spam?',
      'What impact does a low pickup rate have on outbound conversions?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Dependency: "We already use Truecaller."',
        response:
            'Truecaller requires the app installed and internet. Airtel Business Name Display works natively at the network level.',
      ),
      ObjectionHandling(
        objection: 'Integration: "We don\'t want to change our PBX."',
        response:
            'Business Name Display is activated directly on existing numbers without requiring complex hardware integration.',
      ),
      ObjectionHandling(
        objection: 'ROI: "Will showing our name increase sales?"',
        response:
            'Eliminating "unknown number" anxiety immediately lifts answer rates, directly improving customer contact ratios.',
      ),
    ],
    crossSellProducts: [
      'Airtel Corporate Postpaid',
      'Airtel Contact Center as a Service',
    ],
    idealIndustries: [
      'Banking & Financial Services',
      'E-Commerce',
      'Retail',
      'Logistics',
    ],
    officialSourceUrls: ['PRODUCTS.docx (Business Name Display section)'],
    verificationStatus: 'Fully Verified',
  ),

  'prod_sd_wan': const EnrichedProduct(
    productName: 'Airtel SD-WAN',
    whatItIs:
        'A software-defined networking solution that intelligently routes application traffic across broadband, LTE, and MPLS links.',
    whenToPitch:
        'Pitch when an enterprise is opening multiple new branches quickly or migrating heavy workloads to the cloud.',
    openingHook:
        'How are you modernizing your branch networks to support direct cloud access securely?',
    positioningStatement:
        'Position SD-WAN as a network modernization solution, not an MPLS replacement.',
    whenNotToPitch: [
      'Customer operates from a single central office.',
      'Customer has zero cloud applications and relies entirely on-premise.',
      'Customer insists strictly on traditional MPLS architectures.',
    ],
    category: 'Networking & Connectivity',
    pitchDifficulty: 'Advanced',
    primaryUseCase: 'Modernizing multi-branch networks for direct cloud access',
    fiveThingsToRemember: [
      'Never pitch as an MPLS killer; pitch as a hybrid complement',
      'Accelerates branch rollouts with zero-touch provisioning',
      'Offloads non-critical traffic to cheaper broadband links',
      'Requires deep discovery into cloud application usage',
      'Always co-pitch with Secure Internet for edge protection',
    ],
    officialFeaturesAndBenefits: {
      'All-in-one branch solution': [
        'Reduce complex multi-vendor interoperability to ensure quick deployment of branch networks within days.',
      ],
      'Streamlined operations': [
        'End to end managed services from network design and implementation to maintenance and 24*7 support.',
      ],
      'Network expertise': [
        'Achieve faster roll out using media agnostic connectivity paired with software-defined networking solutions.',
      ],
      'Powerful insights': [
        'Single dashboard for real-time analytics into performance, network, devices, and location data.',
      ],
      'Enhanced security': [
        'Safeguard branch networks with malware protection, content filtering, identity based firewall and intrusion prevention.',
      ],
      'Cost optimization': [
        'OPEX-based pricing and a shared resources NOC resulting in reduced costs compared to multiple vendor offerings.',
      ],
    },
    technicalCapabilities: [
      'Media agnostic connectivity',
      'Identity-based firewall',
      'Intrusion prevention',
      'Real-time analytics',
    ],
    deploymentModels: ['Managed Service (OPEX-based)'],
    integrations: ['Wireless LAN', 'Security appliances'],
    keyDifferentiators: [
      'End-to-end managed service backed by unified Airtel SLAs',
      'Deep integration with Airtel MPLS for hybrid deployments',
      'Zero-touch provisioning portal via cloud orchestration',
      'Hardware-agnostic vendor options (Cisco, Fortinet, Versa)',
    ],
    customerSignals: [
      'Complaints about expensive MPLS bandwidth at remote sites',
      'Cloud applications running slowly at branch offices',
      'IT struggling to manually configure routers at new locations',
    ],
    businessOutcomes: [
      'Reduce WAN transport costs using broadband offloading',
      'Accelerate new branch deployments with zero-touch provisioning',
      'Improve cloud application performance via direct breakout',
    ],
    discoveryHooks: [
      'How long does it take to provision networks for new branches?',
      'Are remote users experiencing latency when accessing centralized cloud applications?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection:
            'Reliability: "Broadband is too unreliable compared to MPLS."',
        response:
            'SD-WAN aggregates multiple links. Intelligent path control instantly routes traffic to the healthiest link, providing MPLS-like reliability.',
      ),
      ObjectionHandling(
        objection:
            'Security: "Sending traffic directly to the internet is risky."',
        response:
            'Airtel SD-WAN includes built-in next-generation firewall capabilities and content filtering directly at the edge.',
      ),
      ObjectionHandling(
        objection:
            'Complexity: "Replacing routers sounds like massive disruption."',
        response:
            'Airtel provides end-to-end managed services. We implement SD-WAN alongside your existing MPLS for a phased transition.',
      ),
    ],
    crossSellProducts: [
      'Airtel Dedicated Internet (ILL)',
      'Airtel Secure Internet',
    ],
    idealIndustries: [
      'Retail',
      'Manufacturing',
      'Banking & Financial Services',
      'Healthcare',
    ],
    officialSourceUrls: ['PRODUCTS.docx (SD Branch / SD WAN section)'],
    verificationStatus: 'Fully Verified',
  ),

  'prod_sip_trunking': const EnrichedProduct(
    productName: 'Airtel SIP Trunking',
    whatItIs:
        'A scalable voice connectivity solution transmitting voice calls over an IP network directly to an enterprise IP-PBX.',
    whenToPitch:
        'Pitch when a customer is moving to a unified communications platform or reaching capacity limits on physical lines.',
    openingHook:
        'What is your roadmap for migrating off expensive physical PRI lines to unified communications?',
    positioningStatement:
        'Position SIP Trunking as a necessary modernization step for IP-PBX or Microsoft Teams integration.',
    whenNotToPitch: [
      'Customer uses a legacy PBX that does not support SIP.',
      'Voice calling is an absolute zero-priority for the business.',
      'Customer is entirely migrating to a cloud-native CCaaS.',
    ],
    category: 'Unified Communications',
    pitchDifficulty: 'Intermediate',
    primaryUseCase: 'Modernizing voice capacity over IP networks',
    fiveThingsToRemember: [
      'Replaces rigid physical PRI lines with scalable IP channels',
      'Integrates seamlessly with Microsoft Teams and IP-PBXs',
      'Drastically reduces maintenance costs of legacy hardware',
      'High capacity handling during seasonal call volume spikes',
      'Can be phased in using media gateways for older PBXs',
    ],
    officialFeaturesAndBenefits: {
      'High-Capacity Connectivity': [
        'Supports a high volume of concurrent calls over a single, unified digital connection.',
      ],
      'Direct Inward Dialing (DID)': [
        'Assign specific numbers to different departments or individuals without auto-attendants.',
      ],
      'Advanced Call Routing': [
        'Intelligent call distribution mapping inbound traffic effectively.',
      ],
      'Consolidated Billing': [
        'Simplifies administration with a single, unified bill for all extensions and lines.',
      ],
      'Carrier-Grade Reliability': [
        'Backed by nationwide telecom infrastructure and enterprise-level SLAs.',
      ],
      'Transparent Analytics': [
        'Visibility into call metrics to monitor performance, volume, and quality.',
      ],
    },
    technicalCapabilities: [],
    deploymentModels: [],
    integrations: [],
    keyDifferentiators: [
      'Direct routing over Airtel\'s robust IP backbone',
      'Certified Microsoft Teams direct routing partner',
      'Stringent Quality of Service (QoS) guarantees',
      'End-to-end security with robust Session Border Controllers',
    ],
    customerSignals: [
      'Paying for unused voice channels on fixed PRI lines',
      'Migrating from legacy PBX to modern IP-PBX or Teams',
      'Experiencing voice capacity bottlenecks during peak hours',
    ],
    businessOutcomes: [
      'Scale voice channels dynamically without physical lines',
      'Reduce telephony costs by consolidating voice and data',
      'Enable seamless integration with unified communications platforms',
    ],
    discoveryHooks: [
      'How do you scale voice capacity during unexpected call spikes?',
      'Are you still managing physical PRI lines across separate locations?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Quality: "VoIP is unreliable and prone to jitter."',
        response:
            'Airtel SIP Trunking is delivered over a dedicated, SLA-backed IP network, ensuring enterprise-grade Quality of Service.',
      ),
      ObjectionHandling(
        objection:
            'Security: "Exposing our PBX to IP increases toll fraud risks."',
        response:
            'The service is secured via Session Border Controllers and robust authentication to protect your voice infrastructure.',
      ),
      ObjectionHandling(
        objection:
            'Infrastructure: "We already invested in legacy PBX hardware."',
        response:
            'Airtel SIP Trunking can integrate with legacy systems using a media gateway to realize cost savings today.',
      ),
    ],
    crossSellProducts: [
      'Airtel Dedicated Internet (ILL)',
      'Airtel Contact Center as a Service',
    ],
    idealIndustries: [
      'IT & ITES',
      'Banking & Financial Services',
      'Hospitality',
      'E-Commerce',
    ],
    officialSourceUrls: ['Derived from standard Airtel IQ SIP capabilities'],
    verificationStatus: 'Partially Verified',
  ),

  'prod_ccaas': const EnrichedProduct(
    productName: 'Airtel Contact Center as a Service',
    whatItIs:
        'A cloud-based omnichannel contact center platform allowing agents to handle voice, chat, and email natively on Airtel\'s network.',
    whenToPitch:
        'Pitch when a business wants to enable remote agents or deploy a customer service team rapidly without hardware.',
    openingHook:
        'How are you equipping your support team to handle omnichannel customer interactions remotely?',
    positioningStatement:
        'Position CCaaS as an agility enabler to shift contact center costs from CapEx to OpEx.',
    whenNotToPitch: [
      'Customer does not have a customer service or outbound sales team.',
      'Customer just invested heavily in a brand new on-premise contact center.',
      'Business strictly prohibits cloud data storage for call recordings.',
    ],
    category: 'Customer Engagement',
    pitchDifficulty: 'Intermediate',
    primaryUseCase: 'Deploying scalable, remote-friendly contact center agents',
    fiveThingsToRemember: [
      'Shifts heavy CapEx investments into predictable OpEx',
      'Enables agents to work securely from any location',
      'Natively integrated into Airtel\'s telecom backbone',
      'Offers deep out-of-the-box CRM integrations',
      'Eliminates the need to buy and maintain on-premise PBX',
    ],
    officialFeaturesAndBenefits: {
      'Omnichannel Integration': [
        'A unified platform managing voice, email, chat, and social interactions.',
      ],
      'Comprehensive Call Handling': [
        'Advanced inbound and outbound management, routing, queuing, and conferencing.',
      ],
      'Software Partnerships': [
        'Natively integrated with top-tier contact center software providers like Genesys.',
      ],
      'Web-Based Management': [
        '100% web-based interface allowing agents and supervisors to operate from anywhere.',
      ],
      'Real-Time Analytics & Dashboards': [
        'Unified view of KPIs and conversational insights for real-time decisions.',
      ],
      'Intelligent IVR': [
        'Interactive Voice Response system to automate repetitive inquiries and reduce agent load.',
      ],
    },
    technicalCapabilities: [],
    deploymentModels: [],
    integrations: [],
    keyDifferentiators: [
      'Natively integrated with Airtel\'s core voice network',
      'Zero-drop architecture routing directly to mobile networks',
      'Pre-built integrations with major CRMs (Salesforce, Zendesk)',
      '100% locally hosted for strict data compliance',
    ],
    customerSignals: [
      'Struggling to manage a hybrid or work-from-home support team',
      'Facing high maintenance costs for legacy hardware',
      'Unable to scale agent seats dynamically during seasonal spikes',
    ],
    businessOutcomes: [
      'Shift contact center costs from CapEx to OpEx',
      'Enable agents to work securely from any location',
      'Deploy new campaigns or agent seats in hours',
    ],
    discoveryHooks: [
      'How difficult is it to provision new agents during demand spikes?',
      'What is the annual maintenance overhead of your on-premise hardware?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection:
            'Integration: "We need tight integration with our custom CRM."',
        response:
            'Airtel CCaaS offers deep out-of-the-box integrations with leading CRMs like Salesforce and Zendesk instantly.',
      ),
      ObjectionHandling(
        objection:
            'Quality: "Cloud telephony drops calls on unstable home internet."',
        response:
            'Being natively integrated into Airtel\'s network, we can route calls directly to a mobile device ensuring zero drops.',
      ),
      ObjectionHandling(
        objection: 'Compliance: "We must record and store all calls locally."',
        response:
            'The platform provides secure, localized cloud storage and offers flexible export options to your internal servers.',
      ),
    ],
    crossSellProducts: ['Airtel WhatsApp Business', 'Airtel CPaaS'],
    idealIndustries: [
      'E-Commerce',
      'Retail',
      'Banking & Financial Services',
      'Travel & Tourism',
    ],
    officialSourceUrls: ['Derived from standard Airtel IQ CCaaS capabilities'],
    verificationStatus: 'Partially Verified',
  ),

  'prod_managed_wifi': const EnrichedProduct(
    productName: 'Airtel Managed Wi-Fi',
    whatItIs:
        'An end-to-end managed enterprise Wi-Fi solution covering access point provisioning, monitoring, and proactive maintenance.',
    whenToPitch:
        'Pitch to organizations with large physical footprints struggling with Wi-Fi dead zones or IT maintenance overhead.',
    openingHook:
        'How is your IT team managing wireless density and dead zones across your physical locations?',
    positioningStatement:
        'Position this as an IT offloading service where Airtel handles all hardware SLAs and security.',
    whenNotToPitch: [
      'Customer operates a small office that runs fine on a standard router.',
      'Customer business model has absolutely no physical footfall operations.',
      'Internal IT team insists on owning all access point hardware directly.',
    ],
    category: 'Networking & Connectivity',
    pitchDifficulty: 'Intermediate',
    primaryUseCase:
        'Outsourcing enterprise wireless network maintenance and security',
    fiveThingsToRemember: [
      'Offloads hardware lifecycle and troubleshooting from IT',
      'Monetizes guest access via customizable captive portals',
      'Ideal for campuses, retail chains, and large warehouses',
      'Hardware-agnostic approach prevents vendor lock-in',
      'Provides cloud-based visibility without hardware ownership',
    ],
    officialFeaturesAndBenefits: {
      'Universal Access': [
        'Enterprise-grade indoor and outdoor Access Points ensuring comprehensive coverage.',
      ],
      'Unified Network Management': [
        'Centralized dashboard for proactive monitoring of APs, policies, and infrastructure.',
      ],
      'Advanced Security': [
        'Multi-layered protocols including MAC binding, OTP, and Active Directory authentication.',
      ],
      'Detailed Analytics & Reporting': [
        'Standardized reporting categorized by users, sites, access points, and SSIDs.',
      ],
      'Network Monetization': [
        'Customizable login landing pages for marketing promotions and engagement.',
      ],
      'High-Density Support': [
        'Engineered for consistent performance in high-traffic, multi-device environments.',
      ],
    },
    technicalCapabilities: [],
    deploymentModels: [],
    integrations: [],
    keyDifferentiators: [
      'End-to-end hardware lifecycle management included',
      'Single-pane cloud visibility dashboard for entire network',
      'Hardware-agnostic (partnerships with multiple leading OEMs)',
      'Guaranteed SLAs for comprehensive coverage and uptime',
    ],
    customerSignals: [
      'High volume of IT helpdesk tickets for wireless connectivity',
      'Inability to segregate corporate traffic from guest traffic',
      'Lack of analytics on visitor behavior in physical locations',
    ],
    businessOutcomes: [
      'Eliminate the IT burden of managing wireless networks',
      'Provide secure, seamless roaming for employees and guests',
      'Monetize guest access via customizable captive portals',
    ],
    discoveryHooks: [
      'How much time does IT spend investigating Wi-Fi dead zones?',
      'Are you capturing any footfall analytics from your guest Wi-Fi?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Cost: "Consumer routers are much cheaper."',
        response:
            'Consumer routers fail under enterprise density. Managed Wi-Fi eliminates hidden operational costs of troubleshooting.',
      ),
      ObjectionHandling(
        objection: 'Control: "We require full control over network hardware."',
        response:
            'Airtel provides a comprehensive cloud dashboard giving your IT full visibility and policy control.',
      ),
      ObjectionHandling(
        objection:
            'Vendor Lock-in: "We don\'t want to be tied to one manufacturer."',
        response:
            'Airtel partners with multiple leading vendors to offer a hardware-agnostic solution tailored to your budget.',
      ),
    ],
    crossSellProducts: ['Airtel Dedicated Internet (ILL)', 'Airtel SD-WAN'],
    idealIndustries: ['Hospitality', 'Education', 'Retail', 'Logistics'],
    officialSourceUrls: ['PRODUCTS.docx (Managed WiFi section)'],
    verificationStatus: 'Fully Verified',
  ),

  'prod_mpls': const EnrichedProduct(
    productName: 'Airtel VPN/MPLS',
    whatItIs:
        'A highly secure, private MPLS network providing dedicated connectivity between enterprise locations with guaranteed QoS.',
    whenToPitch:
        'Pitch to regulated enterprises requiring absolute data privacy and deterministic latency for core applications.',
    openingHook:
        'How are you guaranteeing the deterministic routing of your most critical internal workloads?',
    positioningStatement:
        'Position MPLS as the ultra-secure, SLA-backed backbone for mission-critical, latency-sensitive core applications.',
    whenNotToPitch: [
      'Customer is entirely cloud-native with zero on-premise data centers.',
      'Customer uses basic SaaS applications and is highly cost-conscious.',
      'Customer specifically wants to reduce overall WAN spend.',
    ],
    category: 'Networking & Connectivity',
    pitchDifficulty: 'Advanced',
    primaryUseCase:
        'Ultra-secure, latency-guaranteed routing for mission-critical apps',
    fiveThingsToRemember: [
      'Absolute privacy; traffic never touches the public internet',
      'Essential for regulated industries (Banking, Government)',
      'Guarantees performance for latency-sensitive ERPs like SAP',
      'Pitch as the core backbone, not for cheap branch internet',
      'Highly sticky product with multi-year contract potential',
    ],
    officialFeaturesAndBenefits: {
      'Scalable Bandwidth': [
        'Flexible bandwidth options ranging from 1 Mbps up to 100 Gbps.',
      ],
      'Class of Service (CoS)': [
        'Traffic prioritization ensuring mission-critical data receives consistent performance.',
      ],
      'Comprehensive Coverage': [
        'Backed by 400,000+ route kilometers of domestic fiber and 190+ countries globally.',
      ],
      'Managed Services': [
        'Fully managed CPE with proactive 24/7 remote monitoring from the Airtel NOC.',
      ],
      'Versatile Architectures': [
        'Supports multiple configurations including hub-and-spoke and fully meshed topologies.',
      ],
      'Diverse Connectivity Options': [
        'Compatible with fiber, radio, 5G, 4G, and VSAT last-mile connections.',
      ],
    },
    technicalCapabilities: [],
    deploymentModels: [],
    integrations: [],
    keyDifferentiators: [
      'Largest domestic fiber network in India',
      'Highly deterministic routing guarantees for core ERPs',
      'Deep integration with Airtel Cloud Connect (AWS, Azure)',
      'Financially backed enterprise-grade SLAs',
    ],
    customerSignals: [
      'Strict mandates prohibiting sensitive data on the public internet',
      'Application timeouts or jitter in core banking/ERP systems',
      'Need to connect a new facility securely to the data center',
    ],
    businessOutcomes: [
      'Route traffic entirely off the public internet securely',
      'Guarantee performance for mission-critical applications',
      'Achieve predictable latency backed by stringent SLAs',
    ],
    discoveryHooks: [
      'How are you ensuring absolute privacy for data transmitted between branches?',
      'Do you experience application timeouts during peak network utilization?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Agility: "MPLS takes too long to provision."',
        response:
            'We recommend a hybrid architecture: retain MPLS for core hubs and utilize SD-WAN over broadband for rapid sites.',
      ),
      ObjectionHandling(
        objection:
            'Cost: "MPLS bandwidth is more expensive than internet lines."',
        response:
            'Internet cannot guarantee latency. MPLS provides deterministic routing necessary for real-time financial transactions.',
      ),
      ObjectionHandling(
        objection: 'Cloud: "We don\'t need private branch routing anymore."',
        response:
            'Airtel MPLS integrates directly with Cloud Connect, providing a secure, high-speed on-ramp into AWS or Azure.',
      ),
    ],
    crossSellProducts: ['Airtel SD-WAN', 'Airtel Public Cloud'],
    idealIndustries: [
      'Banking & Financial Services',
      'Government',
      'Manufacturing',
      'Healthcare',
    ],
    officialSourceUrls: ['PRODUCTS.docx (VPN section)'],
    verificationStatus: 'Fully Verified',
  ),

  'prod_wfas': const EnrichedProduct(
    productName: 'Airtel Work From Anywhere Solutions',
    whatItIs:
        'Secure mobility and connectivity services enabling employees to access enterprise applications securely from home.',
    whenToPitch:
        'Pitch when an enterprise operates a hybrid workforce and struggles to secure or provision remote access.',
    openingHook:
        'How are you ensuring your remote workforce can securely access internal applications without exposing networks?',
    positioningStatement:
        'Position this as an enterprise security enabler replacing disjointed VPNs with zero-trust remote access.',
    whenNotToPitch: [
      'Customer mandates 100% return-to-office operations.',
      'Customer only needs basic mobile data plans.',
      'Customer already uses a fully deployed global ZTNA provider.',
    ],
    category: 'Mobility',
    pitchDifficulty: 'Easy',
    primaryUseCase: 'Securing remote workforce connectivity via zero-trust',
    fiveThingsToRemember: [
      'Replaces disjointed traditional VPNs with Zero Trust access',
      'Ensures corporate security policies apply on home networks',
      'Centralized portal drastically reduces helpdesk tickets',
      'Targeted corporate mobility plans offer GST input credits',
      'Strong cross-sell with Secure Internet and Postpaid',
    ],
    officialFeaturesAndBenefits: {
      'Multiple Hybrid Connectivity': ['2 WAN ports', '2 SIM slots'],
      'Stable High-speed Connectivity': [
        'Bandwidth aggregation',
        'Automatic failover',
      ],
      'Plug & Play Solution': [
        'Zero-touch provisioning',
        'Service provider agnostic',
      ],
      'Managed Solution': [
        'Analytics & Alerts',
        'Customer Portal & Dashboards',
      ],
    },
    technicalCapabilities: [
      'Zero-touch provisioning',
      'Bandwidth aggregation',
      'Automatic failover',
    ],
    deploymentModels: ['Plug & Play Router'],
    integrations: ['Customer Portal'],
    keyDifferentiators: [
      'Zero Trust Network Access (ZTNA) native architecture',
      'Unified billing with massive GST input credits',
      'Enterprise mobility seamlessly integrated with Secure Internet',
      'Dedicated 24/7 corporate support desk for remote users',
    ],
    customerSignals: [
      'Security breaches originating from compromised remote endpoints',
      'Helpdesk overwhelmed by VPN connection issues',
      'Inability to monitor data access outside the office',
    ],
    businessOutcomes: [
      'Secure remote access without exposing the internal network',
      'Improve remote workforce productivity with reliable connectivity',
      'Ensure consistent security policies regardless of physical location',
    ],
    discoveryHooks: [
      'How are you securing access for employees on untrusted home networks?',
      'What impact do unstable home connections have on team productivity?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Security: "We already have a traditional VPN."',
        response:
            'Traditional VPNs grant broad access. Secure Internet provides Zero Trust access, ensuring users only see authorized apps.',
      ),
      ObjectionHandling(
        objection: 'Cost: "Subsidizing home internet is too expensive."',
        response:
            'Airtel offers targeted corporate mobility plans providing managed costs with the added benefit of GST input credits.',
      ),
      ObjectionHandling(
        objection:
            'Complexity: "Managing home connectivity for everyone is a nightmare."',
        response:
            'Airtel provides a centralized portal and dedicated support, offloading troubleshooting from your IT team.',
      ),
    ],
    crossSellProducts: ['Airtel Corporate Postpaid', 'Airtel Secure Internet'],
    idealIndustries: [
      'IT & ITES',
      'Banking & Financial Services',
      'Media & Entertainment',
      'Education',
    ],
    officialSourceUrls: [
      'Derived from standard Airtel enterprise mobility positioning',
    ],
    verificationStatus: 'Partially Verified',
  ),

  'prod_5g_enterprise': const EnrichedProduct(
    productName: 'Airtel 5G for Enterprise',
    whatItIs:
        'Ultra-low latency, high-bandwidth 5G network solutions powering industrial automation and IoT deployments.',
    whenToPitch:
        'Pitch to manufacturing plants or logistics hubs looking to automate operations using robotics or real-time analytics.',
    openingHook:
        'How is your organization modernizing its wireless infrastructure to support real-time robotics and computer vision?',
    positioningStatement:
        'Position 5G as an Industry 4.0 enabler focused on low latency and massive device density.',
    whenNotToPitch: [
      'Customer is a standard corporate office with no industrial use cases.',
      'Customer lacks the capital budget for Industry 4.0 initiatives.',
      'Customer only needs standard building Wi-Fi for employee laptops.',
    ],
    category: 'IoT & Industry 4.0',
    pitchDifficulty: 'Advanced',
    primaryUseCase:
        'Powering ultra-low latency industrial automation and robotics',
    fiveThingsToRemember: [
      'Industry 4.0 enabler, not just "faster internet"',
      'Essential for AGVs and real-time computer vision',
      'Secures operational data on a localized Private 5G core',
      'Converts complex infrastructure to a NaaS OpEx model',
      'Requires long-term strategic engagement with operations teams',
    ],
    officialFeaturesAndBenefits: {
      'Private 5G Deployments': [
        'Dedicated, localized connectivity ensuring ultra-low latency for critical operations.',
      ],
      'Smart Factory Enablement': [
        'Provides the high-speed wireless backbone required for Industry 4.0 transformation.',
      ],
      'Industrial Automation': [
        'Replaces rigid wired networks with agile 5G, enabling reconfigurable manufacturing lines.',
      ],
      'Real-Time Robotics Support': [
        'Ultra-reliable low-latency communication (URLLC) guarantees millisecond response times for AMRs/AGVs.',
      ],
      'AI & Video Analytics Support': [
        'Massive uplink capacity to stream high-definition video feeds for real-time AI quality inspection.',
      ],
    },
    technicalCapabilities: [],
    deploymentModels: [],
    integrations: [],
    keyDifferentiators: [
      'First to deploy commercial Private 5G in India',
      'Massive licensed spectrum holdings ensuring high capacity',
      'Network-as-a-Service (NaaS) operational model',
      'Deep expertise in specialized industrial IoT integrations',
    ],
    customerSignals: [
      'Factory Wi-Fi dropping connections for mobile robots',
      'Need for real-time AI computer vision for quality control',
      'Planning a highly automated smart factory deployment',
    ],
    businessOutcomes: [
      'Enable real-time industrial automation with single-digit latency',
      'Secure operational data on a Private 5G core',
      'Support massive sensor density without Wi-Fi limitations',
    ],
    discoveryHooks: [
      'What bottlenecks are you hitting with factory floor Wi-Fi?',
      'How are you securely managing the influx of sensor data?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Maturity: "5G use cases seem unproven for manufacturing."',
        response:
            'Airtel has deployed Private 5G networks in operational plants, powering AGVs and cameras with measurable gains.',
      ),
      ObjectionHandling(
        objection:
            'Cost: "Building Private 5G requires massive capital expenditure."',
        response:
            'Airtel offers Network-as-a-Service models, converting complex infrastructure into a manageable OpEx investment.',
      ),
      ObjectionHandling(
        objection: 'Skills: "We lack telecom expertise to manage a 5G core."',
        response:
            'Airtel handles end-to-end design, deployment, and managed services, allowing your team to focus entirely on applications.',
      ),
    ],
    crossSellProducts: ['Airtel IoT Connectivity', 'Airtel Public Cloud'],
    idealIndustries: ['Manufacturing', 'Logistics', 'Automotive', 'Healthcare'],
    officialSourceUrls: ['Derived from standard Airtel 5G B2B positioning'],
    verificationStatus: 'Partially Verified',
  ),

  'prod_cpaas': const EnrichedProduct(
    productName: 'Airtel CPaaS',
    whatItIs:
        'A platform providing APIs to seamlessly embed SMS, Voice, and messaging capabilities directly into enterprise applications.',
    whenToPitch:
        'Pitch when an enterprise needs to automate transactional notifications, build custom IVRs, or mask phone numbers.',
    openingHook:
        'How are your developers integrating secure messaging and voice directly into your customer-facing applications?',
    positioningStatement:
        'Position CPaaS to the CTO as a developer-friendly API platform backed by direct telecom reliability.',
    whenNotToPitch: [
      'Customer relies entirely on off-the-shelf software with no developers.',
      'Customer only uses simple email marketing.',
      'Customer volume is too small to justify API integration.',
    ],
    category: 'Customer Engagement',
    pitchDifficulty: 'Intermediate',
    primaryUseCase:
        'Embedding transactional messaging and voice APIs into apps',
    fiveThingsToRemember: [
      'Sell to the CTO/Product Owner, not just procurement',
      'Superior delivery rates for OTPs via direct telco integration',
      'Masks phone numbers to ensure customer privacy',
      'Extremely sticky once integrated into core application code',
      'Developer-friendly SDKs ensure rapid time-to-market',
    ],
    officialFeaturesAndBenefits: {
      'Voice APIs': [
        'Click-to-call, intelligent agent routing, call masking, and inbound/outbound IVR.',
      ],
      'Messaging': [
        'Intelligent message automation for scalable SMS campaigns and critical alerts.',
      ],
      'WhatsApp & Chatbots': [
        'Integrated WhatsApp Business API and chatbot support for interactive engagement.',
      ],
      'Video': [
        'Scalable video conferencing and real-time calling experiences.',
      ],
      'Authentication': [
        'Security tools like Silent Auth and implied OTP for seamless user verification.',
      ],
      'Advanced Modules': [
        'Specialized logic flows for fintech E-KYC, retail, and healthcare engagement.',
      ],
    },
    technicalCapabilities: [],
    deploymentModels: [],
    integrations: [],
    keyDifferentiators: [
      'Direct telecom integration avoids latency of aggregators',
      'Superior OTP delivery rates via Tier-1 routing',
      'Comprehensive, developer-friendly API SDKs',
      'Strict enterprise-grade data privacy and masking',
    ],
    customerSignals: [
      'E-commerce platforms needing automated delivery tracking',
      'Cab aggregators requiring driver-to-customer call masking',
      'Banks needing high-reliability OTP delivery systems',
    ],
    businessOutcomes: [
      'Accelerate time-to-market using simple, developer-friendly APIs',
      'Protect customer privacy by masking transaction phone numbers',
      'Ensure high-deliverability of mission-critical alerts like OTPs',
    ],
    discoveryHooks: [
      'How are you protecting customer phone numbers during delivery transactions?',
      'What is the current delivery success rate of your OTP messages?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection:
            'Resources: "We don\'t have engineering bandwidth for APIs."',
        response:
            'Airtel CPaaS offers robust SDKs and pre-built code snippets allowing developers to integrate messaging in days.',
      ),
      ObjectionHandling(
        objection: 'Reliability: "We use a global aggregator for SMS."',
        response:
            'Aggregators increase latency. Airtel CPaaS connects directly to the core network, ensuring superior delivery rates.',
      ),
      ObjectionHandling(
        objection: 'Scalability: "Can this handle massive traffic spikes?"',
        response:
            'Built on telecom infrastructure, it handles thousands of transactions per second with built-in redundancy.',
      ),
    ],
    crossSellProducts: [
      'Airtel WhatsApp Business',
      'Airtel Contact Center as a Service',
    ],
    idealIndustries: [
      'E-Commerce',
      'Banking & Financial Services',
      'Retail',
      'Logistics',
    ],
    officialSourceUrls: ['Derived from standard Airtel IQ CPaaS capabilities'],
    verificationStatus: 'Partially Verified',
  ),

  'prod_ill': const EnrichedProduct(
    productName: 'Airtel Dedicated Internet (ILL)',
    whatItIs:
        'A dedicated, secure internet connection providing guaranteed symmetric bandwidth and an SLA-backed 99.5% uptime.',
    whenToPitch:
        'Pitch when a business cannot tolerate downtime, frequently uploads large files, or hosts web applications.',
    openingHook:
        'How are you guaranteeing the uptime and symmetric upload speeds required for your critical cloud applications?',
    positioningStatement:
        'Position ILL as an insurance policy against downtime, backed by a financially binding SLA.',
    whenNotToPitch: [
      'Customer operates a small cafe needing basic web browsing.',
      'Customer is extremely price-sensitive and happy with shared broadband.',
      'Customer requires complex routing across branches (pitch MPLS/SD-WAN).',
    ],
    category: 'Networking & Connectivity',
    pitchDifficulty: 'Intermediate',
    primaryUseCase:
        'SLA-backed dedicated internet for critical business operations',
    fiveThingsToRemember: [
      'Position as a downtime insurance policy, not basic broadband',
      'Offers true symmetric speeds for heavy cloud uploads',
      'Financially binding 99.5% SLA protects business revenue',
      'Burstable bandwidth handles unpredictable traffic spikes',
      'Must-have for data-heavy media and IT service companies',
    ],
    officialFeaturesAndBenefits: {
      'Superfast speed & top-notch security': [
        'Scale your speed as per requirement ranging from 10Mbps to 100Gbps.',
        'Get world-class DDoS protection and built-in firewall security.',
      ],
      'Dedicated bandwidth': [
        'Get symmetric upload and download bandwidth of 200TB for data-intensive tasks and digital communications.',
      ],
      'Reliable internet': [
        'Ensure 99.5% uptime and near-zero latency on FTTH or fiber, regardless of user volume or bandwidth-intensive applications.',
      ],
      'Burstable bandwidth': [
        'Get flexible and scalable connectivity with burstable bandwidth up to five times the base bandwidth, at minimal added cost.',
      ],
      'Unmatched network reach': [
        '4,00,000+ RKM of fiber network across 50 countries & 5 continents, 34+ international cables, 65+ global and 121 domestic PoPs.',
      ],
      '24*7 support': [
        'World-class SLA with 100% troubleshooting. 24*7 support via Airtel Thanks for Business.',
      ],
    },
    technicalCapabilities: [
      '10Mbps to 100Gbps speeds',
      'Symmetric upload/download',
      'DDoS protection built-in',
      'Burstable bandwidth up to 5x',
    ],
    deploymentModels: ['FTTH', 'Fiber Leased Line'],
    integrations: ['Airtel Thanks for Business Portal'],
    keyDifferentiators: [
      'Financially binding 99.5% uptime SLA',
      'True physical path diversity for redundancy',
      'Burstable bandwidth capabilities on demand',
      'Largest domestic backhaul fiber network',
    ],
    customerSignals: [
      'Complaints about slow internet during peak office hours',
      'Video conferences freezing due to poor upload speeds',
      'Financial losses tied to brief internet outages',
    ],
    businessOutcomes: [
      'Guarantee uninterrupted operations with SLA-backed 99.5% uptime',
      'Accelerate data-intensive tasks with symmetric upload speeds',
      'Handle unpredictable traffic spikes with burstable bandwidth',
    ],
    discoveryHooks: [
      'How much productivity is lost when your internet slows down?',
      'What is the financial impact if your internet goes down?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Cost: "Dedicated Internet is vastly more expensive."',
        response:
            'Broadband shares bandwidth, causing slowdowns. ILL provides guaranteed capacity and an SLA that compensates downtime.',
      ),
      ObjectionHandling(
        objection: 'Redundancy: "Two cheap broadband lines are enough backup."',
        response:
            'Dual broadband lines share the same physical path. Airtel ILL offers true physical path diversity for safety.',
      ),
      ObjectionHandling(
        objection:
            'Flexibility: "We occasionally need more speed but don\'t want to overpay."',
        response:
            'Airtel ILL offers burstable bandwidth, allowing seamless scale up to five times base bandwidth during spikes.',
      ),
    ],
    crossSellProducts: ['Airtel Secure Internet', 'Airtel Public Cloud'],
    idealIndustries: [
      'IT & ITES',
      'Banking & Financial Services',
      'Manufacturing',
      'Media & Entertainment',
    ],
    officialSourceUrls: ['PRODUCTS.docx (DEDICATED INTERNET section)'],
    verificationStatus: 'Fully Verified',
  ),

  'prod_colocation': const EnrichedProduct(
    productName: 'Airtel Colocation (Nxtra)',
    whatItIs:
        'Enterprise-grade data center space providing secure power, cooling, and physical security for server hardware.',
    whenToPitch:
        'Pitch when an enterprise runs out of on-premise server space or struggles with power cooling costs.',
    openingHook:
        'How is your infrastructure strategy shifting to balance proprietary hardware control with modern resilience?',
    positioningStatement:
        'Position Colocation as a strategic bridge replacing private server room CapEx with secure managed facilities.',
    whenNotToPitch: [
      'Customer is 100% cloud-native with zero owned servers.',
      'Customer is a startup running entirely on SaaS.',
      'Customer insists on keeping data servers in their office.',
    ],
    category: 'Cloud & Infrastructure',
    pitchDifficulty: 'Advanced',
    primaryUseCase:
        'Securely hosting legacy enterprise hardware in managed facilities',
    fiveThingsToRemember: [
      'Bridge product for workloads that cannot move to public cloud',
      'Eliminates capital expense of building private server rooms',
      'Resolves escalating power and cooling costs immediately',
      'Offers direct, low-latency cross-connects to hyperscalers',
      'Strict physical security meets rigorous compliance mandates',
    ],
    officialFeaturesAndBenefits: {
      'Flexible Deployment Options': [
        'Shared cages, private suites, and purpose-built dedicated data center facilities.',
      ],
      'Advanced AI-Led Operations': [
        'Predictive maintenance and automated workflows using AI fault detection.',
      ],
      'High-Performance Connectivity': [
        'Carrier-neutral infrastructure with low-latency access to cloud providers and IXs.',
      ],
      'Robust Security': [
        '7-layer security with 24x7 surveillance and multi-factor biometric/OTP access controls.',
      ],
      'Sustainability': [
        'Green infrastructure leveraging LEED/IGBC-certified buildings and renewable energy.',
      ],
      'Infrastructure for Next-Gen Workloads': [
        'Supports high-density racks (up to 130 kW) and liquid cooling for AI/cloud-native workloads.',
      ],
    },
    technicalCapabilities: [],
    deploymentModels: [],
    integrations: [],
    keyDifferentiators: [
      'Largest network of Tier III/IV data centers in India',
      'Direct cross-connects to major hyperscalers',
      'Strict physical security and compliance certifications',
      '100% green energy initiatives and sustainability focus',
    ],
    customerSignals: [
      'Upcoming server refresh cycle but reluctant to move to public cloud',
      'Facing exorbitant cooling costs for on-premise servers',
      'Regulatory requirements dictating physical control over hardware',
    ],
    businessOutcomes: [
      'Eliminate the capital expense of private server rooms',
      'Ensure high availability with N+1 redundant power',
      'Achieve strict regulatory compliance through physical security',
    ],
    discoveryHooks: [
      'How are you managing the escalating power costs of on-premise servers?',
      'What is your disaster recovery plan for prolonged power outages?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Cloud: "We are migrating to the cloud."',
        response:
            'Most enterprises adopt a hybrid strategy. Colocation secures legacy databases while offering cross-connects to hyperscalers.',
      ),
      ObjectionHandling(
        objection: 'Control: "We want immediate physical access to servers."',
        response:
            'Nxtra facilities offer 24x7 secure access and remote hands services where certified technicians perform tasks for you.',
      ),
      ObjectionHandling(
        objection: 'Migration: "Moving our racks is too risky."',
        response:
            'Airtel provides end-to-end migration services, securely transporting your hardware during scheduled maintenance windows.',
      ),
    ],
    crossSellProducts: ['Airtel Dedicated Internet (ILL)', 'Airtel VPN/MPLS'],
    idealIndustries: [
      'Banking & Financial Services',
      'IT & ITES',
      'Government',
      'Healthcare',
    ],
    officialSourceUrls: ['Derived from standard Airtel Nxtra capabilities'],
    verificationStatus: 'Partially Verified',
  ),

  'prod_global_voice': const EnrichedProduct(
    productName: 'Airtel Global Voice',
    whatItIs:
        'Wholesale Voice Termination services utilizing Tier-1 carrier partnerships to provide high-quality international calling.',
    whenToPitch:
        'Pitch to global call centers suffering from call drops, high latency, or excessive international costs.',
    openingHook:
        'How are you optimizing your international voice routing to minimize latency and call drops?',
    positioningStatement:
        'Position Global Voice around network quality and fraud protection, not just the lowest per-minute rate.',
    whenNotToPitch: [
      'Customer only makes domestic calls within India.',
      'Customer uses consumer VoIP tools for occasional chats.',
      'Customer strictly refuses to move away from illegal grey-routes.',
    ],
    category: 'Unified Communications',
    pitchDifficulty: 'Intermediate',
    primaryUseCase:
        'Premium international voice routing for global call centers',
    fiveThingsToRemember: [
      'Sell network quality and agent success, not just cheap rates',
      'Tier-1 direct routes eliminate latency of grey-route hops',
      'Automated fraud detection protects against billing spikes',
      'Essential for BPOs relying on high answer rates',
      'Seamless migration using standard SIP protocols',
    ],
    officialFeaturesAndBenefits: {
      'Global Reach & Connectivity': [
        'Voice termination across 140+ countries supported by 1,200+ global carrier partnerships.',
      ],
      'Numbering Solutions': [
        'Toll-Free Numbers and DID numbers to establish a local presence internationally.',
      ],
      'Airtel Advantage Platform': [
        'Unified digital platform for paperless onboarding, SIP interconnects, and traffic analytics.',
      ],
      'Traffic Assurance': [
        'Network optimized for low latency, high redundancy, and maximum uptime.',
      ],
      'Security & Fraud Protection': [
        'Best-in-class systems to detect and block fraudulent international traffic.',
      ],
    },
    technicalCapabilities: [],
    deploymentModels: [],
    integrations: [],
    keyDifferentiators: [
      '1200+ direct Tier-1 global interconnects',
      'Automated real-time telecom fraud detection',
      'Deep penetration directly into Africa and South Asia',
      'Online Voice Platform for rapid SIP interconnects',
    ],
    customerSignals: [
      'BPO clients complaining about poor voice quality',
      'High rates of international call drops',
      'Fraudulent international routing causing billing spikes',
    ],
    businessOutcomes: [
      'Improve international call quality via direct Tier-1 routing',
      'Protect against telecom fraud with automated fraud detection',
      'Reduce communication costs through competitive wholesale agreements',
    ],
    discoveryHooks: [
      'How is poor international voice quality impacting agent resolution times?',
      'Are you experiencing sudden spikes in calling costs due to fraud?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Price: "Grey-route providers are much cheaper."',
        response:
            'Grey routes suffer severe latency. Tier-1 interconnects guarantee premium voice quality, improving agent success rates.',
      ),
      ObjectionHandling(
        objection: 'Migration: "Switching SIP trunks sounds complex."',
        response:
            'The Online Voice Platform allows quick interconnects using standard SIP protocols for a seamless transition.',
      ),
      ObjectionHandling(
        objection: 'Coverage: "Do you have direct routes to emerging markets?"',
        response:
            'Airtel possesses 1200+ direct interconnects and deep penetration directly into Africa and South Asia.',
      ),
    ],
    crossSellProducts: [
      'Airtel SIP Trunking',
      'Airtel Dedicated Internet (ILL)',
    ],
    idealIndustries: [
      'IT & ITES',
      'Travel & Tourism',
      'E-Commerce',
      'Telecom & Carriers',
    ],
    officialSourceUrls: ['PRODUCTS.docx (GLOBAL VOICE section)'],
    verificationStatus: 'Fully Verified',
  ),

  'prod_iot': const EnrichedProduct(
    productName: 'Airtel IoT Connectivity',
    whatItIs:
        'A scalable M2M connectivity solution powered by NB-IoT, managed centrally through the Airtel IoTHub platform.',
    whenToPitch:
        'Pitch when a business needs to track fleets, monitor smart meters, or automate industrial assets.',
    openingHook:
        'How are you centralizing visibility and control over thousands of remote connected devices at scale?',
    positioningStatement:
        'Position IoT Connectivity as an operational intelligence platform driven by the robust IoTHub dashboard.',
    whenNotToPitch: [
      'Customer only needs internet for human employees.',
      'Customer operates entirely within a single small building.',
      'Customer has no distributed physical assets.',
    ],
    category: 'IoT & Industry 4.0',
    pitchDifficulty: 'Intermediate',
    primaryUseCase: 'Centralized management of remote connected machine assets',
    fiveThingsToRemember: [
      'Pitch the IoTHub platform\'s visibility, not just the SIM cards',
      'NB-IoT penetrates deep underground where standard signals fail',
      'Secures machine data by routing through private APNs',
      'Massively reduces costly field technician dispatches',
      'Ideal for logistics, smart meters, and point-of-sale machines',
    ],
    officialFeaturesAndBenefits: {
      'IoTHub': [
        'One platform to easily manage all your connected devices with flexible billings, network feasibility map and flexible APN which is secure by design.',
      ],
      '5G, NBIoT ready': [
        'Powered by range of connectivity services and vast network to ensure connectivity for all your devices.',
      ],
      'Leverage telco capabilities': [
        'Option to send/receive bulk SMS, support for emergency calling and location services (SIM based) without using GPS.',
      ],
      'Real-time insights': [
        'Monitor real-time SIM wise data usage and diagnose issues with automated tests. Deep-dive into core network performance.',
      ],
    },
    technicalCapabilities: [
      '5G ready',
      'NB-IoT ready',
      'SIM-based location services',
      'Secure APN',
    ],
    deploymentModels: ['IoT SIM Cards'],
    integrations: ['IoTHub Platform'],
    keyDifferentiators: [
      'Deep indoor and underground coverage via NB-IoT network',
      'Powerful IoTHub dashboard for automated lifecycle management',
      'Secure private APN routing architecture for data integrity',
      'Global roaming agreements for seamless tracking across borders',
    ],
    customerSignals: [
      'Logistics companies losing visibility of shipments in transit',
      'Utilities struggling to collect data from remote meters',
      'Inability to diagnose why remote machines go offline',
    ],
    businessOutcomes: [
      'Monitor thousands of connected assets from a single dashboard',
      'Reduce field maintenance costs by diagnosing devices remotely',
      'Ensure secure data transmission with encrypted private APNs',
    ],
    discoveryHooks: [
      'How are you currently tracking the health of distributed physical assets?',
      'What is the cost of sending technicians simply to read meters?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Coverage: "Our assets travel through remote areas."',
        response:
            'Airtel supports NB-IoT, which penetrates deep underground and inside buildings where traditional signals fail.',
      ),
      ObjectionHandling(
        objection: 'Management: "Managing 10,000 SIM cards is impossible."',
        response:
            'IoTHub aggregates all devices into a single pane, allowing automated lifecycle management and anomaly detection.',
      ),
      ObjectionHandling(
        objection: 'Security: "IoT devices are entry points for hackers."',
        response:
            'Airtel IoT secures data at the network level by routing traffic through a private, secure APN.',
      ),
    ],
    crossSellProducts: ['Airtel Public Cloud', 'Airtel 5G for Enterprise'],
    idealIndustries: [
      'Automotive',
      'Logistics',
      'Manufacturing',
      'Energy & Utilities',
    ],
    officialSourceUrls: ['PRODUCTS.docx (IOT section)'],
    verificationStatus: 'Fully Verified',
  ),

  'prod_office_internet': const EnrichedProduct(
    productName: 'Airtel Office Internet',
    whatItIs:
        'A business-grade broadband solution bundled with a free static IP and Cisco DNS security.',
    whenToPitch:
        'Pitch to SMEs or retail stores needing fast internet without the dedicated SLA of an ILL.',
    openingHook:
        'How are you ensuring your branch offices have enterprise-grade security layered directly into their internet?',
    positioningStatement:
        'Position this as a secure Business-in-a-Box for SMEs, leading with bundled static IP and security.',
    whenNotToPitch: [
      'Customer requires guaranteed symmetric SLAs for a data center.',
      'Customer requires complex multi-site routing.',
      'Customer is an enterprise headquarters with thousands of employees.',
    ],
    category: 'Networking & Connectivity',
    pitchDifficulty: 'Easy',
    primaryUseCase: 'Secure, high-speed broadband bundled for small offices',
    fiveThingsToRemember: [
      'The perfect "Business in a Box" solution for SMEs',
      'Free Static IP enables secure remote access to local servers',
      'Integrated Cisco DNS blocks threats at the network level',
      '18% GST credit makes true cost highly competitive',
      'Not for data centers needing guaranteed symmetric SLAs',
    ],
    officialFeaturesAndBenefits: {
      'High-speed up to 1Gbps': [
        'Lightning-fast speeds optimal for all enterprise devices and workflows.',
      ],
      'In-built DNS Security by Cisco': [
        'Network-level protection against malicious domains and cyber threats.',
      ],
      'End Point Device Security by Kaspersky': [
        'Device-level protection ensuring secure browsing and data safety.',
      ],
      'Unlimited voice call': [
        'Seamless voice connectivity bundled directly with the broadband service.',
      ],
      'Parallel Ringing': [
        'Ensure no business call is missed by ringing multiple designated numbers simultaneously.',
      ],
      'Free Static IP': [
        'Included for advanced networking requirements and secure remote access.',
      ],
    },
    technicalCapabilities: [],
    deploymentModels: [],
    integrations: [],
    keyDifferentiators: [
      'True "Business in a Box" bundled offering',
      'Free Static IP included out-of-the-box',
      'Cisco DNS security built-in at the network level',
      '18% GST credit via official corporate billing',
    ],
    customerSignals: [
      'Small offices struggling with consumer-grade broadband drops',
      'Retail stores needing a static IP for surveillance',
      'Businesses wanting basic network security without expensive firewalls',
    ],
    businessOutcomes: [
      'Host web applications securely using the free Static IP',
      'Block malicious websites automatically with integrated DNS Security',
      'Reclaim 18% GST through official corporate billing',
    ],
    discoveryHooks: [
      'Do you need a Static IP to remotely access surveillance cameras?',
      'How are you protecting office devices from malicious websites?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Performance: "We need dedicated bandwidth."',
        response:
            'If you need guaranteed bandwidth, we can upgrade to Airtel ILL. Office Internet is designed for asymmetric usage.',
      ),
      ObjectionHandling(
        objection: 'Cost: "Local providers offer cheaper monthly rates."',
        response:
            'Local providers lack enterprise security. Airtel includes a free Static IP, Cisco DNS, and 18% GST credit.',
      ),
      ObjectionHandling(
        objection: 'Security: "We already have basic antivirus."',
        response:
            'Antivirus protects the device late. Cisco DNS Security blocks malicious domains at the network level instantly.',
      ),
    ],
    crossSellProducts: [
      'Airtel Corporate Postpaid',
      'Airtel IQ Business Connect',
    ],
    idealIndustries: ['Retail', 'Education', 'Hospitality', 'IT & ITES'],
    officialSourceUrls: ['PRODUCTS.docx (OFFICE INTERNET section)'],
    verificationStatus: 'Fully Verified',
  ),

  'prod_precise_positioning': const EnrichedProduct(
    productName: 'Airtel Precise Positioning',
    whatItIs:
        'A high-accuracy location service providing centimeter-level GPS accuracy for autonomous operations over cellular networks.',
    whenToPitch:
        'Pitch to logistics or drone operators where standard GPS accuracy is insufficient for automation.',
    openingHook:
        'How are you achieving the centimeter-level accuracy required to safely automate your high-value mobile assets?',
    positioningStatement:
        'Position this as an infrastructure-free automation enabler that eliminates expensive proprietary ground reference stations.',
    whenNotToPitch: [
      'Customer only tracks standard delivery trucks where street-level GPS is fine.',
      'Customer has no autonomous or precision agricultural use cases.',
      'Customer assets operate entirely indoors.',
    ],
    category: 'IoT & Industry 4.0',
    pitchDifficulty: 'Advanced',
    primaryUseCase:
        'Centimeter-level GPS accuracy for autonomous vehicles and drones',
    fiveThingsToRemember: [
      'Replaces standard 5-meter GPS with centimeter precision',
      'Eliminates the massive CapEx of proprietary ground stations',
      'Delivered entirely over existing cellular networks',
      'Niche product targeted at drone operators and smart agriculture',
      'Essential for autonomous routing in dense environments',
    ],
    officialFeaturesAndBenefits: {
      'Centimeter-Level Accuracy': [
        'Improves location precision by up to 100x compared to standard GNSS systems.',
      ],
      'AI/ML-Powered Cloud Correction': [
        'Uses cloud algorithms and a nationwide reference network to model errors in real-time.',
      ],
      'Seamless Network Integration': [
        'Leverages Airtel pan-India 4G/5G network for continuous, reliable coverage.',
      ],
      'Scalable Architecture': [
        'Built to support mission-critical deployments for autonomous vehicles, drones, and precision agriculture.',
      ],
    },
    technicalCapabilities: [],
    deploymentModels: [],
    integrations: [],
    keyDifferentiators: [
      'Delivered entirely over existing cellular networks',
      'Eliminates CapEx of building proprietary ground stations',
      'True centimeter-level accuracy',
      'Plug-and-play compatible with standard RTK receivers',
    ],
    customerSignals: [
      'Drone delivery companies struggling with landing accuracy',
      'Agriculture firms deploying autonomous vehicles requiring exact routing',
      'GPS drifting causing tracking errors in urban environments',
    ],
    businessOutcomes: [
      'Enable autonomous operations with centimeter-level precision',
      'Eliminate the need for expensive proprietary ground stations',
      'Improve route optimization in dense industrial environments',
    ],
    discoveryHooks: [
      'Is standard 5-meter GPS variance preventing you from automating vehicles?',
      'Are you experiencing signal drift when tracking high-value urban assets?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Coverage: "Does this work in remote areas?"',
        response:
            'The service relies on cellular networks. We provide feasibility maps to ensure operational zones have coverage.',
      ),
      ObjectionHandling(
        objection: 'Hardware: "Will we need completely new hardware?"',
        response:
            'The service works with most RTK-compatible GNSS receivers via standard NTRIP protocols.',
      ),
      ObjectionHandling(
        objection: 'Cost: "Is this much more expensive than standard GPS?"',
        response:
            'Standard GPS cannot support autonomous operations. This removes the CapEx of building proprietary RTK infrastructure.',
      ),
    ],
    crossSellProducts: ['Airtel IoT Connectivity', 'Airtel 5G for Enterprise'],
    idealIndustries: [
      'Logistics',
      'Automotive',
      'Manufacturing',
      'Energy & Utilities',
    ],
    officialSourceUrls: [
      'Derived from standard Airtel Precise Positioning capabilities',
    ],
    verificationStatus: 'Partially Verified',
  ),

  'prod_public_cloud': const EnrichedProduct(
    productName: 'Airtel Public Cloud',
    whatItIs:
        'A sovereign public cloud infrastructure hosted entirely within India, offering unified multi-cloud management.',
    whenToPitch:
        'Pitch when organizations face strict data residency mandates or want to escape unpredictable egress fees.',
    openingHook:
        'How are you balancing hyperscaler cloud expansion with strict local regulatory compliance and egress costs?',
    positioningStatement:
        'Position Airtel Public Cloud as a compliance-first, sovereign cloud layer avoiding unpredictable hyperscaler egress fees.',
    whenNotToPitch: [
      'Customer requires highly specialized AI/ML PaaS services from AWS/Google.',
      'Customer operates a global application requiring US/EU data centers.',
      'Customer is entirely locked into a 5-year hyperscaler enterprise agreement.',
    ],
    category: 'Cloud & Infrastructure',
    pitchDifficulty: 'Advanced',
    primaryUseCase:
        'Sovereign, compliance-first cloud hosting with predictable costs',
    fiveThingsToRemember: [
      'Do not position as a direct feature-for-feature AWS replacement',
      'Perfect for strict data residency and sovereignty mandates',
      'Highly transparent pricing with minimal data egress fees',
      'Single vendor simplicity for both connectivity and cloud',
      'Use the Cloud Management Platform for hybrid orchestration',
    ],
    officialFeaturesAndBenefits: {
      'Rapid Deployment': [
        'Instances provisioned in less than 60 seconds, eliminating hardware procurement delays.',
      ],
      'Sovereign Cloud Capabilities': [
        'Combines global cloud functionality with strict domestic data residency and compliance.',
      ],
      'Integrated Connectivity': [
        'Directly integrates cloud services with Airtel robust B2B connectivity network.',
      ],
      'High Security Standards': [
        'Features 24x7 monitoring by certified professionals with network isolation and encryption.',
      ],
      'Managed Services': [
        'Professional management allowing businesses to focus on core applications rather than infrastructure.',
      ],
    },
    technicalCapabilities: [],
    deploymentModels: [],
    integrations: [],
    keyDifferentiators: [
      'Sovereign data hosted entirely within India',
      'Zero unpredictable global hyperscaler egress fees',
      'Unified billing for enterprise connectivity and cloud',
      'Cloud Management Platform for hybrid orchestration',
    ],
    customerSignals: [
      'Facing strict data residency and sovereignty regulations',
      'CIOs complaining about opaque billing and high egress charges',
      'Migrating legacy workloads without refactoring for hyperscalers',
    ],
    businessOutcomes: [
      'Achieve strict data residency with India-hosted infrastructure',
      'Reduce TCO with minimal data egress charges',
      'Simplify vendor management by procuring connectivity and cloud together',
    ],
    discoveryHooks: [
      'Are you facing regulatory pressure to keep customer data within India?',
      'How are you managing unpredictable data egress costs from global hyperscalers?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection:
            'Ecosystem: "Hyperscalers offer specialized PaaS you don\'t."',
        response:
            'Airtel Public Cloud excels at secure IaaS for core workloads. Our Cloud Management Platform allows seamless hybrid orchestration.',
      ),
      ObjectionHandling(
        objection: 'Reliability: "Is a telco cloud reliable?"',
        response:
            'Airtel Cloud is built on our tier-rated Nxtra data centers with 99.99% uptime and direct core network integration.',
      ),
      ObjectionHandling(
        objection: 'Migration: "Migrating workloads sounds highly disruptive."',
        response:
            'Airtel provides managed migration services, enabling fast data transfer over our private network without disruption.',
      ),
    ],
    crossSellProducts: [
      'Airtel Dedicated Internet (ILL)',
      'Airtel Secure Internet',
    ],
    idealIndustries: [
      'Banking & Financial Services',
      'Government',
      'Healthcare',
      'Manufacturing',
    ],
    officialSourceUrls: ['PRODUCTS.docx (PUBLIC CLOUD section)'],
    verificationStatus: 'Fully Verified',
  ),

  'prod_secure_internet': const EnrichedProduct(
    productName: 'Airtel Secure Internet',
    whatItIs:
        'An integrated connectivity and security solution combining internet leased lines with cloud-delivered security.',
    whenToPitch:
        'Pitch when an enterprise struggles to manage multiple security vendors or faces increased ransomware threats.',
    openingHook:
        'How are you unifying your network connectivity and threat protection to eliminate dangerous operational silos?',
    positioningStatement:
        'Position this as a risk-reduction play offering a single point of accountability for network security.',
    whenNotToPitch: [
      'Customer just invested heavily in a massive fleet of Palo Alto firewalls.',
      'Customer strictly mandates managing all security policies natively with no MSP.',
      'Customer operates a small cafe with no sensitive corporate data.',
    ],
    category: 'Security',
    pitchDifficulty: 'Intermediate',
    primaryUseCase:
        'Integrated connectivity and cloud-delivered network security',
    fiveThingsToRemember: [
      'A massive risk-reduction play offering single accountability',
      'Protects remote branches without heavy data center firewalls',
      'Proactive 24/7 SOC monitoring offloads IT team burden',
      'Enforces Zero Trust Architecture for distributed workforces',
      'Eliminates finger-pointing between ISPs and firewall vendors',
    ],
    officialFeaturesAndBenefits: {
      'Extensive network': [
        'Enterprise-grade Pan-India Internet for secure, consistent connectivity across all office locations.',
      ],
      'Managed services': [
        'End-to-end managed security services with 24/7 monitoring, support and a robust reporting portal.',
      ],
      'Proactive monitoring': [
        'Dedicated Security Operations Center (SOC) with a workforce of 350+ certified professionals, including ZCDS and ZCSS.',
      ],
      'Multi-ISP links protection': [
        'Protection for all your internet links across offices, regardless of the service provider.',
      ],
      'User-centric access': [
        'Zscaler’s ZTA prioritizes identity verification, ensuring all users—office or remote—are authenticated before accessing applications.',
      ],
      'Micro-segmentation': [
        'By segmenting the network into zones, Zscaler reduces lateral movement risks, enabling effective isolation of sensitive data and applications.',
      ],
    },
    technicalCapabilities: [
      'Zero Trust Architecture (ZTA)',
      'Micro-segmentation',
      'Multi-ISP link protection',
      'Zscaler Security Service Edge (SSE)',
    ],
    deploymentModels: ['Managed Service via SOC'],
    integrations: ['Zscaler ZTA', 'Airtel Internet Leased Line (ILL)'],
    keyDifferentiators: [
      'Single point of accountability (ISP + Security)',
      'Proactive 24/7 SOC monitoring included',
      'Cloud-delivered Secure Service Edge (SSE) capabilities',
      'Eliminates vendor finger-pointing during incidents',
    ],
    customerSignals: [
      'IT team overwhelmed managing disjointed firewalls',
      'Concerns about remote employees accessing corporate applications',
      'Recent audits flagging legacy network vulnerabilities',
    ],
    businessOutcomes: [
      'Eliminate the complexity of managing disparate network security vendors',
      'Protect applications with Zero Trust Architecture authentication',
      'Reduce downtime through proactive 24/7 SOC monitoring',
    ],
    discoveryHooks: [
      'How are you ensuring remote employees access your network securely?',
      'Are you purchasing internet connectivity from one vendor and firewalls separately?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Investments: "We recently purchased expensive firewalls."',
        response:
            'Secure Internet can be delivered as a Cloud SSE, protecting remote users without replacing core data center firewalls.',
      ),
      ObjectionHandling(
        objection: 'Control: "We prefer to manage our own security policies."',
        response:
            'We offer co-managed models where your IT retains full control via the dashboard, while Airtel handles 24/7 monitoring.',
      ),
      ObjectionHandling(
        objection:
            'Vendor Lock-in: "Bundling makes it hard to change providers."',
        response:
            'Consolidation provides single-point accountability. Integrated security ensures no finger-pointing between ISP and firewall vendor.',
      ),
    ],
    crossSellProducts: ['Airtel SD-WAN', 'Airtel Work From Anywhere Solutions'],
    idealIndustries: [
      'Banking & Financial Services',
      'Healthcare',
      'IT & ITES',
      'E-Commerce',
    ],
    officialSourceUrls: ['PRODUCTS.docx (SECURE INTERNET sections)'],
    verificationStatus: 'Fully Verified',
  ),

  'prod_whatsapp_business': const EnrichedProduct(
    productName: 'Airtel WhatsApp Business',
    whatItIs:
        'An enterprise WhatsApp API solution converting messaging into a secure, automated customer engagement channel.',
    whenToPitch:
        'Pitch when marketing campaigns face low SMS open rates or support teams are overwhelmed by routine queries.',
    openingHook:
        'How are you shifting your customer interactions from traditional SMS to the channels they prefer?',
    positioningStatement:
        'Position WhatsApp API as a conversion engine that transforms marketing into interactive sales immediately.',
    whenNotToPitch: [
      'Customer only sends a few messages a month (use standard WhatsApp app).',
      'Customer audience is not active on WhatsApp.',
      'Customer refuses to invest in any chatbot orchestration logic.',
    ],
    category: 'Customer Engagement',
    pitchDifficulty: 'Easy',
    primaryUseCase: 'Automated conversational marketing and customer support',
    fiveThingsToRemember: [
      'Transforms one-way SMS blasts into interactive conversations',
      'Deflects routine support queries via intelligent bots',
      'High ROI justifies the higher per-message cost vs SMS',
      'Verified Green Tick builds immense brand trust',
      'Out-of-the-box CRM integrations bypass heavy developer work',
    ],
    officialFeaturesAndBenefits: {
      'Create customized campaigns': [
        'Boost your ROI with curated campaigns designed for better impact.',
        'Deliver personalized ad creatives that resonate with millions of customers in no time.',
      ],
      'Automated conversational marketing': [
        'Create customized campaigns that speak directly to your audience.',
      ],
      'Secure messaging experiences': [
        'Immediate and secure messaging experiences that effortlessly cater to your customers needs.',
      ],
    },
    technicalCapabilities: ['WhatsApp Business API integration'],
    deploymentModels: ['Cloud API'],
    integrations: ['Airtel IQ'],
    keyDifferentiators: [
      'Direct Meta partnership ensures high message throughput',
      'Pre-built bot templates and Campaign Manager portal',
      'Out-of-the-box CRM integrations (Salesforce, Zoho, etc.)',
      'Seamless upgrade path to Airtel CCaaS',
    ],
    customerSignals: [
      'Marketing complaining about poor engagement from SMS blasts',
      'Support queues overflowing with repetitive questions',
      'E-commerce brands suffering from high cart abandonment',
    ],
    businessOutcomes: [
      'Boost campaign ROI through rich media messaging',
      'Reduce customer support costs by deflecting routine queries',
      'Build trust with a verified business Green Tick profile',
    ],
    discoveryHooks: [
      'What are the open rates for your standard SMS marketing campaigns?',
      'How much time is spent answering routine order status queries?',
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Spam: "Customers hate marketing messages on WhatsApp."',
        response:
            'WhatsApp enforces strict quality limits to prevent spam, ensuring messages reach an engaged audience for higher conversion.',
      ),
      ObjectionHandling(
        objection: 'Implementation: "Integrating a bot sounds complex."',
        response:
            'Airtel IQ provides out-of-the-box integrations with CRMs and a Campaign Manager portal without heavy developer reliance.',
      ),
      ObjectionHandling(
        objection: 'Cost: "WhatsApp messages cost more than standard SMS."',
        response:
            'The per-message cost is higher, but near-100% open rates and interactive buttons drive ROI and lower acquisition costs.',
      ),
    ],
    crossSellProducts: ['Airtel CPaaS', 'Airtel Contact Center as a Service'],
    idealIndustries: [
      'Retail',
      'E-Commerce',
      'Banking & Financial Services',
      'Travel & Tourism',
    ],
    officialSourceUrls: ['PRODUCTS.docx (WHATSAPP API section)'],
    verificationStatus: 'Fully Verified',
  ),
};
