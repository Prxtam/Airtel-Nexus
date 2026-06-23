/// Opportunity Insights Engine — Phase 8.7
/// Strategic Account Growth Assistant
///
/// 100% deterministic. No LLM, no external calls, no generative reasoning.
/// Reads from existing repositories only — no data is duplicated.
///
/// Repositories used (read-only):
///   - industry_intelligence.dart (industry-level signals)
///   - product_intelligence.dart (pain point → product mapping)
///   - airtel_iq_knowledge_service.dart (adapter for the above)
///
/// Scoring Philosophy: Whitespace-first.
/// More unowned products = higher growth potential.
/// NOT: more existing products = higher potential.
library;

import 'package:frontend/features/airtel_iq/knowledge/airtel_iq_knowledge_service.dart';
import 'package:frontend/features/airtel_iq/knowledge/knowledge_models.dart';
import 'package:frontend/features/airtel_iq/models/opportunity_insights_models.dart';

class OpportunityInsightsEngine {
  final AirtelIqKnowledgeService _knowledge = AirtelIqKnowledgeService();

  // ── Conversation Areas ─────────────────────────────────────────────────────
  // Business discussion topics for strategic account planning.
  // These are NOT product recommendations — they are business themes.
  static const Map<String, List<String>> _conversationAreas = {
    'Banking & Financial Services': [
      'Digital transformation roadmap and cloud migration strategy',
      'Branch expansion or consolidation plans over the next 12–18 months',
      'Data sovereignty strategy and regulatory compliance priorities',
    ],
    'IT & ITES': [
      'Remote and hybrid workforce strategy post-2024',
      'Cloud cost optimization and multi-cloud management',
      'Global delivery SLA pressures and connectivity to international clients',
    ],
    'Manufacturing': [
      'Industry 4.0 adoption timeline and factory automation roadmap',
      'Predictive maintenance initiatives and operational visibility goals',
      'Supply chain resilience and multi-site coordination strategy',
    ],
    'Automotive': [
      'Connected vehicle and EV transition roadmap',
      'Smart factory and Industry 4.0 deployment plans',
      'AIS-140 fleet compliance strategy across commercial vehicle portfolio',
    ],
    'Healthcare': [
      'Telemedicine expansion roadmap and digital health priorities',
      'Patient data governance and cybersecurity posture',
      'Hospital network modernization without disrupting clinical operations',
    ],
    'Logistics': [
      'Last-mile efficiency initiatives and fleet expansion plans',
      'Warehouse automation and real-time inventory visibility goals',
      'Driver communication and fleet management modernization',
    ],
    'Retail': [
      'Omnichannel strategy and store network expansion',
      'Seasonal demand planning and rapid store provisioning',
      'Supply chain visibility and inventory management modernization',
    ],
    'E-Commerce': [
      'Platform resilience strategy for peak traffic events',
      'Customer engagement automation and notification delivery',
      'Logistics integration and last-mile tracking capabilities',
    ],
    'Government': [
      'Smart city initiatives and digital citizen services roadmap',
      'Cybersecurity posture and critical infrastructure protection',
      'Inter-departmental connectivity and data localization strategy',
    ],
    'Energy & Utilities': [
      'Grid modernization plans and smart metering rollout',
      'Renewable energy site expansion and remote connectivity',
      'Field worker safety programs and real-time monitoring strategy',
    ],
    'Hospitality': [
      'Guest experience digitization and contactless service strategy',
      'Multi-property network management and cost optimization',
      'Loyalty program and guest engagement automation',
    ],
    'Education': [
      'Hybrid and remote learning infrastructure roadmap',
      'Campus safety communication and emergency alert systems',
      'Student engagement and admissions communication strategy',
    ],
    'Media & Entertainment': [
      'Content delivery resilience for major live events',
      'International market expansion and global connectivity strategy',
      'Cloud cost optimization for transcoding and rendering workloads',
    ],
    'Telecom & Carriers': [
      'International traffic growth and revenue monetization strategy',
      'India market entry or expansion plans for the next 12 months',
      'Regulatory compliance strategy under the Telecom Act 2023',
    ],
    'Travel & Tourism': [
      'Personalized guest journey strategy across pre-arrival to post-stay',
      'Energy management and sustainability across properties',
      'Contact center modernization for high-volume reservation support',
    ],
  };

