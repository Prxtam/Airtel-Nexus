import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';

class KnowledgeScreen extends StatelessWidget {
  const KnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  _buildKnowledgeCategory(
                    context: context,
                    icon: Icons.info_outline,
                    title: 'About Airtel',
                    subtitle: 'Company information and updates',
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildKnowledgeCategory(
                    context: context,
                    icon: Icons.shopping_bag_outlined,
                    title: 'Airtel Products',
                    subtitle: 'Enterprise solutions and service details',
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 12),
                  _buildKnowledgeCategory(
                    context: context,
                    icon: Icons.menu_book_outlined,
                    title: 'Sales Playbooks',
                    subtitle: 'Guides and strategies for closing deals',
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildKnowledgeCategory(
                    context: context,
                    icon: Icons.smart_toy_outlined,
                    title: 'AI Sales Coach',
                    subtitle: 'Intelligent tips and meeting analysis',
                    color: AppConstants.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 16, 16, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppConstants.primaryColor, Color(0xFFC00000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Knowledge Center',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Learn, pitch and sell Airtel solutions effectively',
            style: TextStyle(color: Colors.white70, fontSize: 14),
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
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          if (title == 'Airtel Products') {
            context.push('/airtel-iq/products');
          } else if (title == 'Sales Playbooks') {
            context.push('/airtel-iq/playbooks');
          } else if (title == 'AI Sales Coach') {
            context.push('/airtel-iq/ai-coach');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$title coming in Phase 8B')),
            );
          }
        },
      ),
    );
  }
}
