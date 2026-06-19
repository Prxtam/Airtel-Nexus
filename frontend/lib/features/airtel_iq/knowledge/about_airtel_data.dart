// About Airtel (Enterprise Handbook) Repository
// Single source of truth for the Airtel Company Encyclopedia.
// Only contains verified, official information. No AI generation.

// ─── Data Models ─────────────────────────────────────────────────────────────

class AirtelChapter {
  final String title;
  final String summary;
  final List<String> highlights;
  final List<AirtelSubChapter> subChapters;
  final String enterpriseSignificance;

  const AirtelChapter({
    required this.title,
    required this.summary,
    required this.highlights,
    required this.subChapters,
    required this.enterpriseSignificance,
  });
}

class AirtelSubChapter {
  final String title;
  final String content;

  const AirtelSubChapter({required this.title, required this.content});
}

class EcosystemCategory {
  final String name;
  final String summary;
  final String whatItIs;
  final String whyEnterprisesNeedIt;
  final String howAirtelSolvesIt;
  final List<String> products;

  const EcosystemCategory({
    required this.name,
    required this.summary,
    required this.whatItIs,
    required this.whyEnterprisesNeedIt,
    required this.howAirtelSolvesIt,
    required this.products,
  });
}

class AirtelPartnership {
  final String name;
  final String summary;
  final String whyPartnered;
  final String whatItSolves;
  final String whatAirtelGained;
  final String whatCustomersGained;

  const AirtelPartnership({
    required this.name,
    required this.summary,
    required this.whyPartnered,
    required this.whatItSolves,
    required this.whatAirtelGained,
    required this.whatCustomersGained,
  });
}

class AirtelMilestone {
  final String year;
  final String title;
  final String summary;
  final String whatHappened;
  final String whyImportant;
  final String impact;

  const AirtelMilestone({
    required this.year,
    required this.title,
    required this.summary,
    required this.whatHappened,
    required this.whyImportant,
    required this.impact,
  });
}

class DidYouKnowFact {
  final String fact;
  final String detail;

  const DidYouKnowFact({required this.fact, required this.detail});
}

// ─── Static Data Repository ──────────────────────────────────────────────────

class AboutAirtelData {
  static const AirtelChapter theAirtelStory = AirtelChapter(
    title: 'The Airtel Story',
    summary:
        'The journey from a single-city mobile operator to a global technology leader.',
    highlights: [
      'Founded in 1995 by Sunil Bharti Mittal',
      'Pioneered the "minutes factory" low-cost model',
      'Expanded across 17 countries',
    ],
    enterpriseSignificance:
        'Understanding Airtel\'s roots demonstrates our long-term commitment to innovation, scaling infrastructure rapidly, and our proven ability to disrupt markets to deliver exceptional value. This entrepreneurial DNA drives our B2B solutions today.',
    subChapters: [
      AirtelSubChapter(
        title: 'The Beginning',
        content:
            'Sunil Bharti Mittal\'s entrepreneurial journey began in 1976. By 1995, Bharti Cellular Limited was incorporated, launching mobile services in Delhi under the brand name "Airtel". This marked the beginning of a telecom revolution in India.',
      ),
      AirtelSubChapter(
        title: 'Making Mobile Accessible to India',
        content:
            'Airtel revolutionized the industry by pioneering the "minutes factory" model. By outsourcing IT and network operations to global partners like IBM and Ericsson, Airtel drastically reduced costs, making mobile telephony affordable and accessible to the masses across India.',
      ),
      AirtelSubChapter(
        title: 'The Expansion Era',
        content:
            'Throughout the 2000s, Airtel aggressively expanded its spectrum and national footprint. It introduced India\'s first 4G services and established itself as the undisputed market leader in domestic cellular connectivity.',
      ),
      AirtelSubChapter(
        title: 'Going Global',
        content:
            'In 2010, Airtel acquired Zain Africa in a landmark \$10.7 billion deal. This bold move established a massive footprint across the African continent, making Airtel a truly global telecommunications operator spanning 17 countries.',
      ),
      AirtelSubChapter(
        title: 'The Rise of Airtel Business',
        content:
            'Airtel Business was formally unified to serve enterprise clients. Recognizing that businesses needed more than just connectivity, Airtel invested heavily in B2B infrastructure, launching Nxtra data centers and secure enterprise networks.',
      ),
    ],
  );

