import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/widgets/airtel_header.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/features/airtel_iq/knowledge/product_enrichment_repository.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  String _getProductIdByName(String name) {
    for (var entry in productEnrichmentData.entries) {
      if (entry.value.productName == name) {
        return entry.key;
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final product =
        productEnrichmentData[productId] ?? productEnrichmentData.values.first;

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AirtelHeader(
        title: product.productName,
        automaticallyImplyLeading: true,
        variant: HeaderVariant.medium,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickGlanceHero(product),
            const SizedBox(height: 24),

            _buildSectionTitle('What is this product?'),
            _buildTextContent(product.whatItIs),
            const SizedBox(height: 24),

            if (product.officialFeaturesAndBenefits.isNotEmpty) ...[
              _buildSectionTitle('🚀 Features & Benefits'),
              _buildOfficialFeatures(product),
              const SizedBox(height: 24),
            ],

            if (product.businessOutcomes.isNotEmpty) ...[
              _buildSectionTitle('🎯 Business Value'),
              ...product.businessOutcomes.map(
                (b) => _buildBulletPoint(b, Colors.black87),
              ),
              const SizedBox(height: 24),
            ],

            _buildSectionTitle('💡 When should I pitch this?'),
            _buildTextContent(product.whenToPitch),
            const SizedBox(height: 24),

            _buildCollapsibleSection(
              '🧠 How to position it',
              _buildTextContent(product.positioningStatement),
            ),

            if (product.customerSignals.isNotEmpty)
              _buildCollapsibleSection(
                '📡 Customer Signals',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: product.customerSignals
                      .map((s) => _buildBulletPoint(s, Colors.black87))
                      .toList(),
                ),
              ),

            if (product.discoveryHooks.isNotEmpty)
              _buildCollapsibleSection(
                '❓ Discovery Questions',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: product.discoveryHooks
                      .map((q) => _buildBulletPoint(q, Colors.black87))
                      .toList(),
                ),
              ),

            if (product.commonObjections.isNotEmpty)
              _buildCollapsibleSection(
                '🛡️ Common Objections',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: product.commonObjections
                      .map((obj) => _buildObjectionAccordion(obj))
                      .toList(),
                ),
              ),

            const SizedBox(height: 12),

            if (product.crossSellProducts.isNotEmpty) ...[
              _buildSectionTitle('🤝 Cross-Sell Opportunities'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: product.crossSellProducts.map((c) {
                  final targetId = _getProductIdByName(c);
                  return ActionChip(
                    label: Text(
                      c,
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.blue.shade50,
                    side: BorderSide(color: Colors.blue.shade200),
                    onPressed: targetId.isNotEmpty
                        ? () {
                            context.push('/airtel-iq/products/$targetId');
                          }
                        : null,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            if (product.fiveThingsToRemember.isNotEmpty) ...[
              _buildSectionTitle('🧠 5 Things To Remember'),
              ...product.fiveThingsToRemember.map(
                (item) => _buildBulletPoint(item, Colors.purple.shade700),
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickGlanceHero(EnrichedProduct product) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.productName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              product.category,
              style: TextStyle(
                color: Colors.purple.shade700,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Primary Use Case:',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.primaryUseCase,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Best For:',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: product.idealIndustries.map((industry) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  industry,
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 12),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {Color color = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTextContent(String content) {
    return Text(
      content,
      style: TextStyle(color: Colors.grey.shade800, fontSize: 15, height: 1.5),
    );
  }

  Widget _buildBulletPoint(
    String text,
    Color textColor, {
    IconData icon = Icons.circle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 8),
            child: Icon(
              icon,
              size: icon == Icons.circle ? 6 : 14,
              color: textColor,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleSection(String title, Widget content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        iconColor: AppConstants.primaryColor,
        collapsedIconColor: Colors.grey.shade600,
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [content],
      ),
    );
  }

  Widget _buildObjectionAccordion(ObjectionHandling obj) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: Text(
          obj.objection,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        iconColor: AppConstants.primaryColor,
        collapsedIconColor: Colors.grey.shade600,
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border(
                left: BorderSide(color: Colors.blue.shade400, width: 4),
              ),
            ),
            child: Text(
              obj.response,
              style: TextStyle(
                color: Colors.blue.shade900,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficialFeatures(EnrichedProduct product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: product.officialFeaturesAndBenefits.entries.map((entry) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              ...entry.value.map(
                (bullet) => _buildBulletPoint(bullet, Colors.black87),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
