import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_constants.dart';

class KnowledgeScreen extends StatelessWidget {
  const KnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Knowledge Center'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Coming in Phase 8B',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildKnowledgeCategory(
              icon: Icons.info_outline,
              title: 'About Airtel',
              subtitle: 'Company information and updates',
            ),
            const SizedBox(height: 12),
            _buildKnowledgeCategory(
              icon: Icons.shopping_bag_outlined,
              title: 'Airtel Products',
              subtitle: 'Enterprise solutions and service details',
            ),
            const SizedBox(height: 12),
            _buildKnowledgeCategory(
              icon: Icons.menu_book_outlined,
              title: 'Sales Playbooks',
              subtitle: 'Guides and strategies for closing deals',
            ),
            const SizedBox(height: 12),
            _buildKnowledgeCategory(
              icon: Icons.smart_toy_outlined,
              title: 'AI Sales Coach',
              subtitle: 'Intelligent tips and meeting analysis',
              isHighlighted: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKnowledgeCategory({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isHighlighted = false,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: isHighlighted 
            ? AppConstants.primaryColor.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
          child: Icon(
            icon, 
            color: isHighlighted ? AppConstants.primaryColor : Colors.grey.shade700,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          // Placeholder action
        },
      ),
    );
  }
}
