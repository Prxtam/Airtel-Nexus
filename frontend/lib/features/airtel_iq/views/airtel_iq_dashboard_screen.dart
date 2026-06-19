import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/airtel_iq/widgets/airtel_iq_feature_card.dart';
import 'package:frontend/features/airtel_iq/widgets/airtel_iq_section_header.dart';
import 'package:frontend/features/airtel_iq/views/knowledge_explorer/knowledge_explorer_screen.dart';

class AirtelIqDashboardScreen extends StatelessWidget {
  const AirtelIqDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildHeroSection(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AirtelIqSectionHeader(title: 'High Impact Tools'),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                    children: [
                      AirtelIqFeatureCard(
                        title: 'Objection Handling',
                        subtitle: 'Overcome pricing and tech concerns',
                        icon: Icons.shield_outlined,
                        iconColor: const Color(0xFFC00000), // Airtel Red
                        isFeatured: true,
                        onTap: () => context.push('/airtel-iq/objections'),
                      ),
                      AirtelIqFeatureCard(
                        title: 'AI Sales Coach',
                        subtitle: 'Meeting prep & pitch suggestions',
                        icon: Icons.smart_toy_outlined,
                        iconColor: AppConstants.primaryColor,
                        isFeatured: true,
                        onTap: () => context.push('/airtel-iq/ai-coach'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  const AirtelIqSectionHeader(title: 'Core Knowledge'),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                    children: [
                      AirtelIqFeatureCard(
                        title: 'Knowledge Explorer',
                        subtitle: 'Browse Airtel IQ Repository',
                        icon: Icons.travel_explore,
                        iconColor: Colors.teal,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const KnowledgeExplorerScreen(),
                            ),
                          );
                        },
                      ),
                      AirtelIqFeatureCard(
                        title: 'Airtel Products',
                        subtitle: 'Enterprise solutions details',
                        icon: Icons.shopping_bag_outlined,
                        iconColor: Colors.purple,
                        onTap: () => context.push('/airtel-iq/products'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  const AirtelIqSectionHeader(title: 'Resources'),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                    children: [
                      AirtelIqFeatureCard(
                        title: 'Product Knowledge',
                        subtitle: 'Articles & key takeaways',
                        icon: Icons.menu_book_outlined,
                        iconColor: Colors.blue,
                        onTap: () => context.push('/airtel-iq/knowledge'),
                      ),
                      AirtelIqFeatureCard(
                        title: 'Industry Playbooks',
                        subtitle: 'Quick-reference for every industry',
                        icon: Icons.assignment_outlined,
                        iconColor: Colors.green,
                        onTap: () => context.push('/airtel-iq/playbooks'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 20,
        20,
        32,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppConstants.primaryColor, Color(0xFFC00000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
              ),
              const SizedBox(width: 16),
              const Text(
                'Airtel IQ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Sales Enablement Hub',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Helping Airtel Account Managers sell smarter, prepare faster, and close enterprise opportunities more effectively.',
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }
}
