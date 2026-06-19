// Phase 9.1 – Airtel Knowledge Hub
// Static resource data for the Resources section.
// Three lightweight reference categories — no engines, no repos, no scoring.

// ─── Terminologies ────────────────────────────────────────────────────────────

class HubTerminology {
  final String term;
  final String definition;
  final List<String> relatedProductNames;

  const HubTerminology({
    required this.term,
    required this.definition,
    this.relatedProductNames = const [],
  });
}

const List<HubTerminology> hubTerminologies = [
  HubTerminology(
    term: 'SD-WAN',
    definition:
        'Software-Defined Wide Area Network — centrally managed overlay network that routes traffic intelligently across multiple links (MPLS, broadband, LTE).',
    relatedProductNames: ['Airtel SD-WAN'],
  ),
  HubTerminology(
    term: 'SIP Trunking',
    definition:
        'Session Initiation Protocol Trunking — delivers enterprise voice calls over an IP network, replacing traditional PRI/ISDN lines at lower cost.',
    relatedProductNames: ['Airtel SIP Trunking'],
  ),
  HubTerminology(
    term: 'CCaaS',
    definition:
        'Contact Center as a Service — cloud-hosted contact center with routing, IVR, agent management, and CRM integration delivered as a managed service.',
    relatedProductNames: ['Airtel Contact Center as a Service'],
  ),
  HubTerminology(
    term: 'CPaaS',
    definition:
        'Communications Platform as a Service — API-based platform for embedding voice, SMS, and messaging into business applications.',
    relatedProductNames: ['Airtel CPaaS', 'Airtel IQ Business Connect'],
  ),
  HubTerminology(
    term: 'Private APN',
    definition:
        'A dedicated cellular gateway for enterprise IoT devices that keeps traffic isolated from the public internet on a private IP range.',
    relatedProductNames: ['Airtel IoT Connectivity'],
  ),
  HubTerminology(
    term: 'Data Sovereignty',
    definition:
        'The principle that data is subject to the laws of the country in which it resides. Critical for banking, healthcare, and government sectors in India (DPDP Act).',
    relatedProductNames: ['Airtel Public Cloud', 'Airtel Colocation (Nxtra)'],
  ),
  HubTerminology(
    term: 'Clean Pipe Security',
    definition:
        'Airtel\'s network-layer DDoS scrubbing service that filters malicious traffic before it reaches the customer\'s network infrastructure.',
    relatedProductNames: ['Airtel Secure Internet'],
  ),
  HubTerminology(
    term: 'ZTNA',
    definition:
        'Zero Trust Network Access — a security model that verifies every user and device before granting access, replacing traditional VPN-perimeter models.',
    relatedProductNames: ['Airtel Secure Internet', 'Airtel VPN/MPLS'],
  ),
  HubTerminology(
    term: 'ILL',
    definition:
        'Internet Leased Line — a dedicated, symmetrical internet connection with guaranteed SLA-backed bandwidth, typically used for business-critical applications.',
    relatedProductNames: ['Airtel Dedicated Internet (ILL)'],
  ),
  HubTerminology(
    term: 'MPLS',
    definition:
        'Multiprotocol Label Switching — a private WAN technology that routes traffic between enterprise sites with predictable latency and quality of service (QoS).',
    relatedProductNames: ['Airtel VPN/MPLS', 'Airtel SD-WAN'],
  ),
  HubTerminology(
    term: 'NB-IoT',
    definition:
        'Narrowband IoT — a low-power cellular standard for connecting large volumes of sensors and meters that transmit small amounts of data infrequently.',
    relatedProductNames: ['Airtel IoT Connectivity'],
  ),
  HubTerminology(
    term: 'Colocation',
    definition:
        'A service where enterprises house their servers in a third-party data center (Nxtra), gaining power, cooling, physical security, and connectivity without building their own facility.',
    relatedProductNames: ['Airtel Colocation (Nxtra)'],
  ),
  HubTerminology(
    term: 'DLT',
    definition:
        'Distributed Ledger Technology — TRAI\'s mandatory blockchain-based platform for registering entities, headers, and templates for A2P commercial SMS in India.',
    relatedProductNames: ['Airtel CPaaS', 'Airtel IQ Business Connect'],
  ),
  HubTerminology(
    term: 'DPDP Act',
    definition:
        'Digital Personal Data Protection Act 2023 — India\'s primary data privacy legislation governing how personal data of Indian citizens must be collected, stored, and processed.',
    relatedProductNames: ['Airtel Public Cloud', 'Airtel Colocation (Nxtra)'],
  ),
  HubTerminology(
    term: 'AIS-140',
    definition:
        'Ministry of Road Transport mandate requiring GPS and emergency alert devices in all commercial vehicles in India — a key driver for automotive IoT connectivity.',
    relatedProductNames: ['Airtel IoT Connectivity'],
  ),
];

