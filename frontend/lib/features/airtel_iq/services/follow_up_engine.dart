/// Follow-Up Engine — Phase 8.8
/// Post-Meeting Execution Assistant
///
/// 100% deterministic. No LLM, no AI, no external calls.
/// Derives all outputs from: industry, products discussed,
/// customer concerns, meeting summary keywords, agreed next steps.
///
/// Repositories used (read-only):
///   - product_intelligence.dart  → painPointsSolved, discoveryQuestions
///   - industry_intelligence.dart → salesOpportunities, keyRegulations
library;

import 'package:frontend/features/airtel_iq/knowledge/airtel_iq_knowledge_service.dart';
import 'package:frontend/features/airtel_iq/knowledge/knowledge_models.dart';

// ── Output model ─────────────────────────────────────────────────────────────

class FollowUpOutput {
  final String emailSubject;
  final String emailBody;
  final List<String> crmNotes; // max 4 bullets
  final List<String> actionItems; // max 4
  final List<String> nextAgenda; // 3–4 items
  final Map<String, List<String>> recommendedTimeline; // New

  const FollowUpOutput({
    required this.emailSubject,
    required this.emailBody,
    required this.crmNotes,
    required this.actionItems,
    required this.nextAgenda,
    required this.recommendedTimeline,
  });
}

// ── Engine ────────────────────────────────────────────────────────────────────

class FollowUpEngine {
  final AirtelIqKnowledgeService _knowledge = AirtelIqKnowledgeService();

  // ── Keyword signal maps ───────────────────────────────────────────────────
  // Maps summary keywords → implied products / topics (deterministic, not AI)
  static const Map<String, String> _keywordToProduct = {
    'aws': 'Airtel Public Cloud',
    'azure': 'Airtel Public Cloud',
    'gcp': 'Airtel Public Cloud',
    'cloud': 'Airtel Public Cloud',
    'migration': 'Airtel Public Cloud',
    'hosting': 'Airtel Colocation',
    'data center': 'Airtel Colocation',
    'colocation': 'Airtel Colocation',
    'security': 'Airtel Secure Internet',
    'ransomware': 'Airtel Secure Internet',
    'firewall': 'Airtel Secure Internet',
    'compliance': 'Airtel Secure Internet',
    'cyber': 'Airtel Secure Internet',
    'branch': 'Airtel Managed SD-WAN',
    'branches': 'Airtel Managed SD-WAN',
    'network': 'Airtel Managed SD-WAN',
    'wan': 'Airtel Managed SD-WAN',
    'connectivity': 'Airtel Dedicated Internet',
    'internet': 'Airtel Dedicated Internet',
    'leased line': 'Airtel Dedicated Internet',
    'ill': 'Airtel Dedicated Internet',
    'mobile': 'Airtel Corporate Postpaid',
    'postpaid': 'Airtel Corporate Postpaid',
    'sim': 'Airtel Corporate Postpaid',
    'fleet': 'Airtel Corporate Postpaid',
    'remote': 'Airtel Work From Anywhere',
    'hybrid': 'Airtel Work From Anywhere',
    'work from home': 'Airtel Work From Anywhere',
    'iot': 'Airtel IoT Connectivity',
    'sensors': 'Airtel IoT Connectivity',
    'tracking': 'Airtel IoT Connectivity',
    'gps': 'Airtel Precise Positioning',
    'location': 'Airtel Precise Positioning',
    'whatsapp': 'Airtel WhatsApp Business',
    'messaging': 'Airtel WhatsApp Business',
    'cpaas': 'Airtel CPaaS',
    'api': 'Airtel CPaaS',
    'otp': 'Airtel CPaaS',
    'voice': 'Airtel Global Voice',
    'international': 'Airtel Global Voice',
    'vpn': 'Airtel VPN',
    'mpls': 'Airtel VPN',
    'office internet': 'Airtel Office Internet',
    'broadband': 'Airtel Office Internet',
    '5g': 'Airtel 5G for Enterprise',
    'private network': 'Airtel 5G for Enterprise',
  };

