import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/core/widgets/airtel_header.dart';
import 'package:frontend/features/airtel_iq/knowledge/industry_intelligence.dart';
import 'package:frontend/features/airtel_iq/services/industry_playbook_adapter.dart';
import 'package:frontend/features/airtel_iq/widgets/airtel_iq_search_bar.dart';

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
      appBar: const AirtelHeader(
        title: 'Industry Playbooks',
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AirtelIqSearchBar(
              hintText: 'Search industry or solution...',
              onChanged: _onSearch,
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'No industries match your search.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        itemCount: _filtered.length,
                        itemBuilder: (context, index) {
                          final pb = _filtered[index];
                          final icon = _iconForIndustry(pb.industryName);
                          return _IndustryCard(
                            playbook: pb,
                            icon: icon,
                            onTap: () => context.push('/airtel-iq/playbooks/${pb.id}'),
                          );
                        },
                      ),
              ),
        ],
      ),
    );
  }
}

class _IndustryCard extends StatelessWidget {
  final IndustryPlaybook playbook;
  final IconData icon;
  final VoidCallback onTap;

  const _IndustryCard({
    required this.playbook,
    required this.icon,
    required this.onTap,
  });

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
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon, 
                      color: AppConstants.primaryColor, 
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playbook.industryName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${playbook.relevantSolutions.length} Solutions Available',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Bottom Right Link
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Open Playbook',
                      style: TextStyle(
                        color: AppConstants.primaryColor, 
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16, color: AppConstants.primaryColor),
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
