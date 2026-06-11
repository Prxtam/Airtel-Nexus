import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/airtel_iq/mock_data/airtel_iq_mock_data.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final product = AirtelIqMockData.products.firstWhere(
      (p) => p.id == productId,
      orElse: () => AirtelIqMockData.products.first,
    );

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product.category,
                  style: TextStyle(color: Colors.purple.shade700, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              const Text(
                'Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                product.overview,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 24),
              _buildSection('Business Benefits', product.businessBenefits, Icons.check_circle_outline, Colors.green),
              const SizedBox(height: 24),
              _buildSection('Key Differentiators', product.keyDifferentiators, Icons.star_border, Colors.orange),
              const SizedBox(height: 24),
              _buildSection('Ideal Customer Types', product.idealCustomerTypes, Icons.business, Colors.blue),
              const SizedBox(height: 24),
              _buildSection('Typical Use Cases', product.typicalUseCases, Icons.lightbulb_outline, Colors.amber),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items, IconData icon, Color iconColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 15, height: 1.4),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
