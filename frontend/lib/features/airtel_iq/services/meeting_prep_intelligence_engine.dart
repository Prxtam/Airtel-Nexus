import 'package:frontend/features/airtel_iq/knowledge/airtel_iq_knowledge_service.dart';
import 'package:frontend/features/airtel_iq/knowledge/knowledge_models.dart';

// =============================================================================
// Phase 1 -- Meeting-Type Output Shape
//
// Each meeting type carries a specific output contract:
//   questionCount             -- how many discovery questions to return
//   objectionCount            -- how many objections to return
//   maxSupportingProducts     -- how many supporting product recs to return
//   objectionsDominant        -- if true, UI renders objections before questions
//   objectionPoolBoost        -- flat bonus added to every objection in the pool
//   includeExpansionOpportunities -- whether to surface salesOpportunities
// =============================================================================

class _MeetingOutputShape {
  final int questionCount;
  final int objectionCount;
  final int maxSupportingProducts;
  final bool objectionsDominant;
  final double objectionPoolBoost;
  final bool includeExpansionOpportunities;

  const _MeetingOutputShape({
    required this.questionCount,
    required this.objectionCount,
    required this.maxSupportingProducts,
    this.objectionsDominant = false,
    this.objectionPoolBoost = 0,
    this.includeExpansionOpportunities = false,
  });
}

const Map<String, _MeetingOutputShape> _shapeByType = {
  // Discovery: question-heavy, objection-light -- listening mode
  'Discovery Meeting': _MeetingOutputShape(
    questionCount: 6,
    objectionCount: 2,
    maxSupportingProducts: 2,
  ),
  // Proposal: balanced, with objection boost for anticipated pushback
  'Proposal Meeting': _MeetingOutputShape(
    questionCount: 4,
    objectionCount: 3,
    maxSupportingProducts: 2,
    objectionPoolBoost: 10,
  ),
  // Renewal: satisfaction focus, expansion opportunities, fewer questions
  'Renewal Meeting': _MeetingOutputShape(
    questionCount: 3,
    objectionCount: 3,
    maxSupportingProducts: 2,
    objectionPoolBoost: 15,
    includeExpansionOpportunities: true,
  ),
  // Executive: strategic framing, concise questions
  'Executive Alignment Meeting': _MeetingOutputShape(
    questionCount: 4,
    objectionCount: 2,
    maxSupportingProducts: 2,
  ),
  // Technical: architecture deep-dive, more questions, fewer objections
  'Technical Workshop': _MeetingOutputShape(
    questionCount: 5,
    objectionCount: 2,
    maxSupportingProducts: 2,
  ),
  // Demo: prove the product, high objection expectation
  'Solution Demonstration': _MeetingOutputShape(
    questionCount: 3,
    objectionCount: 4,
    maxSupportingProducts: 1,
    objectionPoolBoost: 20,
  ),
  // Renewal Negotiation: commercial battle -- objections dominate
  'Renewal Negotiation': _MeetingOutputShape(
    questionCount: 2,
    objectionCount: 5,
    maxSupportingProducts: 1,
    objectionsDominant: true,
    objectionPoolBoost: 30,
  ),
  // Upsell: broaden product footprint, surface expansion opps
  'Upsell Review': _MeetingOutputShape(
    questionCount: 3,
    objectionCount: 2,
    maxSupportingProducts: 3,
    includeExpansionOpportunities: true,
  ),
  // QBR: performance review + roadmap, expansion opps relevant
  'Quarterly Business Review': _MeetingOutputShape(
    questionCount: 3,
    objectionCount: 2,
    maxSupportingProducts: 2,
    includeExpansionOpportunities: true,
  ),
  // Stakeholder mapping: all about asking questions
  'Stakeholder Mapping Session': _MeetingOutputShape(
    questionCount: 5,
    objectionCount: 1,
    maxSupportingProducts: 1,
  ),
};

const _MeetingOutputShape _defaultShape = _MeetingOutputShape(
  questionCount: 5,
  objectionCount: 3,
  maxSupportingProducts: 2,
);

_MeetingOutputShape _resolveShape(String? meetingType) {
  if (meetingType == null) return _defaultShape;
  return _shapeByType[meetingType] ?? _defaultShape;
}

// =============================================================================
// Phase 2.5 -- Semantic Concept Engine (Situation Notes Intelligence)
// =============================================================================

class _SemanticConcept {
  final String name;
  final List<String> phrases;
  final List<String> products;
  final String nba;

  const _SemanticConcept({
    required this.name,
    required this.phrases,
    required this.products,
    required this.nba,
  });
}

