import 'package:frontend/features/airtel_iq/models/product_enablement_model.dart';

class ProductEnablementRepository {
  static const List<ProductEnablement> enablements = [
    ProductEnablement(
      productName: 'Airtel Public Cloud',
      positionItAs: 'Position Airtel Public Cloud as a compliance-first cloud strategy rather than a replacement for AWS or Azure. Emphasize data sovereignty, regulatory alignment, and reducing complexity for regulated workloads.',
      questionsToAsk: [
        'Where are your regulated workloads currently hosted?',
        'Are data residency requirements slowing down your cloud adoption?',
        'Is managing multiple cloud vendors increasing operational complexity?'
      ],
      businessValue: [
        'Reduce compliance and regulatory risk.',
        'Accelerate cloud adoption without disrupting existing systems.',
        'Reduce infrastructure management overhead.'
      ],
      crossSellOpportunities: [
        'Airtel Colocation (Nxtra)',
        'Airtel Secure Internet'
      ],
    ),
    ProductEnablement(
      productName: 'Airtel Colocation (Nxtra)',
      positionItAs: 'Position Nxtra as the foundational infrastructure layer that eliminates unpredictable CapEx while ensuring maximum uptime and green compliance. Frame it as the bridge between legacy on-premise hardware and full cloud migration.',
      questionsToAsk: [
        'How is your data center strategy adapting to rising energy costs and sustainability goals?',
        'When is your next major server or hardware refresh cycle?',
        'How do you currently ensure disaster recovery across geographically isolated sites?'
      ],
      businessValue: [
        'Eliminate unpredictable infrastructure CapEx.',
        'Ensure 99.99% operational uptime and business continuity.',
        'Meet enterprise sustainability and green energy mandates.'
      ],
      crossSellOpportunities: [
        'Airtel Public Cloud',
        'Airtel Dedicated Internet'
      ],
    ),
    ProductEnablement(
      productName: 'Airtel Secure Internet',
      positionItAs: 'Position Secure Internet as a proactive enterprise shield. Rather than just selling bandwidth, emphasize that it consolidates internet access and advanced threat protection into a single, managed SLA at the network edge.',
      questionsToAsk: [
        'How confident are you in your current edge security as your workforce becomes more distributed?',
        'Are you managing separate vendors for your firewall, threat protection, and internet leased lines?',
        'How quickly could your IT team isolate a ransomware attack originating from a remote branch?'
      ],
      businessValue: [
        'Consolidate security and connectivity into a single manageable SLA.',
        'Proactively block threats before they reach the corporate network.',
        'Reduce IT administrative burden regarding firewall maintenance.'
      ],
      crossSellOpportunities: [
        'Airtel SD-WAN',
        'Airtel VPN/MPLS'
      ],
    ),
    ProductEnablement(
      productName: 'Airtel SD-WAN',
      positionItAs: 'Position SD-WAN as an intelligent traffic router that ensures critical cloud applications never suffer from poor branch connectivity. Emphasize the shift from expensive rigid MPLS links to agile, cost-effective hybrid networks.',
      questionsToAsk: [
        'How are you currently managing the performance of cloud applications across your remote branches?',
        'Are rising MPLS bandwidth costs forcing you to compromise on branch network performance?',
        'How long does it currently take your team to provision secure connectivity for a new branch?'
      ],
      businessValue: [
        'Reduce total branch connectivity costs.',
        'Dramatically improve the performance of cloud and SaaS applications.',
        'Accelerate branch expansion with zero-touch provisioning.'
      ],
      crossSellOpportunities: [
        'Airtel Secure Internet',
        'Airtel Public Cloud'
      ],
    ),
    ProductEnablement(
      productName: 'Airtel VPN/MPLS',
      positionItAs: 'Position VPN/MPLS as the uncompromising, private backbone for mission-critical inter-branch data. It is the gold standard for zero-packet-loss communication and strict data privacy requirements.',
      questionsToAsk: [
        'For your core operational traffic, how do you guarantee zero-packet-loss communication?',
        'Are you experiencing latency issues when replicating data between your primary and disaster recovery sites?',
        'How are you ensuring absolute privacy for traffic moving between your manufacturing facilities and HQ?'
      ],
      businessValue: [
        'Guarantee network performance for mission-critical core operations.',
        'Ensure absolute data privacy bypassing the public internet.',
        'Support high-volume data replication with ultra-low latency.'
      ],
      crossSellOpportunities: [
        'Airtel Colocation (Nxtra)',
        'Airtel Secure Internet'
      ],
    ),
    ProductEnablement(
      productName: 'Airtel IoT Connectivity',
      positionItAs: 'Position IoT Connectivity not as SIM cards, but as a unified global platform that brings real-time visibility to distributed physical assets, turning blind spots into actionable operational data.',
      questionsToAsk: [
        'How much operational downtime are you experiencing because you lack real-time visibility into your physical assets?',
        'Are you currently managing multiple regional telecom vendors to track your national fleet?',
        'How are you transitioning from reactive repairs to predictive maintenance for your equipment?'
      ],
      businessValue: [
        'Turn physical assets into actionable data streams.',
        'Optimize fleet routes and reduce operational downtime.',
        'Simplify billing and management with a single global connectivity platform.'
      ],
      crossSellOpportunities: [
        'Airtel Precise Positioning',
        'Airtel 5G for Enterprise'
      ],
    ),
    ProductEnablement(
      productName: 'Airtel Precise Positioning',
      positionItAs: 'Position Precise Positioning as an enabler for high-value autonomous use cases. Highlight that standard GPS is insufficient for modern robotics, drone delivery, and pinpoint asset tracking.',
      questionsToAsk: [
        'Where is standard GPS inaccuracy currently costing your operations the most?',
        'How are you currently navigating autonomous vehicles or AGVs within your large facilities?',
        'What is your strategy for tracking high-value goods down to the centimeter level?'
      ],
      businessValue: [
        'Enable safe and accurate autonomous operations.',
        'Eliminate inefficiencies caused by location tracking errors.',
        'Provide a foundation for advanced Industry 4.0 applications.'
      ],
      crossSellOpportunities: [
        'Airtel IoT Connectivity',
        'Airtel 5G for Enterprise'
      ],
    ),
    ProductEnablement(
      productName: 'Airtel IQ Business Connect',
      positionItAs: 'Position IQ Business Connect as an intelligent omnichannel layer. It unifies customer engagement across voice, SMS, and WhatsApp without requiring a complete overhaul of their existing CRM or PBX.',
      questionsToAsk: [
        'What percentage of your customer communications are currently siloed across different vendor platforms?',
        'Are your agents struggling with context switching between voice calls and WhatsApp messages?',
        'How are you currently tracking communication compliance and quality assurance across channels?'
      ],
      businessValue: [
        'Unify customer engagement to reduce churn.',
        'Improve support efficiency and agent productivity.',
        'Ensure all customer communications are compliant and recorded.'
      ],
      crossSellOpportunities: [
        'Airtel Corporate Postpaid',
        'Airtel SD-WAN'
      ],
    ),
    ProductEnablement(
      productName: 'Airtel Corporate Postpaid',
      positionItAs: 'Position Corporate Postpaid as a centralized enterprise mobility solution. Focus on how it simplifies provisioning, enforces corporate security, and eliminates the administrative headache of employee reimbursements.',
      questionsToAsk: [
        'How much administrative overhead is your team spending managing individual employee telecom reimbursements?',
        'How do you enforce corporate data security policies on employee-owned mobile connections?',
        'Are you experiencing bill shock due to unmanaged data overages by your field workforce?'
      ],
      businessValue: [
        'Reduce telecom administrative overhead.',
        'Enforce consistent security policies across the mobile workforce.',
        'Predictable billing and elimination of expense report friction.'
      ],
      crossSellOpportunities: [
        'Airtel IQ Business Connect',
        'Airtel Work From Anywhere Solutions'
      ],
    ),
    ProductEnablement(
      productName: 'Airtel 5G for Enterprise',
      positionItAs: 'Position Private 5G as the high-bandwidth, ultra-low latency foundation for next-generation digital transformation. It replaces unreliable Wi-Fi in harsh environments to unlock autonomous operations and massive IoT scale.',
      questionsToAsk: [
        'Which of your digital initiatives are currently bottlenecked by existing Wi-Fi or wired constraints?',
        'Are you experiencing connectivity dropouts with moving assets like AGVs or robotic arms?',
        'How are you planning to handle the massive data ingestion required for real-time video analytics?'
      ],
      businessValue: [
        'Unlock autonomous operations and real-time robotics.',
        'Eliminate factory floor connectivity dead zones.',
        'Support massive IoT sensor density securely.'
      ],
      crossSellOpportunities: [
        'Airtel IoT Connectivity',
        'Airtel Precise Positioning'
      ],
    ),
  ];
}