// ─── Meeting Types ────────────────────────────────────────────────────────────

class HubMeetingType {
  final String name;
  final String description;
  final String purpose;

  const HubMeetingType({
    required this.name,
    required this.description,
    required this.purpose,
  });
}

const List<HubMeetingType> hubMeetingTypes = [
  HubMeetingType(
    name: 'Discovery Meeting',
    description:
        'First substantive conversation with the prospect to understand their business, priorities, and technology landscape.',
    purpose:
        'Qualify the opportunity and map customer pain points to Airtel solutions.',
  ),
  HubMeetingType(
    name: 'Technical Workshop',
    description:
        'Deep-dive session with the customer\'s IT/infrastructure team to validate technical requirements and architecture fit.',
    purpose:
        'Confirm technical feasibility and remove objections before proposal stage.',
  ),
  HubMeetingType(
    name: 'Proposal Presentation',
    description:
        'Structured meeting to present the formal commercial and technical solution proposal to decision-makers.',
    purpose:
        'Align on solution scope, commercial terms, and move toward a decision.',
  ),
  HubMeetingType(
    name: 'Executive Alignment',
    description:
        'C-suite or senior leadership meeting focused on business outcomes, strategic fit, and executive sponsorship.',
    purpose:
        'Secure executive buy-in and accelerate stalled or large-ticket deals.',
  ),
  HubMeetingType(
    name: 'Proof of Concept Review',
    description:
        'Post-pilot session reviewing PoC results, performance metrics, and addressing outstanding concerns.',
    purpose:
        'Validate solution performance and convert a trial into a committed order.',
  ),
  HubMeetingType(
    name: 'Renewal Discussion',
    description:
        'Proactive meeting with an existing customer ahead of contract expiry to review service performance and explore expansion.',
    purpose:
        'Secure renewal, prevent churn, and identify upsell opportunities.',
  ),
  HubMeetingType(
    name: 'QBR (Quarterly Business Review)',
    description:
        'Structured review with existing customers covering SLA performance, roadmap, and strategic alignment.',
    purpose:
        'Strengthen the relationship, surface expansion opportunities, and reinforce Airtel value.',
  ),
];

// ─── Quick Reference Guides ───────────────────────────────────────────────────

class HubQuickRef {
  final String trigger;
  final String solution;
  final String category;

  const HubQuickRef({
    required this.trigger,
    required this.solution,
    required this.category,
  });
}

const List<HubQuickRef> hubQuickRefs = [
  // Cross-sell triggers
  HubQuickRef(
    trigger: 'Customer expanding branch network',
    solution: 'Airtel SD-WAN',
    category: 'Cross-Sell Trigger',
  ),
  HubQuickRef(
    trigger: 'Cloud migration conversations',
    solution: 'Airtel Public Cloud / Colocation (Nxtra)',
    category: 'Cross-Sell Trigger',
  ),
  HubQuickRef(
    trigger: 'Remote or distributed workforce',
    solution: 'Airtel Work From Anywhere Solutions',
    category: 'Cross-Sell Trigger',
  ),
  HubQuickRef(
    trigger: 'Fleet management or asset tracking',
    solution: 'Airtel IoT Connectivity',
    category: 'Cross-Sell Trigger',
  ),
  HubQuickRef(
    trigger: 'High OTP/transactional SMS volumes',
    solution: 'Airtel CPaaS / IQ Business Connect',
    category: 'Cross-Sell Trigger',
  ),
  HubQuickRef(
    trigger: 'Legacy PBX replacement discussion',
    solution: 'Airtel SIP Trunking / CCaaS',
    category: 'Cross-Sell Trigger',
  ),
  HubQuickRef(
    trigger: 'DDoS attack or security incident',
    solution: 'Airtel Secure Internet',
    category: 'Cross-Sell Trigger',
  ),
  HubQuickRef(
    trigger: 'Customer WhatsApp for customer service',
    solution: 'Airtel WhatsApp Business',
    category: 'Cross-Sell Trigger',
  ),
  // SME involvement
  HubQuickRef(
    trigger: 'Private 5G or Industry 4.0 discussion',
    solution: 'Involve Airtel 5G Solutions SME',
    category: 'Involve SME',
  ),
  HubQuickRef(
    trigger: 'Data center or sovereign cloud requirements',
    solution: 'Involve Nxtra / Cloud SME',
    category: 'Involve SME',
  ),
  HubQuickRef(
    trigger: 'Large-scale IoT deployment (1,000+ devices)',
    solution: 'Involve Airtel IoT Solutions Architect',
    category: 'Involve SME',
  ),
  HubQuickRef(
    trigger: 'Enterprise security or SOC requirements',
    solution: 'Involve Airtel Cybersecurity SME',
    category: 'Involve SME',
  ),
];
