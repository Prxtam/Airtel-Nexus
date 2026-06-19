import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/airtel_iq/knowledge/product_enrichment_repository.dart';
import 'package:frontend/features/airtel_iq/knowledge/industry_intelligence.dart';
import 'package:frontend/features/airtel_iq/knowledge/knowledge_models.dart';
import 'package:frontend/features/airtel_iq/knowledge/knowledge_hub_resources.dart';
import 'package:frontend/features/airtel_iq/services/product_alias_resolver.dart';

// ─── Search result model ──────────────────────────────────────────────────────

enum HubResultKind { product, industry, terminology, meetingType, quickRef }

class HubSearchResult {
  final HubResultKind kind;
  final String title;
  final String subtitle;
  final dynamic data;

  const HubSearchResult({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.data,
  });
}

// ─── Main Screen ──────────────────────────────────────────────────────────────

class KnowledgeExplorerScreen extends StatefulWidget {
  const KnowledgeExplorerScreen({super.key});

  @override
  State<KnowledgeExplorerScreen> createState() =>
      _KnowledgeExplorerScreenState();
}

class _KnowledgeExplorerScreenState extends State<KnowledgeExplorerScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';

  // Popular items — curated names from existing repos, no new data
  static const _popularProductNames = [
    'Airtel Public Cloud',
    'Airtel SD-WAN',
    'Airtel Secure Internet',
    'Airtel IoT Connectivity',
    'Airtel WhatsApp Business',
  ];

  static const _popularIndustryNames = [
    'Banking & Financial Services',
    'Manufacturing',
    'Healthcare',
  ];

  static const _popularTerms = [
    'SD-WAN',
    'Data Sovereignty',
    'Clean Pipe Security',
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  // ─── Search ────────────────────────────────────────────────────────────────

  List<HubSearchResult> _buildSearchResults(String q) {
    final qLower = q.toLowerCase();
    final results = <HubSearchResult>[];

    for (final p in productEnrichmentData.values) {
      if (p.productName.toLowerCase().contains(qLower) ||
          p.category.toLowerCase().contains(qLower) ||
          p.whatItIs.toLowerCase().contains(qLower)) {
        results.add(
          HubSearchResult(
            kind: HubResultKind.product,
            title: p.productName,
            subtitle: p.category,
            data: p,
          ),
        );
      }
    }

    for (final i in industryIntelligenceRepo) {
      if (i.industryName.toLowerCase().contains(qLower) ||
          i.businessChallenges.any((c) => c.toLowerCase().contains(qLower))) {
        results.add(
          HubSearchResult(
            kind: HubResultKind.industry,
            title: i.industryName,
            subtitle: i.businessChallenges.isNotEmpty
                ? i.businessChallenges.first
                : '',
            data: i,
          ),
        );
      }
    }

    for (final t in hubTerminologies) {
      if (t.term.toLowerCase().contains(qLower) ||
          t.definition.toLowerCase().contains(qLower)) {
        results.add(
          HubSearchResult(
            kind: HubResultKind.terminology,
            title: t.term,
            subtitle: t.definition,
            data: t,
          ),
        );
      }
    }

    for (final m in hubMeetingTypes) {
      if (m.name.toLowerCase().contains(qLower) ||
          m.description.toLowerCase().contains(qLower)) {
        results.add(
          HubSearchResult(
            kind: HubResultKind.meetingType,
            title: m.name,
            subtitle: m.description,
            data: m,
          ),
        );
      }
    }

    for (final r in hubQuickRefs) {
      if (r.trigger.toLowerCase().contains(qLower) ||
          r.solution.toLowerCase().contains(qLower)) {
        results.add(
          HubSearchResult(
            kind: HubResultKind.quickRef,
            title: r.trigger,
            subtitle: r.solution,
            data: r,
          ),
        );
      }
    }

    return results;
  }

  // ─── Navigation helpers ────────────────────────────────────────────────────

  void _openProduct(BuildContext ctx, EnrichedProduct p) {
    final id = ProductAliasResolver.resolveToId(p.productName);
    if (id != null) ctx.push('/airtel-iq/products/$id');
  }

  void _openIndustry(BuildContext ctx, IndustryIntelligence i) {
    ctx.push('/airtel-iq/playbooks/${i.id}');
  }

  void _openProductByName(BuildContext ctx, String name) {
    final id = ProductAliasResolver.resolveToId(name);
    if (id != null) ctx.push('/airtel-iq/products/$id');
  }

  void _openResultDetail(BuildContext ctx, HubSearchResult r) {
    switch (r.kind) {
      case HubResultKind.product:
        _openProduct(ctx, r.data as EnrichedProduct);
      case HubResultKind.industry:
        _openIndustry(ctx, r.data as IndustryIntelligence);
      case HubResultKind.terminology:
        _showTermSheet(ctx, r.data as HubTerminology);
      case HubResultKind.meetingType:
        _showMeetingSheet(ctx, r.data as HubMeetingType);
      case HubResultKind.quickRef:
        // no detail sheet; tile already shows trigger + solution
        break;
    }
  }

  // ─── Bottom sheets ─────────────────────────────────────────────────────────

  void _showTermSheet(BuildContext ctx, HubTerminology t) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _TerminologySheet(
        term: t,
        onProductTap: (name) {
          Navigator.pop(ctx);
          _openProductByName(ctx, name);
        },
      ),
    );
  }

  void _showMeetingSheet(BuildContext ctx, HubMeetingType m) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _MeetingTypeSheet(meeting: m),
    );
  }

  void _showIndustrySheet(BuildContext ctx, IndustryIntelligence ind) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _IndustrySheet(
        industry: ind,
        onOpenPlaybook: () {
          Navigator.pop(ctx);
          _openIndustry(ctx, ind);
        },
        onProductTap: (name) {
          Navigator.pop(ctx);
          _openProductByName(ctx, name);
        },
      ),
    );
  }

  void _showProductSheet(BuildContext ctx, EnrichedProduct p) {
    // Find industries that recommend this product
    final relatedIndustries = industryIntelligenceRepo
        .where(
          (i) => i.recommendedProducts.any(
            (rp) => ProductAliasResolver.resolve(rp) == p.productName,
          ),
        )
        .toList();

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ProductSheet(
        product: p,
        relatedIndustries: relatedIndustries,
        onOpenProduct: () {
          Navigator.pop(ctx);
          _openProduct(ctx, p);
        },
        onIndustryTap: (ind) {
          Navigator.pop(ctx);
          _openIndustry(ctx, ind);
        },
      ),
    );
  }

  // ─── Industry color helpers (shared with playbook screens) ────────────────

  Color _industryColor(String name) {
    if (name.contains('Banking')) return const Color(0xFF1E3A5F);
    if (name.contains('Manufacturing')) return const Color(0xFF374151);
    if (name.contains('Retail')) return const Color(0xFF7C3AED);
    if (name.contains('Healthcare')) return const Color(0xFF0F766E);
    if (name.contains('IT')) return const Color(0xFF1D4ED8);
    if (name.contains('Logistics')) return const Color(0xFFB45309);
    if (name.contains('Government')) return const Color(0xFF1A5276);
    if (name.contains('E-Commerce')) return const Color(0xFFC2185B);
    if (name.contains('Education')) return const Color(0xFF0D6E3F);
    if (name.contains('Hospitality')) return const Color(0xFF92400E);
    if (name.contains('Energy')) return const Color(0xFF6D4C41);
    if (name.contains('Automotive')) return const Color(0xFF37474F);
    if (name.contains('Media')) return const Color(0xFF4527A0);
    if (name.contains('Travel')) return const Color(0xFF006064);
    if (name.contains('Telecom')) return const Color(0xFF880E4F);
    return AppConstants.primaryColor;
  }

  String _industryEmoji(String name) {
    if (name.contains('Banking')) return '🏦';
    if (name.contains('Manufacturing')) return '🏭';
    if (name.contains('Retail')) return '🛍️';
    if (name.contains('Healthcare')) return '🏥';
    if (name.contains('IT')) return '💻';
    if (name.contains('Logistics')) return '🚚';
    if (name.contains('Government')) return '🏛️';
    if (name.contains('E-Commerce')) return '📦';
    if (name.contains('Education')) return '🎓';
    if (name.contains('Hospitality')) return '🏨';
    if (name.contains('Energy')) return '⚡';
    if (name.contains('Automotive')) return '🚗';
    if (name.contains('Media')) return '🎬';
    if (name.contains('Travel')) return '✈️';
    if (name.contains('Telecom')) return '📡';
    return '🏢';
  }

  Color _categoryColor(String cat) {
    if (cat.contains('Cloud')) return const Color(0xFF0EA5E9);
    if (cat.contains('Security')) return const Color(0xFFEF4444);
    if (cat.contains('Connectivity') || cat.contains('Network')) {
      return const Color(0xFF6366F1);
    }
    if (cat.contains('Communication') || cat.contains('Voice')) {
      return const Color(0xFF10B981);
    }
    if (cat.contains('IoT')) return const Color(0xFFF59E0B);
    if (cat.contains('Mobility')) return const Color(0xFF8B5CF6);
    return const Color(0xFF6B7280);
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final products = productEnrichmentData.values.toList();
    final industries = industryIntelligenceRepo;

    final isSearching = _query.trim().length >= 2;
    final searchResults = isSearching
        ? _buildSearchResults(_query.trim())
        : <HubSearchResult>[];

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
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
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 12),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Airtel Knowledge Hub',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Centralized Airtel reference encyclopedia',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Search bar ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: TextField(
                controller: _search,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search products, industries, terms...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => setState(() {
                            _search.clear();
                            _query = '';
                          }),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppConstants.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ─── SEARCH RESULTS MODE ─────────────────────────────────────────
          if (isSearching) ...[
            if (searchResults.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No results for "$_query"',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    _buildGroupedResults(context, searchResults),
                  ),
                ),
              ),
          ]
          // ─── BROWSE MODE ─────────────────────────────────────────────────
          else ...[
            // ── Stats bar ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    _StatChip(
                      icon: Icons.inventory_2_outlined,
                      label: 'Products',
                      count: products.length,
                      color: const Color(0xFF6366F1),
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      icon: Icons.factory_outlined,
                      label: 'Industries',
                      count: industries.length,
                      color: const Color(0xFF10B981),
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      icon: Icons.book_outlined,
                      label: 'Resources',
                      count:
                          hubTerminologies.length +
                          hubMeetingTypes.length +
                          hubQuickRefs.length,
                      color: const Color(0xFFF59E0B),
                    ),
                  ],
                ),
              ),
            ),

            // ── Popular Knowledge ────────────────────────────────────────
            SliverToBoxAdapter(child: _sectionHeader('Featured Knowledge')),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  children: [
                    ..._popularProductNames.map((name) {
                      final p = productEnrichmentData.values
                          .where((x) => x.productName == name)
                          .firstOrNull;
                      if (p == null) return const SizedBox.shrink();
                      return _PopularChip(
                        label: name,
                        color: _categoryColor(p.category),
                        onTap: () => _showProductSheet(context, p),
                      );
                    }),
                    ..._popularIndustryNames.map((name) {
                      final i = industries
                          .where((x) => x.industryName == name)
                          .firstOrNull;
                      if (i == null) return const SizedBox.shrink();
                      return _PopularChip(
                        label: name,
                        color: _industryColor(name),
                        onTap: () => _showIndustrySheet(context, i),
                      );
                    }),
                    ..._popularTerms.map((term) {
                      final t = hubTerminologies
                          .where((x) => x.term == term)
                          .firstOrNull;
                      if (t == null) return const SizedBox.shrink();
                      return _PopularChip(
                        label: term,
                        color: const Color(0xFFF59E0B),
                        onTap: () => _showTermSheet(context, t),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // ── Browse Products ──────────────────────────────────────────
            SliverToBoxAdapter(child: _sectionHeader('Products')),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 160,
                ),
                delegate: SliverChildBuilderDelegate((ctx, i) {
                  final p = products[i];
                  return _ProductGatewayCard(
                    product: p,
                    accentColor: _categoryColor(p.category),
                    onTap: () => _showProductSheet(ctx, p),
                    onOpen: () => _openProduct(ctx, p),
                  );
                }, childCount: products.length),
              ),
            ),

            // ── Browse Industries ────────────────────────────────────────
            SliverToBoxAdapter(child: _sectionHeader('Industries')),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((ctx, i) {
                  final ind = industries[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _IndustryGatewayCard(
                      industry: ind,
                      color: _industryColor(ind.industryName),
                      emoji: _industryEmoji(ind.industryName),
                      onTap: () => _showIndustrySheet(ctx, ind),
                      onOpen: () => _openIndustry(ctx, ind),
                    ),
                  );
                }, childCount: industries.length),
              ),
            ),

            // ── Resources ─────────────────────────────────────────────────
            SliverToBoxAdapter(child: _sectionHeader('Resources')),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _ResourceSection(
                    title: 'Airtel Terminologies',
                    items: hubTerminologies.length,
                    description:
                        'Key technical terms used across enterprise sales',
                    color: const Color(0xFF6366F1),
                    icon: Icons.book_outlined,
                    onTap: () => _showResourceDetail(context, 'terminology'),
                  ),
                  const SizedBox(height: 10),
                  _ResourceSection(
                    title: 'Meeting Types',
                    items: hubMeetingTypes.length,
                    description:
                        'Reference guide for each enterprise meeting format',
                    color: const Color(0xFF10B981),
                    icon: Icons.event_outlined,
                    onTap: () => _showResourceDetail(context, 'meetings'),
                  ),
                  const SizedBox(height: 10),
                  _ResourceSection(
                    title: 'Quick Reference Guides',
                    items: hubQuickRefs.length,
                    description:
                        'Cross-sell triggers and SME involvement signals',
                    color: const Color(0xFFF59E0B),
                    icon: Icons.bolt_outlined,
                    onTap: () => _showResourceDetail(context, 'quickref'),
                  ),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Section header ───────────────────────────────────────────────────────

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // ─── Grouped search results ───────────────────────────────────────────────

  List<Widget> _buildGroupedResults(
    BuildContext ctx,
    List<HubSearchResult> results,
  ) {
    final grouped = <HubResultKind, List<HubSearchResult>>{};
    for (final r in results) {
      grouped.putIfAbsent(r.kind, () => []).add(r);
    }

    const labels = {
      HubResultKind.product: 'Products',
      HubResultKind.industry: 'Industries',
      HubResultKind.terminology: 'Terminologies',
      HubResultKind.meetingType: 'Meeting Types',
      HubResultKind.quickRef: 'Quick References',
    };

    const icons = {
      HubResultKind.product: Icons.inventory_2_outlined,
      HubResultKind.industry: Icons.factory_outlined,
      HubResultKind.terminology: Icons.book_outlined,
      HubResultKind.meetingType: Icons.event_outlined,
      HubResultKind.quickRef: Icons.bolt_outlined,
    };

    final widgets = <Widget>[];
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          '${results.length} result${results.length == 1 ? '' : 's'} for "$_query"',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );

    for (final kind in HubResultKind.values) {
      final group = grouped[kind];
      if (group == null || group.isEmpty) continue;

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 6, top: 4),
          child: Row(
            children: [
              Icon(icons[kind], size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(
                '${labels[kind]} (${group.length})',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade500,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      );

      for (final r in group) {
        widgets.add(
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => _openResultDetail(ctx, r),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                margin: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      r.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      widgets.add(const SizedBox(height: 4));
    }

    return widgets;
  }

  // ─── Resource detail sheets ───────────────────────────────────────────────

  void _showResourceDetail(BuildContext ctx, String type) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        if (type == 'terminology') {
          return _TerminologyListSheet(
            terminologies: hubTerminologies,
            onProductTap: (name) {
              Navigator.pop(ctx);
              _openProductByName(ctx, name);
            },
          );
        } else if (type == 'meetings') {
          return _MeetingListSheet(meetings: hubMeetingTypes);
        } else {
          return _QuickRefSheet(refs: hubQuickRefs);
        }
      },
    );
  }
}

