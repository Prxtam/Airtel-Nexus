import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/airtel_iq/mock_data/airtel_iq_mock_data.dart';
import 'package:frontend/features/airtel_iq/models/airtel_iq_models.dart';
import 'package:frontend/features/airtel_iq/widgets/airtel_iq_search_bar.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  late List<AirtelProduct> _products;

  @override
  void initState() {
    super.initState();
    _products = AirtelIqMockData.products;
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _products = AirtelIqMockData.products;
      } else {
        _products = AirtelIqMockData.products.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase()) ||
                 product.category.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Airtel Products'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AirtelIqSearchBar(
              hintText: 'Search products...',
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: _products.isEmpty
                ? const Center(
                    child: Text(
                      'No products match your search.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: _products.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: InkWell(
                          onTap: () => context.push('/airtel-iq/products/${product.id}'),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.purple.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        product.category,
                                        style: TextStyle(color: Colors.purple.shade700, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  product.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product.shortDescription,
                                  style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'View Details',
                                      style: TextStyle(color: AppConstants.primaryColor, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(Icons.arrow_forward, size: 16, color: AppConstants.primaryColor),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