  // Industry-specific email opening lines
  static const Map<String, String> _industryEmailOpeners = {
    'Banking & Financial Services':
        'Thank you for taking the time to discuss your digital transformation and compliance roadmap with us.',
    'Manufacturing':
        'Thank you for the discussion around your Industry 4.0 journey and operational connectivity requirements.',
    'Retail':
        'Thank you for sharing your customer engagement and store network modernization priorities with us.',
    'IT & ITES':
        'Thank you for the conversation around your cloud infrastructure and workforce connectivity strategy.',
    'Healthcare':
        'Thank you for discussing your digital health priorities and network reliability requirements with us.',
    'Logistics':
        'Thank you for sharing your fleet connectivity and last-mile efficiency challenges with us.',
    'E-Commerce':
        'Thank you for the discussion around your platform resilience and customer communication strategy.',
    'Government':
        'Thank you for the conversation around your digital governance and secure connectivity priorities.',
    'Automotive':
        'Thank you for discussing your connected mobility and smart factory connectivity requirements.',
    'Energy & Utilities':
        'Thank you for sharing your smart metering and field operations connectivity roadmap with us.',
    'Hospitality':
        'Thank you for the conversation around your guest experience and property network modernization.',
    'Education':
        'Thank you for discussing your campus connectivity and digital learning infrastructure priorities.',
    'Media & Entertainment':
        'Thank you for sharing your content delivery and live streaming connectivity requirements.',
    'Telecom & Carriers':
        'Thank you for the discussion around your wholesale connectivity and international routing requirements.',
    'Travel & Tourism':
        'Thank you for discussing your multi-property connectivity and guest engagement priorities.',
  };

  // Industry-specific next agenda themes (deterministic)
  static const Map<String, List<String>> _industryAgendaThemes = {
    'Banking & Financial Services': [
      'Review current connectivity and network architecture',
      'Deep dive on data sovereignty and compliance requirements',
      'SD-WAN and cloud migration roadmap discussion',
      'Airtel Security solution demonstration',
    ],
    'Manufacturing': [
      'Review factory connectivity and OT/IT integration requirements',
      'IoT device management and real-time monitoring discussion',
      'Industry 4.0 use case prioritization',
      'Solution architecture and pilot planning',
    ],
    'Retail': [
      'Review store network connectivity and standardization requirements',
      'Customer engagement platform and WhatsApp API demonstration',
      'Omnichannel and inventory visibility use cases',
      'Pilot scope and rollout timeline discussion',
    ],
    'IT & ITES': [
      'Remote workforce connectivity and Work From Anywhere deep dive',
      'Cloud cost optimization and multi-cloud architecture review',
      'Security posture assessment and SD-WAN discussion',
      'Contract and commercials discussion',
    ],
    'Healthcare': [
      'Hospital network reliability and uptime requirements review',
      'Telemedicine connectivity and data security discussion',
      'Compliance and data governance requirements',
      'Solution demonstration and pilot planning',
    ],
    'Logistics': [
      'Fleet connectivity and IoT tracking requirements review',
      'Last-mile operations and driver communication discussion',
      'Warehouse automation and visibility use cases',
      'Pilot scope and commercial terms',
    ],
    'E-Commerce': [
      'Platform resilience and redundancy requirements review',
      'CPaaS and WhatsApp API for customer notifications discussion',
      'Peak event preparedness and capacity planning',
      'Technical integration and API documentation sharing',
    ],
    'Government': [
      'Secure connectivity and data localization requirements',
      'Inter-departmental network and compliance discussion',
      'Smart city and digital citizen services roadmap',
      'Commercial and procurement process alignment',
    ],
    'Automotive': [
      'Fleet telematics and AIS-140 compliance requirements',
      'Smart factory and private 5G use case discussion',
      'Connected vehicle platform integration',
      'Pilot vehicle and timeline planning',
    ],
    'Energy & Utilities': [
      'Smart metering and SCADA connectivity requirements',
      'Field worker safety and remote site connectivity discussion',
      'IoT sensor network architecture review',
      'Security requirements for critical infrastructure',
    ],
    'Hospitality': [
      'Guest Wi-Fi and property network requirements review',
      'Multi-property management and centralized connectivity',
      'Guest engagement and loyalty platform discussion',
      'Commercial terms and rollout timeline',
    ],
    'Education': [
      'Campus network requirements and coverage review',
      'Online learning and video conferencing connectivity',
      'Student and staff communication platform discussion',
      'Contract and phased rollout planning',
    ],
    'Media & Entertainment': [
      'Broadcast and live streaming connectivity requirements',
      'Content delivery and CDN strategy discussion',
      'Global connectivity for international content distribution',
      'SLA requirements and redundancy planning',
    ],
    'Telecom & Carriers': [
      'International voice routing and quality review',
      'Wholesale pricing and traffic volume discussion',
      'DLT compliance and regulatory alignment',
      'Commercial terms and interconnect agreement',
    ],
    'Travel & Tourism': [
      'Multi-property connectivity and network standardization',
      'Guest experience and digital services roadmap',
      'Contact center and reservation system connectivity',
      'Commercial proposal and rollout planning',
    ],
  };

