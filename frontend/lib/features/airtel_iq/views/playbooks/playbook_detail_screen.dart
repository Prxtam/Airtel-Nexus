import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/widgets/airtel_header.dart';
import 'package:frontend/features/airtel_iq/knowledge/industry_intelligence.dart';
import 'package:frontend/features/airtel_iq/services/industry_playbook_adapter.dart';
import 'package:frontend/features/airtel_iq/services/product_alias_resolver.dart';

class PlaybookDetailScreen extends StatelessWidget {
  final String playbookId;

  const PlaybookDetailScreen({super.key, required this.playbookId});

  static const List<(String, Color)> _industryColors = [
    ('Banking', Color(0xFF1E3A5F)),
    ('Manufacturing', Color(0xFF374151)),
    ('Retail', Color(0xFF7C3AED)),
    ('Healthcare', Color(0xFF0F766E)),
    ('IT', Color(0xFF1D4ED8)),
    ('Logistics', Color(0xFFB45309)),
    ('Government', Color(0xFF1A5276)),
    ('E-Commerce', Color(0xFFC2185B)),
    ('Education', Color(0xFF0D6E3F)),
    ('Hospitality', Color(0xFF92400E)),
    ('Energy', Color(0xFF6D4C41)),
    ('Automotive', Color(0xFF37474F)),
    ('Media', Color(0xFF4527A0)),
    ('Travel', Color(0xFF006064)),
    ('Telecom', Color(0xFF880E4F)),
  ];

  Color _colorFor(String name) {
    for (final (keyword, color) in _industryColors) {
      if (name.contains(keyword)) return color;
    }
    return AppConstants.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final industry = industryIntelligenceRepo.firstWhere(
      (i) => i.id == playbookId,
      orElse: () => industryIntelligenceRepo.first,
    );
    final playbook = IndustryPlaybook.fromIndustry(industry);
    final color = _colorFor(playbook.industryName);

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      body: SelectionArea(
        child: CustomScrollView(
        slivers: [
          // Header
          AirtelSliverHeader(
            title: '${playbook.industryName} Playbook',
            variant: HeaderVariant.medium,
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // 🎯 Business Priorities
                _PlaybookSection(
                  emoji: '🎯',
                  title: 'Business Priorities',
                  accentColor: color,
                  child: _BulletList(
                    items: playbook.businessPriorities,
                    color: color,
                  ),
                ),
                const SizedBox(height: 12),

                // ⚠️ Common Concerns
                _PlaybookSection(
                  emoji: '⚠️',
                  title: 'Common Concerns',
                  accentColor: const Color(0xFFEF4444),
                  child: _BulletList(
                    items: playbook.commonConcerns,
                    color: const Color(0xFFEF4444),
                    dimColor: const Color(0xFF991B1B),
                  ),
                ),
                const SizedBox(height: 12),

                // ❓ Discovery Questions
                _PlaybookSection(
                  emoji: '❓',
                  title: 'Discovery Questions',
                  accentColor: const Color(0xFF3B82F6),
                  child: _QuestionList(questions: playbook.discoveryQuestions),
                ),
                const SizedBox(height: 12),

                // 🛠️ Relevant Airtel Solutions
                _PlaybookSection(
                  emoji: '🛠️',
                  title: 'Relevant Airtel Solutions',
                  accentColor: const Color(0xFF10B981),
                  child: _ProductChipGrid(
                    products: playbook.relevantSolutions,
                    onProductTap: (name) {
                      final id = ProductAliasResolver.resolveToId(name);
                      if (id != null) {
                        context.push('/airtel-iq/products/$id');
                      }
                    },
                    accentColor: const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(height: 12),

                // 💡 Strategic Conversation Areas
                _PlaybookSection(
                  emoji: '💡',
                  title: 'Strategic Conversation Areas',
                  accentColor: const Color(0xFFF59E0B),
                  child: _ConversationAreaChips(
                    areas: playbook.conversationAreas,
                    color: const Color(0xFFF59E0B),
                  ),
                ),

                // Regulations (only if present)
                if (playbook.keyRegulations.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _PlaybookSection(
                    emoji: '⚖️',
                    title: 'Key Regulations',
                    accentColor: const Color(0xFF8B5CF6),
                    child: _BulletList(
                      items: playbook.keyRegulations,
                      color: const Color(0xFF8B5CF6),
                      dimColor: const Color(0xFF4C1D95),
                    ),
                  ),
                ],

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

// ─── Reusable Section Card ─────────────────────────────────────────────────

class _PlaybookSection extends StatelessWidget {
  final String emoji;
  final String title;
  final Color accentColor;
  final Widget child;

  const _PlaybookSection({
    required this.emoji,
    required this.title,
    required this.accentColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    child,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bullet List ──────────────────────────────────────────────────────────

class _BulletList extends StatelessWidget {
  final List<String> items;
  final Color color;
  final Color? dimColor;

  const _BulletList({required this.items, required this.color, this.dimColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 5,
                height: 5,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: dimColor ?? Colors.grey.shade800,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─── Discovery Questions ──────────────────────────────────────────────────

class _QuestionList extends StatelessWidget {
  final List<String> questions;

  const _QuestionList({required this.questions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: questions.asMap().entries.map((e) {
        final idx = e.key + 1;
        final q = e.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$idx',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  q,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF1E40AF),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─── Product Chips ────────────────────────────────────────────────────────

class _ProductChipGrid extends StatelessWidget {
  final List<String> products;
  final void Function(String) onProductTap;
  final Color accentColor;

  const _ProductChipGrid({
    required this.products,
    required this.onProductTap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: products.map((name) {
        final hasDetail = ProductAliasResolver.isResolvable(name);
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: hasDetail ? () => onProductTap(name) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: hasDetail
                  ? accentColor.withValues(alpha: 0.10)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: hasDetail
                    ? accentColor.withValues(alpha: 0.35)
                    : Colors.grey.shade300,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: hasDetail ? accentColor : Colors.grey.shade600,
                  ),
                ),
                if (hasDetail) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 10,
                    color: accentColor,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Conversation Area Tags ───────────────────────────────────────────────

class _ConversationAreaChips extends StatelessWidget {
  final List<String> areas;
  final Color color;

  const _ConversationAreaChips({required this.areas, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: areas.map((area) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline, size: 14, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  area,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.grey.shade800,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