  // ── Industry-level Strategic Risks ─────────────────────────────────────────
  // Business-level account risks — NOT product objections.
  static const Map<String, List<String>> _industryRisks = {
    'Banking & Financial Services': [
      'Regulatory scrutiny on every new vendor change requires multi-level sign-off',
      'Long RFP and compliance procurement cycles (3–9 months typical)',
      'Heavy existing MPLS investment creates migration resistance',
    ],
    'IT & ITES': [
      'Client-mandated technology choices limit vendor flexibility',
      'Internal IT teams prefer self-managed infrastructure to managed services',
      'Existing MPLS backbone investment creates rip-and-replace resistance',
    ],
    'Manufacturing': [
      'Long operational sales cycles due to factory uptime risk aversion',
      'Complex OT/IT network integration requires specialized approvals',
      'Change management is difficult when factory floor continuity is at stake',
    ],
    'Automotive': [
      'Long OEM qualification and homologation cycles before vendor approval',
      'Existing telematics vendor relationships are deeply embedded',
      'Private 5G CAPEX scrutiny in annual budget planning cycles',
    ],
    'Healthcare': [
      'Compliance-heavy procurement requiring clinical and legal sign-off',
      'IT budgets are secondary to medical equipment spend',
      'High uptime requirement creates extreme resistance to network changes',
    ],
    'Logistics': [
      'Thin operating margins limit appetite for premium connectivity investment',
      'High fleet staff turnover complicates device and SIM management',
      'BYOD culture among drivers creates device standardization challenges',
    ],
    'Retail': [
      'Seasonal budget cycles create narrow procurement windows',
      'Decentralized store decision-making slows central IT deals',
      'Thin retail margins limit premium connectivity investment',
    ],
    'E-Commerce': [
      'Deep commitment to existing hyperscaler (AWS/GCP) ecosystems',
      'CPaaS volume pricing contracts create strong vendor lock-in',
      'Logistics fully outsourced to 3PL providers reduces IoT opportunity',
    ],
    'Government': [
      'BSNL mandate preference for government-owned telecom networks',
      'Multi-year procurement and RFP cycles significantly extend sales timelines',
      'Data localization restrictions limit cloud and colocation conversations',
    ],
    'Energy & Utilities': [
      'Critical infrastructure risk aversion makes network changes very difficult',
      'OT/IT integration complexity requires specialized approval processes',
      'Cellular reliability concerns for mission-critical grid infrastructure',
    ],
    'Hospitality': [
      'Low-margin business model limits IT infrastructure investment',
      'Property-level decision-making is fragmented across locations',
      'Legacy PBX replacement CAPEX is prohibitive across multiple properties',
    ],
    'Education': [
      'Public institution procurement constraints tied to government budget cycles',
      'Established campus network vendor creates strong incumbent advantage',
      'Cloud migration perceived as expensive given tight education budgets',
    ],
    'Media & Entertainment': [
      'Deep commitment to global CDN providers (Akamai, AWS CloudFront)',
      'Streaming platform vendor manages delivery, reducing direct Airtel access',
      'Content delivery is event-driven making long-term contracts complex',
    ],
    'Telecom & Carriers': [
      'Established incumbent relationships with BSNL/Tata for Indian termination',
      'Rate sensitivity on top international corridors is extremely high',
      'DLT compliance complexity creates adoption barriers for foreign carriers',
    ],
    'Travel & Tourism': [
      'Existing internet and PBX contracts create 12–24 month switching barriers',
      'Fragmented property-level decisions complicate central negotiations',
      'Hospitality margins create budget pressure on every IT investment',
    ],
  };

  // ── Main Entry Point ───────────────────────────────────────────────────────

