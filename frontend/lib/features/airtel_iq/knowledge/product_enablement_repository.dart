import 'package:frontend/features/airtel_iq/models/product_enablement_model.dart';

class ProductEnablementRepository {
  static const List<ProductEnablement> enablements = [
    ProductEnablement(
      productName: 'Airtel Public Cloud',
      positionItAs:
          'Position Airtel Public Cloud as a compliance-first cloud strategy rather than a replacement for AWS or Azure. Emphasize data sovereignty, regulatory alignment, and reducing complexity for regulated workloads.',
      questionsToAsk: [
        'Where are your regulated workloads currently hosted?',
        'Are data residency requirements slowing down your cloud adoption?',
        'Is managing multiple cloud vendors increasing operational complexity?',
      ],
      businessValue: [
        'Reduce compliance and regulatory risk.',
        'Accelerate cloud adoption without disrupting existing systems.',
        'Reduce infrastructure management overhead.',
      ],
      crossSellOpportunities: [
        'Airtel Colocation (Nxtra)',
        'Airtel Secure Internet',
      ],
    ),
    ProductEnablement(
      productName: 'Airtel Colocation (Nxtra)',
      positionItAs:
          'Position Nxtra as the foundational infrastructure layer that helps enterprises reduce infrastructure ownership burdens while improving resilience and compliance. Frame it as the bridge between legacy on-premise hardware and full cloud migration.',
      questionsToAsk: [
        'How is your data center strategy adapting to rising energy costs and sustainability goals?',
        'When is your next major server or hardware refresh cycle?',
        'How do you currently ensure disaster recovery across geographically isolated sites?',
      ],
      businessValue: [
        'Eliminate unpredictable infrastructure CapEx.',
        'Support business continuity with resilient, professionally managed infrastructure.',
        'Meet enterprise sustainability and green energy mandates.',
      ],
      crossSellOpportunities: [
        'Airtel Public Cloud',
        'Airtel Leased Line (ILL)',
      ],
    ),
    ProductEnablement(
      productName: 'Airtel Secure Internet',
      positionItAs:
          'Position Secure Internet as a proactive enterprise shield. Rather than just selling bandwidth, emphasize that it consolidates internet access and advanced threat protection into a single, managed SLA at the network edge.',
      questionsToAsk: [
        'How confident are you in your current edge security as your workforce becomes more distributed?',
        'Are you managing separate vendors for your firewall, threat protection, and internet leased lines?',
        'How quickly could your IT team isolate a ransomware attack originating from a remote branch?',
      ],
      businessValue: [
        'Consolidate security and connectivity into a single manageable SLA.',
        'Proactively block threats before they reach the corporate network.',
        'Reduce IT administrative burden regarding firewall maintenance.',
      ],
      crossSellOpportunities: ['Airtel SD-WAN', 'Airtel VPN/MPLS'],
    ),
    ProductEnablement(
      productName: 'Airtel SD-WAN',
      positionItAs:
          'Position SD-WAN as an intelligent traffic router that ensures critical cloud applications never suffer from poor branch connectivity. Emphasize the shift from expensive rigid MPLS links to agile, cost-effective hybrid networks.',
      questionsToAsk: [
        'How are you currently managing the performance of cloud applications across your remote branches?',
        'Are rising MPLS bandwidth costs forcing you to compromise on branch network performance?',
        'How long does it currently take your team to provision secure connectivity for a new branch?',
      ],
      businessValue: [
        'Reduce total branch connectivity costs.',
        'Dramatically improve the performance of cloud and SaaS applications.',
        'Accelerate branch expansion with simpler and more consistent provisioning.',
      ],
      crossSellOpportunities: ['Airtel Secure Internet', 'Airtel Public Cloud'],
    ),
    ProductEnablement(
      productName: 'Airtel VPN/MPLS',
      positionItAs:
          'Position VPN/MPLS as the uncompromising, private backbone for mission-critical inter-branch data. It is the gold standard for highly controlled communication and strict data privacy requirements.',
      questionsToAsk: [
        'For your core operational traffic, how do you guarantee predictable communication?',
        'Are you experiencing latency issues when replicating data between your primary and disaster recovery sites?',
        'How are you ensuring strong privacy for traffic moving between your manufacturing facilities and HQ?',
      ],
      businessValue: [
        'Guarantee network performance for mission-critical core operations.',
        'Ensure strong data privacy by bypassing the public internet.',
        'Support high-volume data replication with low latency.',
      ],
      crossSellOpportunities: [
        'Airtel Colocation (Nxtra)',
        'Airtel Secure Internet',
      ],
    ),
    ProductEnablement(
      productName: 'Airtel IoT Connectivity',
      positionItAs:
          'Position IoT Connectivity not as SIM cards, but as a unified platform that brings real-time visibility to distributed physical assets and turns blind spots into actionable operational data.',
      questionsToAsk: [
        'How much operational downtime are you experiencing because you lack real-time visibility into your physical assets?',
        'Are you currently managing multiple regional telecom vendors to track your national fleet?',
        'How are you transitioning from reactive repairs to predictive maintenance for your equipment?',
      ],
      businessValue: [
        'Turn physical assets into actionable data streams.',
        'Optimize fleet routes and reduce operational downtime.',
        'Simplify billing and management with a single connectivity platform.',
      ],
      crossSellOpportunities: [
        'Airtel Precise Positioning',
        'Airtel 5G for Enterprise',
      ],
    ),
    ProductEnablement(
      productName: 'Airtel Precise Positioning',
      positionItAs:
          'Position Precise Positioning as an enabler for high-value operational use cases. Highlight that standard GPS can be insufficient for modern robotics, drone delivery, and precise asset tracking.',
      questionsToAsk: [
        'Where is standard GPS inaccuracy currently costing your operations the most?',
        'How are you currently navigating autonomous vehicles or AGVs within your large facilities?',
        'What is your strategy for tracking high-value goods with greater precision?',
      ],
      businessValue: [
        'Enable safer and more accurate autonomous operations.',
        'Reduce inefficiencies caused by location tracking errors.',
        'Provide a foundation for advanced Industry 4.0 applications.',
      ],
      crossSellOpportunities: [
        'Airtel IoT Connectivity',
        'Airtel 5G for Enterprise',
      ],
    ),
    ProductEnablement(
      productName: 'Airtel IQ Business Connect',
      positionItAs:
          'Position IQ Business Connect as an intelligent omnichannel layer. It unifies customer engagement across voice, SMS, and WhatsApp without requiring a complete overhaul of the existing CRM or PBX.',
      questionsToAsk: [
        'What percentage of your customer communications are currently siloed across different vendor platforms?',
        'Are your agents struggling with context switching between voice calls and WhatsApp messages?',
        'How are you currently tracking communication compliance and quality assurance across channels?',
      ],
      businessValue: [
        'Unify customer engagement to reduce churn.',
        'Improve support efficiency and agent productivity.',
        'Ensure all customer communications are compliant and recorded.',
      ],
      crossSellOpportunities: ['Airtel Corporate Postpaid', 'Airtel SD-WAN'],
    ),
    ProductEnablement(
      productName: 'Airtel Corporate Postpaid',
      positionItAs:
          'Position Corporate Postpaid as a centralized enterprise mobility solution. Focus on how it simplifies provisioning, enforces corporate security, and eliminates the administrative headache of employee reimbursements.',
      questionsToAsk: [
        'How much administrative overhead is your team spending managing individual employee telecom reimbursements?',
        'How do you enforce corporate data security policies on employee-owned mobile connections?',
        'Are you experiencing bill shock due to unmanaged data overages by your field workforce?',
      ],
      businessValue: [
        'Reduce telecom administrative overhead.',
        'Enforce consistent security policies across the mobile workforce.',
        'Provide predictable billing and remove expense report friction.',
      ],
      crossSellOpportunities: [
        'Airtel IQ Business Connect',
        'Airtel Work From Anywhere Solutions',
      ],
    ),
    ProductEnablement(
      productName: 'Airtel 5G for Enterprise',
      positionItAs:
          'Position Private 5G as the high-bandwidth foundation for next-generation digital transformation. It replaces unreliable Wi-Fi in harsh environments and supports more advanced industrial use cases.',
      questionsToAsk: [
        'Which of your digital initiatives are currently bottlenecked by existing Wi-Fi or wired constraints?',
        'Are you experiencing connectivity dropouts with moving assets like AGVs or robotic arms?',
        'How are you planning to handle the data volume required for real-time video analytics?',
      ],
      businessValue: [
        'Unlock autonomous operations and real-time robotics.',
        'Eliminate factory floor connectivity dead zones.',
        'Support dense IoT sensor environments securely.',
      ],
      crossSellOpportunities: [
        'Airtel IoT Connectivity',
        'Airtel Precise Positioning',
      ],
    ),
    ProductEnablement(
      productName: 'Airtel SIP Trunking',
      positionItAs:
          'Position SIP Trunking as a practical upgrade for enterprises that want to modernize voice infrastructure without replacing everything at once. Focus on better scalability, simpler management, and cleaner integration with existing PBX environments.',
      questionsToAsk: [
        'How are you handling call capacity changes during peak periods today?',
        'What parts of your voice stack still depend on legacy PRI or ISDN infrastructure?',
        'How important is voice continuity if one location or carrier path fails?',
      ],
      businessValue: [
        'Make voice capacity easier to scale as call volumes change.',
        'Reduce dependence on older circuit-based voice infrastructure.',
        'Support more flexible voice operations across branches and contact centers.',
      ],
      crossSellOpportunities: [
        'Airtel Contact Center as a Service',
        'Airtel Leased Line (ILL)',
        'Airtel IQ Business Connect',
      ],
    ),
    ProductEnablement(
      productName: 'Airtel Contact Center as a Service',
      positionItAs:
          'Position CCaaS as a way to simplify customer support operations while giving agents a more flexible working model. Emphasize that it is useful when the business wants to reduce on-premises complexity and improve service consistency.',
      questionsToAsk: [
        'How are your agents handling voice, chat, and email work today?',
        'Which parts of your contact center are hardest to scale during busy periods?',
        'What is slowing down your move away from on-premises call center infrastructure?',
      ],
      businessValue: [
        'Help support teams work from more flexible locations.',
        'Reduce the operational burden of maintaining contact center hardware.',
        'Give managers better visibility into service performance across channels.',
      ],
      crossSellOpportunities: [
        'Airtel SIP Trunking',
        'Airtel CPaaS',
        'Airtel Work From Anywhere Solutions',
      ],
    ),
    ProductEnablement(
      productName: 'Airtel Managed Wi-Fi',
      positionItAs:
          'Position Managed Wi-Fi as an easier way to provide consistent wireless access across offices, campuses, stores, or guest environments. Focus on experience, operational simplicity, and centralized management.',
      questionsToAsk: [
        'Where are users still experiencing poor wireless coverage or inconsistent performance?',
        'How much internal effort goes into keeping access points and guest networks running today?',
        'Would centralized visibility across multiple locations help your IT team respond faster?',
      ],
      businessValue: [
        'Improve wireless consistency across busy locations.',
        'Reduce the maintenance burden on internal IT teams.',
        'Support guest and employee connectivity through a managed service model.',
      ],
      crossSellOpportunities: [
        'Airtel Leased Line (ILL)',
        'Airtel SD-WAN',
        'Airtel Secure Internet',
      ],
    ),
    ProductEnablement(
      productName: 'Airtel CPaaS',
      positionItAs:
          'Position CPaaS as a developer-friendly messaging and voice layer for customer communication workflows. Keep the conversation focused on integration simplicity, channel reach, and operational control.',
      questionsToAsk: [
        'Which customer journeys still depend on manual communication today?',
        'Do your teams need SMS, voice, and WhatsApp from a single platform?',
        'How quickly can your current communication stack support a new campaign or workflow change?',
      ],
      businessValue: [
        'Help teams automate customer communication across multiple channels.',
        'Reduce the number of separate tools needed for messaging workflows.',
        'Support product teams that need communication inside applications and processes.',
      ],
      crossSellOpportunities: [
        'Airtel WhatsApp Business',
        'Airtel Contact Center as a Service',
        'Airtel IQ Business Connect',
      ],
    ),
    ProductEnablement(
      productName: 'Airtel Leased Line (ILL)',
      positionItAs:
          'Position Leased Line as dedicated business connectivity for teams that need predictable performance and stronger control than shared internet access. Focus on reliability, symmetry, and business continuity.',
      questionsToAsk: [
        'Which applications are most sensitive to latency or fluctuating bandwidth?',
        'Do you need more predictable performance for cloud applications or backups?',
        'How do you handle outages or last-mile issues at the office today?',
      ],
      businessValue: [
        'Provide more predictable connectivity for business-critical workloads.',
        'Support offices that need consistent upstream and downstream performance.',
        'Create a stronger foundation for security and branch networking services.',
      ],
      crossSellOpportunities: [
        'Airtel Secure Internet',
        'Airtel SD-WAN',
        'Airtel Managed Wi-Fi',
      ],
    ),
    ProductEnablement(
      productName: 'Airtel Global Voice',
      positionItAs:
          'Position Global Voice as a way to simplify international calling and inbound reach for distributed businesses. Keep the discussion on coverage, call quality, and operational simplicity.',
      questionsToAsk: [
        'How do your teams manage international calling today?',
        'Do you need local presence numbers in more than one market?',
        'Where do quality or routing issues create friction for your global calling teams?',
      ],
      businessValue: [
        'Simplify international voice management under one commercial arrangement.',
        'Help teams provide a more consistent calling experience across markets.',
        'Reduce the complexity of maintaining separate global voice relationships.',
      ],
      crossSellOpportunities: [
        'Airtel SIP Trunking',
        'Airtel Contact Center as a Service',
        'Airtel CPaaS',
      ],
    ),
    ProductEnablement(
      productName: 'Airtel Office Internet',
      positionItAs:
          'Position Office Internet as a practical business connectivity option for smaller offices that want an easier experience than consumer broadband. Focus on reliability, security add-ons, and simpler billing.',
      questionsToAsk: [
        'How many users share the connection at each office today?',
        'Do you need a static IP or any office-level security add-ons?',
        'How much time is spent coordinating internet and voice services separately?',
      ],
      businessValue: [
        'Give smaller offices a more consistent business connectivity experience.',
        'Support basic office security and routing needs without extra complexity.',
        'Reduce the number of vendors needed to run a small site.',
      ],
      crossSellOpportunities: [
        'Airtel Secure Internet',
        'Airtel Corporate Postpaid',
        'Airtel SIP Trunking',
      ],
    ),
    ProductEnablement(
      productName: 'Airtel WhatsApp Business',
      positionItAs:
          'Position WhatsApp Business as a customer communication channel for updates, service, and engagement where customers already spend time. Focus on opt-in communication, faster response handling, and less manual follow-up.',
      questionsToAsk: [
        'Which customer updates still depend on email or outbound calls today?',
        'Do your teams need a better way to handle repetitive service conversations?',
        'Where would a chat-based channel reduce delay for customers or agents?',
      ],
      businessValue: [
        'Help teams communicate with customers on a familiar channel.',
        'Reduce repetitive service work through more structured messaging flows.',
        'Support customer engagement without forcing customers into a new app.',
      ],
      crossSellOpportunities: [
        'Airtel CPaaS',
        'Airtel Contact Center as a Service',
        'Airtel IQ Business Connect',
      ],
    ),
    ProductEnablement(
      productName: 'Airtel Work From Anywhere Solutions',
      positionItAs:
          'Position Work From Anywhere Solutions as a practical way to keep distributed staff productive and secure without relying on ad hoc home internet arrangements. Focus on connectivity consistency, supportability, and security enforcement.',
      questionsToAsk: [
        'How are you supporting remote employees who need reliable work connectivity today?',
        'What security controls do you need when staff work away from the office?',
        'How much time is spent managing reimbursements or troubleshooting employee home internet issues?',
      ],
      businessValue: [
        'Give remote employees a more consistent work connectivity experience.',
        'Help IT teams enforce security and support standards more easily.',
        'Reduce the operational overhead of ad hoc remote work support models.',
      ],
      crossSellOpportunities: [
        'Airtel Corporate Postpaid',
        'Airtel Contact Center as a Service',
        'Airtel Secure Internet',
      ],
    ),
  ];
}