  static const AirtelChapter airtelToday = AirtelChapter(
    title: 'Airtel Today',
    summary:
        'A snapshot of Bharti Airtel\'s current massive scale, focus, and digital direction.',
    highlights: [
      '650M+ customers globally',
      'Operating in 17 countries',
      'Leading B2B provider in India',
      'Massive shift to AI and Cloud',
    ],
    enterpriseSignificance:
        'Airtel\'s massive global scale gives us unparalleled buying power, data insights, and infrastructure resilience. When an enterprise partners with Airtel, they are backed by the financial stability and technological might of one of the world\'s largest telecom groups.',
    subChapters: [
      AirtelSubChapter(
        title: 'What Airtel Is Today',
        content:
            'Airtel is no longer just a telecom operator; it is a full-stack digital technology company. We provide comprehensive communication, connectivity, and digital infrastructure solutions across the globe.',
      ),
      AirtelSubChapter(
        title: 'Consumer Business Scale',
        content:
            'With over 650 million customers globally, our consumer business forms a massive foundation of network scale and data insights, enabling us to continuously upgrade our domestic and international networks.',
      ),
      AirtelSubChapter(
        title: 'Airtel Business',
        content:
            'As the leading B2B connectivity provider in India, Airtel Business serves over a million enterprises, including 80% of India’s top companies, delivering everything from MPLS to sovereign cloud and CPaaS.',
      ),
      AirtelSubChapter(
        title: 'Africa Operations',
        content:
            'Airtel Africa is a major pan-African operator, providing mobile voice, data, and financial services across 14 countries. We are rapidly expanding our fiber and data center footprint across the continent to support Africa\'s digital economy.',
      ),
      AirtelSubChapter(
        title: 'Digital Infrastructure Focus',
        content:
            'Through Nxtra by Airtel, we are building the largest network of hyper-scale and edge data centers in India and Africa, preparing for the exponential growth in cloud and data residency requirements.',
      ),
      AirtelSubChapter(
        title: 'AI, Cloud, Cybersecurity, and IoT',
        content:
            'Airtel is aggressively pivoting into next-generation technologies. We are launching mega AI hubs, unified Zero Trust cybersecurity platforms, and managing over 20 million connected IoT devices, positioning ourselves as the ultimate digital transformation partner.',
      ),
    ],
  );

  static const AirtelChapter globalPresence = AirtelChapter(
    title: 'Global Presence & Network',
    summary:
        'Our unparalleled terrestrial and subsea network spanning five continents.',
    highlights: [
      '5 Continents connected',
      '50+ Countries reached',
      '400,000+ km terrestrial fiber',
      '34+ subsea cable systems',
    ],
    enterpriseSignificance:
        'For global enterprises and hyperscalers, our subsea and terrestrial network provides unmatched route diversity and low-latency data transit. We bypass high-risk regions to ensure mission-critical data takes the fastest, safest route possible.',
    subChapters: [
      AirtelSubChapter(
        title: 'International Subsea Network',
        content:
            'Airtel operates one of the largest undersea cable portfolios globally, with investments in 34+ major submarine systems including SEA-ME-WE 6, 2Africa, EIG, and i2i. These cables provide essential high-capacity, low-latency data paths that underpin global internet traffic.',
      ),
      AirtelSubChapter(
        title: 'Terrestrial Fiber Backbone',
        content:
            'Our domestic terrestrial fiber network spans over 400,000 route kilometers. This extensive grid acts as the "veins" connecting inland cities, business parks, and edge data centers directly to the "arteries" of our international subsea systems at our Cable Landing Stations.',
      ),
      AirtelSubChapter(
        title: 'African Footprint Expansion',
        content:
            'In Africa, we have deployed over 71,000+ km of terrestrial fiber. We are actively building cross-border fiber routes to connect East and West Africa, providing critical digital gateways for landlocked nations.',
      ),
    ],
  );

  static const AirtelChapter whyCustomersChooseAirtel = AirtelChapter(
    title: 'Why Customers Choose Airtel',
    summary:
        'The definitive reasons why India\'s largest enterprises trust our infrastructure.',
    highlights: [
      'End-to-End Ownership',
      'SLA-Backed Reliability',
      'Massive Route Diversity',
      'Deep B2B Expertise',
    ],
    enterpriseSignificance:
        'These differentiators are the core pillars of our value proposition. When an enterprise evaluates vendors, Airtel stands out as the only partner capable of delivering true end-to-end SLA guarantees across the entire digital stack.',
    subChapters: [
      AirtelSubChapter(
        title: 'End-to-End Control',
        content:
            'Unlike aggregators, we own the underlying infrastructure. From the enterprise edge device, through our domestic fiber, into our Nxtra data centers, and across our subsea cables, we provide seamless integration without relying on third-party backbones.',
      ),
      AirtelSubChapter(
        title: 'Route Diversity & Redundancy',
        content:
            'Our strategic subsea network is deliberately designed to bypass congested hubs and high-risk regions. We offer multiple redundant paths, ensuring safe and uninterrupted data transit even during massive regional outages.',
      ),
      AirtelSubChapter(
        title: 'Scale & Reliability',
        content:
            'We provide strict SLA-backed performance that powers the mission-critical operations of India’s largest banks, manufacturing hubs, and government agencies. Our network is battle-tested at an enormous scale.',
      ),
      AirtelSubChapter(
        title: 'Deep Domain Expertise',
        content:
            'With decades of telecom operations, our dedicated B2B account management and technical solution architects possess deep industry knowledge. We don\'t just sell products; we co-create digital transformation strategies.',
      ),
    ],
  );

