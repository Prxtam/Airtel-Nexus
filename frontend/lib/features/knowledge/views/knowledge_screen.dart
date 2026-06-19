import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/airtel_iq/views/knowledge_explorer/knowledge_explorer_screen.dart';
import 'package:frontend/features/airtel_iq/views/about_airtel/about_airtel_screen.dart';

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
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'High Impact Tools',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildKnowledgeCategory(
                    context: context,
                    icon: Icons.smart_toy_outlined,
                    title: 'AI Sales Coach',
                    subtitle: 'Intelligent meeting prep & pitch analysis',
                    color: AppConstants.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  _buildKnowledgeCategory(
                    context: context,
                    icon: Icons.menu_book_outlined,
                    title: 'Industry Playbooks',
                    subtitle: 'Quick-reference for every industry',
                    color: Colors.green,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Core Foundation',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
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
                    icon: Icons.hub_outlined,
                    title: 'Knowledge Hub',
                    subtitle: 'Airtel reference encyclopedia',
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 12),
                  _buildKnowledgeCategory(
                    context: context,
                    icon: Icons.info_outline,
                    title: 'About Airtel',
                    subtitle: 'Company information and updates',
                    color: Colors.blue,
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 16,
        20,
        20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppConstants.primaryColor, Color(0xFFC00000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Airtel IQ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Sales intelligence for Account Managers',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
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
            } else if (title == 'AI Sales Coach') {
              context.push('/airtel-iq/ai-coach');
            } else if (title == 'Knowledge Hub') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const KnowledgeExplorerScreen(),
                ),
              );
            } else if (title == 'About Airtel') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutAirtelScreen(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$title coming in Phase 8B')),
              );
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