  // ── Main Entry Point ─────────────────────────────────────────────────────

  FollowUpOutput generate({
    required String industry,
    required List<String> productsDiscussed,
    required List<String> customerConcerns,
    required String meetingSummary,
    required String agreedNextSteps,
  }) {
    final summaryLower = meetingSummary.toLowerCase();
    final stepsLower = agreedNextSteps.toLowerCase();
    final concernsLower = customerConcerns.map((c) => c.toLowerCase()).toList();

    // 1. Detect keyword-implied products from summary (not duplicating listed products)
    final impliedProducts = _detectImpliedProducts(
      summaryLower,
      productsDiscussed,
    );

    // 2. All discussed products (explicit + implied)
    final allProducts = [
      ...productsDiscussed,
      ...impliedProducts.where((p) => !productsDiscussed.contains(p)),
    ];

    // 3. Industry data (read-only)
    final industryData = _knowledge.getIndustryByName(industry);

    // 4. Build all 4 outputs
    final crmNotes = _buildCrmNotes(
      industry: industry,
      allProducts: allProducts,
      customerConcerns: customerConcerns,
      summaryLower: summaryLower,
      stepsLower: stepsLower,
      industryData: industryData,
    );

    final actionItems = _buildActionItems(
      allProducts: allProducts,
      customerConcerns: customerConcerns,
      summaryLower: summaryLower,
      stepsLower: stepsLower,
      industry: industry,
    );

    final nextAgenda = _buildNextAgenda(
      industry: industry,
      allProducts: allProducts,
      summaryLower: summaryLower,
      concernsLower: concernsLower,
      industryData: industryData,
    );

    final subject = _buildEmailSubject(industry, allProducts, agreedNextSteps);
    final body = _buildEmailBody(
      industry: industry,
      allProducts: allProducts,
      customerConcerns: customerConcerns,
      agreedNextSteps: agreedNextSteps.trim(),
      summaryLower: summaryLower,
      nextAgenda: nextAgenda,
    );

    final recommendedTimeline = _buildRecommendedTimeline(
      allProducts: allProducts,
      summaryLower: summaryLower,
      stepsLower: stepsLower,
    );

    return FollowUpOutput(
      emailSubject: subject,
      emailBody: body,
      crmNotes: crmNotes,
      actionItems: actionItems,
      nextAgenda: nextAgenda,
      recommendedTimeline: recommendedTimeline,
    );
  }

  // ── Keyword detection ────────────────────────────────────────────────────

