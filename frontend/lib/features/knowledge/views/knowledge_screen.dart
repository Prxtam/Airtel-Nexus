import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/widgets/airtel_header.dart';

class KnowledgeScreen extends StatelessWidget {
  const KnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: const AirtelHeader(
        title: 'Airtel Assist',
        subtitle: 'Sales intelligence for Account Managers',
        automaticallyImplyLeading: false,
        variant: HeaderVariant.large,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildKnowledgeCategory(
                    context: context,
                    icon: Icons.shopping_bag_outlined,
                    title: 'Airtel Products',
                    subtitle: 'Enterprise solutions and service details',
                    color: AppConstants.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  _buildKnowledgeCategory(
                    context: context,
                    icon: Icons.menu_book_outlined,
                    title: 'Industry Playbooks',
                    subtitle: 'Quick-reference for every industry',
                    color: AppConstants.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  _buildKnowledgeCategory(
                    context: context,
                    icon: Icons.smart_toy_outlined,
                    title: 'Sales Coach',
                    subtitle: 'Intelligent meeting prep & pitch analysis',
                    color: AppConstants.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  _buildKnowledgeCategory(
                    context: context,
                    icon: Icons.hub_outlined,
                    title: 'Knowledge Hub',
                    subtitle: 'Airtel reference encyclopedia',
                    color: AppConstants.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  _buildKnowledgeCategory(
                    context: context,
                    icon: Icons.info_outline,
                    title: 'About Airtel',
                    subtitle: 'Company information and updates',
                    color: AppConstants.primaryColor,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKnowledgeCategory({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (title == 'Airtel Products') {
              context.push('/airtel-iq/products');
            } else if (title == 'Industry Playbooks') {
              context.push('/airtel-iq/playbooks');
            } else if (title == 'Sales Coach') {
              context.push('/airtel-iq/ai-coach');
            } else if (title == 'Knowledge Hub') {
              context.push('/airtel-iq/knowledge-hub');
            } else if (title == 'About Airtel') {
              context.push('/airtel-iq/about');
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