  static const List<EcosystemCategory> businessEcosystem = [
    EcosystemCategory(
      name: 'Connectivity',
      summary:
          'The resilient, high-speed foundation for modern enterprise operations.',
      whatItIs:
          'A comprehensive suite of secure data connectivity solutions, ranging from dedicated private networks to software-defined branch routing.',
      whyEnterprisesNeedIt:
          'As applications move to the cloud, legacy networks become bottlenecks. Enterprises require agile, secure, and highly reliable connectivity to maintain productivity and connect distributed workforces.',
      howAirtelSolvesIt:
          'We deliver SLA-backed MPLS, scalable SD-WAN with intelligent routing, and dedicated Internet leased lines, all powered by our robust 400,000+ km fiber backbone.',
      products: [
        'Airtel VPN/MPLS',
        'Airtel Dedicated Internet (ILL)',
        'Airtel SD-WAN',
        'Airtel Managed Wi-Fi',
      ],
    ),
    EcosystemCategory(
      name: 'Cloud & Infrastructure',
      summary:
          'Scalable data centers and hybrid cloud environments for mission-critical workloads.',
      whatItIs:
          'Enterprise-grade cloud hosting, sovereign cloud solutions, and physical colocation services delivered through our Nxtra data centers.',
      whyEnterprisesNeedIt:
          'Enterprises need to modernize their infrastructure without compromising data residency, security, or capital expenditure. They require reliable environments to host applications and store data.',
      howAirtelSolvesIt:
          'Through Nxtra, we offer India\'s largest network of hyper-scale data centers. We provide hybrid cloud environments and sovereign cloud solutions that guarantee data localization and compliance with stringent BFSI regulations.',
      products: ['Airtel Public Cloud', 'Airtel Colocation (Nxtra)'],
    ),
    EcosystemCategory(
      name: 'Cybersecurity',
      summary:
          'Unified, intelligence-driven protection for the hybrid enterprise.',
      whatItIs:
          'Airtel Secure is a multi-layered security portfolio offering Zero Trust Network Access (ZTNA), Web Application Protection, and Managed Security Services.',
      whyEnterprisesNeedIt:
          'The traditional perimeter is dead. With remote work and cloud adoption, enterprises face sophisticated cyber threats and require comprehensive protection across all endpoints and networks.',
      howAirtelSolvesIt:
          'We integrate advanced security directly into the network layer. Our 24/7 Secure Intelligence Centre provides automated incident response and threat mitigation, simplifying security operations for the enterprise.',
      products: ['Airtel Secure Internet'],
    ),
    EcosystemCategory(
      name: 'Customer Engagement',
      summary:
          'Omnichannel communication platforms to transform customer experiences.',
      whatItIs:
          'Airtel IQ is our flagship Communications Platform as a Service (CPaaS), unifying Voice, SMS, WhatsApp, and Contact Center operations.',
      whyEnterprisesNeedIt:
          'Customers demand seamless, personalized interactions across multiple channels. Businesses struggle to integrate disjointed communication tools into their core CRM and applications.',
      howAirtelSolvesIt:
          'Airtel IQ embeds communications directly into enterprise applications via APIs. We eliminate the need for complex hardware, offering a cloud-native platform that scales instantly to handle millions of interactions.',
      products: [
        'Airtel IQ Business Connect',
        'Airtel WhatsApp Business',
        'Airtel Contact Center as a Service',
        'Airtel SIP Trunking',
        'Airtel CPaaS',
        'Airtel Corporate Postpaid',
      ],
    ),
    EcosystemCategory(
      name: 'IoT & 5G',
      summary:
          'Intelligent connectivity powering the next industrial revolution.',
      whatItIs:
          'Dedicated cellular IoT connectivity and management platforms, alongside private 5G networks for high-bandwidth automation.',
      whyEnterprisesNeedIt:
          'Industries like manufacturing and logistics require real-time visibility and automation across thousands of remote assets, demanding specialized, low-power, wide-area networks.',
      howAirtelSolvesIt:
          'We provide dedicated IoT SIMs managed through a centralized IoT Hub, supporting over 20 million connected devices. Our solutions power smart metering, fleet tracking, and edge automation.',
      products: [
        'Airtel IoT Connectivity',
        'Airtel Work From Anywhere Solutions',
      ],
    ),
  ];

