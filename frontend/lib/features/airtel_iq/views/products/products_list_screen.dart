import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/core/widgets/airtel_header.dart';
import 'package:frontend/features/airtel_iq/knowledge/product_enrichment_repository.dart';
import 'package:frontend/features/airtel_iq/widgets/airtel_iq_search_bar.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  late Map<String, EnrichedProduct> _filteredProducts;
  final List<String> _categories = [
    'All Products',
    'Mobility',
    'Connectivity',
    'Customer Engagement',
    'Cloud',
    'Security'
  ];
  final String _selectedCategory = 'All Products';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredProducts = Map.from(productEnrichmentData);
  }

  IconData _getIconForCategory(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('mobility')) return Icons.stay_current_portrait_outlined;
    if (cat.contains('connectivity')) return Icons.share_outlined;
    if (cat.contains('engagement')) return Icons.verified_user_outlined;
    if (cat.contains('cloud')) return Icons.cloud_outlined;
    if (cat.contains('security')) return Icons.security_outlined;
    if (cat.contains('unified')) return Icons.phone_in_talk_outlined;
    return Icons.business_outlined;
  }

  void _applyFilters() {
    setState(() {
      _filteredProducts = Map.fromEntries(
        productEnrichmentData.entries.where((entry) {
          final product = entry.value;
          final matchesSearch = _searchQuery.isEmpty || 
                 product.productName.toLowerCase().contains(_searchQuery) ||
                 product.primaryUseCase.toLowerCase().contains(_searchQuery) ||
                 product.category.toLowerCase().contains(_searchQuery);
                 
          final matchesCategory = _selectedCategory == 'All Products' || 
                 product.category.toLowerCase().contains(_selectedCategory.toLowerCase());
                 
          return matchesSearch && matchesCategory;
        }),
      );
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categories.length,
      child: Scaffold(
        backgroundColor: AppConstants.scaffoldBackgroundColor,
        appBar: const AirtelHeader(
          title: 'Airtel Products',
          automaticallyImplyLeading: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AirtelIqSearchBar(
                hintText: 'Search products by name or category...',
                onChanged: _onSearchChanged,
              ),
            ),
            // Slidable Category Tabs
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppConstants.primaryColor,
              unselectedLabelColor: Colors.grey.shade700,
              indicatorColor: AppConstants.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2,
              dividerColor: Colors.transparent,
              tabs: _categories.map((c) => Tab(text: c)).toList(),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                children: _categories.map((category) {
                  // Filter products dynamically for this specific tab
                  final tabProducts = productEnrichmentData.entries.where((entry) {
                    final product = entry.value;
                    final matchesSearch = _searchQuery.isEmpty || 
                           product.productName.toLowerCase().contains(_searchQuery) ||
                           product.primaryUseCase.toLowerCase().contains(_searchQuery) ||
                           product.category.toLowerCase().contains(_searchQuery);
                           
                    final matchesCategory = category == 'All Products' || 
                           product.category.toLowerCase().contains(category.toLowerCase());
                           
                    return matchesSearch && matchesCategory;
                  }).toList();

                  if (tabProducts.isEmpty) {
                    return const Center(
                      child: Text(
                        'No products match your search.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: tabProducts.length,
                    itemBuilder: (context, index) {
                      final productId = tabProducts[index].key;
                      final product = tabProducts[index].value;
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: InkWell(
                          onTap: () => context.push('/airtel-iq/products/$productId'),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon Box
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppConstants.primaryColor.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    _getIconForCategory(product.category), 
                                    color: AppConstants.primaryColor, 
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Text Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.productName,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product.category,
                                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        product.idealIndustries.take(3).join('  •  '),
                                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Chevron
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 24.0),
                                    child: Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