const List<_SemanticConcept> _semanticConcepts = [
  _SemanticConcept(
    name: 'Connectivity & Network Reliability',
    phrases: [
      'outage', 'downtime', 'unstable network', 'network instability', 'disconnected',
      'latency', 'packet loss', 'slow network', 'branch unavailable', 'connectivity issue',
      'link failure', 'branch outage', 'dropping connection', 'poor connectivity',
      'network goes down', 'site isolated', 'frequent disconnections',
    ],
    products: ['Airtel SD-WAN', 'Airtel VPN/MPLS', 'Airtel Leased Line', 'Airtel Office Internet'],
    nba: 'Schedule a network assessment focused on branch uptime and failover readiness.',
  ),
  _SemanticConcept(
    name: 'Security & Compliance',
    phrases: [
      'audit', 'compliance', 'regulation', 'governance', 'security breach',
      'privacy', 'data protection', 'data residency', 'sovereignty', 'risk management',
      'ransomware', 'cyber attack', 'hacked', 'data leak', 'unauthorized access',
      'regulatory fine', 'security posture',
    ],
    products: ['Airtel Secure Internet', 'Airtel VPN/MPLS', 'Airtel Public Cloud', 'Airtel Colocation'],
    nba: 'Review compliance and security controls with customer IT leadership.',
  ),
  _SemanticConcept(
    name: 'Mobility & Workforce',
    phrases: [
      'roaming', 'field staff', 'remote employees', 'distributed workforce', 'travel',
      'employee productivity', 'workforce management', 'work from home', 'wfh',
      'remote access', 'hybrid work', 'byod', 'mobile workforce', 'field agents',
    ],
    products: ['Airtel Corporate Postpaid', 'Airtel Work From Anywhere Solutions'],
    nba: 'Propose a unified mobility policy review for remote and field staff.',
  ),
  _SemanticConcept(
    name: 'Customer Engagement',
    phrases: [
      'sms', 'whatsapp', 'notifications', 'campaigns', 'customer communication',
      'engagement', 'messaging', 'otp failure', 'message delivery', 'reach customers',
      'abandoned cart', 'delivery alerts', 'customer updates',
    ],
    products: ['Airtel CPaaS', 'Airtel WhatsApp Business', 'Airtel Contact Center as a Service'],
    nba: 'Audit their current customer communication flows and OTP delivery success rates.',
  ),
  _SemanticConcept(
    name: 'Cloud & Data Center',
    phrases: [
      'migration', 'cloud', 'workload', 'hosting', 'disaster recovery',
      'backup', 'colocation', 'compute', 'server end of life', 'hardware refresh',
      'data center move', 'dr drill', 'on-prem', 'on premise',
    ],
    products: ['Airtel Public Cloud', 'Airtel Colocation'],
    nba: 'Discuss workload migration timeline and disaster recovery requirements.',
  ),
  _SemanticConcept(
    name: 'IoT & Asset Visibility',
    phrases: [
      'tracking', 'sensors', 'telematics', 'fleet', 'shipment', 'logistics',
      'visibility', 'monitoring', 'smart meter', 'asset loss', 'route deviation',
      'supply chain visibility', 'equipment breakdown', 'predictive maintenance',
    ],
    products: ['Airtel IoT Connectivity', 'Airtel Precise Positioning', 'Airtel 5G for Enterprise'],
    nba: 'Validate asset tracking requirements and identify pilot deployment candidates.',
  ),
  _SemanticConcept(
    name: 'Voice & Contact Center',
    phrases: [
      'call center', 'voice quality', 'inbound calls', 'outbound calls', 'customer support',
      'agent productivity', 'pbx', 'sip', 'toll free', 'dropped calls',
      'helpdesk', 'ivr', 'call routing',
    ],
    products: ['Airtel Global Voice', 'Airtel SIP Trunking', 'Airtel Contact Center as a Service'],
    nba: 'Map out their current inbound call routing and agent software integration.',
  ),
];

// =============================================================================
// Output Models
// =============================================================================

/// A ranked Airtel product recommendation with a repo-derived explanation.
class RankedProduct {
  final String productName;

  /// One-line explanation built entirely from repository fields.
  final String selectionReason;
  final String elevatorPitch;

  const RankedProduct({
    required this.productName,
    required this.selectionReason,
    required this.elevatorPitch,
  });
}

/// An objection paired with its matched response from the same repository source.
class ScoredObjection {
  final String objection;
  final String response;

  const ScoredObjection({required this.objection, required this.response});
}

/// 4-section meeting strategy assembled from repository methodology fields.
class MeetingStrategy {
  final String leadWith;
  final String avoid;
  final String validate;
  final String closeWith;

  const MeetingStrategy({
    required this.leadWith,
    required this.avoid,
    required this.validate,
    required this.closeWith,
  });
}

/// The complete V4 output. Every list field is bounded by meeting type shape.
class MeetingPrepV3Result {
  final String contextSummary;

  /// Ranked industry challenges -- max 3.
  final List<String> topChallenges;

  /// Discovery questions -- count determined by meeting type shape.
  final List<String> discoveryQuestions;

  final RankedProduct primaryRecommendation;

  /// Supporting product recommendations -- count determined by meeting type shape.
  final List<RankedProduct> supportingRecs;

  /// Objections + matched responses -- count determined by meeting type shape.
  final List<ScoredObjection> topObjections;

  final MeetingStrategy meetingStrategy;
  final String nextBestAction;

  /// True when generation ran without industry context (methodology-only path).
  final bool isMethodologyOnlyMode;

  // Phase 1 additions --------------------------------------------------------

  /// When true, the UI renders objections before discovery questions.
  final bool objectionsDominant;

  /// Sales expansion opportunities from IndustryIntelligence.salesOpportunities.
  /// Non-null only for Renewal, Upsell, and QBR meeting types.
  final List<String>? expansionOpportunities;

  const MeetingPrepV3Result({
    required this.contextSummary,
    required this.topChallenges,
    required this.discoveryQuestions,
    required this.primaryRecommendation,
    required this.supportingRecs,
    required this.topObjections,
    required this.meetingStrategy,
    required this.nextBestAction,
    this.isMethodologyOnlyMode = false,
    this.objectionsDominant = false,
    this.expansionOpportunities,
  });
}

// =============================================================================
// Input Model
// =============================================================================