  static const List<AirtelPartnership> strategicPartnerships = [
    AirtelPartnership(
      name: 'IBM',
      summary: 'Augmenting Airtel Cloud with AI-ready infrastructure.',
      whyPartnered:
          'To strengthen our sovereign cloud offerings and provide enterprises with advanced hybrid cloud capabilities.',
      whatItSolves:
          'Enterprises in regulated industries (BFSI, Government) struggle to adopt AI and modern cloud architectures due to strict data residency and security compliance laws.',
      whatAirtelGained:
          'Access to IBM Power11 servers and advanced AI tooling, significantly elevating the technical capabilities of Airtel Cloud.',
      whatCustomersGained:
          'The ability to migrate mission-critical, complex workloads to a secure, localized cloud environment as-a-Service, accelerating their AI readiness.',
    ),
    AirtelPartnership(
      name: 'Google',
      summary: 'Establishing India\'s first mega AI hub and data center.',
      whyPartnered:
          'To build the physical and digital infrastructure required to support massive, gigawatt-scale AI workloads in India.',
      whatItSolves:
          'The immense compute and low-latency connectivity bottleneck currently restricting the widespread adoption of generative AI at an enterprise scale.',
      whatAirtelGained:
          'A massive long-term investment (2026-2030) to establish a state-of-the-art Cable Landing Station and hyperscale facility in Visakhapatnam.',
      whatCustomersGained:
          'Future-proof access to gigawatt-scale AI computing power and localized Google Cloud services, backed by Airtel\'s unmatched network reliability.',
    ),
    AirtelPartnership(
      name: 'Fortinet',
      summary: 'Powering the Airtel Secure Internet offering.',
      whyPartnered:
          'To integrate world-class, enterprise-grade firewall and security capabilities directly into our connectivity products.',
      whatItSolves:
          'The complexity and high capital expenditure enterprises face when trying to build, manage, and maintain their own network security perimeters.',
      whatAirtelGained:
          'Industry-leading threat intelligence and unified threat management technology embedded into our core network.',
      whatCustomersGained:
          'Airtel Secure Internet provides a simplified, managed, and unified Zero Trust architecture, drastically reducing their cybersecurity risk with zero hardware maintenance.',
    ),
    AirtelPartnership(
      name: 'Vonage',
      summary:
          'Delivering unified communications via Airtel IQ Business Connect.',
      whyPartnered:
          'To accelerate the development of cloud-native communication applications tailored for enterprise workforces.',
      whatItSolves:
          'The fragmented nature of enterprise communications, where voice, messaging, and video exist in disparate silos, hindering productivity.',
      whatAirtelGained:
          'Vonage\'s deep expertise in cloud communications and APIs, enriching the Airtel IQ CPaaS portfolio.',
      whatCustomersGained:
          'Access to a unified, secure, multi-channel communication platform that integrates seamlessly with existing enterprise workflows.',
    ),
    AirtelPartnership(
      name: 'Swift Navigation',
      summary: 'Launching Airtel-Skylark for precise AI/ML positioning.',
      whyPartnered:
          'To unlock next-generation spatial precision capabilities over our nationwide cellular network.',
      whatItSolves:
          'Standard GNSS (GPS) is inaccurate by several meters, which is unacceptable for mission-critical use cases like autonomous vehicles, drone navigation, and automated tolling.',
      whatAirtelGained:
          'Exclusive deployment of the Skylark precise positioning network across India\'s cellular infrastructure.',
      whatCustomersGained:
          'Centimeter-level location accuracy (up to 100x better than standard GPS) delivered seamlessly over the cloud, enabling new autonomous enterprise operations.',
    ),
  ];