  OpportunityInsightsResult generate(OpportunityInsightsInput input) {
    final industryData = _knowledge.getIndustryByName(input.industry);
    final List<ProductIntelligence> allProducts = _knowledge.getAllProducts();

    // 1. Industry-recommended products (from repository, not hardcoded)
    final industryRecommended = industryData?.recommendedProducts ?? <String>[];

    // 2. Whitespace: industry-recommended products NOT in existing stack
    final existingNorm = input.existingProducts
        .map((p) => p.toLowerCase())
        .toSet();
    final whiteSpace = industryRecommended.where((p) {
      return !existingNorm.any(
        (e) => e.contains(p.toLowerCase()) || p.toLowerCase().contains(e),
      );
    }).toList();

    // 3. Growth Potential Score (whitespace-first)
    final growthPotential = _calculateGrowthPotential(
      input: input,
      industryData: industryData,
      whiteSpaceCount: whiteSpace.length,
      allProducts: allProducts,
    );

    // 4. Best Opportunities (max 3, score-threshold confidence)
    final bestOpportunities = _rankOpportunities(
      input: input,
      candidates: whiteSpace,
      allProducts: allProducts,
    );

    // 5. Strategic Risks (2-3, industry-based + situational from notes)
    final strategicRisks = _deriveStrategicRisks(input);

    // 6. Conversation Areas (max 3, business topics only)
    final areas = _conversationAreas[input.industry] ?? [];
    final conversationAreas = areas.take(3).toList();

    // 7. Suggested Next Move (1 sentence, deterministic)
    final suggestedNextMove = _deriveSuggestedNextMove(
      input: input,
      bestOpportunities: bestOpportunities,
      whiteSpace: whiteSpace,
    );

    return OpportunityInsightsResult(
      growthPotential: growthPotential,
      bestOpportunities: bestOpportunities,
      currentStack: List.from(input.existingProducts),
      expansionOpportunities: whiteSpace.take(4).toList(), // Max 4
      strategicRisks: strategicRisks,
      conversationAreas: conversationAreas,
      suggestedNextMove: suggestedNextMove,
    );
  }

  // ── Growth Potential Score ─────────────────────────────────────────────────
  // Base score is dynamically derived from repository data — no hardcoded numbers.
  // Philosophy: repos that have more challenges, products, and regulations
  // represent more opportunity surface area.

  GrowthPotential _calculateGrowthPotential({
    required OpportunityInsightsInput input,
    required IndustryIntelligence? industryData,
    required int whiteSpaceCount,
    required List<ProductIntelligence> allProducts,
  }) {
    int score = 40; // Neutral base
    final List<String> drivers = ['${input.industry} industry alignment'];

    // ── Dynamic Industry Base (derived from repository richness) ──────────────
    // +10 if >=4 recommended products → broad product opportunity surface
    if ((industryData?.recommendedProducts.length ?? 0) >= 4) {
      score += 10;
      drivers.add('Broad product portfolio applicable to this industry');
    }

    // +10 if >=4 business challenges → high digitization pain surface
    if ((industryData?.businessChallenges.length ?? 0) >= 4) {
      score += 10;
      drivers.add(
        'Multiple business challenges indicate digitization opportunity',
      );
    }

    // +10 if >=4 sales opportunities → proven Airtel plays exist
    if ((industryData?.salesOpportunities.length ?? 0) >= 4) {
      score += 10;
      drivers.add(
        'Multiple proven Airtel sales opportunities in this industry',
      );
    }

    // +10 if >=3 regulations → compliance complexity drives Airtel relevance
    if ((industryData?.keyRegulations.length ?? 0) >= 3) {
      score += 10;
      drivers.add(
        'Regulatory complexity creates mandatory technology requirements',
      );
    }

    // ── Whitespace: +5 per unowned product (max +20) ──────────────────────────
    if (whiteSpaceCount > 0) {
      final wsPoints = (whiteSpaceCount * 5).clamp(0, 20);
      score += wsPoints;
      drivers.add(
        '$whiteSpaceCount unowned product${whiteSpaceCount > 1 ? 's' : ''} identified as expansion opportunity',
      );
    }

    // ── Pain points matched to unowned products: +5 each (max +15) ───────────
    if (input.painPoints.isNotEmpty) {
      int ppMatches = 0;
      for (final pp in input.painPoints) {
        final ppLower = pp.toLowerCase();
        final matchesUnownedProduct = allProducts.any((
          ProductIntelligence prod,
        ) {
          final isMatch = prod.painPointsSolved.any(
            (p) =>
                p.toLowerCase().contains(ppLower) ||
                ppLower.contains(p.toLowerCase()),
          );
          final isUnowned = !input.existingProducts.any(
            (e) =>
                e.toLowerCase().contains(prod.name.toLowerCase()) ||
                prod.name.toLowerCase().contains(e.toLowerCase()),
          );
          return isMatch && isUnowned;
        });
        if (matchesUnownedProduct) ppMatches++;
      }
      if (ppMatches > 0) {
        final ppPoints = (ppMatches * 5).clamp(0, 15);
        score += ppPoints;
        drivers.add(
          'Active pain point${ppMatches > 1 ? 's' : ''} matched to unowned products',
        );
      }
    }

    // ── Situation notes: +10 if meaningful context (>30 chars) ─────────────
    // Only awarded if notes contain substantive content, not garbage text.
    // Garbage check: must contain at least one space (multi-word) AND >30 chars.
    final notesRaw = input.situationNotes?.trim() ?? '';
    final notesHasSubstance =
        notesRaw.length > 30 && notesRaw.contains(' ');
    if (notesHasSubstance) {
      score += 10;
      drivers.add('Detailed account context provided');
    }

    // ── Existing products: trust signal only (not a growth signal) ───────────
    final existingCount = input.existingProducts.length;
    if (existingCount >= 1 && existingCount <= 3) {
      score += 5;
      drivers.add(
        existingCount == 1
            ? 'Early Airtel relationship — strong land-and-expand potential'
            : 'Established Airtel relationship creates cross-sell trust',
      );
    }
    // 4+ products → saturated, no bonus

    // Clamp to 100
    final finalScore = score.clamp(0, 100);

    // ── Thresholds: High must be EARNED, not the default ──────────────────────
    // Industry-only (no pain points, no notes, no existing products):
    //   Base 40 + up to 40 (industry signals) + up to 20 (whitespace) = max 100
    //   BUT without active inputs (pain points / notes / existing),
    //   whitespace alone won't push past ~80 worst case.
    //   We apply a penalty to ensure industry-only stays at Medium.
    final hasActiveInputs = input.painPoints.isNotEmpty ||
        notesHasSubstance ||
        input.existingProducts.isNotEmpty;

    // Industry-only accounts are capped at Medium (≤72) regardless of score.
    final cappedScore =
        (!hasActiveInputs && finalScore > 72) ? 72 : finalScore;

    String label;
    if (cappedScore <= 55) {
      label = 'Low Opportunity';
    } else if (cappedScore <= 72) {
      label = 'Medium Opportunity';
    } else {
      label = 'High Opportunity';
    }

    return GrowthPotential(
      score: cappedScore,
      label: label,
      drivers: drivers,
    );
  }