class MeetingPrepV3Input {
  /// Required for full intelligence. Null triggers methodology-only fallback.
  final String? industry;

  /// Optional. When null, output shape uses generic defaults.
  final String? meetingType;

  /// Optional. Enables eligibility filtering (e.g. removes Private 5G for SMBs).
  final String? companySize;

  /// Optional. When provided, becomes the dominant ranking and filtering signal.
  final String? painPoint;

  /// Optional. Secondary signal for question and NBA tuning.
  final String? objective;

  /// Customer name -- displayed in the context summary for History Mode.
  final String? customerName;

  /// Previous meeting count -- displayed in the context summary for History Mode.
  final int? previousMeetingCount;

  // Phase 2 additions --------------------------------------------------------

  /// Airtel products the customer already owns.
  /// Triggers Signal 6:
  ///   - Already-owned products are penalised (-40) so they won't be re-recommended.
  ///   - Their listed cross-sell partners are boosted (+25).
  final List<String> existingAirtelProducts;

  /// Free-text situation notes (e.g. "branch outages, evaluating SD-WAN").
  /// Keywords are extracted and applied as Signal 7 (+20 moderate boost) across
  /// questions, challenges, and objections -- but ONLY when no explicit painPoint
  /// is provided, keeping painPoint dominant.
  final String? situationNotes;

  const MeetingPrepV3Input({
    this.industry,
    this.meetingType,
    this.companySize,
    this.painPoint,
    this.objective,
    this.customerName,
    this.previousMeetingCount,
    this.existingAirtelProducts = const [],
    this.situationNotes,
  });
}

// =============================================================================
// Internal Scoring Helper
// =============================================================================

class _Scored<T> {
  final T item;
  final double score;
  const _Scored(this.item, this.score);
}

// =============================================================================
// Engine
// =============================================================================

class MeetingPrepIntelligenceEngine {
  final AirtelIqKnowledgeService _knowledge = AirtelIqKnowledgeService();

  /// Entry point. Always returns a result -- never throws.
  /// Falls back to methodology-only mode when industry is unavailable.
  Future<MeetingPrepV3Result> generate(MeetingPrepV3Input input) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final methodology = input.meetingType != null
        ? _knowledge.getMethodologyByMeetingType(input.meetingType!)
        : null;

    final industry =
        input.industry != null ? _knowledge.getIndustryByName(input.industry!) : null;

