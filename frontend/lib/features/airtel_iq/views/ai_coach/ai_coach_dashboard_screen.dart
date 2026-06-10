import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';


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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Your AI-powered sales workspace',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
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
            const SizedBox(height: 32),
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
      margin: const EdgeInsets.only(bottom: 12),
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
          onTap: () => context.push(route),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppConstants.primaryColor, size: 28),
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
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
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