  // ── Best Opportunities Ranking ─────────────────────────────────────────────

  List<BestOpportunity> _rankOpportunities({
    required OpportunityInsightsInput input,
    required List<String> candidates,
    required List<ProductIntelligence> allProducts,
  }) {
    if (candidates.isEmpty) return [];

    final notesLower = (input.situationNotes ?? '').toLowerCase();

    // Score each candidate
    final scored = <MapEntry<String, int>>[];
    for (final candidate in candidates) {
      int s = 5; // base — ensures ranking even with no inputs
      final candLower = candidate.toLowerCase();

      // +20 if a selected pain point maps to this product
      for (final pp in input.painPoints) {
        final ppLower = pp.toLowerCase();
        final productMatches = allProducts.where(
          (p) =>
              p.name.toLowerCase().contains(candLower) ||
              candLower.contains(p.name.toLowerCase()),
        );
        if (productMatches.isNotEmpty) {
          final productMatch = productMatches.first;
          final painMatch = productMatch.painPointsSolved.any(
            (solved) =>
                solved.toLowerCase().contains(ppLower) ||
                ppLower.contains(solved.toLowerCase()),
          );
          if (painMatch) {
            s += 20;
            break; // count once per product
          }
        }
      }

      // +10 if product name appears in situation notes
      if (notesLower.isNotEmpty && notesLower.contains(candLower)) {
        s += 10;
      }

      scored.add(MapEntry(candidate, s));
    }

    // Sort descending by score
    scored.sort((a, b) => b.value.compareTo(a.value));
    final top3 = scored.take(3).toList();

    // Assign confidence by SCORE THRESHOLD (not position)
    // >=35 = Quick Win, 20-34 = Medium-Term, <20 = Strategic Bet
    final result = <BestOpportunity>[];
    for (final entry in top3) {
      final prodName = entry.key;
      final candidateScore = entry.value;

      OpportunityConfidence confidence;
      if (candidateScore >= 35) {
        confidence = OpportunityConfidence.quickWin;
      } else if (candidateScore >= 20) {
        confidence = OpportunityConfidence.mediumTerm;
      } else {
        confidence = OpportunityConfidence.strategicBet;
      }

      final drivers = _buildOpportunityDrivers(
        productName: prodName,
        input: input,
        allProducts: allProducts,
      );

      result.add(
        BestOpportunity(
          productName: prodName,
          confidence: confidence,
          shortReason: _buildShortReason(prodName, input, allProducts),
          opportunityDrivers: drivers,
        ),
      );
    }

    return result;
  }

