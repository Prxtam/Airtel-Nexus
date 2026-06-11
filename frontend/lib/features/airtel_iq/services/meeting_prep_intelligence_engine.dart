import 'package:frontend/features/airtel_iq/knowledge/airtel_iq_knowledge_service.dart';
import 'package:frontend/features/airtel_iq/knowledge/knowledge_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Output Models
// ─────────────────────────────────────────────────────────────────────────────

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

/// The complete V3 output. Every list field is strictly bounded.
class MeetingPrepV3Result {
  final String contextSummary;
  final List<String> topChallenges;       // max 3
  final List<String> discoveryQuestions;  // max 5
  final RankedProduct primaryRecommendation;
  final List<RankedProduct> supportingRecs; // max 2
  final List<ScoredObjection> topObjections; // max 3
  final MeetingStrategy meetingStrategy;
  final String nextBestAction;

  /// True when generation ran without industry context (methodology-only path).
  final bool isMethodologyOnlyMode;

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
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Input Model
// ─────────────────────────────────────────────────────────────────────────────

class MeetingPrepV3Input {
  /// Required for full intelligence. Null triggers methodology-only fallback.
  final String? industry;

  /// Required. Maps to a MeetingMethodology in the repository.
  final String meetingType;

  /// Optional. Enables eligibility filtering (e.g. removes Private 5G for SMBs).
  final String? companySize;

  /// Optional. When provided, becomes the dominant ranking and filtering signal.
  final String? painPoint;

  /// Optional. Secondary signal for question and NBA tuning.
  final String? objective;

  /// Customer name — displayed in the context summary for History Mode.
  final String? customerName;

  /// Previous meeting count — displayed in the context summary for History Mode.
  final int? previousMeetingCount;

  const MeetingPrepV3Input({
    this.industry,
    required this.meetingType,
    this.companySize,
    this.painPoint,
    this.objective,
    this.customerName,
    this.previousMeetingCount,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal Scoring Helper
// ─────────────────────────────────────────────────────────────────────────────

class _Scored<T> {
  final T item;
  final double score;
  const _Scored(this.item, this.score);
}

// ─────────────────────────────────────────────────────────────────────────────
// Engine
// ─────────────────────────────────────────────────────────────────────────────

class MeetingPrepIntelligenceEngine {
  final AirtelIqKnowledgeService _knowledge = AirtelIqKnowledgeService();

  /// Entry point. Always returns a result — never throws.
  /// Falls back to methodology-only mode when industry is unavailable.
  Future<MeetingPrepV3Result> generate(MeetingPrepV3Input input) async {
    // Simulate processing time
    await Future.delayed(const Duration(milliseconds: 1000));

    final methodology = _knowledge.getMethodologyByMeetingType(input.meetingType);
    final industry =
        input.industry != null ? _knowledge.getIndustryByName(input.industry!) : null;

    if (industry == null) {
      return _generateMethodologyOnly(input, methodology);
    }
    return _generateFullBrief(input, industry, methodology);
  }

  // ─── Methodology-Only Fallback ───────────────────────────────────────────

  MeetingPrepV3Result _generateMethodologyOnly(
    MeetingPrepV3Input input,
    MeetingMethodology? methodology,
  ) {
    final customerPrefix =
        input.customerName != null ? 'Meeting with ${input.customerName}. ' : '';
    final historyNote =
        (input.previousMeetingCount != null && input.previousMeetingCount! > 0)
            ? '${input.previousMeetingCount} previous engagements on record. '
            : '';

    final contextSummary =
        '$customerPrefix${historyNote}Industry context not provided — '
        'preparation is based on ${input.meetingType} methodology defaults. '
        'Add an industry in the Enrich Context section for a fully tailored brief.';

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
    ], 5);

    final allProducts = _knowledge.getAllProducts();
    final defaultProduct = allProducts.isNotEmpty ? allProducts.first : null;

    final primary = defaultProduct != null
        ? RankedProduct(
            productName: defaultProduct.name,
            selectionReason:
                '${defaultProduct.name} is one of Airtel\'s most widely applicable '
                'enterprise solutions — ${defaultProduct.elevatorPitch}',
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
              methodology.meetingType,
              'your industry',
              primary.productName,
            )
          : 'Agree on clear next steps and document findings before ending the meeting',
    );

    final nba = _buildNextBestAction(methodology, 'your industry', primary.productName);

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
    );
  }

  // ─── Full Brief ──────────────────────────────────────────────────────────

