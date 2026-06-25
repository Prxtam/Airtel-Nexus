import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/core/widgets/airtel_header.dart';
import 'package:frontend/features/airtel_iq/knowledge/product_enrichment_repository.dart';
import 'package:frontend/features/airtel_iq/knowledge/industry_intelligence.dart';
import 'package:frontend/features/airtel_iq/services/industry_playbook_adapter.dart';

class KnowledgeListScreen extends StatefulWidget {
  const KnowledgeListScreen({super.key});

  @override
  State<KnowledgeListScreen> createState() => _KnowledgeListScreenState();
}

class _KnowledgeListScreenState extends State<KnowledgeListScreen> {
  String _searchQuery = '';
  late List<MapEntry<String, EnrichedProduct>> _allProducts;
  late List<IndustryPlaybook> _allPlaybooks;

  final List<String> _featuredProductIds = [
    'prod_public_cloud',
    'prod_sd_wan',
    'prod_secure_internet',
    'prod_corporate_postpaid', // fallback for cloud
  ];

  @override
  void initState() {
    super.initState();
    _allProducts = productEnrichmentData.entries.toList();
    _allPlaybooks = industryIntelligenceRepo
        .map(IndustryPlaybook.fromIndustry)
        .toList();
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  // Tag color logic matching the new screenshot
  Color _tagColorForCategory(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('mobility')) return const Color(0xFF8B5CF6); // Purple
    if (cat.contains('engagement')) return const Color(0xFF10B981); // Green
    if (cat.contains('connectivity') || cat.contains('networking')) return const Color(0xFF6366F1); // Indigo
    if (cat.contains('unified') || cat.contains('communication')) return const Color(0xFF14B8A6); // Teal
    if (cat.contains('cloud')) return const Color(0xFF0EA5E9); // Blue
    if (cat.contains('security')) return const Color(0xFFF43F5E); // Rose
    return const Color(0xFF6366F1);
  }

  // Color logic for featured knowledge pills
  Color _colorForFeatured(int index) {
    final colors = [
      const Color(0xFF0EA5E9), // Blue
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFF43F5E), // Red/Pink
      const Color(0xFFF59E0B), // Yellow/Orange
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _searchQuery.isEmpty 
        ? _allProducts 
        : _allProducts.where((p) {
            return p.value.productName.toLowerCase().contains(_searchQuery) ||
                   p.value.category.toLowerCase().contains(_searchQuery);
          }).toList();

    final filteredPlaybooks = _searchQuery.isEmpty
        ? _allPlaybooks
        : _allPlaybooks.where((pb) {
            return pb.industryName.toLowerCase().contains(_searchQuery);
          }).toList();

    final featuredProducts = _featuredProductIds
        .where((id) => productEnrichmentData.containsKey(id))
        .map((id) => MapEntry(id, productEnrichmentData[id]!))
        .toList();

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AirtelSearchHeader(
        title: 'Airtel Knowledge Hub',
        subtitle: 'Centralized Airtel reference encyclopedia',
        hintText: 'Search products, industries, terms...',
        onChanged: _onSearch,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AirtelHeaderConstants.searchBodyTopPadding),
            
            if (_searchQuery.isEmpty) ...[
              // Stats Cards
              _buildStatsRow(),
              const SizedBox(height: 24),

              // Featured Knowledge
              _buildSectionHeader('Featured Knowledge'),
              _buildFeaturedList(featuredProducts),
              const SizedBox(height: 24),
            ],

            // Products
            _buildSectionHeader('Products'),
            _buildProductsGrid(filteredProducts),

            if (_searchQuery.isNotEmpty) ...[
               const SizedBox(height: 24),
               _buildSectionHeader('Industry Playbooks'),
               _buildPlaybooksGrid(filteredPlaybooks),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              count: '19',
              title: 'Products',
              icon: Icons.inventory_2_outlined,
              color: const Color(0xFF6366F1), // Indigo/Blue
              bgColor: const Color(0xFFEEF2FF),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              count: '15',
              title: 'Industries',
              icon: Icons.precision_manufacturing_outlined,
              color: const Color(0xFF10B981), // Green
              bgColor: const Color(0xFFECFDF5),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              count: '34',
              title: 'Resources',
              icon: Icons.menu_book_outlined,
              color: const Color(0xFFF59E0B), // Orange/Yellow
              bgColor: const Color(0xFFFFFBEB),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String count,
    required String title,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildFeaturedList(List<MapEntry<String, EnrichedProduct>> featured) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: featured.length,
        itemBuilder: (context, index) {
          final id = featured[index].key;
          final product = featured[index].value;
          final color = _colorForFeatured(index);

          return Container(
            width: 140,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: InkWell(
              onTap: () => context.push('/airtel-iq/products/$id'),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    product.productName.replaceAll('Airtel ', 'Airtel\n'),
                    style: TextStyle(
                      fontWeight: FontWeight.w500, 
                      fontSize: 14, 
                      height: 1.3,
                      color: color,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsGrid(List<MapEntry<String, EnrichedProduct>> products) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No products found.', style: TextStyle(color: Colors.grey)),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 600 ? 2 : 2; // Screenshot has 2 columns
          return GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisExtent: 180, // Taller to fit description and button
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final id = products[index].key;
              final product = products[index].value;
              final color = _tagColorForCategory(product.category);

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: InkWell(
                  onTap: () => context.push('/airtel-iq/products/$id'),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            product.category,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Title
                        Text(
                          product.productName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        
                        // Description
                        Expanded(
                          child: Text(
                            product.whatItIs,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              height: 1.3,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                        // Open Button
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Open',
                                style: TextStyle(
                                  color: color,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_forward, size: 16, color: color),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPlaybooksGrid(List<IndustryPlaybook> playbooks) {
    if (playbooks.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
          return GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisExtent: 60,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: playbooks.length,
            itemBuilder: (context, index) {
              final pb = playbooks[index];

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: InkWell(
                  onTap: () => context.push('/airtel-iq/playbooks/${pb.id}'),
                  borderRadius: BorderRadius.circular(8),
                  child: Center(
                    child: Text(
                      pb.industryName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