  List<String> _buildOpportunityDrivers({
    required String productName,
    required OpportunityInsightsInput input,
    required List<ProductIntelligence> allProducts,
  }) {
    final drivers = <String>[];
    final prodNameLower = productName.toLowerCase();
    final notesLower = (input.situationNotes ?? '').toLowerCase();

    // Driver 1: Industry alignment (always present, phrased specifically)
    drivers.add('${input.industry} industry alignment');

    // Driver 2: Pain point matches (specific, input-driven)
    for (final pp in input.painPoints) {
      final ppLower = pp.toLowerCase();
      final productMatches = allProducts.where(
        (p) =>
            p.name.toLowerCase().contains(prodNameLower) ||
            prodNameLower.contains(p.name.toLowerCase()),
      );
      if (productMatches.isNotEmpty) {
        final productMatch = productMatches.first;
        final painMatch = productMatch.painPointsSolved.any(
          (solved) =>
              solved.toLowerCase().contains(ppLower) ||
              ppLower.contains(solved.toLowerCase()),
        );
        if (painMatch) {
          drivers.add('"$pp" pain point selected');
        }
      }
    }

    // Driver 3: Existing stack context (specific, not generic)
    final prodCategory = _inferProductCategory(prodNameLower);
    final hasProductInCategory = input.existingProducts.any(
      (e) => _inferProductCategory(e.toLowerCase()) == prodCategory,
    );
    if (input.existingProducts.isEmpty) {
      drivers.add('No existing Airtel products — full whitespace available');
    } else if (!hasProductInCategory) {
      drivers.add('No existing $prodCategory product in current stack');
    }

    // Driver 4: Mentioned in notes
    if (notesLower.isNotEmpty && notesLower.contains(prodNameLower)) {
      drivers.add('Explicitly mentioned in account context notes');
    }

    // Cap at 3 drivers to keep it scannable
    return drivers.take(3).toList();
  }

  // Maps a product name to a broad category for driver generation
  String _inferProductCategory(String prodNameLower) {
    if (prodNameLower.contains('cloud') || prodNameLower.contains('colocation') ||
        prodNameLower.contains('nxtra')) {
      return 'Cloud & Infrastructure';
    }
    if (prodNameLower.contains('secure') || prodNameLower.contains('security')) {
      return 'Security';
    }
    if (prodNameLower.contains('sd-wan') || prodNameLower.contains('mpls') ||
        prodNameLower.contains('vpn') || prodNameLower.contains('ill') ||
        prodNameLower.contains('leased') || prodNameLower.contains('dedicated') ||
        prodNameLower.contains('office internet')) {
      return 'Connectivity';
    }
    if (prodNameLower.contains('iot') || prodNameLower.contains('positioning') ||
        prodNameLower.contains('5g')) {
      return 'IoT & Advanced Connectivity';
    }
    if (prodNameLower.contains('postpaid') || prodNameLower.contains('work from')) {
      return 'Mobility';
    }
    if (prodNameLower.contains('cpaas') || prodNameLower.contains('whatsapp') ||
        prodNameLower.contains('business connect') ||
        prodNameLower.contains('contact center') ||
        prodNameLower.contains('sip') || prodNameLower.contains('global voice')) {
      return 'Communication & Engagement';
    }
    if (prodNameLower.contains('wi-fi') || prodNameLower.contains('wifi')) {
      return 'Connectivity';
    }
    return 'Technology';
  }

