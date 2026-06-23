import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/airtel_iq/knowledge/industry_intelligence.dart';
import 'package:frontend/features/airtel_iq/services/industry_playbook_adapter.dart';

class PlaybooksListScreen extends StatefulWidget {
  const PlaybooksListScreen({super.key});

  @override
  State<PlaybooksListScreen> createState() => _PlaybooksListScreenState();
}

class _PlaybooksListScreenState extends State<PlaybooksListScreen> {
  late List<IndustryPlaybook> _allPlaybooks;
  late List<IndustryPlaybook> _filtered;
  final TextEditingController _search = TextEditingController();

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

  Color _colorForIndustry(String name) {
    for (final (keyword, color) in _industryColors) {
      if (name.contains(keyword)) return color;
    }
    return AppConstants.primaryColor;
  }

  IconData _iconForIndustry(String name) {
    if (name.contains('Banking')) return Icons.account_balance_outlined;
    if (name.contains('Manufacturing')) return Icons.precision_manufacturing_outlined;
    if (name.contains('Retail')) return Icons.storefront_outlined;
    if (name.contains('Healthcare')) return Icons.local_hospital_outlined;
    if (name.contains('IT')) return Icons.computer_outlined;
    if (name.contains('Logistics')) return Icons.local_shipping_outlined;
    if (name.contains('Government')) return Icons.gavel_outlined;
    if (name.contains('E-Commerce')) return Icons.shopping_bag_outlined;
    if (name.contains('Education')) return Icons.school_outlined;
    if (name.contains('Hospitality')) return Icons.hotel_outlined;
    if (name.contains('Energy')) return Icons.bolt_outlined;
    if (name.contains('Automotive')) return Icons.directions_car_outlined;
    if (name.contains('Media')) return Icons.movie_outlined;
    if (name.contains('Travel')) return Icons.flight_outlined;
    if (name.contains('Telecom')) return Icons.cell_tower_outlined;
    return Icons.business_outlined;
  }

  @override
  void initState() {
    super.initState();
    _allPlaybooks = industryIntelligenceRepo
        .map(IndustryPlaybook.fromIndustry)
        .toList();
    _filtered = _allPlaybooks;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filtered = _allPlaybooks;
      } else {
        final q = query.toLowerCase();
        _filtered = _allPlaybooks.where((pb) {
          return pb.industryName.toLowerCase().contains(q) ||
              pb.businessPriorities.any((c) => c.toLowerCase().contains(q)) ||
              pb.relevantSolutions.any((s) => s.toLowerCase().contains(q));
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Industry Playbooks'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Container(
            color: AppConstants.primaryColor,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _search,
              onChanged: _onSearch,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search industry or solution...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.15),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _filtered.isEmpty
          ? const Center(
              child: Text(
                'No industries match your search.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final pb = _filtered[index];
                final color = _colorForIndustry(pb.industryName);
                final icon = _iconForIndustry(pb.industryName);
                return _IndustryCard(
                  playbook: pb,
                  color: color,
                  icon: icon,
                  onTap: () => context.push('/airtel-iq/playbooks/${pb.id}'),
                );
              },
            ),
    );
  }
}

class _IndustryCard extends StatelessWidget {
  final IndustryPlaybook playbook;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _IndustryCard({
    required this.playbook,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final topPriorities = playbook.businessPriorities.take(3).toList();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              // Header stripe
              Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        playbook.industryName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${playbook.relevantSolutions.length} solutions',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Body
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Business Priorities',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: color,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...topPriorities.map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                p,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Open Playbook',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 14, color: color),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