  List<String> _detectImpliedProducts(
    String summaryLower,
    List<String> alreadyListed,
  ) {
    final alreadyLower = alreadyListed.map((p) => p.toLowerCase()).toSet();
    final detected = <String>[];

    for (final entry in _keywordToProduct.entries) {
      if (summaryLower.contains(entry.key)) {
        final prod = entry.value;
        if (!alreadyLower.contains(prod.toLowerCase()) &&
            !detected.contains(prod)) {
          detected.add(prod);
        }
      }
    }
    return detected;
  }

  // ── CRM Notes ────────────────────────────────────────────────────────────

  List<String> _buildCrmNotes({
    required String industry,
    required List<String> allProducts,
    required List<String> customerConcerns,
    required String summaryLower,
    required String stepsLower,
    required IndustryIntelligence? industryData,
  }) {
    final notes = <String>[];

    // Account context & Pain points
    if (summaryLower.contains('aws') ||
        summaryLower.contains('azure') ||
        summaryLower.contains('gcp')) {
      notes.add(
        'Customer currently relies on hyperscaler (AWS/Azure/GCP) for core workloads.',
      );
      notes.add(
        'Opportunity to position Airtel Public Cloud as a sovereign complement to their existing stack.',
      );
    } else if (summaryLower.contains('security') ||
        summaryLower.contains('compliance') ||
        summaryLower.contains('data sovereignty')) {
      notes.add(
        'Stringent compliance and data sovereignty requirements are shaping their technology roadmap.',
      );
      notes.add(
        'Airtel Secure Internet and localized infrastructure positioned as strategic risk mitigators.',
      );
    } else if (summaryLower.contains('network') ||
        summaryLower.contains('branch') ||
        summaryLower.contains('connectivity')) {
      notes.add(
        'Customer is experiencing friction with current branch network resilience and scalability.',
      );
      notes.add(
        'Airtel Managed SD-WAN positioned to standardize connectivity across distributed locations.',
      );
    } else if (summaryLower.contains('automation') ||
        summaryLower.contains('smart factory')) {
      notes.add(
        'Key focus on driving operational efficiency through smart factory initiatives and automation.',
      );
    } else {
      notes.add(
        'Strategic engagement with $industry account initiated to uncover enterprise technology gaps.',
      );
    }

    // Products discussed
    if (allProducts.isNotEmpty) {
      notes.add(
        'Executive interest confirmed around ${allProducts.take(2).join(" and ")}.',
      );
    }

    // Risks / specific concerns
    if (customerConcerns.isNotEmpty) {
      final topConcern = customerConcerns.first;
      notes.add(
        'Key risk identified: "$topConcern" — requires targeted mitigation in subsequent proposals.',
      );
    } else if (summaryLower.contains('budget') ||
        summaryLower.contains('cost')) {
      notes.add(
        'High budget sensitivity noted — ROI and cost consolidation must be central to our proposal.',
      );
    }

    return notes.take(4).toList();
  }

  // ── Action Items ─────────────────────────────────────────────────────────

