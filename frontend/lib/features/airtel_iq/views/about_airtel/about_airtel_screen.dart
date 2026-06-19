import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/airtel_iq/knowledge/about_airtel_data.dart';
import 'package:frontend/features/airtel_iq/services/product_alias_resolver.dart';

class AboutAirtelScreen extends StatelessWidget {
  const AboutAirtelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // ── Header ────────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 140,
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppConstants.primaryColor, Color(0xFFC00000)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 70, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'About Airtel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Understand Airtel\'s history, global footprint, enterprise ecosystem, innovations, partnerships, and strategic evolution.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _PremiumExpandableChapter(
                  chapter: AboutAirtelData.theAirtelStory,
                ),
                const SizedBox(height: 16),
                _PremiumExpandableChapter(chapter: AboutAirtelData.airtelToday),
                const SizedBox(height: 16),
                _PremiumExpandableChapter(
                  chapter: AboutAirtelData.globalPresence,
                ),
                const SizedBox(height: 16),
                _PremiumExpandableChapter(
                  chapter: AboutAirtelData.whyCustomersChooseAirtel,
                ),

                const SizedBox(height: 32),
                _buildSectionTitle('Enterprise Ecosystem'),
                const SizedBox(height: 12),
                ...AboutAirtelData.businessEcosystem.map(
                  (cat) => _EcosystemCard(category: cat),
                ),

                const SizedBox(height: 32),
                _buildSectionTitle('Strategic Partnerships'),
                const SizedBox(height: 12),
                ...AboutAirtelData.strategicPartnerships.map(
                  (p) => _PartnershipCard(partnership: p),
                ),

                const SizedBox(height: 32),
                _buildSectionTitle('Key Milestones'),
                const SizedBox(height: 12),
                ...AboutAirtelData.keyMilestones.map(
                  (m) => _MilestoneCard(milestone: m),
                ),

                const SizedBox(height: 32),
                _buildSectionTitle('Did You Know?'),
                const SizedBox(height: 12),
                ...AboutAirtelData.didYouKnow.map(
                  (fact) => _DidYouKnowCard(fact: fact),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          letterSpacing: -0.3,
        ),
      ),
    );
  }
}

// ─── Custom Expandable Chapter ──────────────────────────────────────────────

class _PremiumExpandableChapter extends StatelessWidget {
  final AirtelChapter chapter;

  const _PremiumExpandableChapter({required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
        title: Text(
          chapter.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            chapter.summary,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ),
        children: [
          const Divider(height: 24),
          // Fact Highlights
          if (chapter.highlights.isNotEmpty) ...[
            const Text(
              'FACT HIGHLIGHTS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.grey,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: chapter.highlights.map((h) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppConstants.primaryColor.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Text(
                    h,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Paragraphs (SubChapters)
          ...chapter.subChapters.map((sub) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sub.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    sub.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
          }),

          // Why this matters
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.blue, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'WHY THIS MATTERS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.blue,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  chapter.enterpriseSignificance,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Ecosystem Custom Card ───────────────────────────────────────────────────

class _EcosystemCard extends StatefulWidget {
  final EcosystemCategory category;
  const _EcosystemCard({required this.category});

  @override
  State<_EcosystemCard> createState() => _EcosystemCardState();
}

class _EcosystemCardState extends State<_EcosystemCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.category.summary,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 20),
                _buildInfoBlock('WHAT IT IS', widget.category.whatItIs),
                const SizedBox(height: 16),
                _buildInfoBlock(
                  'WHY ENTERPRISES NEED IT',
                  widget.category.whyEnterprisesNeedIt,
                ),
                const SizedBox(height: 16),
                _buildInfoBlock(
                  'HOW AIRTEL SOLVES IT',
                  widget.category.howAirtelSolvesIt,
                ),
                const SizedBox(height: 20),
                const Text(
                  'ASSOCIATED PRODUCTS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.category.products.map((productName) {
                    final isResolvable = ProductAliasResolver.isResolvable(
                      productName,
                    );
                    return GestureDetector(
                      onTap: isResolvable
                          ? () {
                              final id = ProductAliasResolver.resolveToId(
                                productName,
                              );
                              if (id != null) {
                                context.push('/airtel-iq/products/$id');
                              }
                            }
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isResolvable
                              ? AppConstants.primaryColor.withValues(
                                  alpha: 0.08,
                                )
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isResolvable
                                ? AppConstants.primaryColor.withValues(
                                    alpha: 0.2,
                                  )
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              productName,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isResolvable
                                    ? AppConstants.primaryColor
                                    : Colors.grey.shade700,
                              ),
                            ),
                            if (isResolvable) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 9,
                                color: AppConstants.primaryColor,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBlock(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Colors.grey.shade500,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// ─── Partnership Custom Card ────────────────────────────────────────────────

class _PartnershipCard extends StatefulWidget {
  final AirtelPartnership partnership;
  const _PartnershipCard({required this.partnership});

  @override
  State<_PartnershipCard> createState() => _PartnershipCardState();
}

class _PartnershipCardState extends State<_PartnershipCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.handshake_outlined,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.partnership.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.partnership.summary,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 16),
                _buildField(
                  'WHY WE PARTNERED',
                  widget.partnership.whyPartnered,
                ),
                const SizedBox(height: 12),
                _buildField('WHAT IT SOLVES', widget.partnership.whatItSolves),
                const SizedBox(height: 12),
                _buildField(
                  'WHAT AIRTEL GAINED',
                  widget.partnership.whatAirtelGained,
                ),
                const SizedBox(height: 12),
                _buildField(
                  'WHAT CUSTOMERS GAINED',
                  widget.partnership.whatCustomersGained,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Colors.grey.shade500,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// ─── Milestone Custom Card ──────────────────────────────────────────────────

class _MilestoneCard extends StatefulWidget {
  final AirtelMilestone milestone;
  const _MilestoneCard({required this.milestone});

  @override
  State<_MilestoneCard> createState() => _MilestoneCardState();
}

class _MilestoneCardState extends State<_MilestoneCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.milestone.year,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.milestone.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.milestone.summary,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 16),
                _buildField('WHAT HAPPENED', widget.milestone.whatHappened),
                const SizedBox(height: 12),
                _buildField(
                  'WHY IT WAS IMPORTANT',
                  widget.milestone.whyImportant,
                ),
                const SizedBox(height: 12),
                _buildField('THE IMPACT', widget.milestone.impact),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Colors.grey.shade500,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// ─── Did You Know Card ──────────────────────────────────────────────────────

class _DidYouKnowCard extends StatefulWidget {
  final DidYouKnowFact fact;
  const _DidYouKnowCard({required this.fact});

  @override
  State<_DidYouKnowCard> createState() => _DidYouKnowCardState();
}

class _DidYouKnowCardState extends State<_DidYouKnowCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb, color: Colors.purple, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.fact.fact,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text(
                    widget.fact.detail,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