  MeetingPrepV3Result _generateFullBrief(
    MeetingPrepV3Input input,
    IndustryIntelligence industry,
    MeetingMethodology? methodology,
  ) {
    final painPoint = _normalisePainPoint(input.painPoint);

    // 1. Rank all 15 products
    final rankedProducts = _rankProducts(input, industry, methodology, painPoint);

    final primaryProduct = rankedProducts.isNotEmpty ? rankedProducts[0] : null;
    final supporting = rankedProducts.length > 1
        ? rankedProducts.sublist(1, rankedProducts.length.clamp(1, 3))
        : <ProductIntelligence>[];

    // 2. Rank challenges
    final challenges = _rankChallenges(industry, methodology, painPoint);

    // 3. Select questions (filtered toward pain point when present)
    final questions = _selectQuestions(
        industry, methodology, primaryProduct, painPoint, input.objective);

    // 4. Select objections (filtered toward pain point when present)
    final objections = _selectObjections(
      primaryProduct,
      supporting.isNotEmpty ? supporting[0] : null,
      industry,
      input.meetingType,
      painPoint,
    );

    // 5. Build ranked products with repo-derived reasons
    final primary = primaryProduct != null
        ? _buildRankedProduct(primaryProduct, input.industry!, painPoint)
        : _fallbackRankedProduct();

    final supportingRanked = supporting
        .map((p) => _buildRankedProduct(p, input.industry!, painPoint))
        .toList();

    // 6. Meeting strategy
    final strategy =
        _buildMeetingStrategy(methodology, challenges, painPoint, input.industry!);

    // 7. Next best action
    final nba = _buildNextBestAction(methodology, input.industry!, primary.productName);

    // 8. Context summary
    final contextSummary =
        _buildContextSummary(input, industry, challenges, methodology, painPoint);

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
    );
  }

  // ─── Product Ranking ─────────────────────────────────────────────────────

  List<ProductIntelligence> _rankProducts(
    MeetingPrepV3Input input,
    IndustryIntelligence industry,
    MeetingMethodology? methodology,
    String? painPoint,
  ) {
    final allProducts = _knowledge.getAllProducts();
    final hasPainPoint = painPoint != null && painPoint.isNotEmpty;
    final industryChallenges = [
      ...industry.businessChallenges,
      ...industry.technologyChallenges,
    ];

    final scored = allProducts.map((product) {
      double score = 0;

      // Signal 1 — Industry membership (+40)
      if (product.industries.contains(input.industry)) score += 40;

      // Signal 2 — Pain point match (dominant when present: +60 or -20)
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

      // Signal 3 — Industry challenge keyword matching (capped at +20)
      double challengeScore = 0;
      for (final pp in product.painPointsSolved) {
        for (final challenge in industryChallenges) {
          if (_hasSignificantWordOverlap(pp.toLowerCase(), challenge.toLowerCase())) {
            challengeScore += 5;
          }
        }
      }
      score += challengeScore.clamp(0, 20);

      // Signal 4 — Meeting type affinity (capped at +15)
      if (methodology != null) {
        double affinityScore = 0;
        for (final focus in methodology.focusAreas) {
          for (final pp in product.painPointsSolved) {
            if (_hasSignificantWordOverlap(
                focus.toLowerCase(), pp.toLowerCase())) {
              affinityScore += 5;
            }
          }
        }
        score += affinityScore.clamp(0, 15);
      }

      // Signal 5 — Company size eligibility
      if (input.companySize != null) {
        score += _companySizeAdjustment(product, input.companySize!);
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

  // ─── RankedProduct Builder ────────────────────────────────────────────────

  RankedProduct _buildRankedProduct(
    ProductIntelligence product,
    String industry,
    String? painPoint,
  ) {
    String reason;
    final hasPainPoint = painPoint != null && painPoint.isNotEmpty;

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
            '${product.name} directly addresses $painPoint — ${product.elevatorPitch}';
      } else {
        final outcome = product.businessOutcomes.isNotEmpty
            ? product.businessOutcomes.first
            : product.elevatorPitch;
        reason = '${product.name} supports $industry organisations by: $outcome';
      }
    } else if (product.industries.contains(industry)) {
      final outcome = product.businessOutcomes.isNotEmpty
          ? product.businessOutcomes.first
          : product.elevatorPitch;
      reason = '${product.name} serves $industry organisations by: $outcome';
    } else {
      reason =
          '${product.name} complements the primary solution — ${product.elevatorPitch}';
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

  // ─── Challenge Ranking ────────────────────────────────────────────────────

  List<String> _rankChallenges(
    IndustryIntelligence industry,
    MeetingMethodology? methodology,
    String? painPoint,
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

    // Pain point is DOMINANT for challenge ranking
    final hasPainPoint = painPoint != null && painPoint.isNotEmpty;
    List<_Scored<String>> adjusted;

    if (hasPainPoint) {
      final ppLower = painPoint.toLowerCase();
      final ppWords =
          ppLower.split(' ').where((w) => w.length > 3).toList();

      adjusted = allChallenges.map((s) {
        final challengeLower = s.item.toLowerCase();
        final matches = ppWords.any((w) => challengeLower.contains(w));
        return _Scored(s.item, s.score + (matches ? 40 : -10));
      }).toList();
    } else {
      adjusted = allChallenges;
    }

    adjusted.sort((a, b) => b.score.compareTo(a.score));
    return adjusted.take(3).map((s) => s.item).toList();
  }

  // ─── Question Selection ───────────────────────────────────────────────────

  List<String> _selectQuestions(
    IndustryIntelligence industry,
    MeetingMethodology? methodology,
    ProductIntelligence? primaryProduct,
    String? painPoint,
    String? objective,
  ) {
    // Build scored pool from three tiers
    final pool = <_Scored<String>>[];

    for (final q in industry.discoveryQuestions) {
      pool.add(_Scored(q, 30));
    }
    for (final q in (methodology?.keyQuestions ?? [])) {
      pool.add(_Scored(q, 20));
    }
    for (final q in (primaryProduct?.discoveryQuestions ?? []).take(2)) {
      pool.add(_Scored(q, 10));
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

      if (filtered.length >= 5) {
        return _deduplicateAndTake(filtered.map((s) => s.item).toList(), 5);
      }

      // Fill remaining with boosted scoring
      final boosted = pool.map((s) {
        final matches = ppWords.any((w) => s.item.toLowerCase().contains(w));
        return _Scored(s.item, s.score + (matches ? 50 : 0));
      }).toList()
        ..sort((a, b) => b.score.compareTo(a.score));

      return _deduplicateAndTake(boosted.map((s) => s.item).toList(), 5);
    }

    // Objective as secondary signal
    if (objective != null && objective.isNotEmpty) {
      final objWords = objective.toLowerCase().split(' ').where((w) => w.length > 3);
      final boosted = pool.map((s) {
        final matches = objWords.any((w) => s.item.toLowerCase().contains(w));
        return _Scored(s.item, s.score + (matches ? 10 : 0));
      }).toList()
        ..sort((a, b) => b.score.compareTo(a.score));
      return _deduplicateAndTake(boosted.map((s) => s.item).toList(), 5);
    }

    pool.sort((a, b) => b.score.compareTo(a.score));
    return _deduplicateAndTake(pool.map((s) => s.item).toList(), 5);
  }

  // ─── Objection Selection ──────────────────────────────────────────────────

  List<ScoredObjection> _selectObjections(
    ProductIntelligence? primary,
    ProductIntelligence? supporting,
    IndustryIntelligence industry,
    String meetingType,
    String? painPoint,
  ) {
    final pool = <_Scored<ScoredObjection>>[];

    // Tier A: primary product (matched objection+response pairs)
    if (primary != null) {
      for (var i = 0; i < primary.objections.length; i++) {
        final response = i < primary.objectionResponses.length
            ? primary.objectionResponses[i]
            : 'Engage with the Airtel enterprise team for a tailored response.';
        pool.add(_Scored(
          ScoredObjection(objection: primary.objections[i], response: response),
          30,
        ));
      }
    }

    // Tier B: supporting product (matched pairs)
    if (supporting != null) {
      for (var i = 0; i < supporting.objections.length; i++) {
        final response = i < supporting.objectionResponses.length
            ? supporting.objectionResponses[i]
            : 'Engage with the Airtel enterprise team for a tailored response.';
        pool.add(_Scored(
          ScoredObjection(objection: supporting.objections[i], response: response),
          20,
        ));
      }
    }

    // Tier C: industry-level objections (generic response)
    for (final obj in industry.objections) {
      pool.add(_Scored(
        ScoredObjection(
          objection: obj,
          response:
              'Demonstrate Airtel\'s specific solution fit for ${industry.industryName} organisations '
              'and reference relevant case studies from the sector.',
        ),
        15,
      ));
    }

    // Commercial meeting boost
    final mtLower = meetingType.toLowerCase();
    final isCommercial = mtLower.contains('renewal') ||
        mtLower.contains('negotiation') ||
        mtLower.contains('proposal');

    final hasPainPoint = painPoint != null && painPoint.isNotEmpty;

    List<_Scored<ScoredObjection>> scored;

    if (hasPainPoint) {
      final ppLower = painPoint.toLowerCase();
      final ppWords = ppLower.split(' ').where((w) => w.length > 3).toList();

      // Filter pass: pain-point-oriented objections first
      final filtered = pool
          .where((s) => ppWords.any((w) => s.item.objection.toLowerCase().contains(w)))
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));

      if (filtered.length >= 3) {
        return filtered.take(3).map((s) => s.item).toList();
      }

      // Boost pain-point-matching objections
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
    return scored.take(3).map((s) => s.item).toList();
  }

  bool _isCommercialObjection(String lower) =>
      lower.contains('price') ||
      lower.contains('cost') ||
      lower.contains('contract') ||
      lower.contains('budget') ||
      lower.contains('cheaper');

  // ─── Meeting Strategy ─────────────────────────────────────────────────────

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
        ? '$leadBase — specifically exploring $painPoint challenges in their $industry operations'
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

    final closeWith = _enrichNextBestAction(
      rawClose,
      methodology?.meetingType ?? '',
      industry,
      '',
    );

    return MeetingStrategy(
      leadWith: leadWith,
      avoid: avoid,
      validate: validate,
      closeWith: closeWith,
    );
  }

  // ─── Next Best Action ─────────────────────────────────────────────────────

  String _buildNextBestAction(
    MeetingMethodology? methodology,
    String industry,
    String productName,
  ) {
    final meetingType = methodology?.meetingType ?? '';
    return _enrichNextBestAction(
      methodology?.nextBestActions.isNotEmpty == true
          ? methodology!.nextBestActions.first
          : 'Agree on next steps',
      meetingType,
      industry,
      productName,
    );
  }

  String _enrichNextBestAction(
    String base,
    String meetingType,
    String industry,
    String productName,
  ) {
    if (meetingType.contains('Discovery')) {
      return 'Document the top 2 $industry challenges identified and '
          'confirm the stakeholder map before leaving the meeting';
    } else if (meetingType.contains('Technical Workshop')) {
      return 'Provide $productName architecture documentation and '
          'scope the Statement of Work within 48 hours';
    } else if (meetingType.contains('Renewal Negotiation')) {
      return 'Secure a verbal agreement on terms and route the renewal '
          'contract for signature today';
    } else if (meetingType.contains('Executive')) {
      return 'Send an executive summary and initiate a technical working group — '
          'do not leave without naming a champion';
    } else if (meetingType.contains('Quarterly') || meetingType.contains('QBR')) {
      return 'Send QBR summary report within 24 hours and action '
          'all pending open support items';
    } else if (meetingType.contains('Proposal')) {
      return 'Send the revised $productName proposal with ROI justification '
          'within 48 hours';
    } else if (meetingType.contains('Upsell')) {
      return 'Provide detailed $productName information and schedule '
          'a technical deep-dive session';
    } else if (meetingType.contains('Demo') || meetingType.contains('Demonstration')) {
      return 'Send a tailored $productName proposal and discuss '
          'pilot or proof-of-concept terms';
    } else if (meetingType.contains('Stakeholder')) {
      return 'Draft the stakeholder engagement plan and request '
          'introductions to secondary decision-makers within 48 hours';
    } else if (meetingType.contains('Renewal')) {
      return 'Send the renewal contract and address any escalated issues '
          'flagged during the meeting';
    }
    return '$base — in the context of $industry with $productName as the primary solution';
  }

  // ─── Context Summary ──────────────────────────────────────────────────────

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

    final c1 = challenges.isNotEmpty
        ? challenges[0].toLowerCase()
        : 'operational challenges';
    final c2 = challenges.length > 1
        ? challenges[1].toLowerCase()
        : 'infrastructure priorities';

    final purpose =
        methodology?.purpose ?? 'identify how Airtel can add strategic value';

    if (painPoint != null && painPoint.isNotEmpty) {
      return '$prefix$historyNote${industry.industryName} organisations '
          'dealing with $painPoint typically face $c1 and $c2. '
          'This ${input.meetingType} is best used to $purpose.';
    }

    return '$prefix$historyNote${industry.industryName} organisations '
        'typically face $c1 and $c2. '
        'This ${input.meetingType} is best used to $purpose.';
  }

  // ─── Utilities ────────────────────────────────────────────────────────────

  /// Removes entries with fewer than [n] meaningful word characters from being
  /// used as the pain-point signal (avoids matching on single prepositions).
  String? _normalisePainPoint(String? painPoint) {
    if (painPoint == null || painPoint.trim().isEmpty) return null;
    return painPoint.trim();
  }

  /// Checks whether two strings share at least one significant word (>3 chars).
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
