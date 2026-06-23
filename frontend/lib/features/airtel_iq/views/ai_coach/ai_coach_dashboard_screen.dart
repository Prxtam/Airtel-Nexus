import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:gap/gap.dart';


class AiCoachDashboardScreen extends StatelessWidget {
  const AiCoachDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('AI Sales Coach'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your AI-powered sales workspace',
              style: AppTypography.sectionTitle.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(AppSpacing.xl),
            _buildActionCard(
              context: context,
              title: 'Meeting Prep',
              subtitle: 'Briefs, stakeholder context and discovery questions',
              icon: Icons.event_note_outlined,
              route: '/airtel-iq/ai-coach/meeting-prep',
            ),
            _buildActionCard(
              context: context,
              title: 'Opportunity Insights',
              subtitle: 'Cross-sell, upsell and expansion opportunities',
              icon: Icons.lightbulb_outline,
              route: '/airtel-iq/ai-coach/insights',
            ),
            _buildActionCard(
              context: context,
              title: 'Follow-Up Generator',
              subtitle: 'Executive summaries and customer emails',
              icon: Icons.mark_email_read_outlined,
              route: '/airtel-iq/ai-coach/follow-ups',
            ),
            _buildActionCard(
              context: context,
              title: 'Objection Coach',
              subtitle: 'Recommended responses to customer concerns',
              icon: Icons.shield_outlined,
              route: '/airtel-iq/objections',
            ),
            _buildActionCard(
              context: context,
              title: 'Ask Airtel IQ',
              subtitle: 'Enterprise knowledge search',
              icon: Icons.search,
              route: '/airtel-iq/ai-coach/ask',
            ),
            const Gap(AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String route,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: () => context.push(route),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(icon, color: AppConstants.primaryColor, size: 28),
                ),
                const Gap(AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.cardTitle.copyWith(
                          fontWeight: FontWeight.w700, 
                          color: Colors.black87,
                        ),
                      ),
                      const Gap(AppSpacing.sm),
                      Text(
                        subtitle,
                        style: AppTypography.caption.copyWith(color: Colors.grey.shade600),
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
