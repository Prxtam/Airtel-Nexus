import 'dart:io';

void main() {
  final scenarios = [
    {'product': 'Airtel Public Cloud', 'industry': 'Banking & Financial Services'},
    {'product': 'Airtel Secure Internet', 'industry': 'Healthcare'},
    {'product': 'Airtel Managed SD-WAN', 'industry': 'Manufacturing'},
    {'product': 'Airtel WhatsApp Business', 'industry': 'Retail & eCommerce'},
    {'product': 'Airtel IoT Connectivity', 'industry': 'Manufacturing'},
  ];

  for (final s in scenarios) {
    print('---');
    print('SCENARIO: ${s['product']} + ${s['industry']}');
    final out = generateTop5Objections(s['product']!, s['industry']!);
    for (int i = 0; i < out.length; i++) {
      print('${i + 1}. ${out[i]}');
    }
    print('');
  }
}

List<String> generateTop5Objections(String product, String industry) {
  List<String> baseProductObjections = [];
  if (product.contains('Cloud')) {
    baseProductObjections = [
      'We already use AWS/Azure.',
      'Data migration is too complex and risky.',
      'Public clouds are too expensive compared to our on-prem setup.',
      'We lose control over our own infrastructure.',
      'Our team lacks the skills to manage a new cloud environment.',
    ];
  } else if (product.contains('Secure Internet')) {
    baseProductObjections = [
      'We already have Palo Alto firewalls at the edge.',
      'Adding another vendor complicates our security stack.',
      'This seems too expensive just for internet connectivity.',
      'Our internal IT team manages all security appliances.',
      'We just renewed our current firewall licenses.',
    ];
  } else if (product.contains('SD-WAN')) {
    baseProductObjections = [
      'We just renewed our MPLS contract for 5 years.',
      'Internet broadband is not reliable enough for our branch traffic.',
      'Replacing our edge routers is too expensive.',
      'The migration process will cause too much downtime.',
      'Our team is not trained on software-defined networking.',
    ];
  } else if (product.contains('WhatsApp')) {
    baseProductObjections = [
      'Customers will see this as annoying spam.',
      'WhatsApp API is too expensive compared to SMS.',
      'It is too complicated to integrate with our CRM.',
      'We do not have a team to handle two-way conversations.',
      'SMS works just fine for our OTPs and alerts.',
    ];
  } else if (product.contains('IoT')) {
    baseProductObjections = [
      'We are worried about IoT endpoint security and hacking.',
      'It is too expensive to outfit all our remote assets.',
      'We cannot afford downtime if the cellular network drops.',
      'Managing thousands of SIMs manually is a nightmare.',
      'We do not have the technical expertise to integrate sensor data.',
    ];
  }

  List<String> indObjections = [];
  if (industry.contains('Banking')) {
    indObjections = [
      'Security concerns regarding public cloud migration',
      'Compliance concerns with CPaaS providers',
      'Data residency rules prevent us from using global solutions'
    ];
  } else if (industry.contains('Healthcare')) {
    indObjections = [
      'HIPAA / patient data privacy compliance concerns',
      'We cannot risk network downtime affecting patient care',
    ];
  } else if (industry.contains('Manufacturing')) {
    indObjections = [
      'Industrial environments are too harsh for standard equipment',
      'We have poor cellular connectivity on the factory floor',
    ];
  } else if (industry.contains('Retail')) {
    indObjections = [
      'Profit margins are too thin for expensive IT upgrades',
      'High employee turnover makes training on new systems hard',
    ];
  }

  final merged = [...baseProductObjections, ...indObjections];
  return merged.take(5).toList();
}
