import 'package:frontend/features/airtel_iq/knowledge/product_enrichment_repository.dart';
import 'package:frontend/features/airtel_iq/knowledge/industry_intelligence.dart';

class ObjectionOutput {
  final String objectionText;
  final String likelihood; // 'Very Likely' or 'Likely'
  final String coreConcern;
  final String recommendedResponse;
  final List<String> questionsToAsk;
  final List<String> positionAirtel;
  final String reframe;
  final List<String> avoidSaying;

  const ObjectionOutput({
    required this.objectionText,
    this.likelihood = 'Likely',
    required this.coreConcern,
    required this.recommendedResponse,
    required this.questionsToAsk,
    required this.positionAirtel,
    required this.reframe,
    required this.avoidSaying,
  });
}

class ObjectionCandidate {
  final String text;
  final String likelihood;
  const ObjectionCandidate(this.text, this.likelihood);
}

class ObjectionCoachEngine {
  final List<String> _universalObjections = [
    'We already use another vendor.',
    'What is the ROI?',
    'Migration will be highly disruptive.',
    'This will be too expensive.',
    'Implementation will take too long.',
    'We do not have the internal bandwidth to manage this.',
  ];

  List<ObjectionOutput> generateTop5({
    required String productName,
    required String industryName,
  }) {
    final productOpt = productEnrichmentData.values
        .where((p) => p.productName == productName)
        .toList();
    final product = productOpt.isNotEmpty ? productOpt.first : null;

    final industryOpt = industryIntelligenceRepo
        .where((i) => i.industryName == industryName)
        .toList();
    final industry = industryOpt.isNotEmpty ? industryOpt.first : null;

    List<ObjectionCandidate> pool = [];

    if (product != null) {
      for (final obj in product.commonObjections) {
        final parts = obj.objection.split(':');
        String clean = parts.length > 1
            ? parts[1].replaceAll('"', '').trim()
            : obj.objection;
        pool.add(ObjectionCandidate(clean, 'Very Likely'));
      }
    }

    if (industry != null) {
      for (final obj in industry.objections) {
        pool.add(ObjectionCandidate(obj, 'Very Likely'));
      }
    }

    for (final obj in _universalObjections) {
      pool.add(ObjectionCandidate(obj, 'Likely'));
    }

    final seen = <String>{};
    List<ObjectionCandidate> uniquePool = [];
    for (final c in pool) {
      final lower = c.text.toLowerCase();
      if (!seen.contains(lower)) {
        seen.add(lower);
        uniquePool.add(c);
      }
    }

    uniquePool.sort((a, b) {
      if (a.likelihood == 'Very Likely' && b.likelihood == 'Likely') return -1;
      if (a.likelihood == 'Likely' && b.likelihood == 'Very Likely') return 1;
      return 0;
    });

    final top5 = uniquePool.take(5).toList();

    return top5.map((c) {
      return generate(
        productName: productName,
        objectionText: c.text,
        industryName: industryName,
        likelihood: c.likelihood,
      );
    }).toList();
  }

  ObjectionOutput generate({
    required String productName,
    required String objectionText,
    required String industryName,
    String likelihood = 'Likely',
  }) {
    final objLower = objectionText.toLowerCase();
    final category = _classifyObjection(objLower);

    final productOpt = productEnrichmentData.values
        .where((p) => p.productName == productName)
        .toList();
    final product = productOpt.isNotEmpty ? productOpt.first : null;

    final coreConcern = _buildCoreConcern(category);
    final recommendedResponse = _buildRecommendedResponse(
      category,
      product,
      objLower,
    );
    final questionsToAsk = _buildQuestionsToAsk(product);
    final positionAirtel = _buildPositioning(product);
    final reframe = _buildReframe(category, product);
    final avoidSaying = _buildAvoidSaying(category, product, objLower);

    return ObjectionOutput(
      objectionText: objectionText,
      likelihood: likelihood,
      coreConcern: coreConcern,
      recommendedResponse: recommendedResponse,
      questionsToAsk: questionsToAsk,
      positionAirtel: positionAirtel,
      reframe: reframe,
      avoidSaying: avoidSaying,
    );
  }

  String _classifyObjection(String obj) {
    if (obj.contains('aws') ||
        obj.contains('azure') ||
        obj.contains('gcp') ||
        obj.contains('palo alto') ||
        obj.contains('cisco') ||
        obj.contains('renewed') ||
        obj.contains('already have') ||
        obj.contains('already use') ||
        obj.contains('incumbent') ||
        obj.contains('vendor')) {
      return 'Existing Vendor';
    }
    if (obj.contains('price') ||
        obj.contains('cost') ||
        obj.contains('expensive') ||
        obj.contains('budget') ||
        obj.contains('cheap') ||
        obj.contains('roi')) {
      return 'Pricing';
    }
    if (obj.contains('security') ||
        obj.contains('secure') ||
        obj.contains('firewall') ||
        obj.contains('hacker') ||
        obj.contains('breach') ||
        obj.contains('data sovereignty') ||
        obj.contains('compliance') ||
        obj.contains('dpdp') ||
        obj.contains('ndhm')) {
      return 'Security';
    }
    if (obj.contains('migration') ||
        obj.contains('downtime') ||
        obj.contains('hard to switch') ||
        obj.contains('complex') ||
        obj.contains('disruptive') ||
        obj.contains('take too long') ||
        obj.contains('plants')) {
      return 'Migration Complexity';
    }
    if (obj.contains('our team') ||
        obj.contains('internal it') ||
        obj.contains('diy') ||
        obj.contains('control') ||
        obj.contains('bandwidth') ||
        obj.contains('expertise')) {
      return 'Internal IT Team';
    }
    if (obj.contains('not now') ||
        obj.contains('later') ||
        obj.contains('next year') ||
        obj.contains('priority') ||
        obj.contains('timing')) {
      return 'Timing';
    }
    if (obj.contains('spam') ||
        obj.contains('trust') ||
        obj.contains('reputation') ||
        obj.contains('annoying')) {
      return 'Vendor Trust';
    }
    return 'General';
  }

