import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/features/airtel_iq/widgets/airtel_iq_feature_card.dart';
import 'package:frontend/core/widgets/airtel_header.dart';
import 'package:frontend/features/airtel_iq/views/knowledge_explorer/knowledge_explorer_screen.dart';
import 'package:gap/gap.dart';

class AirtelIqDashboardScreen extends StatelessWidget {
  const AirtelIqDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: const AirtelHeader(
        title: 'Airtel Assist',
        subtitle: 'Sales intelligence for Account Managers',
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.85,
              children: [
                AirtelIqFeatureCard(
                  title: 'Sales Coach',
                  subtitle: 'Meeting prep & pitch suggestions',
                  icon: Icons.smart_toy_outlined,
                  iconColor: AppConstants.primaryColor,
                  isFeatured: true,
                  onTap: () => context.push('/airtel-iq/ai-coach'),
                ),
                AirtelIqFeatureCard(
                  title: 'Objection Handling',
                  subtitle: 'Overcome pricing and tech concerns',
                  icon: Icons.shield_outlined,
                  iconColor: const Color(0xFFC00000), // Airtel Red
                  isFeatured: true,
                  onTap: () => context.push('/airtel-iq/objections'),
                ),
                AirtelIqFeatureCard(
                  title: 'Knowledge Hub',
                  subtitle: 'Airtel reference encyclopedia',
                  icon: Icons.hub_outlined,
                  iconColor: Colors.teal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KnowledgeExplorerScreen(),
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
                AirtelIqFeatureCard(
                  title: 'Industry Playbooks',
                  subtitle: 'Quick-reference for every industry',
                  icon: Icons.assignment_outlined,
                  iconColor: Colors.green,
                  onTap: () => context.push('/airtel-iq/playbooks'),
                ),
                AirtelIqFeatureCard(
                  title: 'About Airtel',
                  subtitle: 'Company information and updates',
                  icon: Icons.info_outline,
                  iconColor: Colors.blueGrey,
                  onTap: () => context.push('/airtel-iq/about'),
                ),
              ],
            ),
            const Gap(AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