  static const List<AirtelMilestone> keyMilestones = [
    AirtelMilestone(
      year: '1995',
      title: 'Foundation',
      summary: 'Bharti Cellular Limited is incorporated.',
      whatHappened:
          'Sunil Bharti Mittal incorporates Bharti Cellular Limited on July 7, 1995, launching mobile cellular services in Delhi under the brand name "Airtel".',
      whyImportant:
          'This marked the group\'s formal entry into the telecommunications service sector, transitioning from hardware manufacturing to network operations.',
      impact:
          'It laid the foundation for the cellular revolution in India, establishing the Airtel brand as synonymous with mobile connectivity.',
    ),
    AirtelMilestone(
      year: '2001',
      title: 'National & ILD Expansion',
      summary:
          'Airtel launches National Long Distance and International Long Distance operations.',
      whatHappened:
          'Airtel successfully launched National Long Distance (NLD) services and initiated international operations via the i2i submarine cable.',
      whyImportant:
          'It transformed Airtel from a regional mobile operator into a comprehensive national and international connectivity provider.',
      impact:
          'Significantly reduced long-distance call costs and built the core backbone infrastructure that Airtel Business relies on today.',
    ),
    AirtelMilestone(
      year: '2004',
      title: 'Landmark IT Outsourcing',
      summary: 'Airtel executes a strategic IT outsourcing deal with IBM.',
      whatHappened:
          'In an unprecedented move for the telecom industry, Airtel outsourced its entire IT and network infrastructure management to IBM and Ericsson.',
      whyImportant:
          'It introduced the "minutes factory" model, allowing Airtel to convert fixed capital expenditure into variable operational expenditure.',
      impact:
          'Enabled Airtel to focus purely on marketing, sales, and customer experience, driving massive scalable growth and reshaping global telco business models.',
    ),
    AirtelMilestone(
      year: '2010',
      title: 'Going Global: Zain Africa',
      summary: 'Airtel acquires Zain Africa for \$10.7 Billion.',
      whatHappened:
          'Airtel completed the acquisition of Zain\'s mobile operations across 15 African countries.',
      whyImportant:
          'It was the largest ever cross-border telecom acquisition by an Indian company at the time, establishing Airtel as a truly global operator.',
      impact:
          'Expanded Airtel\'s footprint across the African continent, making it one of the top five mobile operators in the world by subscriber base.',
    ),
    AirtelMilestone(
      year: '2013',
      title: 'Establishment of Nxtra',
      summary:
          'Airtel spins off its data center business into Nxtra Data Limited.',
      whatHappened:
          'Recognizing the shift toward cloud computing, Airtel established Nxtra as a wholly-owned subsidiary focused on Data Center and Managed Services.',
      whyImportant:
          'It separated the specialized data center operations from core telecom, allowing for focused investment and rapid infrastructure scaling.',
      impact:
          'Positioned Airtel to capitalize on India\'s massive data localization and cloud boom, eventually becoming the largest network of hyper-scale facilities in the country.',
    ),
    AirtelMilestone(
      year: '2020',
      title: 'B2B Revenue Milestone',
      summary: 'Airtel Business crosses \$2 Billion in revenue.',
      whatHappened:
          'Airtel Business officially surpassed the \$2 billion revenue mark, solidifying its position as India\'s leading B2B connectivity provider.',
      whyImportant:
          'It proved the success of Airtel\'s transition from a consumer-only telco to an enterprise digital transformation partner.',
      impact:
          'Accelerated investments into enterprise-specific portfolios like Airtel IQ (CPaaS), Airtel Secure, and dedicated IoT platforms.',
    ),
  ];

  static const List<DidYouKnowFact> didYouKnow = [
    DidYouKnowFact(
      fact:
          'Airtel operates one of the world\'s largest integrated telecom networks.',
      detail:
          'Our network architecture seamlessly connects deep domestic terrestrial fiber with massive international subsea capacity, entirely managed by a single entity.',
    ),
    DidYouKnowFact(
      fact: 'Airtel owns investments in 34+ submarine cable systems.',
      detail:
          'This includes massive capacity on the SEA-ME-WE 6 and 2Africa cables, ensuring global enterprises have diverse, low-latency routes bypassing global chokepoints.',
    ),
    DidYouKnowFact(
      fact: 'Airtel Business serves 80% of India\'s top enterprises.',
      detail:
          'From the largest banks to massive manufacturing hubs, Airtel provides the critical SLA-backed digital infrastructure powering the Indian economy.',
    ),
    DidYouKnowFact(
      fact: 'Airtel was the first to launch 4G and 5G in India.',
      detail:
          'Airtel has a consistent history of pioneering network technologies, launching India\'s first 4G network in 2012 and aggressively deploying 5G enterprise networks today.',
    ),
    DidYouKnowFact(
      fact: 'Airtel manages over 20 million IoT devices.',
      detail:
          'Airtel is a dominant force in cellular IoT, powering everything from smart electricity meters to connected vehicles across the subcontinent.',
    ),
  ];
}