  String _buildCoreConcern(String category) {
    switch (category) {
      case 'Pricing':
        return "Budget optimization and ROI predictability";
      case 'Security':
        return "Security risk and compliance mandates";
      case 'Existing Vendor':
        return "Vendor lock-in and multi-vendor strategy";
      case 'Migration Complexity':
        return "Operational disruption and downtime risk";
      case 'Internal IT Team':
        return "Internal bandwidth constraints and loss of control";
      case 'Timing':
        return "Strategic priority alignment and implementation timeline";
      case 'Vendor Trust':
        return "Brand reputation and customer experience risk";
      default:
        return "Operational efficiency and business alignment";
    }
  }

  List<String> _buildQuestionsToAsk(EnrichedProduct? product) {
    if (product != null && product.discoveryHooks.isNotEmpty) {
      return product.discoveryHooks.take(2).toList();
    }
    return [
      "Could you elaborate on the specific limitations you're experiencing?",
      "How is this currently impacting operational efficiency?",
    ];
  }

  List<String> _buildPositioning(EnrichedProduct? product) {
    if (product != null && product.keyDifferentiators.isNotEmpty) {
      return product.keyDifferentiators.take(3).toList();
    }
    return [
      'End-to-end managed service',
      'Enterprise-grade SLAs',
      '24x7 proactive monitoring',
    ];
  }

  String _buildReframe(String category, EnrichedProduct? product) {
    if (product != null && product.objectionGuidance != null) {
      final guidance = product.objectionGuidance![category];
      if (guidance != null) {
        return guidance.reframe;
      }
    }

    if (category == 'Pricing') {
      return "Reframe from an IT spend increase to a consolidation of point solutions lowering Total Cost of Ownership (TCO).";
    }
    if (category == 'Migration Complexity') {
      return "Reframe from a sudden cutover to a phased, zero-downtime migration managed by deployment experts.";
    }
    if (category == 'Internal IT Team') {
      return "Shift focus from replacing their team to freeing up bandwidth so they can focus on strategic initiatives.";
    }

    return "Shift focus from adding complexity to streamlining operations for better business outcomes.";
  }

  String _buildRecommendedResponse(
    String category,
    EnrichedProduct? product,
    String objLower,
  ) {
    if (product != null) {
      for (final obj in product.commonObjections) {
        if (objLower.contains(obj.objection.split(':').first.toLowerCase()) ||
            obj.objection.toLowerCase().contains(category.toLowerCase())) {
          return obj.response;
        }
      }
    }

    if (product != null && product.objectionGuidance != null) {
      final guidance = product.objectionGuidance![category];
      if (guidance != null) {
        return guidance.recommendedResponse;
      }
    }

    final name = product?.productName ?? 'Airtel solutions';

    if (category == 'Migration Complexity') {
      return "Address the downtime concern directly. Propose a phased, parallel-run approach handled by deployment experts to ensure zero downtime and prove stability before cutover.";
    }

    return "Address the concern by highlighting how $name simplifies architecture and reduces operational overhead. Propose starting with a small pilot to prove the value.";
  }

  List<String> _buildAvoidSaying(
    String category,
    EnrichedProduct? product,
    String objLower,
  ) {
    if (product != null && product.objectionGuidance != null) {
      final guidance = product.objectionGuidance![category];
      if (guidance != null) {
        return guidance.avoidSaying;
      }
    }

    if (category == 'Pricing') {
      return [
        "Don't lead with discounting or price drops.",
        "Don't claim we are the absolute cheapest in the market.",
        "Don't argue about the competitor's pricing model.",
      ];
    }
    if (category == 'Vendor Trust') {
      return [
        "Don't promise zero customer complaints.",
        "Don't say they can send messages to anyone they want.",
        "Don't ignore strict opt-in regulations.",
      ];
    }
    if (category == 'Migration Complexity') {
      return [
        "Don't say 'It will be done in a day.'",
        "Don't ignore their past trauma with bad migrations.",
        "Don't promise zero configuration on their part.",
      ];
    }

    return [
      "Don't be defensive about Airtel's capabilities.",
      "Don't suggest they have to switch entirely to solve the issue.",
      "Don't overpromise on feature delivery timelines.",
    ];
  }
}