  String _buildShortReason(
    String productName,
    OpportunityInsightsInput input,
    List<ProductIntelligence> allProducts,
  ) {
    final prodLower = productName.toLowerCase();

    // Find the product intelligence for a specific pain-point reason
    final productMatches = allProducts.where(
      (p) =>
          p.name.toLowerCase().contains(prodLower) ||
          prodLower.contains(p.name.toLowerCase()),
    );
    if (productMatches.isNotEmpty) {
      final prod = productMatches.first;
      // Find a matched pain point for a concrete, specific reason
      for (final pp in input.painPoints) {
        final ppLower = pp.toLowerCase();
        final painMatch = prod.painPointsSolved.any(
          (solved) =>
              solved.toLowerCase().contains(ppLower) ||
              ppLower.contains(solved.toLowerCase()),
        );
        if (painMatch) {
          // Return a specific reason using the product's elevator pitch framing
          final category = _inferProductCategory(prodLower);
          return 'Directly addresses the "$pp" challenge — a $category gap identified in this account.';
        }
      }
    }

    // Notes-based reason
    final notesLower = (input.situationNotes ?? '').toLowerCase();
    if (notesLower.isNotEmpty && notesLower.contains(prodLower)) {
      return 'Account context notes indicate direct relevance for $productName.';
    }

    // Industry-based specific reason (not generic)
    return 'A high-frequency adoption in ${input.industry} — strong category fit identified.';
  }

  // ── Strategic Risks ────────────────────────────────────────────────────────

  List<String> _deriveStrategicRisks(OpportunityInsightsInput input) {
    final risks = <String>[];
    final notesLower = (input.situationNotes ?? '').toLowerCase();

    // Source 1: Situational risks from keyword matching in notes (highest priority)
    if (notesLower.contains('aws') ||
        notesLower.contains('azure') ||
        notesLower.contains('gcp') ||
        notesLower.contains('google cloud')) {
      risks.add(
        'Deep hyperscaler dependency — cloud conversations may be limited',
      );
    }
    if (notesLower.contains('mpls') || notesLower.contains('leased line')) {
      risks.add(
        'Existing connectivity contracts may create switching barriers',
      );
    }
    if (notesLower.contains('budget') || notesLower.contains('cost pressure')) {
      risks.add('Budget constraints flagged — may extend sales cycle');
    }
    if (notesLower.contains('jio') ||
        notesLower.contains('tata') ||
        notesLower.contains('bsnl') ||
        notesLower.contains('competitor')) {
      risks.add('Incumbent competitor relationship present');
    }

    // Source 2: Industry-level risks (fill remaining slots, cap at 3 total)
    final industryRisks = _industryRisks[input.industry] ?? [];
    for (final r in industryRisks) {
      if (risks.length >= 3) break;
      if (!risks.contains(r)) {
        risks.add(r);
      }
    }

    return risks.take(3).toList();
  }

  // ── Suggested Next Move ────────────────────────────────────────────────────
  // One sentence. Deterministic. No AI.

  // ── 6 deterministic Next Move templates, selected by context priority ────────
  //
  // Template selection order (highest priority first):
  //   1. Security signal in notes → security-led
  //   2. Cloud/migration signal in notes → cloud-led
  //   3. Compliance pain point selected → compliance-led
  //   4. Existing products 3+ → expansion-led
  //   5. Operations/IoT pain point → operations-led
  //   6. No existing products + new account → connectivity-led or industry fallback

