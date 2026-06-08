import 'package:frontend/features/airtel_iq/models/airtel_iq_models.dart';

class AirtelIqMockData {
  static const List<AirtelProduct> products = [
    AirtelProduct(
      id: 'p1',
      name: 'Airtel IQ Business Connect',
      category: 'Unified Communications',
      shortDescription: 'Omni-channel tool for field force with WhatsApp integration and virtual PBX.',
      overview: 'IQ Business Connect provides a unified communication app (Vonage Business app) for mobile and desktop, enabling clear, tracked communication using Virtual Mobile Numbers (VMN). It replaces unmonitored personal numbers with a secure, managed PBX-like system.',
      businessBenefits: [
        'No heavy Capex required for on-premise PBX',
        'Visibility into field force communication via Call Dashboards',
        'Data retention even if field force employees switch jobs',
        'Omni-channel experience combining chat, calls, and WhatsApp'
      ],
      idealCustomerTypes: [
        'SMBs with field sales or service forces',
        'Home service management companies',
        'Banking and financial institutions requiring relationship continuity'
      ],
      keyDifferentiators: [
        'Seamless Call Flip between desktop and mobile app',
        'Virtual Receptionist for streamlining call routing',
        'WhatsApp for Business integration right into the app'
      ],
      typicalUseCases: [
        'Field force taking calls on-the-go',
        'Tracking manpower and service coordination',
        'Ensuring leads are not lost when account managers change'
      ],
    ),
    AirtelProduct(
      id: 'p2',
      name: 'Airtel Corporate Postpaid (Mobility)',
      category: 'Mobility',
      shortDescription: 'Enterprise mobility plans featuring 5G Plus, Perplexity Pro AI, and Trace Mate.',
      overview: 'Airtel Corporate Postpaid offers robust mobile data and voice plans designed for modern hybrid and remote work. It leverages the Airtel 5G Plus network and includes AI-powered fraud protection at the network level.',
      businessBenefits: [
        'Save 18% GST on total rental',
        'Data Rollover allows keeping unused data',
        'Included 12-month Perplexity Pro AI subscription worth ₹17,000',
        'AI-powered Fraud Detection blocking phishing attacks in real-time'
      ],
      idealCustomerTypes: [
        'Enterprises needing reliable connectivity for remote teams',
        'Companies providing COCP (Corporate Owned Corporate Paid) devices',
        'Businesses needing resource tracking (Trace Mate)'
      ],
      keyDifferentiators: [
        'Only telco in India offering intelligent link protection at network level',
        'No lag video calls on the widest 5G network',
        'Perplexity Pro AI included at no extra cost'
      ],
      typicalUseCases: [
        'Remote and hybrid workforce connectivity',
        'International roaming (Airtel World pass) for travelling executives',
        'Resource tracking using the Trace Mate facility'
      ],
    ),
  ];

  static const List<KnowledgeArticle> articles = [
    KnowledgeArticle(
      id: 'a1',
      title: 'Leveraging Airtel 5G Plus for Enterprise',
      category: 'Connectivity',
      summary: 'How 5G transforms business operations with networking slicing and high speeds.',
      readTime: '3 min read',
      content: 'Airtel 5G Plus offers superfast speeds and the widest technology acceptance in India. It enables "Network Slicing" for differential quality needs and is the most energy-efficient, eco-friendly technology. For enterprises, this means no lag on video calls and instant uploading of heavy files on the go. We currently serve 8 Million corporate postpaid customers across 1.5 lac 5G sites in India.',
      keyTakeaways: [
        'First operator to rollout 5G network live across India.',
        '100% network assurance across all circles through a single spoke.',
        'Eco-friendly and energy-efficient infrastructure.'
      ],
    ),
    KnowledgeArticle(
      id: 'a2',
      title: 'Airtel Safe Network & Fraud Protection',
      category: 'Security',
      summary: 'Understanding Airtel\'s AI-powered Fraud Detection solution built into the network.',
      readTime: '4 min read',
      content: 'Airtel is the only telco in India offering intelligent link protection at the network level. The AI-powered Fraud Detection solution detects and blocks phishing attacks and malicious links in real time across browsers, emails, and apps like WhatsApp, Instagram, and Telegram. There are no apps to install, no tools to configure, and no setup required. It automatically protects all enterprise users from spam, real-time fraud, and malicious links.',
      keyTakeaways: [
        'Built directly into the network—no apps needed.',
        'Blocks phishing attacks in real-time across multiple platforms.',
        'Protects sensitive company data automatically.'
      ],
    ),
    KnowledgeArticle(
      id: 'a3',
      title: 'Airtel World Pass: International Roaming Explained',
      category: 'Mobility',
      summary: 'Why Airtel World pass is the smarter choice compared to local SIMs.',
      readTime: '5 min read',
      content: 'Airtel World pass is one pack for the world, covering 184 countries (including layover locations). It requires no extra documents, offers usage tracking, and alerts for financial safety. Compared to local SIMs or competitors (which can be 60% more expensive and cover fewer countries), Airtel automatically activates the pack when you land. It includes unlimited data (with FUP throttle) and free incoming SMS.',
      keyTakeaways: [
        'One pack covers 184 countries.',
        'Auto-activates upon landing.',
        'Includes in-flight roaming on supported airlines.'
      ],
    ),
  ];