  List<String> _buildActionItems({
    required List<String> allProducts,
    required List<String> customerConcerns,
    required String summaryLower,
    required String stepsLower,
    required String industry,
  }) {
    final items = <String>[];

    // Priority 1: Product-specific action items (modular approach)
    for (final product in allProducts.take(2)) {
      final prodLower = product.toLowerCase();
      if (prodLower.contains('cloud') || prodLower.contains('colocation')) {
        if (!_containsAction(items, 'cloud')) {
          items.add(
            'Share $product solution brief emphasizing sovereign architecture',
          );
          items.add('Schedule cloud architecture workshop');
          items.add('Invite Airtel Cloud SME for technical deep dive');
        }
      } else if (prodLower.contains('secure') ||
          prodLower.contains('security')) {
        if (!_containsAction(items, 'security')) {
          items.add(
            'Share $product technical whitepaper and compliance certificates',
          );
          items.add('Coordinate security posture assessment session');
          items.add('Invite Airtel Security SME to next alignment call');
        }
      } else if (prodLower.contains('sd-wan') ||
          prodLower.contains('vpn') ||
          prodLower.contains('internet')) {
        if (!_containsAction(items, 'network')) {
          items.add('Share SD-WAN migration case studies for $industry');
          items.add('Send site-assessment questionnaire for initial sizing');
        }
      } else if (prodLower.contains('iot')) {
        if (!_containsAction(items, 'iot')) {
          items.add('Share IoT connectivity management platform overview');
          items.add('Coordinate with IoT team for pilot device provisioning');
        }
      } else if (prodLower.contains('whatsapp') ||
          prodLower.contains('cpaas')) {
        if (!_containsAction(items, 'api')) {
          items.add('Provide CPaaS API documentation and sandbox access keys');
          items.add(
            'Schedule API integration walkthrough with development team',
          );
        }
      } else if (prodLower.contains('postpaid') ||
          prodLower.contains('mobile')) {
        if (!_containsAction(items, 'postpaid')) {
          items.add(
            'Prepare TCO comparison model against their incumbent mobile provider',
          );
        }
      }
      if (items.length >= 3) break;
    }

    // Priority 2: Items derived from agreed next steps
    if (stepsLower.isNotEmpty) {
      if (stepsLower.contains('proposal') || stepsLower.contains('quote')) {
        items.add(
          'Draft formal commercial proposal and seek internal pricing approval',
        );
      }
      if (stepsLower.contains('demo') || stepsLower.contains('demonstration')) {
        if (!_containsAction(items, 'demo')) {
          items.add(
            'Prepare tailored product demonstration highlighting their specific use cases',
          );
        }
      }
      if (stepsLower.contains('meeting') ||
          stepsLower.contains('call') ||
          stepsLower.contains('schedule')) {
        if (!_containsAction(items, 'schedule')) {
          items.add(
            'Propose 3 availability slots for follow-up executive briefing',
          );
        }
      }
    }

    // Priority 3: Concern-driven action items
    for (final concern in customerConcerns.take(2)) {
      final cLower = concern.toLowerCase();
      if ((cLower.contains('price') || cLower.contains('cost')) &&
          !_containsAction(items, 'cost')) {
        items.add(
          'Prepare ROI calculator and total cost of ownership comparison',
        );
      }
      if ((cLower.contains('migration') || cLower.contains('downtime')) &&
          !_containsAction(items, 'migration')) {
        items.add(
          'Prepare zero-downtime migration plan and SLA commitments document',
        );
      }
      if (items.length >= 4) break;
    }

    // Priority 4: Summary keyword–driven items
    if (items.length < 4) {
      if (summaryLower.contains('pilot') || summaryLower.contains('poc')) {
        if (!_containsAction(items, 'pilot') &&
            !_containsAction(items, 'poc')) {
          items.add(
            'Draft PoC scope, timelines, and success criteria document',
          );
        }
      }
      if (summaryLower.contains('cto') ||
          summaryLower.contains('ciso') ||
          summaryLower.contains('cxo')) {
        if (!_containsAction(items, 'executive')) {
          items.add('Prepare executive brief for CXO-level presentation');
        }
      }
    }

    // Priority 5: Universal fallback
    if (items.isEmpty) {
      items.add(
        'Draft comprehensive meeting recap highlighting strategic alignment',
      );
      items.add(
        'Propose 3 availability slots for follow-up executive briefing',
      );
    }

    return items.take(4).toList();
  }

  // ── Next Meeting Agenda ──────────────────────────────────────────────────

