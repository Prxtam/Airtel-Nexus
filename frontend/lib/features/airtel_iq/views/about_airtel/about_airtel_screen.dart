import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/widgets/airtel_header.dart';
import 'package:frontend/features/airtel_iq/knowledge/about_airtel_data.dart';
import 'package:frontend/features/airtel_iq/services/product_alias_resolver.dart';

class AboutAirtelScreen extends StatelessWidget {
  const AboutAirtelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      body: SelectionArea(
        child: CustomScrollView(
        slivers: [
          // ── Header ────────────────────────────────────────────────────────
          const AirtelSliverHeader(
            title: 'About Airtel',
            subtitle: 'Learn everything about the company',
            variant: HeaderVariant.large,
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

class _PremiumExpansionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;

  const _PremiumExpansionTile({
    required this.title,
    this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: subtitle != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  subtitle!,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              )
            : null,
        children: children,
      ),
    );
  }
}

// ─── Ecosystem Custom Card ───────────────────────────────────────────────────

class _EcosystemCard extends StatelessWidget {
  final EcosystemCategory category;
  const _EcosystemCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return _PremiumExpansionTile(
      title: category.name,
      subtitle: category.summary,
      children: [
        _buildInfoBlock('WHAT IT IS', category.whatItIs),
        const SizedBox(height: 16),
        _buildInfoBlock('WHY ENTERPRISES NEED IT', category.whyEnterprisesNeedIt),
        const SizedBox(height: 16),
        _buildInfoBlock('HOW AIRTEL SOLVES IT', category.howAirtelSolvesIt),
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
          children: category.products.map((productName) {
            final isResolvable = ProductAliasResolver.isResolvable(productName);
            return GestureDetector(
              onTap: isResolvable
                  ? () {
                      final id = ProductAliasResolver.resolveToId(productName);
                      if (id != null) {
                        context.push('/airtel-iq/products/$id');
                      }
                    }
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isResolvable
                      ? AppConstants.primaryColor.withValues(alpha: 0.08)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isResolvable
                        ? AppConstants.primaryColor.withValues(alpha: 0.2)
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

class _PartnershipCard extends StatelessWidget {
  final AirtelPartnership partnership;
  const _PartnershipCard({required this.partnership});

  @override
  Widget build(BuildContext context) {
    return _PremiumExpansionTile(
      title: partnership.name,
      subtitle: partnership.summary,
      children: [
        const Divider(height: 1),
        const SizedBox(height: 16),
        _buildField('WHY WE PARTNERED', partnership.whyPartnered),
        const SizedBox(height: 12),
        _buildField('WHAT IT SOLVES', partnership.whatItSolves),
        const SizedBox(height: 12),
        _buildField('WHAT AIRTEL GAINED', partnership.whatAirtelGained),
        const SizedBox(height: 12),
        _buildField('WHAT CUSTOMERS GAINED', partnership.whatCustomersGained),
      ],
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

class _MilestoneCard extends StatelessWidget {
  final AirtelMilestone milestone;
  const _MilestoneCard({required this.milestone});

  @override
  Widget build(BuildContext context) {
    return _PremiumExpansionTile(
      title: '${milestone.year}: ${milestone.title}',
      subtitle: milestone.summary,
      children: [
        const Divider(height: 1),
        const SizedBox(height: 16),
        _buildField('WHAT HAPPENED', milestone.whatHappened),
        const SizedBox(height: 12),
        _buildField('WHY IT WAS IMPORTANT', milestone.whyImportant),
        const SizedBox(height: 12),
        _buildField('THE IMPACT', milestone.impact),
      ],
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

class _DidYouKnowCard extends StatelessWidget {
  final DidYouKnowFact fact;
  const _DidYouKnowCard({required this.fact});

  @override
  Widget build(BuildContext context) {
    return _PremiumExpansionTile(
      title: fact.fact,
      children: [
        const Divider(height: 1),
        const SizedBox(height: 16),
        Text(
          fact.detail,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
