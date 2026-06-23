import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/features/airtel_iq/widgets/airtel_iq_feature_card.dart';
import 'package:frontend/features/airtel_iq/widgets/airtel_iq_section_header.dart';
import 'package:frontend/features/airtel_iq/views/knowledge_explorer/knowledge_explorer_screen.dart';
import 'package:gap/gap.dart';

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
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AirtelIqSectionHeader(title: 'High Impact Tools'),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
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

                  const Gap(AppSpacing.xl),
                  const AirtelIqSectionHeader(title: 'Core Knowledge'),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.85,
                    children: [
                      AirtelIqFeatureCard(
                        title: 'Knowledge Hub',
                        subtitle: 'Airtel reference encyclopedia',
                        icon: Icons.hub_outlined,
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

                  const Gap(AppSpacing.xl),
                  const AirtelIqSectionHeader(title: 'Resources'),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
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
                  const Gap(AppSpacing.xxl),
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
        AppSpacing.lg,
        MediaQuery.of(context).padding.top + AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppConstants.primaryColor, Color(0xFFC00000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.lg),
          bottomRight: Radius.circular(AppRadius.lg),
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
              const Gap(AppSpacing.md),
              Text(
                'Airtel Assist',
                style: AppTypography.pageTitle.copyWith(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.sm),
          Text(
            'Sales Enablement Hub',
            style: AppTypography.sectionTitle.copyWith(
              color: Colors.white,
            ),
          ),
          const Gap(AppSpacing.md),
          Text(
            'Helping Airtel Account Managers sell smarter, prepare faster, and close enterprise opportunities more effectively.',
            style: AppTypography.bodyText.copyWith(color: Colors.white70, height: 1.4),
          ),
        ],
      ),
    );
  }
}