  List<String> _buildNextAgenda({
    required String industry,
    required List<String> allProducts,
    required String summaryLower,
    required List<String> concernsLower,
    required IndustryIntelligence? industryData,
  }) {
    final agenda = <String>[];

    // Agenda 1: Always open with recap / requirements validation
    agenda.add(
      'Recap and validation of requirements discussed in last meeting',
    );

    // Agenda 2: Product-specific deep dive (first discussed product)
    if (allProducts.isNotEmpty) {
      agenda.add('${allProducts.first} — solution architecture and deep dive');
    }

    // Agenda 3: Address the most prominent concern
    if (concernsLower.isNotEmpty) {
      final raw = concernsLower.first;
      final formatted = raw.isNotEmpty
          ? raw[0].toUpperCase() + raw.substring(1)
          : raw;
      agenda.add('Address "$formatted" — detailed response and options');
    }

    // Agenda 4+: Industry-specific themes from the static map (fill to 4)
    final industryThemes = _industryAgendaThemes[industry] ?? [];
    for (final theme in industryThemes) {
      if (agenda.length >= 4) break;
      // Avoid duplicates by checking if theme text is already covered
      final themeLower = theme.toLowerCase();
      final alreadyCovered = agenda.any(
        (a) =>
            a.toLowerCase().contains(themeLower.split(' ').first) ||
            themeLower.contains(a.toLowerCase().split(' ').first),
      );
      if (!alreadyCovered) {
        agenda.add(theme);
      }
    }

    // Ensure at least 3 agenda items
    if (agenda.length < 3) {
      agenda.add('Commercial terms, timelines, and next steps');
    }

    return agenda.take(4).toList();
  }

  // ── Email Subject ────────────────────────────────────────────────────────

  String _buildEmailSubject(
    String industry,
    List<String> allProducts,
    String agreedNextSteps,
  ) {
    if (agreedNextSteps.trim().isNotEmpty) {
      // If next steps mention specific actions, reflect in subject
      final stepsLower = agreedNextSteps.toLowerCase();
      if (stepsLower.contains('proposal') || stepsLower.contains('quote')) {
        return 'Following Up — Commercial Proposal Enclosed';
      }
      if (stepsLower.contains('demo')) {
        return 'Following Up — Demo Scheduling & Next Steps';
      }
      if (stepsLower.contains('meeting') || stepsLower.contains('schedule')) {
        return 'Following Up — Next Steps & Meeting Invitation';
      }
    }

    if (allProducts.isNotEmpty) {
      if (allProducts.length == 1) {
        return 'Thank You — ${allProducts.first} Discussion & Next Steps';
      }
      return 'Thank You — Airtel Enterprise Solutions Discussion & Next Steps';
    }

    return 'Thank You for the Meeting — $industry Discussion & Next Steps';
  }

  // ── Modular Email Composers ──────────────────────────────────────────────

  String _buildSituationSummary(String summaryLower) {
    if (summaryLower.contains('aws') ||
        summaryLower.contains('azure') ||
        summaryLower.contains('gcp')) {
      return 'I enjoyed learning about your cloud modernization efforts and how you are evaluating your current infrastructure strategy.';
    }
    if (summaryLower.contains('security') ||
        summaryLower.contains('compliance') ||
        summaryLower.contains('data sovereignty')) {
      return 'Our conversation around risk reduction, compliance, and ensuring a robust security posture was very insightful.';
    }
    if (summaryLower.contains('branch') ||
        summaryLower.contains('network') ||
        summaryLower.contains('connectivity')) {
      return 'It was great discussing your network resilience goals and how to optimize connectivity across your footprint.';
    }
    if (summaryLower.contains('automation') ||
        summaryLower.contains('smart factory') ||
        summaryLower.contains('iot')) {
      return 'I appreciated our discussion on driving operational efficiency through smart factory initiatives and automation.';
    }
    if (summaryLower.contains('customer engagement') ||
        summaryLower.contains('cpaas') ||
        summaryLower.contains('whatsapp')) {
      return 'It was insightful to learn about your omnichannel customer engagement priorities and communication strategy.';
    }
    return 'I appreciate you sharing the current business challenges and your strategic priorities for the upcoming quarters.';
  }