  static const List<FaqItem> faqs = [
    FaqItem(
      id: 'f1',
      category: 'Mobility',
      question: 'What happens to unused data on Corporate Postpaid plans?',
      answer: 'Airtel offers a Data Rollover feature. Unused data from the previous month is added to the current month\'s allowance (applicable on specific plans). Note that plan downgrades lead to the loss of accumulated data.',
    ),
    FaqItem(
      id: 'f2',
      category: 'Mobility',
      question: 'Is the Perplexity Pro AI subscription included in all plans?',
      answer: 'Corporate Plans include a 12-month subscription of Perplexity Pro AI worth ₹17,000 for a year at no extra cost, enabling employees to analyze complex files and receive real-time citations.',
    ),
    FaqItem(
      id: 'f3',
      category: 'Unified Communications',
      question: 'What is the cost of a Virtual Mobile Number (VMN) on IQ Business Connect?',
      answer: 'Each Virtual Mobile Number (VMN) costs ₹399 per month.',
    ),
    FaqItem(
      id: 'f4',
      category: 'Unified Communications',
      question: 'Can the field force retain their numbers when they leave?',
      answer: 'With IQ Business Connect, the numbers are owned by the enterprise. The business retains the contact numbers and customer data, ensuring communication consistency and security even if an employee switches jobs.',
    ),
    FaqItem(
      id: 'f5',
      category: 'Mobility',
      question: 'How does the Trace Mate facility work?',
      answer: 'Trace Mate is a resource tracking tool that allows companies to easily track their manpower and location over a utility, enhancing accountability, time management, and safety.',
    ),
  ];

  static const List<SalesPlaybook> playbooks = [
    SalesPlaybook(
      id: 'pb1',
      industry: 'Banking & Financial Services',
      overview: 'Selling communication solutions to BFS clients who prioritize security, relationship continuity, and operational efficiency.',
      painPoints: [
        'When an employee leaves, leads are often passed to competitors.',
        'Communication over personal numbers lacks visibility and security.',
        'High compliance requirements for call recording and auditing.'
      ],
      recommendedSolutions: [
        'Airtel IQ Business Connect',
        'Airtel Safe Network Postpaid Plans'
      ],
      discoveryQuestions: [
        'How do you currently track conversations between your relationship managers and high-net-worth clients?',
        'What happens to client communication when an account manager leaves your firm?',
        'Are your current mobile communications protected against phishing and malicious links?'
      ],
      crossSellOpportunities: [
        'Trace Mate for tracking field loan recovery agents',
        'Airtel Office Internet for branch connectivity'
      ],
    ),
    SalesPlaybook(
      id: 'pb2',
      industry: 'Home Services & Logistics',
      overview: 'Targeting companies that deploy large field forces requiring reliable connectivity and tracking.',
      painPoints: [
        'Employees misrepresenting their departure or location.',
        'Poor connectivity in remote areas delaying service updates.',
        'Need for a unified tool combining chat and calls on the go.'
      ],
      recommendedSolutions: [
        'Airtel Corporate Postpaid with Trace Mate',
        'Airtel IQ Business Connect'
      ],
      discoveryQuestions: [
        'How do you currently verify that your service agents have arrived at the customer location?',
        'Are your agents using separate apps for calls, chat, and WhatsApp?',
        'Do you experience connectivity drop-offs in remote areas?'
      ],
      crossSellOpportunities: [
        'Mi-Fi Hotspots for teams travelling in groups',
        'Data Pool plans for aggregate data usage'
      ],
    ),
  ];

  static const List<Objection> objections = [
    Objection(
      id: 'o1',
      category: 'Pricing',
      objection: 'Airtel pricing is higher than our current local provider.',
      recommendedResponse: 'While our base rental might appear slightly higher, Airtel Corporate Postpaid plans allow you to save 18% GST on the total rental. Furthermore, we include high-value add-ons like Perplexity Pro AI (worth ₹17,000/year) and network-level AI Fraud Protection at no extra cost, making the total cost of ownership significantly lower while providing enterprise-grade security.',
      suggestedFollowUp: 'Are you currently paying separately for enterprise AI tools or mobile security software?',
    ),
    Objection(
      id: 'o2',
      category: 'Competition',
      objection: 'Competitor X offers cheaper International Roaming packs.',
      recommendedResponse: 'Competitor packs are often 60% more expensive when factoring in the limited coverage (they cover ~81 countries vs our 184). Additionally, their packs often require you to specify the exact date of travel, whereas Airtel World Pass auto-activates when you land and covers layover destinations natively.',
      suggestedFollowUp: 'Have your executives ever faced bill shocks or lack of coverage during layovers in destinations like Dubai?',
    ),
    Objection(
      id: 'o3',
      category: 'Technical Concerns',
      objection: 'Setting up a new PBX system will require heavy Capex and downtime.',
      recommendedResponse: 'That is exactly why we introduced Airtel IQ Business Connect. It is a completely cloud-based Virtual PBX. There is zero heavy Capex required for on-premise deployment, and your team can simply download the Vonage Business app on their existing smartphones and desktops.',
      suggestedFollowUp: 'Would a cloud-based solution that activates in days rather than weeks align better with your IT budget?',
    ),
    Objection(
      id: 'o4',
      category: 'Security',
      objection: 'We use MDM, so we don\'t need your network security.',
      recommendedResponse: 'MDM is great for device management, but our AI-powered Fraud Detection operates at the network level. It detects and blocks phishing attacks and malicious links in real-time across browsers and apps (like WhatsApp) before they even reach the device OS. It acts as a zero-setup first line of defense.',
      suggestedFollowUp: 'How often do your employees click links in personal WhatsApp messages on their corporate devices?',
    ),
  ];
}