    if (industry == null) {
      return _generateMethodologyOnly(input, methodology);
    }
    return _generateFullBrief(input, industry, methodology);
  }

  // ---------------------------------------------------------------------------
  // Methodology-Only Fallback
  // ---------------------------------------------------------------------------

  MeetingPrepV3Result _generateMethodologyOnly(
    MeetingPrepV3Input input,
    MeetingMethodology? methodology,
  ) {
    final shape = _resolveShape(input.meetingType);
    final customerPrefix =
        input.customerName != null ? 'Meeting with ${input.customerName}. ' : '';
    final historyNote =
        (input.previousMeetingCount != null && input.previousMeetingCount! > 0)
            ? '${input.previousMeetingCount} previous engagements on record. '
            : '';

    final meetingLabel = input.meetingType ?? 'this meeting';

    final contextSummary =
        '$customerPrefix${historyNote}Industry context not provided -- '
        'preparation is based on $meetingLabel methodology defaults. '
        'Add an industry for a fully tailored brief.';

    final challenges = [
      'Understand current operational priorities and business context',
      'Identify key decision-makers and internal stakeholders',
      'Assess current technology and communication infrastructure',
    ];

    final questions = _deduplicateAndTake([
      ...(methodology?.keyQuestions ?? []),
      'What are your primary business priorities this quarter?',
      'What challenges are you currently trying to solve?',
      'What would a successful outcome from today\'s meeting look like?',
      'Who else is involved in evaluating this type of decision?',
      'What is your current provider, and what is working or not working?',
    ], shape.questionCount);

    final allProducts = _knowledge.getAllProducts();
    final defaultProduct = allProducts.isNotEmpty ? allProducts.first : null;

    final primary = defaultProduct != null
        ? RankedProduct(
            productName: defaultProduct.name,
            selectionReason:
                '${defaultProduct.name} is one of Airtel\'s most widely applicable '
                'enterprise solutions -- ${defaultProduct.elevatorPitch}',
            elevatorPitch: defaultProduct.elevatorPitch,
          )
        : const RankedProduct(
            productName: 'Airtel Corporate Postpaid',
            selectionReason:
                'Airtel Corporate Postpaid is Airtel\'s most universally applicable enterprise solution.',
            elevatorPitch:
                'Simplifies enterprise mobility through centralised management and better visibility.',
          );

    final strategy = MeetingStrategy(
      leadWith: methodology?.focusAreas.isNotEmpty == true
          ? methodology!.focusAreas.first
          : 'Understanding the customer\'s current business context and priorities',
      avoid: methodology?.risks.isNotEmpty == true
          ? methodology!.risks.first
          : 'Presenting solutions before understanding the customer\'s challenges',
      validate:
          'Confirm the customer\'s immediate priorities and who is involved in the decision',
      closeWith: methodology?.nextBestActions.isNotEmpty == true
          ? _enrichNextBestAction(
              methodology!.nextBestActions.first,
              input.meetingType,
              'your sector',
              primary.productName,
            )
          : 'Agree on clear next steps and document findings before ending the meeting',
    );

    final nba = _buildNextBestAction(input.meetingType, 'your sector', primary.productName);

    return MeetingPrepV3Result(
      contextSummary: contextSummary,
      topChallenges: challenges,
      discoveryQuestions: questions,
      primaryRecommendation: primary,
      supportingRecs: const [],
      topObjections: const [],
      meetingStrategy: strategy,
      nextBestAction: nba,
      isMethodologyOnlyMode: true,
      objectionsDominant: shape.objectionsDominant,
    );
  }

  // ---------------------------------------------------------------------------
  // Full Brief
  // ---------------------------------------------------------------------------

  MeetingPrepV3Result _generateFullBrief(
    MeetingPrepV3Input input,
    IndustryIntelligence industry,
    MeetingMethodology? methodology,
  ) {
    final shape = _resolveShape(input.meetingType);
    final painPoint = _normalisePainPoint(input.painPoint);

    // Phase 2: extract situation note keywords once (active only when no painPoint)
    final noteKeywords = _extractNoteKeywords(input.situationNotes, painPoint);

    // Phase 2.5: Semantic Concept Engine mapping
    final matchedConcepts = _extractSemanticConcepts(input.situationNotes);

    // 1. Rank all products -- Signals 1 through 6 + Semantic Concepts
    final rankedProducts = _rankProducts(input, industry, methodology, painPoint, matchedConcepts);

    final primaryProduct = rankedProducts.isNotEmpty ? rankedProducts[0] : null;
    final supportingSlice = rankedProducts.length > 1
        ? rankedProducts.sublist(
            1, rankedProducts.length.clamp(1, shape.maxSupportingProducts + 1))
        : <ProductIntelligence>[];

    // 2. Rank challenges (Signal 7: notes boost when no pain point)
    final challenges = _rankChallenges(industry, methodology, painPoint, noteKeywords);

    // 3. Select questions (count + tier weights from shape; Signal 7 when active)
    final questions = _selectQuestions(
        industry, methodology, primaryProduct, painPoint, input.objective,
        shape, noteKeywords);

    // 4. Select objections (count + pool boost from shape; Signal 7 when active)
    final objections = _selectObjections(
      primaryProduct,
      supportingSlice.isNotEmpty ? supportingSlice[0] : null,
      industry,
      input.meetingType,
      painPoint,
      shape,
      noteKeywords,
    );

    // 5. Build ranked products with repo-derived reasons + concept explanation
    final primary = primaryProduct != null
        ? _buildRankedProduct(primaryProduct, input.industry!, painPoint, matchedConcepts)
        : _fallbackRankedProduct();

    final supportingRanked = supportingSlice
        .map((p) => _buildRankedProduct(p, input.industry!, painPoint, matchedConcepts))
        .toList();

    // 6. Meeting strategy
    final strategy =
        _buildMeetingStrategy(methodology, challenges, painPoint, input.industry!);

    // 7. Next best action
    final nba = _buildNextBestAction(input.meetingType, input.industry!, primary.productName, matchedConcepts);

    // 8. Context summary
    final contextSummary =
        _buildContextSummary(input, industry, challenges, methodology, painPoint);

    // 9. Expansion opportunities (Renewal, Upsell, QBR only)
    List<String>? expansionOpps;
    if (shape.includeExpansionOpportunities && industry.salesOpportunities.isNotEmpty) {
      expansionOpps = industry.salesOpportunities.take(3).toList();
    }

    return MeetingPrepV3Result(
      contextSummary: contextSummary,
      topChallenges: challenges,
      discoveryQuestions: questions,
      primaryRecommendation: primary,
      supportingRecs: supportingRanked,
      topObjections: objections,
      meetingStrategy: strategy,
      nextBestAction: nba,
      isMethodologyOnlyMode: false,
      objectionsDominant: shape.objectionsDominant,
      expansionOpportunities: expansionOpps,
    );
  }

  // ---------------------------------------------------------------------------
  // Product Ranking  (Signals 1-6)
  // ---------------------------------------------------------------------------

  List<_SemanticConcept> _extractSemanticConcepts(String? situationNotes) {
    if (situationNotes == null || situationNotes.trim().isEmpty) return [];
    final notesLower = situationNotes.toLowerCase();
    
    final matched = <_SemanticConcept>[];
    for (final concept in _semanticConcepts) {
      for (final phrase in concept.phrases) {
        if (notesLower.contains(phrase.toLowerCase())) {
          matched.add(concept);
          break; // Move to next concept once matched
        }
      }
    }
    return matched;
  }

  List<ProductIntelligence> _rankProducts(
    MeetingPrepV3Input input,
    IndustryIntelligence industry,
    MeetingMethodology? methodology,
    String? painPoint,
    List<_SemanticConcept> matchedConcepts,
  ) {
    final allProducts = _knowledge.getAllProducts();
    final hasPainPoint = painPoint != null && painPoint.isNotEmpty;
    final industryChallenges = [
      ...industry.businessChallenges,
      ...industry.technologyChallenges,
    ];

    final scored = allProducts.map((product) {
      double score = 0;

      // Phase 2.5 -- Semantic Concept Boost (+40 per matched concept, max +80)
      double conceptBoost = 0;
      for (final concept in matchedConcepts) {
        if (concept.products.contains(product.name)) {
          conceptBoost += 40;
        }
      }
      score += conceptBoost.clamp(0, 80);

      // Signal 1 -- Industry membership (+40)
      if (product.industries.contains(input.industry)) score += 40;

      // Signal 2 -- Pain point match (dominant when present: +60 or -20)
      if (hasPainPoint) {
        final ppLower = painPoint.toLowerCase();
        final solves = product.painPointsSolved.any((p) {
          final pLower = p.toLowerCase();
          return pLower.contains(ppLower) ||
              ppLower.contains(pLower) ||
              _hasSignificantWordOverlap(ppLower, pLower);
        });
        score += solves ? 60 : -20;
      }

      // Signal 3 -- Industry challenge keyword matching (capped at +20)
      double challengeScore = 0;
      for (final pp in product.painPointsSolved) {
        for (final challenge in industryChallenges) {
          if (_hasSignificantWordOverlap(pp.toLowerCase(), challenge.toLowerCase())) {
            challengeScore += 5;
          }
        }
      }
      score += challengeScore.clamp(0, 20);

      // Signal 4 -- Meeting type affinity (Phase 1: cap raised from +15 to +30)
      if (methodology != null) {
        double affinityScore = 0;
        for (final focus in methodology.focusAreas) {
          for (final pp in product.painPointsSolved) {
            if (_hasSignificantWordOverlap(focus.toLowerCase(), pp.toLowerCase())) {
              affinityScore += 5;
            }
          }
        }
        score += affinityScore.clamp(0, 30);
      }

      // Signal 5 -- Company size eligibility
      if (input.companySize != null) {
        score += _companySizeAdjustment(product, input.companySize!);
      }

      // Signal 6 (Phase 2) -- Cross-sell logic for existing products
      if (input.existingAirtelProducts.isNotEmpty) {
        if (input.existingAirtelProducts.contains(product.name)) {
          // Customer already owns this -- strong penalty so it won't be re-recommended
          score -= 40;
        } else {
          // Boost if this product is a cross-sell partner of an owned product
          for (final ownedName in input.existingAirtelProducts) {
            final owned = allProducts.firstWhere(
              (p) => p.name == ownedName,
              orElse: () => product, // safe fallback; won't match cross-sell
            );
            if (owned.name != product.name &&
                owned.crossSellOpportunities.contains(product.name)) {
              score += 25;
              break;
            }
          }
        }
      }

      return _Scored(product, score);
    }).toList();

    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.map((s) => s.item).toList();
  }

  double _companySizeAdjustment(ProductIntelligence product, String companySize) {
    if (companySize.contains('Small')) {
      final isEnterpriseExclusive = product.idealCustomers.isNotEmpty &&
          product.idealCustomers.every((c) {
            final lower = c.toLowerCase();
            return lower.contains('large') ||
                lower.contains('enterprise') ||
                lower.contains('government') ||
                lower.contains('hyperscale') ||
                lower.contains('cloud service provider');
          });
      return isEnterpriseExclusive ? -50 : 0;
    } else if (companySize.contains('1000+')) {
      final isEnterprise = product.idealCustomers.any((c) {
        final lower = c.toLowerCase();
        return lower.contains('large') ||
            lower.contains('enterprise') ||
            lower.contains('government');
      });
      return isEnterprise ? 10 : 0;
    }
    return 0;
  }

  // ---------------------------------------------------------------------------
  // RankedProduct Builder
  // ---------------------------------------------------------------------------

  RankedProduct _buildRankedProduct(
    ProductIntelligence product,
    String industry,
    String? painPoint,
    List<_SemanticConcept> matchedConcepts,
  ) {
    String reason;
    final hasPainPoint = painPoint != null && painPoint.isNotEmpty;

    // Phase 2.5 -- Build concept prefix if product was boosted
    String conceptPrefix = '';
    final matchingConcepts = matchedConcepts.where((c) => c.products.contains(product.name)).toList();
    if (matchingConcepts.isNotEmpty) {
      final conceptNames = matchingConcepts.map((c) => c.name).join(' and ');
      conceptPrefix = 'Situation notes indicate $conceptNames concerns which ${product.name} directly addresses. ';
    }

    if (hasPainPoint) {
      final ppLower = painPoint.toLowerCase();
      final directSolve = product.painPointsSolved.any((p) {
        final pLower = p.toLowerCase();
        return pLower.contains(ppLower) ||
            ppLower.contains(pLower) ||
            _hasSignificantWordOverlap(ppLower, pLower);
      });

      if (directSolve) {
        reason =
            '$conceptPrefix${product.name} addresses $painPoint -- ${product.elevatorPitch}';
      } else {
        final outcome = product.businessOutcomes.isNotEmpty
            ? product.businessOutcomes.first
            : product.elevatorPitch;
        reason = '$conceptPrefix${product.name} supports $industry organisations by: $outcome';
      }
    } else if (product.industries.contains(industry)) {
      final outcome = product.businessOutcomes.isNotEmpty
          ? product.businessOutcomes.first
          : product.elevatorPitch;
      reason = '$conceptPrefix${product.name} serves $industry organisations by: $outcome';
    } else {
      reason =
          '$conceptPrefix${product.name} complements the primary solution -- ${product.elevatorPitch}';
    }

    return RankedProduct(
      productName: product.name,
      selectionReason: reason,
      elevatorPitch: product.elevatorPitch,
    );
  }

  RankedProduct _fallbackRankedProduct() => const RankedProduct(
        productName: 'Airtel Corporate Postpaid',
        selectionReason:
            'Airtel Corporate Postpaid is Airtel\'s most universally applicable enterprise solution.',
        elevatorPitch:
            'Simplifies enterprise mobility through centralised management and better visibility.',
      );

  // ---------------------------------------------------------------------------
  // Challenge Ranking
  // ---------------------------------------------------------------------------

  List<String> _rankChallenges(
    IndustryIntelligence industry,
    MeetingMethodology? methodology,
    String? painPoint,
    List<String> noteKeywords,
  ) {
    final meetingType = methodology?.meetingType ?? '';
    final isTechFocused =
        meetingType.contains('Technical') || meetingType.contains('Demonstration');
    final isExecFocused = meetingType.contains('Executive');

    final allChallenges = [
      ...industry.businessChallenges.asMap().entries.map((e) {
        double base = (20 - e.key * 2).clamp(2, 20).toDouble();
        if (isExecFocused) base += 10;
        return _Scored(e.value, base);
      }),
      ...industry.technologyChallenges.asMap().entries.map((e) {
        double base = (18 - e.key * 2).clamp(2, 18).toDouble();
        if (isTechFocused) base += 10;
        return _Scored(e.value, base);
      }),
    ];

    final hasPainPoint = painPoint != null && painPoint.isNotEmpty;
    List<_Scored<String>> adjusted;

    if (hasPainPoint) {
      final ppLower = painPoint.toLowerCase();
      final ppWords = ppLower.split(' ').where((w) => w.length > 3).toList();
      adjusted = allChallenges.map((s) {
        final challengeLower = s.item.toLowerCase();
        final matches = ppWords.any((w) => challengeLower.contains(w));
        return _Scored(s.item, s.score + (matches ? 40 : -10));
      }).toList();
    } else if (noteKeywords.isNotEmpty) {
      // Phase 2 Signal 7 -- situation notes boost (+20) when no explicit pain point
      adjusted = allChallenges.map((s) {
        final challengeLower = s.item.toLowerCase();
        final matches = noteKeywords.any((w) => challengeLower.contains(w));
        return _Scored(s.item, s.score + (matches ? 20 : 0));
      }).toList();
    } else {
      adjusted = allChallenges;
    }

    adjusted.sort((a, b) => b.score.compareTo(a.score));
    return adjusted.take(3).map((s) => s.item).toList();
  }

  // ---------------------------------------------------------------------------
  // Question Selection
  // ---------------------------------------------------------------------------

  List<String> _selectQuestions(
    IndustryIntelligence industry,
    MeetingMethodology? methodology,
    ProductIntelligence? primaryProduct,
    String? painPoint,
    String? objective,
    _MeetingOutputShape shape,
    List<String> noteKeywords,
  ) {
    final meetingType = methodology?.meetingType ?? '';
    final isDiscovery = meetingType.contains('Discovery') || meetingType.isEmpty;

    // Phase 1: tier weights flip by meeting type.
    // Discovery: industry questions dominate (30 vs 20).
    // All other types: methodology questions dominate (35 vs 20).
    final tier1Base = isDiscovery ? 30.0 : 20.0;
    final tier2Base = isDiscovery ? 20.0 : 35.0;
    const tier3Base = 10.0;

    final pool = <_Scored<String>>[];

    for (final q in industry.discoveryQuestions) {
      pool.add(_Scored(q, tier1Base));
    }
    for (final q in (methodology?.keyQuestions ?? [])) {
      pool.add(_Scored(q, tier2Base));
    }
    for (final q in (primaryProduct?.discoveryQuestions ?? []).take(2)) {
      pool.add(_Scored(q, tier3Base));
    }

    final hasPainPoint = painPoint != null && painPoint.isNotEmpty;

    if (hasPainPoint) {
      final ppLower = painPoint.toLowerCase();
      final ppWords = ppLower.split(' ').where((w) => w.length > 3).toList();

      // Filter pass: pain-point-matching questions first
      final filtered = pool
          .where((s) => ppWords.any((w) => s.item.toLowerCase().contains(w)))
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));

      if (filtered.length >= shape.questionCount) {
        return _deduplicateAndTake(
            filtered.map((s) => s.item).toList(), shape.questionCount);
      }

      // Fill remaining with boosted scoring
      final boosted = pool.map((s) {
        final matches = ppWords.any((w) => s.item.toLowerCase().contains(w));
        return _Scored(s.item, s.score + (matches ? 50 : 0));
      }).toList()
        ..sort((a, b) => b.score.compareTo(a.score));

      return _deduplicateAndTake(boosted.map((s) => s.item).toList(), shape.questionCount);
    }

    // Objective as secondary signal
    if (objective != null && objective.isNotEmpty) {
      final objWords = objective.toLowerCase().split(' ').where((w) => w.length > 3);
      final boosted = pool.map((s) {
        final matches = objWords.any((w) => s.item.toLowerCase().contains(w));
        return _Scored(s.item, s.score + (matches ? 10 : 0));
      }).toList()
        ..sort((a, b) => b.score.compareTo(a.score));
      return _deduplicateAndTake(boosted.map((s) => s.item).toList(), shape.questionCount);
    }

    pool.sort((a, b) => b.score.compareTo(a.score));

    // Phase 2 Signal 7 -- notes keyword boost when no pain point
    if (noteKeywords.isNotEmpty) {
      final boosted = pool.map((s) {
        final matches = noteKeywords.any((w) => s.item.toLowerCase().contains(w));
        return _Scored(s.item, s.score + (matches ? 20 : 0));
      }).toList()
        ..sort((a, b) => b.score.compareTo(a.score));
      return _deduplicateAndTake(boosted.map((s) => s.item).toList(), shape.questionCount);
    }

    return _deduplicateAndTake(pool.map((s) => s.item).toList(), shape.questionCount);
  }

  // ---------------------------------------------------------------------------
  // Objection Selection
  // ---------------------------------------------------------------------------

  List<ScoredObjection> _selectObjections(
    ProductIntelligence? primary,
    ProductIntelligence? supporting,
    IndustryIntelligence industry,
    String? meetingType,
    String? painPoint,
    _MeetingOutputShape shape,
    List<String> noteKeywords,
  ) {
    final pool = <_Scored<ScoredObjection>>[];
    final boost = shape.objectionPoolBoost;

    // Tier A: primary product -- highest relevance
    if (primary != null) {
      for (var i = 0; i < primary.objections.length; i++) {
        final response = i < primary.objectionResponses.length
            ? primary.objectionResponses[i]
            : 'Engage with the Airtel enterprise team for a tailored response.';
        pool.add(_Scored(
          ScoredObjection(objection: primary.objections[i], response: response),
          30 + boost,
        ));
      }
    }

    // Tier B: supporting product
    if (supporting != null) {
      for (var i = 0; i < supporting.objections.length; i++) {
        final response = i < supporting.objectionResponses.length
            ? supporting.objectionResponses[i]
            : 'Engage with the Airtel enterprise team for a tailored response.';
        pool.add(_Scored(
          ScoredObjection(objection: supporting.objections[i], response: response),
          20 + boost,
        ));
      }
    }

    // Tier C: industry-level objections
    for (final obj in industry.objections) {
      pool.add(_Scored(
        ScoredObjection(
          objection: obj,
          response:
              'Demonstrate Airtel\'s specific solution fit for ${industry.industryName} organisations '
              'and reference relevant case studies from the sector.',
        ),
        15 + boost,
      ));
    }

    final mtLower = (meetingType ?? '').toLowerCase();
    final isCommercial = mtLower.contains('renewal') ||
        mtLower.contains('negotiation') ||
        mtLower.contains('proposal');

    final hasPainPoint = painPoint != null && painPoint.isNotEmpty;
    List<_Scored<ScoredObjection>> scored;

    if (hasPainPoint) {
      final ppLower = painPoint.toLowerCase();
      final ppWords = ppLower.split(' ').where((w) => w.length > 3).toList();

      final filtered = pool
          .where((s) => ppWords.any((w) => s.item.objection.toLowerCase().contains(w)))
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));

      if (filtered.length >= shape.objectionCount) {
        return filtered.take(shape.objectionCount).map((s) => s.item).toList();
      }

      scored = pool.map((s) {
        final objLower = s.item.objection.toLowerCase();
        final ppMatch = ppWords.any((w) => objLower.contains(w));
        double sc = s.score + (ppMatch ? 50 : 0);
        if (isCommercial && _isCommercialObjection(objLower)) sc += 20;
        return _Scored(s.item, sc);
      }).toList();
    } else {
      scored = pool.map((s) {
        double sc = s.score;
        if (isCommercial && _isCommercialObjection(s.item.objection.toLowerCase())) {
          sc += 20;
        }
        return _Scored(s.item, sc);
      }).toList();
    }

    scored.sort((a, b) => b.score.compareTo(a.score));

    // Phase 2 Signal 7 -- notes boost on objections when no explicit pain point
    if (noteKeywords.isNotEmpty && !hasPainPoint) {
      scored = scored.map((s) {
        final matches =
            noteKeywords.any((w) => s.item.objection.toLowerCase().contains(w));
        return _Scored(s.item, s.score + (matches ? 20 : 0));
      }).toList()
        ..sort((a, b) => b.score.compareTo(a.score));
    }

    return scored.take(shape.objectionCount).map((s) => s.item).toList();
  }

  bool _isCommercialObjection(String lower) =>
      lower.contains('price') ||
      lower.contains('cost') ||
      lower.contains('contract') ||
      lower.contains('budget') ||
      lower.contains('cheaper');

  // ---------------------------------------------------------------------------
  // Meeting Strategy
  // ---------------------------------------------------------------------------

  MeetingStrategy _buildMeetingStrategy(
    MeetingMethodology? methodology,
    List<String> challenges,
    String? painPoint,
    String industry,
  ) {
    final leadBase = methodology?.focusAreas.isNotEmpty == true
        ? methodology!.focusAreas.first
        : 'Understanding the customer\'s current priorities and business context';

    final hasPainPoint = painPoint != null && painPoint.isNotEmpty;
    final leadWith = hasPainPoint
        ? '$leadBase -- specifically exploring $painPoint challenges in their $industry operations'
        : leadBase;

    final avoid = methodology?.risks.isNotEmpty == true
        ? methodology!.risks.first
        : 'Presenting solutions before understanding the customer\'s specific challenges';

    final topChallenge =
        challenges.isNotEmpty ? challenges.first : 'key operational challenges';
    final validate =
        'Confirm with the customer: is "$topChallenge" currently affecting their operations?';

    final rawClose = methodology?.nextBestActions.isNotEmpty == true
        ? methodology!.nextBestActions.first
        : 'Agree on clear next steps before ending the meeting';

    final closeWith =
        _enrichNextBestAction(rawClose, methodology?.meetingType, industry, '');

    return MeetingStrategy(
      leadWith: leadWith,
      avoid: avoid,
      validate: validate,
      closeWith: closeWith,
    );
  }

  // ---------------------------------------------------------------------------
  // Next Best Action
  // ---------------------------------------------------------------------------

  String _buildNextBestAction(
    String? meetingType,
    String industry,
    String productName,
    [List<_SemanticConcept> matchedConcepts = const []]
  ) {
    return _enrichNextBestAction('Agree on next steps', meetingType, industry, productName, matchedConcepts);
  }

  String _enrichNextBestAction(
    String base,
    String? meetingType,
    String industry,
    String productName,
    [List<_SemanticConcept> matchedConcepts = const []]
  ) {
    // Phase 2.5: Semantic Concept NBA injection
    String conceptNbaPrefix = '';
    if (matchedConcepts.isNotEmpty) {
      conceptNbaPrefix = '${matchedConcepts.first.nba} ';
    }

    final mt = meetingType ?? '';
    if (mt.contains('Discovery')) {
      return '${conceptNbaPrefix}Document the top 2 $industry challenges identified and '
          'confirm the stakeholder map before leaving the meeting';
    } else if (mt.contains('Technical Workshop')) {
      return '${conceptNbaPrefix}Provide $productName architecture documentation and '
          'scope the Statement of Work within 48 hours';
    } else if (mt.contains('Renewal Negotiation')) {
      return '${conceptNbaPrefix}Secure a verbal agreement on terms and route the renewal '
          'contract for signature today';
    } else if (mt.contains('Executive')) {
      return '${conceptNbaPrefix}Send an executive summary and initiate a technical working group -- '
          'do not leave without naming a champion';
    } else if (mt.contains('Quarterly') || mt.contains('QBR')) {
      return '${conceptNbaPrefix}Send QBR summary report within 24 hours and action '
          'all pending open support items';
    } else if (mt.contains('Proposal')) {
      return '${conceptNbaPrefix}Send the revised $productName proposal with ROI justification '
          'within 48 hours';
    } else if (mt.contains('Upsell')) {
      return '${conceptNbaPrefix}Provide detailed $productName information and schedule '
          'a technical deep-dive session';
    } else if (mt.contains('Demonstration') || mt.contains('Demo')) {
      return '${conceptNbaPrefix}Send a tailored $productName proposal and discuss '
          'pilot or proof-of-concept terms';
    } else if (mt.contains('Stakeholder')) {
      return '${conceptNbaPrefix}Draft the stakeholder engagement plan and request '
          'introductions to secondary decision-makers within 48 hours';
    } else if (mt.contains('Renewal')) {
      return '${conceptNbaPrefix}Send adoption metrics summary and renewal contract for review '
          'within 48 hours -- resolve any flagged service issues first';
    }
    return '$conceptNbaPrefix$base -- focused on $industry context with $productName as the primary solution';
  }

  // ---------------------------------------------------------------------------
  // Context Summary
  // ---------------------------------------------------------------------------

  String _buildContextSummary(
    MeetingPrepV3Input input,
    IndustryIntelligence industry,
    List<String> challenges,
    MeetingMethodology? methodology,
    String? painPoint,
  ) {
    final prefix =
        input.customerName != null ? 'Meeting with ${input.customerName}. ' : '';
    final historyNote =
        (input.previousMeetingCount != null && input.previousMeetingCount! > 0)
            ? '${input.previousMeetingCount} previous engagements on record. '
            : '';

    final c1 =
        challenges.isNotEmpty ? challenges[0].toLowerCase() : 'operational challenges';
    final c2 = challenges.length > 1
        ? challenges[1].toLowerCase()
        : 'infrastructure priorities';

    final purpose = methodology?.purpose ?? 'identify how Airtel can add strategic value';
    final meetingLabel = input.meetingType ?? 'this meeting';

    // Phase 2: mention existing products when provided
    final existingNote = input.existingAirtelProducts.isNotEmpty
        ? ' They currently use ${input.existingAirtelProducts.join(', ')}.'
        : '';

    if (painPoint != null && painPoint.isNotEmpty) {
      return '$prefix$historyNote${industry.industryName} organisations '
          'dealing with $painPoint typically face $c1 and $c2.$existingNote '
          'This $meetingLabel is best used to $purpose.';
    }

    return '$prefix$historyNote${industry.industryName} organisations '
        'typically face $c1 and $c2.$existingNote '
        'This $meetingLabel is best used to $purpose.';
  }

  // ---------------------------------------------------------------------------
  // Utilities
  // ---------------------------------------------------------------------------

  String? _normalisePainPoint(String? painPoint) {
    if (painPoint == null || painPoint.trim().isEmpty) return null;
    return painPoint.trim();
  }

  /// Phase 2: Extracts significant keywords from situationNotes.
  /// Returns empty when painPoint is present -- painPoint always wins.
  List<String> _extractNoteKeywords(String? notes, String? painPoint) {
    if (notes == null || notes.trim().isEmpty) return const [];
    if (painPoint != null && painPoint.isNotEmpty) return const [];
    return notes
        .toLowerCase()
        .split(RegExp(r'[\s,;.!?]+'))
        .where((w) => w.length > 3)
        .toSet()
        .toList();
  }

  bool _hasSignificantWordOverlap(String a, String b) {
    final aWords = a.split(RegExp(r'\W+')).where((w) => w.length > 3);
    return aWords.any((w) => b.contains(w));
  }

  List<String> _deduplicateAndTake(List<String> items, int n) {
    final seen = <String>{};
    final result = <String>[];
    for (final item in items) {
      if (seen.add(item) && result.length < n) {
        result.add(item);
      }
    }
    return result;
  }
}
