import 'package:flutter/foundation.dart';

class ObjectionHandling {
  final String objection;
  final String response;

  const ObjectionHandling({
    required this.objection,
    required this.response,
  });
}

class EnrichedProduct {
  final String productName;
  final String whatItIs;
  final String whenToPitch;
  
  // NEW Phase 8.5 Fields
  final String openingHook;
  final String positioningStatement;
  final List<String> whenNotToPitch;

  final List<String> customerSignals;
  final List<String> businessOutcomes;
  final List<String> discoveryHooks;
  final List<ObjectionHandling> commonObjections;
  final List<String> crossSellProducts;
  final List<String> idealIndustries;
  final List<String> officialSourceUrls;
  final String verificationStatus;

  const EnrichedProduct({
    required this.productName,
    required this.whatItIs,
    required this.whenToPitch,
    required this.openingHook,
    required this.positioningStatement,
    required this.whenNotToPitch,
    required this.customerSignals,
    required this.businessOutcomes,
    required this.discoveryHooks,
    required this.commonObjections,
    required this.crossSellProducts,
    required this.idealIndustries,
    required this.officialSourceUrls,
    required this.verificationStatus,
  });
}

final Map<String, EnrichedProduct> productEnrichmentData = {
  'prod_corporate_postpaid': const EnrichedProduct(
    productName: 'Airtel Corporate Postpaid',
    whatItIs: 'A managed enterprise mobility solution offering centralized billing, dynamic data pooling, TraceMate workforce tracking, and Business Name Display for corporate verification.',
    whenToPitch: 'Pitch when clients are expanding field teams, struggling with BYOD reimbursement overhead, or suffering low call answer rates from customers.',
    openingHook: 'Many enterprises are currently struggling to maintain visibility and control over their expanding field workforce. How are you currently managing the financial overhead and data security of individual mobile reimbursements?',
    positioningStatement: 'Position this as a centralized visibility and cost-optimization tool, not just a mobile plan. Emphasize the 18% GST input credit and the retention of corporate contacts when employees leave.',
    whenNotToPitch: [
      'Customer has a strict, well-functioning BYOD policy with no reimbursement issues.',
      'Workforce is 100% desk-bound with no field movement.',
      'Customer is extremely price-sensitive and ignores GST/OpEx benefits.'
    ],
    customerSignals: [
      'Field agents using personal numbers for client communication',
      'Finance team struggling with individual mobile reimbursements',
      'Outbound calling teams suffering from low pickup rates due to spam tagging'
    ],
    businessOutcomes: [
      'Eliminate individual reimbursement overhead with centralized billing and 18% GST savings',
      'Prevent data wastage through dynamic data pooling across the organization',
      'Retain enterprise data and contact numbers when employees leave',
      'Improve customer answer rates and trust via Business Name Display (BND)'
    ],
    discoveryHooks: [
      'How does your finance team currently manage individual mobile and data reimbursements for field staff?',
      'What happens to client communication histories and contact numbers when an account manager leaves your company?',
      'How are you currently tracking the productivity and location of your distributed field workforce?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Cost: "Employees are comfortable with their prepaid plans, and reimbursing them is cheaper than buying corporate lines."',
        response: 'While individual reimbursements seem cheaper, you lose the 18% GST input credit and lack centralized visibility. Plus, dynamic data pooling prevents data wastage, often lowering the total cost of ownership.',
      ),
      ObjectionHandling(
        objection: 'Adoption: "Employees prefer using their dual-SIM personal phones (BYOD) rather than carrying a corporate device."',
        response: 'Corporate Postpaid can be issued as an eSIM or secondary physical SIM for their existing devices, ensuring their personal usage remains separate from managed corporate data and tracking.',
      ),
      ObjectionHandling(
        objection: 'Administrative Overhead: "Managing hundreds of SIMs, plan upgrades, and terminations sounds like a logistical nightmare."',
        response: 'Airtel provides a centralized portal and a dedicated relationship manager to handle onboarding, zero-downtime doorstep SIM delivery, and instant plan modifications at scale.',
      )
    ],
    crossSellProducts: [
      'Airtel Work From Anywhere Solutions',
      'Airtel IQ Business Connect'
    ],
    idealIndustries: [
      'Logistics',
      'Retail',
      'Banking & Financial Services',
      'Healthcare'
    ],
    officialSourceUrls: [
      'Airtel Business Website - Corporate Postpaid',
      'PRODUCTS.docx'
    ],
    verificationStatus: 'Fully Verified',
  ),

  'prod_iq_business_connect': const EnrichedProduct(
    productName: 'Airtel IQ Business Connect',
    whatItIs: 'An omnichannel customer engagement platform natively integrated with the Airtel network, providing verified caller identity (Business Name Display) without third-party app dependencies.',
    whenToPitch: 'Pitch when a business relies heavily on outbound calling (collections, sales, deliveries) and complains about low contact rates or calls being flagged as spam.',
    openingHook: 'We are seeing a massive trend where legitimate enterprise calls are being flagged as spam, directly impacting sales and delivery SLAs. How is your outbound calling team navigating the drop in customer answer rates?',
    positioningStatement: 'Position this as a revenue-recovery tool. Low answer rates mean lost sales and wasted agent time. Focus on network-native verified identity rather than comparing it to Truecaller.',
    whenNotToPitch: [
      'Customer does not rely on outbound voice calls for sales or operations.',
      'Customer already has a deeply integrated omnichannel CCaaS platform that solves this natively.',
      'Outbound volume is too low to justify enterprise verification overhead.'
    ],
    customerSignals: [
      'Drop in outbound sales conversion rates',
      'Delivery or field agents unable to reach customers due to spam blocking',
      'Multiple isolated communication tools used across departments'
    ],
    businessOutcomes: [
      'Increase call answer rates by displaying a verified business name alongside the number',
      'Eliminate third-party app dependencies for caller identification',
      'Gain real-time analytics on call engagement, answer rates, and interaction patterns',
      'Protect brand reputation by distinguishing legitimate calls from fraudulent spam'
    ],
    discoveryHooks: [
      'How are you currently preventing your legitimate business calls from being flagged as spam on customer devices?',
      'What impact does a low call pickup rate have on your delivery fulfillment or outbound sales conversions?',
      'Are you using multiple third-party applications to manage caller identity and analytics?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Dependency: "We already use Truecaller for business identity verification."',
        response: 'Truecaller requires the end-user to have the app installed and internet connectivity. Airtel Business Name Display works at the network level, ensuring your identity is displayed to all customers on the Airtel network seamlessly.',
      ),
      ObjectionHandling(
        objection: 'Integration: "We don\'t want to change our existing PBX or telephony infrastructure."',
        response: 'Business Name Display is activated directly on your existing Airtel numbers or SIP trunks without requiring any complex hardware or software integration.',
      ),
      ObjectionHandling(
        objection: 'ROI: "Will showing our name actually increase sales?"',
        response: 'By eliminating the "unknown number" anxiety, businesses immediately see a lift in answer rates, which directly improves customer contact ratios, reduces repeated call attempts, and accelerates resolution times.',
      )
    ],
    crossSellProducts: [
      'Airtel Corporate Postpaid',
      'Airtel Contact Center as a Service'
    ],
    idealIndustries: [
      'Banking & Financial Services',
      'E-Commerce',
      'Retail',
      'Logistics'
    ],
    officialSourceUrls: [
      'PRODUCTS.docx (Business Name Display section)'
    ],
    verificationStatus: 'Fully Verified',
  ),

  'prod_sd_wan': const EnrichedProduct(
    productName: 'Airtel SD-WAN',
    whatItIs: 'A software-defined networking solution that intelligently routes application traffic across broadband, LTE, and MPLS links, centralized through a single management dashboard.',
    whenToPitch: 'Pitch when an enterprise is opening multiple new branches quickly, struggling with MPLS costs, or migrating heavy workloads to the cloud requiring direct internet access.',
    openingHook: 'As organizations shift workloads to the cloud, routing all branch traffic back through a central data center creates severe latency bottlenecks. How are you modernizing your branch networks to support direct cloud access securely?',
    positioningStatement: 'Position SD-WAN as an agility and cost-optimization play. Do not pitch it as an MPLS killer; rather, pitch it as a hybrid solution to offload non-critical traffic to cheaper broadband while accelerating branch rollouts.',
    whenNotToPitch: [
      'Customer operates from a single central office with no remote branches.',
      'Customer has zero cloud applications and runs 100% legacy on-premise servers.',
      'Customer just signed a 5-year MPLS renewal and refuses a hybrid overlay.'
    ],
    customerSignals: [
      'Complaints about expensive MPLS bandwidth at remote sites',
      'Cloud applications (O365, Salesforce) running slowly at branch offices',
      'IT teams struggling to manually configure routers at dozens of new retail locations'
    ],
    businessOutcomes: [
      'Reduce WAN transport costs by offloading non-critical traffic to broadband',
      'Accelerate branch deployments with zero-touch provisioning',
      'Improve cloud application performance via intelligent path control and direct internet breakout',
      'Simplify network management with a centralized orchestration dashboard'
    ],
    discoveryHooks: [
      'How long does it typically take your IT team to provision the network for a new branch location?',
      'Are your branch users experiencing latency when accessing cloud applications routed through the central data center?',
      'How are you balancing the high cost of MPLS with the increasing bandwidth demands of video and cloud at the edge?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Reliability: "Broadband is too unreliable compared to our SLA-backed MPLS connections."',
        response: 'SD-WAN allows you to aggregate multiple broadband and LTE links. If one degrades, intelligent path control instantly seamlessly routes traffic to the healthiest link, providing MPLS-like reliability at broadband costs.',
      ),
      ObjectionHandling(
        objection: 'Security: "Sending branch traffic directly to the internet bypassing the data center is a security risk."',
        response: 'Airtel SD-WAN includes built-in next-generation firewall capabilities, malware protection, and content filtering directly at the edge, securing the branch without backhauling traffic.',
      ),
      ObjectionHandling(
        objection: 'Complexity: "Replacing our current routing infrastructure sounds like a massive operational disruption."',
        response: 'Airtel provides end-to-end managed services from design to deployment. We can implement SD-WAN in a hybrid model alongside your existing MPLS to ensure a phased, risk-free transition.',
      )
    ],
    crossSellProducts: [
      'Airtel Dedicated Internet (ILL)',
      'Airtel Public Cloud',
      'Airtel Secure Internet'
    ],
    idealIndustries: [
      'Retail',
      'Manufacturing',
      'Banking & Financial Services',
      'Healthcare'
    ],
    officialSourceUrls: [
      'PRODUCTS.docx (SD Branch / SD WAN section)'
    ],
    verificationStatus: 'Fully Verified',
  ),

  'prod_sip_trunking': const EnrichedProduct(
    productName: 'Airtel SIP Trunking',
    whatItIs: 'A scalable voice connectivity solution that replaces traditional ISDN/PRI lines, transmitting voice calls over an IP network directly to an enterprise IP-PBX.',
    whenToPitch: 'Pitch when a customer is consolidating infrastructure, moving to a unified communications platform, or reaching capacity limits on physical PRI lines.',
    openingHook: 'Many enterprises are retiring legacy physical telephony hardware in favor of unified IP communications to reduce maintenance overhead. What is your roadmap for migrating off expensive physical PRI lines?',
    positioningStatement: 'Position SIP Trunking as a necessary modernization step for IP-PBX or Microsoft Teams integration. Focus on the scalability and the reduction of physical infrastructure costs.',
    whenNotToPitch: [
      'Customer has a brand new legacy PBX that does not support SIP and refuses media gateways.',
      'Voice calling is an absolute zero-priority for the business.',
      'Customer is entirely migrating to a cloud-native CCaaS where external SIP routing is unnecessary.'
    ],
    customerSignals: [
      'Paying for unused voice channels on fixed PRI lines',
      'Migrating from legacy PBX to modern IP-PBX or Microsoft Teams',
      'Experiencing voice capacity bottlenecks during peak business hours'
    ],
    businessOutcomes: [
      'Scale voice channels dynamically without installing physical lines',
      'Reduce telephony costs by consolidating voice and data over a single IP network',
      'Enable seamless integration with unified communications platforms',
      'Ensure high voice availability with network redundancy and failover routing'
    ],
    discoveryHooks: [
      'How are you planning to scale your voice capacity if call volumes spike unexpectedly?',
      'Are you still managing physical PRI lines across multiple separate office locations?',
      'What is your roadmap for migrating from legacy telephony to unified communications or IP-PBX?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Quality: "Voice over IP (VoIP) is notoriously unreliable and prone to jitter."',
        response: 'Airtel SIP Trunking is delivered over a dedicated, SLA-backed IP network rather than the public internet, ensuring enterprise-grade Quality of Service (QoS) and crystal-clear voice.',
      ),
      ObjectionHandling(
        objection: 'Security: "Exposing our PBX to an IP network increases the risk of toll fraud and eavesdropping."',
        response: 'The service is secured via Session Border Controllers (SBC) and robust authentication protocols, protecting your voice infrastructure from unauthorized access and fraud.',
      ),
      ObjectionHandling(
        objection: 'Infrastructure: "We already invested heavily in our legacy PBX hardware."',
        response: 'Airtel SIP Trunking can be integrated with legacy PBX systems using a media gateway, allowing you to realize cost savings today without ripping and replacing your current hardware.',
      )
    ],
    crossSellProducts: [
      'Airtel Dedicated Internet (ILL)',
      'Airtel Contact Center as a Service'
    ],
    idealIndustries: [
      'IT & ITES',
      'Banking & Financial Services',
      'Hospitality',
      'E-Commerce'
    ],
    officialSourceUrls: [
      'Derived from standard Airtel IQ SIP capabilities'
    ],
    verificationStatus: 'Partially Verified',
  ),

  'prod_ccaas': const EnrichedProduct(
    productName: 'Airtel Contact Center as a Service',
    whatItIs: 'A cloud-based omnichannel contact center platform natively integrated with Airtel\'s telecom network, allowing agents to handle voice, chat, and email without on-premise hardware.',
    whenToPitch: 'Pitch when a business wants to enable remote agents, is frustrated by the capital expense of legacy PBX infrastructure, or needs to deploy a customer service team rapidly.',
    openingHook: 'Modern customer service requires agents to seamlessly pivot between voice, chat, and social media regardless of where they are working from. How are you currently equipping your support team to handle omnichannel interactions remotely?',
    positioningStatement: 'Position CCaaS as an agility enabler. The primary value is shifting contact center costs from rigid CapEx to elastic OpEx, allowing rapid agent deployment during peak seasons.',
    whenNotToPitch: [
      'Customer does not have a dedicated customer service or outbound sales team.',
      'Customer recently invested heavily in a brand new on-premise Cisco/Avaya contact center.',
      'Business strictly prohibits cloud data storage for call recordings due to extreme compliance.'
    ],
    customerSignals: [
      'Struggling to manage a hybrid or work-from-home customer support team',
      'Facing high maintenance costs for legacy on-premise contact center hardware',
      'Experiencing seasonal spikes in customer inquiries and unable to scale agent seats dynamically'
    ],
    businessOutcomes: [
      'Shift contact center costs from CapEx to a predictable pay-as-you-go OpEx model',
      'Enable agents to work securely from any location with just an internet connection',
      'Deploy new campaigns or agent seats in hours rather than weeks',
      'Consolidate voice, email, and social media interactions into a single agent desktop'
    ],
    discoveryHooks: [
      'How difficult is it for your IT team to provision new contact center agents during seasonal demand spikes?',
      'Are your agents able to seamlessly handle voice, WhatsApp, and email from a unified interface?',
      'What is the annual maintenance overhead of your current on-premise telephony hardware?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Integration: "Our contact center needs tight integration with our custom CRM to be effective."',
        response: 'Airtel CCaaS offers out-of-the-box APIs and deep integrations with leading CRMs like Salesforce and Zendesk, ensuring screen-pops and contextual data are available to agents instantly.',
      ),
      ObjectionHandling(
        objection: 'Quality: "Cloud telephony drops calls when the internet is unstable at the agent\'s location."',
        response: 'Because CCaaS is natively integrated into Airtel\'s telecom network, we can route calls directly to an agent\'s mobile device if their data connection degrades, ensuring zero dropped calls.',
      ),
      ObjectionHandling(
        objection: 'Compliance: "We must record and store all calls locally for regulatory reasons."',
        response: 'The platform provides secure, encrypted cloud storage for call recordings that complies with data localization mandates, and offers flexible export options to your internal servers.',
      )
    ],
    crossSellProducts: [
      'Airtel WhatsApp Business',
      'Airtel CPaaS'
    ],
    idealIndustries: [
      'E-Commerce',
      'Retail',
      'Banking & Financial Services',
      'Travel & Tourism'
    ],
    officialSourceUrls: [
      'Derived from standard Airtel IQ CCaaS capabilities'
    ],
    verificationStatus: 'Partially Verified',
  ),

  'prod_managed_wifi': const EnrichedProduct(
    productName: 'Airtel Managed Wi-Fi',
    whatItIs: 'An end-to-end managed enterprise Wi-Fi solution covering access point provisioning, centralized monitoring, proactive maintenance, and secure guest access portals.',
    whenToPitch: 'Pitch to organizations with large physical footprints (campuses, warehouses, retail chains) struggling with Wi-Fi dead zones, IT maintenance overhead, or poor guest connectivity.',
    openingHook: 'As footfall increases in large retail and campus environments, poor Wi-Fi connectivity often translates directly to a poor guest experience and IT headaches. How is your IT team managing wireless density and dead zones across your physical locations?',
    positioningStatement: 'Position this as an IT offloading service. Enterprise Wi-Fi is complex to tune and maintain; Airtel takes on the SLAs, hardware lifecycle, and security, freeing the internal IT team.',
    whenNotToPitch: [
      'Customer operates a small 10-person office that runs fine on a standard router.',
      'Customer\'s business model has absolutely no physical footfall or warehouse operations.',
      'Internal IT team insists on owning and managing all access point hardware directly.'
    ],
    customerSignals: [
      'High volume of IT helpdesk tickets related to wireless connectivity issues',
      'Inability to segregate corporate network traffic from guest or IoT traffic securely',
      'Lack of analytics on footfall or visitor behavior in physical locations'
    ],
    businessOutcomes: [
      'Eliminate the IT burden of managing, updating, and troubleshooting wireless access points',
      'Provide secure, seamless roaming for employees across large facilities without connection drops',
      'Monetize guest access via customizable captive portals and visitor analytics',
      'Shift Wi-Fi infrastructure from an upfront CapEx investment to a managed OpEx model'
    ],
    discoveryHooks: [
      'How much time does your IT team spend investigating complaints about Wi-Fi dead zones?',
      'Are you currently capturing any marketing data or footfall analytics from the guests using your Wi-Fi?',
      'How do you ensure that visitors on your guest network cannot access sensitive corporate servers?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Cost: "We can buy off-the-shelf routers much cheaper than a managed enterprise solution."',
        response: 'Consumer routers fail under enterprise user density and lack centralized security protocols. Managed Wi-Fi eliminates the hidden operational costs of troubleshooting and constant hardware replacement.',
      ),
      ObjectionHandling(
        objection: 'Control: "Our security policy requires our internal IT to have full control over the network hardware."',
        response: 'Airtel provides a comprehensive cloud dashboard giving your IT team full visibility, reporting, and policy control, while we handle the underlying hardware SLAs and firmware updates.',
      ),
      ObjectionHandling(
        objection: 'Vendor Lock-in: "We don\'t want to be tied to a specific hardware manufacturer."',
        response: 'Airtel partners with multiple leading vendors to offer a hardware-agnostic solution, ensuring you get the best access points tailored to your specific environment and budget.',
      )
    ],
    crossSellProducts: [
      'Airtel Dedicated Internet (ILL)',
      'Airtel SD-WAN'
    ],
    idealIndustries: [
      'Hospitality',
      'Education',
      'Retail',
      'Logistics'
    ],
    officialSourceUrls: [
      'PRODUCTS.docx (Managed WiFi section)'
    ],
    verificationStatus: 'Fully Verified',
  ),

  'prod_mpls': const EnrichedProduct(
    productName: 'Airtel VPN/MPLS',
    whatItIs: 'A highly secure, private Multiprotocol Label Switching (MPLS) network providing dedicated, point-to-point connectivity between enterprise locations with guaranteed Quality of Service (QoS).',
    whenToPitch: 'Pitch to highly regulated enterprises requiring absolute data privacy, deterministic latency for core applications (like SAP/ERP), and immunity from public internet congestion.',
    openingHook: 'Regulated industries face immense pressure to keep sensitive data completely off the public internet while ensuring zero latency for core ERP applications. How are you currently guaranteeing the deterministic routing of your most critical internal workloads?',
    positioningStatement: 'Position MPLS for mission-critical, latency-sensitive core workloads. Do not pitch it for generic branch internet access. Frame it as the ultra-secure, SLA-backed backbone of the enterprise.',
    whenNotToPitch: [
      'Customer is entirely cloud-native with zero on-premise data centers.',
      'Customer is highly cost-conscious and primarily uses SaaS applications over broadband.',
      'Customer is trying to reduce WAN spend and specifically asked to move away from MPLS.'
    ],
    customerSignals: [
      'Strict compliance mandates prohibiting the transmission of sensitive data over the public internet',
      'Complaints about application timeouts or jitter in core banking or ERP systems',
      'Need to connect a new manufacturing plant or regional headquarters securely to the central data center'
    ],
    businessOutcomes: [
      'Ensure absolute data privacy by routing traffic entirely off the public internet',
      'Guarantee performance for mission-critical applications through traffic prioritization (Class of Service)',
      'Achieve predictable latency and high availability backed by stringent enterprise SLAs',
      'Establish seamless, secure direct connections to major public cloud platforms'
    ],
    discoveryHooks: [
      'How are you ensuring the absolute privacy of data transmitted between your regional branches and the core data center?',
      'Do you experience application timeouts with your ERP software during peak network utilization?',
      'What are your compliance mandates regarding data transmission over shared or public networks?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Agility: "MPLS takes too long to provision for new branch offices compared to broadband."',
        response: 'For agile branch expansion, we recommend a hybrid architecture: retain MPLS for the core data centers and critical hubs, while utilizing Airtel SD-WAN over broadband for smaller, rapidly deployed sites.',
      ),
      ObjectionHandling(
        objection: 'Cost: "MPLS bandwidth is significantly more expensive per megabit than internet leased lines."',
        response: 'While internet is cheaper, it cannot guarantee latency or packet delivery. MPLS provides the SLA-backed deterministic routing necessary for voice, video, and real-time financial transactions to function without failure.',
      ),
      ObjectionHandling(
        objection: 'Cloud Migration: "Since we are moving workloads to the public cloud, we don\'t need private branch routing anymore."',
        response: 'Airtel MPLS integrates directly with our Cloud Connect service, providing a secure, private, and high-speed on-ramp from your branches directly into AWS, Azure, or Google Cloud.',
      )
    ],
    crossSellProducts: [
      'Airtel SD-WAN',
      'Airtel Public Cloud'
    ],
    idealIndustries: [
      'Banking & Financial Services',
      'Government',
      'Manufacturing',
      'Healthcare'
    ],
    officialSourceUrls: [
      'PRODUCTS.docx (VPN section)'
    ],
    verificationStatus: 'Fully Verified',
  ),

  'prod_wfas': const EnrichedProduct(
    productName: 'Airtel Work From Anywhere Solutions',
    whatItIs: 'A suite of secure mobility and connectivity services enabling employees to access enterprise applications securely from home or remote locations.',
    whenToPitch: 'Pitch when an enterprise operates a hybrid workforce, struggles to secure remote access, or needs to rapidly provision connectivity for remote employees.',
    openingHook: 'As hybrid work becomes permanent, enterprises are struggling to extend corporate security policies to untrusted home networks. How are you ensuring your remote workforce can securely access internal applications without exposing the corporate network?',
    positioningStatement: 'Position this as an enterprise security and productivity enabler. It replaces disjointed VPNs and unmanaged home broadband with a cohesive, secure remote access strategy.',
    whenNotToPitch: [
      'Customer mandates 100% return-to-office and has no remote workers.',
      'Customer only needs basic mobile data plans, not secure access to corporate networks.',
      'Customer already uses a fully deployed Zero Trust Network Access (ZTNA) provider globally.'
    ],
    customerSignals: [
      'Security breaches originating from compromised remote employee endpoints',
      'Helpdesk overwhelmed by VPN connection issues from home broadband users',
      'Inability to monitor or control data access when employees work outside the office'
    ],
    businessOutcomes: [
      'Secure remote access to corporate applications without exposing the internal network',
      'Improve remote workforce productivity with reliable, enterprise-grade connectivity',
      'Ensure consistent security policies apply regardless of the employee\'s physical location',
      'Simplify IT management by consolidating remote connectivity under a single provider'
    ],
    discoveryHooks: [
      'How are you currently securing access to your internal applications for employees working from untrusted home networks?',
      'What impact do unstable home broadband connections have on your remote team\'s productivity?',
      'Are you struggling to enforce corporate security policies on devices operating outside the corporate perimeter?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Security: "We already have a traditional VPN concentrator for remote access."',
        response: 'Traditional VPNs grant broad network access once authenticated. Our modern Secure Internet access provides Zero Trust application-level access, ensuring remote workers only see the specific apps they are authorized to use.',
      ),
      ObjectionHandling(
        objection: 'Cost: "Subsidizing home internet for all employees is too expensive."',
        response: 'Instead of blanket subsidies, Airtel offers targeted corporate mobility plans and secure dongles that provide managed, predictable costs with the added benefit of GST input credits.',
      ),
      ObjectionHandling(
        objection: 'Complexity: "Managing home connectivity for hundreds of employees sounds like a nightmare."',
        response: 'Airtel provides a centralized management portal and dedicated support, completely offloading the troubleshooting and provisioning burden from your internal IT team.',
      )
    ],
    crossSellProducts: [
      'Airtel Corporate Postpaid',
      'Airtel Secure Internet'
    ],
    idealIndustries: [
      'IT & ITES',
      'Banking & Financial Services',
      'Media & Entertainment',
      'Education'
    ],
    officialSourceUrls: [
      'Derived from standard Airtel enterprise mobility positioning'
    ],
    verificationStatus: 'Partially Verified',
  ),

  'prod_5g_enterprise': const EnrichedProduct(
    productName: 'Airtel 5G for Enterprise',
    whatItIs: 'Ultra-low latency, high-bandwidth private and public 5G network solutions designed to power industrial automation, IoT deployments, and massive device density.',
    whenToPitch: 'Pitch to manufacturing plants, ports, or logistics hubs looking to automate operations using robotics, AGVs (Automated Guided Vehicles), or real-time high-definition video analytics.',
    openingHook: 'Industrial automation is often bottlenecked by the latency and unreliability of standard Wi-Fi on the factory floor. How is your organization modernizing its wireless infrastructure to support real-time robotics and computer vision?',
    positioningStatement: 'Position 5G as an Industry 4.0 enabler. This is a highly strategic, long-term play. Frame it around low latency, edge computing, and massive device density, not just "faster internet".',
    whenNotToPitch: [
      'Customer is a standard corporate office with no industrial or automation use cases.',
      'Customer lacks the capital budget or operational maturity for Industry 4.0 initiatives.',
      'Customer only needs standard building Wi-Fi for employee laptops.'
    ],
    customerSignals: [
      'Current factory Wi-Fi dropping connections for mobile robots or AGVs',
      'Need for real-time AI computer vision for quality control on assembly lines',
      'Planning a highly automated "Industry 4.0" smart factory deployment'
    ],
    businessOutcomes: [
      'Enable real-time industrial automation with single-digit millisecond network latency',
      'Secure operational data by keeping traffic localized on a Private 5G core',
      'Support massive sensor density without the bandwidth limitations of traditional Wi-Fi',
      'Eliminate physical cabling costs and constraints on the factory floor'
    ],
    discoveryHooks: [
      'What bottlenecks are you hitting with your current factory floor Wi-Fi when trying to deploy automated guided vehicles?',
      'How are you securely managing the massive influx of data generated by sensors on your production line?',
      'Is network latency preventing you from utilizing real-time video analytics for quality inspection?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Maturity: "5G use cases still seem experimental and unproven for critical manufacturing."',
        response: 'Airtel has already deployed commercial Private 5G networks in operational manufacturing plants in India, successfully powering AGVs and quality control cameras with measurable efficiency gains.',
      ),
      ObjectionHandling(
        objection: 'Cost: "Building a Private 5G network requires massive upfront capital expenditure."',
        response: 'Airtel offers Network-as-a-Service (NaaS) models, converting the complex 5G infrastructure deployment into a manageable OpEx investment aligned with your automation milestones.',
      ),
      ObjectionHandling(
        objection: 'Skills: "We do not have the internal telecom expertise to manage a 5G core network."',
        response: 'Airtel handles the end-to-end design, deployment, and ongoing managed services of the 5G network, allowing your team to focus entirely on the industrial applications running on top of it.',
      )
    ],
    crossSellProducts: [
      'Airtel IoT Connectivity',
      'Airtel Public Cloud'
    ],
    idealIndustries: [
      'Manufacturing',
      'Logistics',
      'Automotive',
      'Healthcare'
    ],
    officialSourceUrls: [
      'Derived from standard Airtel 5G B2B positioning'
    ],
    verificationStatus: 'Partially Verified',
  ),

  'prod_cpaas': const EnrichedProduct(
    productName: 'Airtel CPaaS',
    whatItIs: 'A Communications Platform as a Service that provides APIs to seamlessly embed SMS, Voice, and messaging capabilities directly into enterprise applications and workflows.',
    whenToPitch: 'Pitch when an enterprise needs to automate transactional notifications (OTPs, delivery updates), build custom IVRs, or mask phone numbers for customer privacy.',
    openingHook: 'Customers today expect instant, secure notifications and seamless interactions within apps, but building native telecom infrastructure is costly. How are your developers currently integrating secure messaging and voice directly into your applications?',
    positioningStatement: 'Position CPaaS to the CTO or Product Owner as a developer-friendly API platform. Emphasize speed-to-market and Airtel’s direct-to-telecom reliability over third-party aggregators.',
    whenNotToPitch: [
      'Customer relies entirely on off-the-shelf software and has no in-house developers.',
      'Customer uses simple email marketing and has no need for transactional SMS or voice APIs.',
      'Customer volume is too small to justify an API integration.'
    ],
    customerSignals: [
      'E-commerce platforms needing automated delivery tracking updates',
      'Cab aggregators or delivery apps requiring driver-to-customer call masking',
      'Banks needing high-reliability OTP delivery systems'
    ],
    businessOutcomes: [
      'Accelerate time-to-market for communication features using simple, developer-friendly APIs',
      'Protect customer privacy by masking phone numbers during transactions',
      'Ensure high-deliverability of mission-critical alerts (like OTPs) via direct telco integration',
      'Reduce customer service workloads by automating routine notifications'
    ],
    discoveryHooks: [
      'How are you currently ensuring the privacy of your customers\' phone numbers when they interact with your delivery agents?',
      'What is the delivery success rate of your critical authentication messages like OTPs?',
      'How easily can your development team integrate new communication channels like WhatsApp into your existing CRM?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Developer Resources: "We don\'t have the engineering bandwidth to integrate APIs right now."',
        response: 'Airtel CPaaS offers robust documentation, SDKs, and pre-built code snippets that allow developers to integrate messaging capabilities in days, not months.',
      ),
      ObjectionHandling(
        objection: 'Reliability: "We use a global aggregator for SMS, why switch to a telco API?"',
        response: 'Aggregators route traffic through multiple hops, increasing latency and failure rates. Airtel CPaaS connects directly to the core network, ensuring superior delivery rates for time-sensitive OTPs.',
      ),
      ObjectionHandling(
        objection: 'Scalability: "Will this platform handle massive spikes during our annual sales events?"',
        response: 'Built on Airtel\'s telecom infrastructure, the platform is designed to handle thousands of transactions per second with built-in redundancy, ensuring zero downtime during peak traffic.',
      )
    ],
    crossSellProducts: [
      'Airtel WhatsApp Business',
      'Airtel Contact Center as a Service'
    ],
    idealIndustries: [
      'E-Commerce',
      'Banking & Financial Services',
      'Retail',
      'Logistics'
    ],
    officialSourceUrls: [
      'Derived from standard Airtel IQ CPaaS capabilities'
    ],
    verificationStatus: 'Partially Verified',
  ),

  'prod_ill': const EnrichedProduct(
    productName: 'Airtel Leased Line (ILL)',
    whatItIs: 'A dedicated, secure, and uncontended internet connection providing guaranteed symmetric bandwidth (equal upload/download speeds) and an SLA-backed 99.5% uptime.',
    whenToPitch: 'Pitch when a business cannot tolerate internet downtime, frequently uploads large files, or hosts critical web applications on-premise.',
    openingHook: 'For digitally mature enterprises, any internet downtime translates directly to lost revenue and stalled productivity. How are you guaranteeing the uptime and symmetric upload speeds required for your critical cloud applications?',
    positioningStatement: 'Position ILL as the foundational lifeline of the business. Do not sell it as "fast broadband." Sell it as an insurance policy against downtime, backed by a financially binding SLA and uncontended bandwidth.',
    whenNotToPitch: [
      'Customer operates a small cafe or 3-person office that just needs basic web browsing.',
      'Customer is extremely price-sensitive and perfectly happy with shared consumer broadband.',
      'Customer requires routing across multiple branches rather than direct internet (pitch MPLS/SD-WAN instead).'
    ],
    customerSignals: [
      'Complaints about slow internet during peak office hours due to shared broadband',
      'Video conferences freezing or dropping due to poor upload speeds',
      'Significant financial losses tied to brief internet outages'
    ],
    businessOutcomes: [
      'Guarantee uninterrupted business operations with SLA-backed 99.5% uptime',
      'Accelerate data-intensive tasks and cloud backups with symmetric upload speeds',
      'Handle unpredictable traffic spikes smoothly with burstable bandwidth capabilities',
      'Resolve network issues rapidly with 24x7 dedicated enterprise support'
    ],
    discoveryHooks: [
      'How much productivity is lost across the office when your current internet connection slows down during peak hours?',
      'Are you experiencing bottlenecks when uploading large files or running data backups to the cloud?',
      'What is the financial impact on your business if the internet goes down for four hours?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Cost: "Dedicated Internet is vastly more expensive than our current business broadband."',
        response: 'While broadband is cheaper, it shares bandwidth with surrounding buildings, causing slowdowns. ILL provides guaranteed, dedicated capacity and an SLA that compensates you for downtime, protecting your revenue.',
      ),
      ObjectionHandling(
        objection: 'Redundancy: "We already have two cheap broadband lines for backup, isn\'t that enough?"',
        response: 'Dual broadband lines often share the same underlying physical fiber path. Airtel ILL can be delivered with true physical path diversity, ensuring a single fiber cut doesn\'t take down both connections.',
      ),
      ObjectionHandling(
        objection: 'Flexibility: "We occasionally need more speed but don\'t want to pay for a higher tier permanently."',
        response: 'Airtel ILL offers burstable bandwidth, allowing you to seamlessly scale up to five times your base bandwidth during temporary traffic spikes at minimal added cost.',
      )
    ],
    crossSellProducts: [
      'Airtel Secure Internet',
      'Airtel Public Cloud',
      'Airtel SD-WAN'
    ],
    idealIndustries: [
      'IT & ITES',
      'Banking & Financial Services',
      'Manufacturing',
      'Media & Entertainment'
    ],
    officialSourceUrls: [
      'PRODUCTS.docx (DEDICATED INTERNET section)'
    ],
    verificationStatus: 'Fully Verified',
  ),

  'prod_colocation': const EnrichedProduct(
    productName: 'Airtel Colocation (Nxtra)',
    whatItIs: 'Enterprise-grade data center space providing secure power, cooling, and physical security for a company\'s proprietary server hardware, backed by high-density network connectivity.',
    whenToPitch: 'Pitch when an enterprise is running out of space in their on-premise server room, struggling with power cooling costs, or requires a disaster recovery site.',
    openingHook: 'Maintaining on-premise server rooms is becoming increasingly unsustainable due to escalating power costs and compliance mandates. How is your infrastructure strategy shifting to balance proprietary hardware control with modern resilience?',
    positioningStatement: 'Position Colocation as a strategic bridge. It relieves the customer of massive real estate and cooling CapEx while allowing them to retain physical control of their legacy hardware near hyperscaler cloud ramps.',
    whenNotToPitch: [
      'Customer is proudly 100% cloud-native with zero owned server hardware.',
      'Customer is a small startup running everything on SaaS.',
      'Customer insists on keeping data servers under their desk for "security".'
    ],
    customerSignals: [
      'Upcoming server hardware refresh cycle but reluctant to move entirely to the public cloud',
      'Facing exorbitant cooling and power costs for an aging on-premise server room',
      'Regulatory requirements dictating physical control over proprietary hardware'
    ],
    businessOutcomes: [
      'Eliminate the capital expense of building and maintaining private server rooms',
      'Ensure high availability of critical hardware with N+1 redundant power and cooling',
      'Achieve strict regulatory compliance through certified physical security and access controls',
      'Enable ultra-low latency connectivity via direct cross-connects to telco networks and public clouds'
    ],
    discoveryHooks: [
      'How are you managing the escalating power and cooling costs of your on-premise server room?',
      'What is your disaster recovery plan if your primary office experiences a prolonged power outage?',
      'Are you facing regulatory requirements that prevent you from migrating certain legacy workloads to the public cloud?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Cloud Migration: "We are migrating everything to the cloud, so we don\'t need data center space."',
        response: 'Most enterprises adopt a hybrid strategy. Colocation provides a secure home for legacy databases that are too expensive or difficult to refactor for the cloud, while offering direct, low-latency cross-connects to hyperscalers.',
      ),
      ObjectionHandling(
        objection: 'Control: "We want our IT team to have immediate physical access to our servers at the office."',
        response: 'Nxtra facilities offer 24x7 secure access for your authorized personnel, alongside remote hands services where our certified technicians can perform physical tasks on your behalf at any time.',
      ),
      ObjectionHandling(
        objection: 'Migration Risk: "Physically moving our racks to a new facility is too risky and complex."',
        response: 'Airtel provides end-to-end migration services, securely transporting and installing your hardware during scheduled maintenance windows to ensure zero unplanned disruption.',
      )
    ],
    crossSellProducts: [
      'Airtel Dedicated Internet (ILL)',
      'Airtel VPN/MPLS'
    ],
    idealIndustries: [
      'Banking & Financial Services',
      'IT & ITES',
      'Government',
      'Healthcare'
    ],
    officialSourceUrls: [
      'Derived from standard Airtel Nxtra capabilities'
    ],
    verificationStatus: 'Partially Verified',
  ),

  'prod_global_voice': const EnrichedProduct(
    productName: 'Airtel Global Voice',
    whatItIs: 'Wholesale Voice Termination services utilizing Tier-1 carrier partnerships and 1200+ global interconnects to provide high-quality international calling routes.',
    whenToPitch: 'Pitch to international BPOs, call centers, or multi-national corporations suffering from call drops, high latency, or excessive costs on international outbound calls.',
    openingHook: 'For global contact centers, poor international voice quality directly impacts agent resolution times and customer satisfaction. How are you currently optimizing your international routing to minimize latency and call drops?',
    positioningStatement: 'Position Global Voice around network quality and fraud protection. Do not compete purely on the lowest per-minute rate; sell the reliability of Tier-1 routing and the operational savings of high answer rates.',
    whenNotToPitch: [
      'Customer only makes domestic calls within India.',
      'Customer uses basic consumer VoIP tools (like Skype/Zoom) for occasional international chats.',
      'Customer strictly refuses to move away from illegal/grey-route telecom providers.'
    ],
    customerSignals: [
      'BPO clients complaining about poor voice quality impacting customer satisfaction',
      'High rates of international call drops or jitter',
      'Fraudulent international routing causing sudden spikes in telecom bills'
    ],
    businessOutcomes: [
      'Improve international call quality and reduce latency via direct Tier-1 carrier routing',
      'Protect against telecom fraud with best-in-class automated fraud detection',
      'Reduce global communication costs through competitive wholesale routing agreements',
      'Gain real-time visibility into usage and traffic analytics through the Airtel Advantage portal'
    ],
    discoveryHooks: [
      'How is poor international call quality impacting the resolution times of your global support center?',
      'Are you experiencing sudden, unexplained spikes in your international calling costs due to fraud?',
      'How many different carrier relationships are you currently managing to achieve global voice coverage?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Price: "We use grey-route providers because their international calling rates are much cheaper."',
        response: 'Grey routes suffer from severe latency, constant call drops, and sudden blockages. Airtel Global Voice utilizes Tier-1 interconnects to guarantee premium voice quality, which directly improves your agents\' success rates and customer satisfaction.',
      ),
      ObjectionHandling(
        objection: 'Migration: "Switching our international SIP trunks sounds technically complex."',
        response: 'Using the Airtel Advantage Online Voice Platform, you can establish quick A-Z interconnects using standard SIP protocols, enabling a seamless transition without hardware changes.',
      ),
      ObjectionHandling(
        objection: 'Coverage: "Do you have direct routes to remote emerging markets?"',
        response: 'Airtel is the second largest telecom player globally, possessing 1200+ direct interconnects and deep market penetration directly into Africa and South Asia, minimizing third-party hops.',
      )
    ],
    crossSellProducts: [
      'Airtel SIP Trunking',
      'Airtel Dedicated Internet (ILL)'
    ],
    idealIndustries: [
      'IT & ITES',
      'Travel & Tourism',
      'E-Commerce',
      'Telecom & Carriers'
    ],
    officialSourceUrls: [
      'PRODUCTS.docx (GLOBAL VOICE section)'
    ],
    verificationStatus: 'Fully Verified',
  ),

  'prod_iot': const EnrichedProduct(
    productName: 'Airtel IoT Connectivity',
    whatItIs: 'A scalable M2M (Machine-to-Machine) connectivity solution powered by 5G and NB-IoT, managed centrally through the Airtel IoTHub platform for real-time device control.',
    whenToPitch: 'Pitch when a business needs to track fleets, monitor smart meters, automate industrial assets, or manage thousands of remote point-of-sale machines securely.',
    openingHook: 'Managing thousands of distributed IoT assets becomes incredibly expensive if technicians have to constantly visit the field for diagnostics. How are you centralizing visibility and control over your remote connected devices?',
    positioningStatement: 'Position IoT Connectivity as an operational intelligence platform, not just "SIM cards". Focus heavily on the IoTHub dashboard which enables bulk management, diagnostics, and security at scale.',
    whenNotToPitch: [
      'Customer only needs internet for human employees (laptops/phones).',
      'Customer operates entirely within a single small building using Wi-Fi.',
      'Customer has no distributed physical assets or logistics operations.'
    ],
    customerSignals: [
      'Logistics companies losing visibility of high-value shipments in transit',
      'Utilities struggling to collect data manually from remote utility meters',
      'Inability to diagnose why remote machines (like ATMs or vending machines) go offline'
    ],
    businessOutcomes: [
      'Monitor and manage thousands of connected assets in real-time through a single dashboard (IoTHub)',
      'Reduce field maintenance costs by diagnosing device issues remotely',
      'Ensure secure data transmission with encrypted, dedicated private APNs',
      'Future-proof deployments with readiness for 5G and NB-IoT technologies'
    ],
    discoveryHooks: [
      'How are you currently tracking the location and health of your distributed physical assets in real-time?',
      'What is the operational cost of sending technicians to the field simply to manually read meters or diagnose offline machines?',
      'How are you securing the data transmitted by your remote devices against interception?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Coverage: "Our assets travel through remote areas where cellular networks are unreliable."',
        response: 'Airtel provides nationwide coverage and supports NB-IoT (Narrowband IoT), which penetrates deep underground and inside buildings where traditional cellular signals fail.',
      ),
      ObjectionHandling(
        objection: 'Management: "Managing data plans for 10,000 separate SIM cards is administratively impossible."',
        response: 'The Airtel IoTHub platform aggregates all your devices into a single pane of glass, allowing you to automate lifecycle management, pool data usage, and detect anomalies instantly.',
      ),
      ObjectionHandling(
        objection: 'Security: "IoT devices are notorious entry points for hackers to access the corporate network."',
        response: 'Airtel IoT secures data at the network level by routing traffic through a private, secure APN, ensuring device data never touches the public internet.',
      )
    ],
    crossSellProducts: [
      'Airtel Public Cloud',
      'Airtel 5G for Enterprise'
    ],
    idealIndustries: [
      'Automotive',
      'Logistics',
      'Manufacturing',
      'Energy & Utilities'
    ],
    officialSourceUrls: [
      'PRODUCTS.docx (IOT section)'
    ],
    verificationStatus: 'Fully Verified',
  ),

  'prod_office_internet': const EnrichedProduct(
    productName: 'Airtel Office Internet',
    whatItIs: 'A business-grade broadband solution delivering up to 1 Gbps speeds, bundled with a free static IP, Cisco DNS security, and parallel ringing for enterprise mobility.',
    whenToPitch: 'Pitch to SMEs, branch offices, or retail stores that need fast, secure internet but do not require the dedicated SLA and cost of an Internet Leased Line.',
    openingHook: 'Many small offices and retail chains expose themselves to cyber threats by relying on standard consumer broadband. How are you ensuring your branch offices have enterprise-grade security layered directly into their internet connection?',
    positioningStatement: 'Position this as a secure, all-in-one "Business in a Box" for SMEs. Lead with the bundled value of the free Static IP and built-in Cisco DNS security, separating it from cheap consumer broadband.',
    whenNotToPitch: [
      'Customer runs a massive data center requiring guaranteed symmetric SLAs.',
      'Customer requires complex multi-site routing (pitch SD-WAN).',
      'Customer is an enterprise headquarters with thousands of employees.'
    ],
    customerSignals: [
      'Small offices struggling with consumer-grade broadband dropping out',
      'Retail stores needing a static IP for surveillance cameras or secure POS systems',
      'Businesses wanting basic network security without buying expensive firewalls'
    ],
    businessOutcomes: [
      'Host web applications and access remote servers securely using the included free Static IP',
      'Block malicious websites and ransomware automatically with integrated Cisco DNS Security',
      'Ensure employees never miss desk calls via parallel ringing to their mobile devices',
      'Reclaim 18% GST through official corporate billing'
    ],
    discoveryHooks: [
      'Are you using a consumer broadband connection that lacks security and dedicated business support?',
      'Do you need a Static IP to remotely access your office CCTV or local servers?',
      'How are you currently protecting your office devices from malicious websites and malware?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Performance: "We need dedicated bandwidth, not a shared broadband connection."',
        response: 'If your business requires guaranteed, uncontended bandwidth and stringent SLAs, we can upgrade you to Airtel Dedicated Internet (ILL). Office Internet is designed for high-speed but cost-effective asymmetric usage.',
      ),
      ObjectionHandling(
        objection: 'Cost: "Local broadband providers offer cheaper monthly rates."',
        response: 'Local providers offer consumer-grade lines without enterprise security. Airtel Office Internet includes a free Static IP, Cisco DNS Security, Kaspersky licenses, and 18% GST input credit, making the true business value much higher.',
      ),
      ObjectionHandling(
        objection: 'Security: "We already have basic antivirus on our laptops."',
        response: 'Antivirus only protects the device after a threat arrives. The included Cisco DNS Security blocks malicious domains at the network level before they ever reach your employees\' devices.',
      )
    ],
    crossSellProducts: [
      'Airtel Corporate Postpaid',
      'Airtel IQ Business Connect'
    ],
    idealIndustries: [
      'Retail',
      'Education',
      'Hospitality',
      'IT & ITES'
    ],
    officialSourceUrls: [
      'PRODUCTS.docx (OFFICE INTERNET section)'
    ],
    verificationStatus: 'Fully Verified',
  ),

  'prod_precise_positioning': const EnrichedProduct(
    productName: 'Airtel Precise Positioning',
    whatItIs: 'A high-accuracy location service utilizing RTK (Real-Time Kinematic) technology over the cellular network to provide centimeter-level GPS accuracy for autonomous operations.',
    whenToPitch: 'Pitch to logistics, agriculture, or drone operators where standard 5-meter GPS accuracy is insufficient for automation or precision tracking.',
    openingHook: 'For autonomous operations and drone delivery, standard GPS variance of 5 meters is dangerous and unacceptable. How are you achieving the centimeter-level accuracy required to safely automate your high-value assets?',
    positioningStatement: 'Position this as an infrastructure-free automation enabler. Customers no longer need to build and maintain expensive proprietary ground reference stations to achieve RTK accuracy.',
    whenNotToPitch: [
      'Customer only tracks standard delivery trucks where street-level GPS is fine.',
      'Customer has no autonomous, drone, or precision agricultural use cases.',
      'Customer assets operate entirely indoors with no GPS visibility.'
    ],
    customerSignals: [
      'Drone delivery companies struggling with landing accuracy',
      'Mining or agriculture firms deploying autonomous vehicles that require exact routing',
      'Standard GPS drifting causing tracking errors in dense urban environments'
    ],
    businessOutcomes: [
      'Enable autonomous vehicle and drone operations with centimeter-level precision',
      'Eliminate the need to build and maintain expensive proprietary ground reference stations',
      'Improve route optimization and asset tracking accuracy in dense industrial environments',
      'Accelerate time-to-market for precision applications using Airtel\'s existing cellular infrastructure'
    ],
    discoveryHooks: [
      'Is the standard 5-meter variance of commercial GPS preventing you from fully automating your vehicles or drones?',
      'How much capital are you spending to build proprietary ground stations to correct GPS signals?',
      'Are you experiencing signal drift when tracking high-value assets in dense urban environments?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Coverage: "Does this precision tracking work in remote agricultural areas?"',
        response: 'The service relies on Airtel\'s extensive cellular network to deliver correction data. We provide feasibility maps to ensure your specific operational zones have the required coverage.',
      ),
      ObjectionHandling(
        objection: 'Hardware: "Will we need to buy completely new tracking hardware?"',
        response: 'The service works with most RTK-compatible GNSS receivers. We provide the correction data stream via standard protocols (NTRIP), which easily integrates into modern precision hardware.',
      ),
      ObjectionHandling(
        objection: 'Cost: "Is this significantly more expensive than standard GPS?"',
        response: 'While standard GPS is free, it cannot support autonomous operations. Precise Positioning removes the massive capital expense of building your own RTK infrastructure, converting it into an affordable service.',
      )
    ],
    crossSellProducts: [
      'Airtel IoT Connectivity',
      'Airtel 5G for Enterprise'
    ],
    idealIndustries: [
      'Logistics',
      'Automotive',
      'Manufacturing',
      'Energy & Utilities'
    ],
    officialSourceUrls: [
      'Derived from standard Airtel Precise Positioning capabilities'
    ],
    verificationStatus: 'Partially Verified',
  ),

  'prod_public_cloud': const EnrichedProduct(
    productName: 'Airtel Public Cloud',
    whatItIs: 'A telco-grade, sovereign public cloud infrastructure hosted entirely within India, offering compute, storage, and a unified Cloud Management Platform (CMP).',
    whenToPitch: 'Pitch when organizations are mandated to keep data within India, want to escape unpredictable egress fees from global hyperscalers, or need a single vendor for both connectivity and cloud.',
    openingHook: 'Many enterprises find themselves trapped by unpredictable data egress fees and sovereignty concerns when dealing with global hyperscalers. How are you balancing cloud scale with strict local regulatory compliance?',
    positioningStatement: 'Position Airtel Public Cloud as a compliance-first, sovereign cloud layer rather than a direct AWS/Azure replacement. Emphasize low egress fees and seamless hybrid orchestration.',
    whenNotToPitch: [
      'Customer requires highly specialized AI/ML PaaS services only AWS/Google can provide.',
      'Customer operates a global application requiring data centers in US/EU.',
      'Customer is entirely locked into a 5-year enterprise agreement with a hyperscaler.'
    ],
    customerSignals: [
      'Organizations facing strict data residency and sovereignty regulations',
      'CIOs complaining about opaque billing and high data egress charges from AWS/Azure',
      'Enterprises looking to migrate legacy workloads without refactoring them for hyperscalers'
    ],
    businessOutcomes: [
      'Achieve strict data residency and compliance with infrastructure hosted exclusively in India',
      'Reduce total cost of ownership (TCO) with minimal data egress charges and transparent pricing',
      'Gain unified visibility and cost optimization across multi-cloud environments via the Cloud Management Platform',
      'Simplify vendor management by procuring both secure connectivity and cloud from Airtel'
    ],
    discoveryHooks: [
      'Are you facing regulatory pressure to ensure your customer data physically remains within India?',
      'How are you currently managing the unpredictable data egress costs associated with global hyperscalers?',
      'Do you have unified visibility into your cloud spend across different departments and platforms?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Ecosystem: "Global hyperscalers offer hundreds of specialized AI and PaaS services that you don\'t."',
        response: 'Airtel Public Cloud excels at robust, secure Infrastructure-as-a-Service (IaaS) for core workloads. For specialized PaaS, our Cloud Management Platform allows you to manage a hybrid environment seamlessly alongside hyperscalers.',
      ),
      ObjectionHandling(
        objection: 'Reliability: "Is a telco cloud as reliable as established global cloud providers?"',
        response: 'Airtel Cloud is built on our own tier-rated Nxtra data centers with 99.99% uptime, integrated directly into our core network for superior connectivity and resilience.',
      ),
      ObjectionHandling(
        objection: 'Migration: "Migrating our existing workloads sounds highly disruptive."',
        response: 'Airtel provides end-to-end managed migration services, enabling secure, fast data transfer over our private network without disrupting your ongoing business operations.',
      )
    ],
    crossSellProducts: [
      'Airtel Dedicated Internet (ILL)',
      'Airtel Secure Internet',
      'Airtel VPN/MPLS'
    ],
    idealIndustries: [
      'Banking & Financial Services',
      'Government',
      'Healthcare',
      'Manufacturing'
    ],
    officialSourceUrls: [
      'PRODUCTS.docx (PUBLIC CLOUD section)'
    ],
    verificationStatus: 'Fully Verified',
  ),

  'prod_secure_internet': const EnrichedProduct(
    productName: 'Airtel Secure Internet',
    whatItIs: 'An integrated connectivity and security solution combining Airtel\'s reliable internet leased lines with cloud-delivered security (Zscaler SSE) or on-premise Fortinet firewalls.',
    whenToPitch: 'Pitch when an enterprise is struggling to manage multiple security vendors, moving to a hybrid work model, or facing increased threats like ransomware and DDoS attacks.',
    openingHook: 'As cyber threats become more sophisticated, managing disparate firewalls and network vendors creates dangerous security gaps. How are you unifying your network connectivity and threat protection to eliminate operational silos?',
    positioningStatement: 'Position this as a consolidation and risk-reduction play. The value is a "single throat to choke" when an outage or attack occurs. Sell the 24x7 SOC monitoring so the customer\'s IT team can sleep at night.',
    whenNotToPitch: [
      'Customer just heavily invested in a massive fleet of Palo Alto firewalls.',
      'Customer IT team strictly mandates managing all security policies natively with no MSP involvement.',
      'Customer operates a small cafe with no sensitive corporate data.'
    ],
    customerSignals: [
      'IT team overwhelmed by managing disjointed firewalls and security policies across locations',
      'Concerns about remote employees accessing corporate applications via untrusted home networks',
      'Recent compliance audits flagging legacy network vulnerabilities'
    ],
    businessOutcomes: [
      'Eliminate the complexity of managing disparate network and security vendors',
      'Protect applications with Zero Trust Architecture, verifying every user before granting access',
      'Prevent lateral movement of threats through effective network micro-segmentation',
      'Reduce downtime through proactive 24/7 monitoring by Airtel\'s Security Operations Center (SOC)'
    ],
    discoveryHooks: [
      'How are you ensuring that remote employees accessing your network from home are fully authenticated and secure?',
      'Are you purchasing internet connectivity from one vendor and firewall hardware from another?',
      'How quickly can your current IT team detect and isolate a ransomware threat before it spreads laterally?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Existing Investments: "We recently purchased expensive firewalls for our data center."',
        response: 'Airtel Secure Internet can be delivered as a Cloud Security Service Edge (SSE), protecting your distributed branches and remote users without requiring you to rip and replace your core data center firewalls.',
      ),
      ObjectionHandling(
        objection: 'Control: "We prefer to manage our own security policies rather than relying on a managed service."',
        response: 'We offer co-managed models where your IT team retains full control over security policies via the central dashboard, while Airtel handles the tedious 24/7 monitoring and threat intelligence updates.',
      ),
      ObjectionHandling(
        objection: 'Vendor Lock-in: "Bundling internet and security makes it hard to change providers later."',
        response: 'Consolidation provides single-point accountability. When security and connectivity are integrated, resolution times drop dramatically because there is no finger-pointing between the ISP and the firewall vendor.',
      )
    ],
    crossSellProducts: [
      'Airtel SD-WAN',
      'Airtel Work From Anywhere Solutions'
    ],
    idealIndustries: [
      'Banking & Financial Services',
      'Healthcare',
      'IT & ITES',
      'E-Commerce'
    ],
    officialSourceUrls: [
      'PRODUCTS.docx (SECURE INTERNET & AIRTEL DIGITAL SECURE INTERNET sections)'
    ],
    verificationStatus: 'Fully Verified',
  ),

  'prod_whatsapp_business': const EnrichedProduct(
    productName: 'Airtel WhatsApp Business',
    whatItIs: 'An enterprise-grade WhatsApp API solution that converts WhatsApp into a secure, automated, two-way customer engagement channel capable of handling rich media and transactions.',
    whenToPitch: 'Pitch when marketing campaigns face low SMS open rates, or when customer support teams are overwhelmed by routine queries that could be handled via chatbots.',
    openingHook: 'Traditional SMS marketing is suffering from extreme fatigue and low engagement rates, while support queues are bursting with routine queries. How are you shifting your customer interactions to the channels they actually prefer to use daily?',
    positioningStatement: 'Position WhatsApp API as a conversion and deflection engine. It converts marketing into interactive sales, and deflects expensive human support calls into automated bot resolutions.',
    whenNotToPitch: [
      'Customer only needs to send a few hundred messages a month (use a standard WhatsApp Business App).',
      'Customer audience is not active on WhatsApp (e.g., highly specific B2B sectors).',
      'Customer refuses to invest in any CRM or chatbot orchestration logic.'
    ],
    customerSignals: [
      'Marketing teams complaining about poor engagement and ROI from traditional SMS blasts',
      'Customer service queues overflowing with repetitive questions like "Where is my order?"',
      'E-commerce brands suffering from high cart abandonment rates'
    ],
    businessOutcomes: [
      'Boost campaign ROI through rich media messaging (images, videos, documents) and higher open rates',
      'Reduce customer support costs by deflecting routine queries to intelligent WhatsApp bots',
      'Increase conversion rates by sending personalized, interactive cart abandonment reminders',
      'Build trust with a verified business profile (Green Tick) and end-to-end encrypted conversations'
    ],
    discoveryHooks: [
      'What are the current open and engagement rates for your standard SMS marketing campaigns?',
      'How much of your customer support team\'s time is spent answering routine order status queries?',
      'Are you able to securely share rich media like invoices, tickets, or product catalogs directly to your customers\' phones?'
    ],
    commonObjections: [
      ObjectionHandling(
        objection: 'Spam: "Customers hate receiving marketing messages on their personal WhatsApp."',
        response: 'WhatsApp requires explicit customer opt-in and enforces strict quality limits to prevent spam. This ensures your messages only reach an engaged audience, resulting in significantly higher conversion rates.',
      ),
      ObjectionHandling(
        objection: 'Implementation: "Integrating a WhatsApp bot into our CRM sounds technically complex."',
        response: 'Airtel IQ provides out-of-the-box integrations with major CRMs and a Campaign Manager portal, allowing you to execute campaigns and deploy bots without heavy developer reliance.',
      ),
      ObjectionHandling(
        objection: 'Cost: "WhatsApp API messages cost more per interaction than standard SMS."',
        response: 'While the per-message cost is higher, the ROI is vastly superior due to near-100% open rates and interactive buttons that drive immediate action, ultimately lowering your customer acquisition cost.',
      )
    ],
    crossSellProducts: [
      'Airtel CPaaS',
      'Airtel Contact Center as a Service'
    ],
    idealIndustries: [
      'Retail',
      'E-Commerce',
      'Banking & Financial Services',
      'Travel & Tourism'
    ],
    officialSourceUrls: [
      'PRODUCTS.docx (WHATSAPP API section)'
    ],
    verificationStatus: 'Fully Verified',
  ),
};