// ─── Widgets ──────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 2),
            Text(
              '$count',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PopularChip({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 10, bottom: 4, top: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductGatewayCard extends StatelessWidget {
  final EnrichedProduct product;
  final Color accentColor;
  final VoidCallback onTap;
  final VoidCallback onOpen;

  const _ProductGatewayCard({
    required this.product,
    required this.accentColor,
    required this.onTap,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  product.category,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.productName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  product.whatItIs,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: onOpen,
                    child: Row(
                      children: [
                        Text(
                          'Open →',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IndustryGatewayCard extends StatelessWidget {
  final IndustryIntelligence industry;
  final Color color;
  final String emoji;
  final VoidCallback onTap;
  final VoidCallback onOpen;

  const _IndustryGatewayCard({
    required this.industry,
    required this.color,
    required this.emoji,
    required this.onTap,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      industry.industryName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (industry.businessChallenges.isNotEmpty)
                      Text(
                        industry.businessChallenges.take(2).join(' · '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          height: 1.35,
                        ),
                      ),
                    if (industry.objections.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text('⚠️', style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              industry.objections.first,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF991B1B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onOpen,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    'Playbook',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResourceSection extends StatelessWidget {
  final String title;
  final int items;
  final String description;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _ResourceSection({
    required this.title,
    required this.items,
    required this.description,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '$items',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Bottom Sheets ────────────────────────────────────────────────────────────

class _ProductSheet extends StatelessWidget {
  final EnrichedProduct product;
  final List<IndustryIntelligence> relatedIndustries;
  final VoidCallback onOpenProduct;
  final void Function(IndustryIntelligence) onIndustryTap;

  const _ProductSheet({
    required this.product,
    required this.relatedIndustries,
    required this.onOpenProduct,
    required this.onIndustryTap,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: [
                  // Category chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.productName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.whatItIs,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Key differentiators
                  if (product.keyDifferentiators.isNotEmpty) ...[
                    const Text(
                      'Key Differentiators',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...product.keyDifferentiators
                        .take(4)
                        .map(
                          (d) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 14,
                                  color: Color(0xFF10B981),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    d,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    const SizedBox(height: 16),
                  ],
                  // Related industries (knowledge graph)
                  if (relatedIndustries.isNotEmpty) ...[
                    const Text(
                      'Relevant Industries',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: relatedIndustries.map((i) {
                        return GestureDetector(
                          onTap: () => onIndustryTap(i),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF1D4ED8,
                              ).withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(
                                  0xFF1D4ED8,
                                ).withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              i.industryName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1D4ED8),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Open full product page
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: onOpenProduct,
                      child: const Text(
                        'Open Product Playbook →',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IndustrySheet extends StatelessWidget {
  final IndustryIntelligence industry;
  final VoidCallback onOpenPlaybook;
  final void Function(String) onProductTap;

  const _IndustrySheet({
    required this.industry,
    required this.onOpenPlaybook,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: [
                  Text(
                    industry.industryName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Top priorities
                  const Text(
                    'Business Priorities',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...industry.businessChallenges
                      .take(4)
                      .map(
                        (c) => Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: AppConstants.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  c,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  const SizedBox(height: 14),
                  // Related products (knowledge graph)
                  if (industry.recommendedProducts.isNotEmpty) ...[
                    const Text(
                      'Related Airtel Products',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: industry.recommendedProducts.map((name) {
                        final canNavigate = ProductAliasResolver.isResolvable(
                          name,
                        );
                        return GestureDetector(
                          onTap: canNavigate ? () => onProductTap(name) : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF10B981,
                              ).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(
                                  0xFF10B981,
                                ).withValues(alpha: 0.25),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: canNavigate
                                        ? const Color(0xFF059669)
                                        : Colors.grey.shade500,
                                  ),
                                ),
                                if (canNavigate) ...[
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 9,
                                    color: Color(0xFF059669),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: onOpenPlaybook,
                      child: const Text(
                        'Open Industry Playbook →',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TerminologySheet extends StatelessWidget {
  final HubTerminology term;
  final void Function(String) onProductTap;

  const _TerminologySheet({required this.term, required this.onProductTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'TERMINOLOGY',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6366F1),
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            term.term,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            term.definition,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          if (term.relatedProductNames.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Commonly used with',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: term.relatedProductNames.map((name) {
                return GestureDetector(
                  onTap: () => onProductTap(name),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 9,
                          color: Color(0xFF6366F1),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _MeetingTypeSheet extends StatelessWidget {
  final HubMeetingType meeting;

  const _MeetingTypeSheet({required this.meeting});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'MEETING TYPE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF10B981),
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            meeting.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            meeting.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🎯', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    meeting.purpose,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF065F46),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _TerminologyListSheet extends StatelessWidget {
  final List<HubTerminology> terminologies;
  final void Function(String) onProductTap;

  const _TerminologyListSheet({
    required this.terminologies,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Airtel Terminologies',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                controller: ctrl,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                itemCount: terminologies.length,
                separatorBuilder: (_, __) =>
                    Divider(color: Colors.grey.shade100),
                itemBuilder: (ctx, i) {
                  final t = terminologies[i];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    title: Text(
                      t.term,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      t.definition,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: ctx,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) => _TerminologySheet(
                          term: t,
                          onProductTap: onProductTap,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeetingListSheet extends StatelessWidget {
  final List<HubMeetingType> meetings;

  const _MeetingListSheet({required this.meetings});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Meeting Types',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                controller: ctrl,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                itemCount: meetings.length,
                separatorBuilder: (_, __) =>
                    Divider(color: Colors.grey.shade100),
                itemBuilder: (ctx, i) {
                  final m = meetings[i];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    title: Text(
                      m.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      m.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: ctx,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) => _MeetingTypeSheet(meeting: m),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickRefSheet extends StatelessWidget {
  final List<HubQuickRef> refs;

  const _QuickRefSheet({required this.refs});

  @override
  Widget build(BuildContext context) {
    // Group by category
    final grouped = <String, List<HubQuickRef>>{};
    for (final r in refs) {
      grouped.putIfAbsent(r.category, () => []).add(r);
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quick Reference Guides',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  for (final cat in grouped.keys) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        cat.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    ...grouped[cat]!.map(
                      (r) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '→',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r.trigger,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    r.solution,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppConstants.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