  String _buildEmailBody({
    required String industry,
    required List<String> allProducts,
    required List<String> customerConcerns,
    required String agreedNextSteps,
    required String summaryLower,
    required List<String> nextAgenda,
  }) {
    final opener =
        _industryEmailOpeners[industry] ??
        'Thank you for taking the time to meet with us and discussing your technology requirements.';

    final situationSummary = _buildSituationSummary(summaryLower);

    final buffer = StringBuffer();

    // Greeting
    buffer.writeln('Hi,');
    buffer.writeln();

    // Opening block
    buffer.writeln('$opener $situationSummary');
    buffer.writeln();

    // Discussion recap (products-driven)
    if (allProducts.isNotEmpty) {
      if (allProducts.length == 1) {
        buffer.writeln(
          'As we explored, ${allProducts.first} can be a strong fit to address these key requirements and accelerate your roadmap.',
        );
      } else {
        final productList = allProducts.take(3).join(', ');
        buffer.writeln(
          'Based on our discussion, the following Airtel solutions align well with your objectives: $productList.',
        );
      }
      buffer.writeln();
    }

    // Agreed next steps
    if (agreedNextSteps.isNotEmpty) {
      buffer.writeln(
        'To keep our momentum, here are the immediate next steps we agreed upon:',
      );
      final steps = agreedNextSteps
          .split('\n')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      if (steps.length > 1) {
        for (var i = 0; i < steps.length && i < 3; i++) {
          buffer.writeln('• ${steps[i]}');
        }
      } else {
        buffer.writeln('• $agreedNextSteps');
      }
      buffer.writeln();
    }

    // Suggest next meeting with a preview agenda item
    if (nextAgenda.isNotEmpty) {
      buffer.writeln(
        'I will follow up shortly to schedule a session where we can ${nextAgenda.length > 1 ? nextAgenda[1].toLowerCase() : "discuss the next steps in detail"}.',
      );
      buffer.writeln();
    }

    // Closing
    buffer.writeln(
      'Please feel free to reach out if you have any questions in the meantime. I look forward to continuing this partnership.',
    );
    buffer.writeln();
    buffer.writeln('Warm regards,');
    buffer.writeln('Airtel Account Manager');

    return buffer.toString().trimRight();
  }

  // ── Recommended Follow-up Timeline ───────────────────────────────────────

  Map<String, List<String>> _buildRecommendedTimeline({
    required List<String> allProducts,
    required String summaryLower,
    required String stepsLower,
  }) {
    final timeline = <String, List<String>>{};

    // Determine engagement level deterministically
    final isHighEngagement =
        summaryLower.contains('pilot') ||
        summaryLower.contains('poc') ||
        summaryLower.contains('demo') ||
        stepsLower.contains('proposal') ||
        stepsLower.contains('quote') ||
        stepsLower.contains('urgent');

    if (isHighEngagement) {
      timeline['Within 2 days'] = [
        if (allProducts.isNotEmpty)
          'Share solution documents for ${allProducts.first}'
        else
          'Share tailored solution presentation',
        if (stepsLower.contains('proposal') || stepsLower.contains('quote'))
          'Send commercial proposal',
      ];
      timeline['Within 1 week'] = [
        'Schedule technical workshop or demo session',
        'Follow up on initial proposal feedback',
      ];
    } else {
      timeline['Within 3 days'] = [
        if (allProducts.isNotEmpty)
          'Share relevant material on ${allProducts.first}'
        else
          'Share relevant case studies',
      ];
      timeline['Within 2 weeks'] = [
        'Reconnect with customer to gauge ongoing interest',
        'Propose an introductory architecture session',
      ];
    }

    // Clean up empty lists
    timeline.removeWhere((key, value) => value.isEmpty);
    return timeline;
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  bool _containsAction(List<String> items, String keyword) {
    return items.any((i) => i.toLowerCase().contains(keyword));
  }
}
