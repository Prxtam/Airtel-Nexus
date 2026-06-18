import 'dart:io';

void main() {
  final scenarios = [
    {
      'product': 'Airtel Public Cloud',
      'objection': 'We already use AWS',
      'industry': 'Banking'
    },
    {
      'product': 'Airtel Secure Internet',
      'objection': 'We already have Palo Alto firewalls',
      'industry': 'Healthcare'
    },
    {
      'product': 'Airtel Managed SD-WAN',
      'objection': 'We just renewed MPLS for 5 years',
      'industry': 'Manufacturing'
    },
    {
      'product': 'Airtel IoT Connectivity',
      'objection': 'We are worried about security',
      'industry': 'Manufacturing'
    },
    {
      'product': 'Airtel WhatsApp Business',
      'objection': 'Customers will see this as spam',
      'industry': 'Retail'
    },
  ];

  for (final s in scenarios) {
    print('---');
    print('SCENARIO: ${s['product']} + "${s['objection']}" + ${s['industry']}');
    final out = generateResponse(s['product']!, s['objection']!, s['industry']!);
    print('🫱 Acknowledge: ${out['acknowledge']}');
    print('🔍 Probe Further:');
    for (final p in out['probe']) print('  - $p');
    print('🎯 Reframe: ${out['reframe']}');
    print('💡 Position Airtel:');
    for (final p in out['positioning']) print('  - $p');
    print('🗣 Suggested Response: ${out['response']}');
    print('');
  }
}

Map<String, dynamic> generateResponse(String product, String objection, String industry) {
  final objLower = objection.toLowerCase();
  String category = 'General';

  if (objLower.contains('aws') || objLower.contains('palo alto') || objLower.contains('renewed') || objLower.contains('already use') || objLower.contains('already have')) {
    category = 'Existing Vendor';
  } else if (objLower.contains('security') || objLower.contains('secure')) {
    category = 'Security';
  } else if (objLower.contains('spam')) {
    category = 'Vendor Trust';
  }

  String ack = '';
  List<String> probe = [];
  String reframe = '';
  List<String> pos = [];
  String resp = '';

  if (category == 'Existing Vendor') {
    ack = "That makes sense. Many of our largest $industry clients run a multi-vendor strategy or started with that exact setup.";
    probe = [
      "What specific limitations or cost-overruns are you currently facing with your existing setup?",
      "Are you open to exploring a complementary solution if it significantly improves resilience or lowers TCO?"
    ];
    if (product.contains('Cloud')) {
      reframe = "This isn't about replacing AWS immediately. It's about identifying specific workloads that benefit from localized, sovereign infrastructure.";
      pos = ['Sovereign infrastructure (Data stays in India)', 'Zero egress fees', 'Managed services layer included'];
      resp = "We recognize AWS is a strong platform for certain workloads. However, for your sensitive banking data, our sovereign cloud ensures strict compliance with local regulations, and we eliminate the unpredictable data egress fees you are likely paying today. How are you currently managing data sovereignty requirements?";
    } else if (product.contains('Secure Internet')) {
      reframe = "This isn't about ripping out Palo Alto. It's about securing the network layer itself before threats even reach your perimeter firewall.";
      pos = ['Clean pipe network-level security', 'DDoS protection baked-in', 'Complementary to existing edge firewalls'];
      resp = "Palo Alto makes excellent edge devices. What we provide is 'Clean Pipe' security—we stop volumetric DDoS and known threats within our core network before they ever hit your Palo Alto firewalls, ensuring your bandwidth isn't choked by malicious traffic.";
    } else if (product.contains('SD-WAN')) {
      reframe = "This isn't about breaking your MPLS contract. It's about overlaying SD-WAN to intelligently route traffic and prepare for a hybrid network architecture.";
      pos = ['Transport-agnostic overlay', 'Centralized orchestration', 'Optimized cloud application performance'];
      resp = "Many of our clients use Airtel SD-WAN to overlay their existing MPLS links. This allows you to immediately gain centralized visibility, prioritize critical manufacturing applications, and gradually introduce cheaper broadband links for non-critical traffic without touching your MPLS contract.";
    }
  } else if (category == 'Security') {
    ack = "That's a very valid concern. Security is the foundation of any enterprise architecture we deploy, especially in $industry.";
    probe = [
      "Are there specific vulnerabilities or compliance mandates you are trying to address?",
      "How are you currently managing visibility and threat detection across your edge devices?"
    ];
    if (product.contains('IoT')) {
      reframe = "This isn't just about providing SIM cards. It's about providing a private, encrypted tunnel for your IoT traffic that never touches the public internet.";
      pos = ['Airtel IoT platform with deep visibility', 'Private APN configurations', 'End-to-end encryption'];
      resp = "Security is actually our biggest differentiator here. We don't just provide connectivity; we offer Private APNs and a dedicated IoT management platform. This means your manufacturing sensor data travels through a secure, encrypted tunnel entirely isolated from the public internet.";
    }
  } else if (category == 'Vendor Trust') {
    ack = "That's a critical point. The last thing you want is for a new channel to degrade your customer experience.";
    probe = [
      "How are you currently measuring engagement and opt-out rates on your messaging channels?",
      "What use cases do you currently rely on SMS or email for?"
    ];
    if (product.contains('WhatsApp')) {
      reframe = "This isn't about broadcasting spam. It's about shifting from one-way notifications to secure, two-way conversational commerce that customers actually opt into.";
      pos = ['Official Meta API partner', 'Strict opt-in template controls', 'Verified business profile (Green Tick)'];
      resp = "WhatsApp Business API strictly enforces spam prevention through template approvals and user opt-ins. Instead of spamming, this allows you to send high-value notifications like order updates or personalized offers from a Verified Green Tick account, which significantly increases customer trust and engagement compared to standard SMS.";
    }
  }

  return {
    'acknowledge': ack,
    'probe': probe,
    'reframe': reframe,
    'positioning': pos,
    'response': resp
  };
}