  String _deriveSuggestedNextMove({
    required OpportunityInsightsInput input,
    required List<BestOpportunity> bestOpportunities,
    required List<String> whiteSpace,
  }) {
    final existingCount = input.existingProducts.length;
    final notesLower = (input.situationNotes ?? '').toLowerCase();
    final painLower = input.painPoints.map((p) => p.toLowerCase()).join(' ');

    // ── Template 1: Security-led ───────────────────────────────────────────────
    if (notesLower.contains('security') ||
        notesLower.contains('ransomware') ||
        notesLower.contains('breach') ||
        painLower.contains('security') ||
        painLower.contains('compliance')) {
      return 'Lead with a security posture discussion before introducing infrastructure or cloud products — security creates the strongest executive pull in this account.';
    }

    // ── Template 2: Cloud-led ─────────────────────────────────────────────────
    if (notesLower.contains('cloud') ||
        notesLower.contains('migration') ||
        notesLower.contains('aws') ||
        notesLower.contains('azure') ||
        painLower.contains('cloud') ||
        painLower.contains('data sovereignty')) {
      return 'Use cloud modernization as the entry point — position Airtel\'s sovereign cloud as a complement to (not replacement of) their existing cloud investments.';
    }

    // ── Template 3: Compliance-led ────────────────────────────────────────────
    if (notesLower.contains('compliance') ||
        notesLower.contains('regulation') ||
        notesLower.contains('regulatory') ||
        painLower.contains('regulatory compliance') ||
        painLower.contains('data privacy')) {
      return 'Use regulatory and compliance priorities as the strategic anchor — compliance-driven conversations have the shortest path to procurement approval.';
    }

    // ── Template 4: Expansion-led (existing footprint) ────────────────────────
    if (existingCount >= 3) {
      return 'Expand the existing Airtel footprint into adjacent cloud and security opportunities — the current relationship is deep enough for a strategic expansion conversation.';
    }

    // ── Template 5: Operations-led ────────────────────────────────────────────
    if (painLower.contains('operational efficiency') ||
        painLower.contains('predictive maintenance') ||
        painLower.contains('asset') ||
        painLower.contains('fleet') ||
        painLower.contains('iot') ||
        notesLower.contains('factory') ||
        notesLower.contains('iot') ||
        notesLower.contains('automation')) {
      return 'Start with operational visibility and real-time monitoring — demonstrating tangible ROI on operations unlocks the budget conversation for broader infrastructure investments.';
    }

    // ── Template 6: Connectivity-led (new account or no active signals) ───────
    if (existingCount == 0) {
      // Industry-specific connectivity hooks
      const connectivityHooks = <String, String>{
        'Banking & Financial Services':
            'Begin with a branch connectivity reliability discussion — network resilience is the fastest path to trust in banking, and it opens the door to SD-WAN and cloud conversations.',
        'Manufacturing':
            'Start with factory connectivity and site-to-site reliability — these are immediate operational pain points before expanding into IoT and automation discussions.',
        'Healthcare':
            'Lead with hospital network reliability and security — demonstrating zero-downtime connectivity is the entry point for all broader technology conversations in healthcare.',
        'IT & ITES':
            'Anchor the conversation on remote workforce connectivity — this is the most universally felt pain point in IT firms and creates a natural pathway to cloud and security.',
        'Logistics':
            'Start with fleet visibility and driver connectivity — these have the clearest ROI story and the fastest decision-making cycle in logistics.',
        'Retail':
            'Begin with store connectivity standardization — a consistent network across all locations is the prerequisite for every other digital retail initiative.',
        'E-Commerce':
            'Lead with platform resilience and transactional communication APIs — OTP delivery and uptime during peak events are the highest-urgency pain points in e-commerce.',
        'Government':
            'Focus on data sovereignty and secure inter-departmental connectivity — these align with mandatory government compliance requirements and are the most fundable projects.',
        'Automotive':
            'Start with fleet telematics and AIS-140 compliance — regulatory mandates create a non-negotiable entry point with a clear procurement timeline.',
        'Energy & Utilities':
            'Lead with smart metering connectivity and critical infrastructure security — both have regulatory backing that accelerates procurement.',
        'Hospitality':
            'Start with guest Wi-Fi modernization — it has the highest visibility, fastest ROI, and creates a natural bridge to broader property-network conversations.',
        'Education':
            'Focus on campus network reliability and cybersecurity — these are the most budget-approved infrastructure conversations in educational institutions.',
        'Media & Entertainment':
            'Lead with content delivery resilience for live events — latency and uptime during major broadcasts are the most urgent pain points with clear financial impact.',
        'Telecom & Carriers':
            'Focus on international voice quality and fraud prevention — these create immediate and measurable P&L impact for carrier customers.',
        'Travel & Tourism':
            'Begin with multi-property connectivity standardization — this unlocks centralized network management and is the broadest platform conversation available.',
      };
      return connectivityHooks[input.industry] ??
          'Start with a connectivity reliability conversation — this is the most universally applicable entry point before expanding into adjacent opportunities.';
    }

    // Expansion with 1-2 existing products
    return 'Build on the existing Airtel relationship by identifying the most adjacent capability gap — a targeted expansion is more likely to succeed than a broad platform pitch at this stage.';
  }
}
