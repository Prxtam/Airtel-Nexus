import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/features/airtel_iq/widgets/airtel_iq_feature_card.dart';
import 'package:frontend/core/widgets/airtel_header.dart';
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
            AirtelIqFeatureCard(
              title: 'Airtel Products',
              subtitle: 'Enterprise solutions and service details',
              icon: Icons.shopping_bag_outlined,
              iconColor: AppConstants.primaryColor,
              onTap: () => context.push('/airtel-iq/products'),
            ),
            const Gap(AppSpacing.md),
            AirtelIqFeatureCard(
              title: 'Industry Playbooks',
              subtitle: 'Quick-reference for every industry',
              icon: Icons.menu_book_outlined,
              iconColor: AppConstants.primaryColor,
              onTap: () => context.push('/airtel-iq/playbooks'),
            ),
            const Gap(AppSpacing.md),
            AirtelIqFeatureCard(
              title: 'Sales Coach',
              subtitle: 'Intelligent meeting prep & pitch analysis',
              icon: Icons.smart_toy_outlined,
              iconColor: AppConstants.primaryColor,
              isFeatured: false,
              onTap: () => context.push('/airtel-iq/ai-coach'),
            ),
            const Gap(AppSpacing.md),
            AirtelIqFeatureCard(
              title: 'Knowledge Hub',
              subtitle: 'Airtel reference encyclopedia',
              icon: Icons.hub_outlined,
              iconColor: AppConstants.primaryColor,
              onTap: () => context.push('/airtel-iq/knowledge-hub'),
            ),
            const Gap(AppSpacing.md),
            AirtelIqFeatureCard(
              title: 'About Airtel',
              subtitle: 'Company information and updates',
              icon: Icons.info_outline,
              iconColor: AppConstants.primaryColor,
              onTap: () => context.push('/airtel-iq/about'),
            ),
            const Gap(AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
