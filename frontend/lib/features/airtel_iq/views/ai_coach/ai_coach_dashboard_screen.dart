import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/airtel_iq/widgets/airtel_iq_feature_card.dart';

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppConstants.primaryColor, Colors.red.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.smart_toy, color: Colors.white, size: 32),
                  SizedBox(height: 16),
                  Text(
                    'Sales Intelligence',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your context-aware copilot for meeting prep, insights, and follow-ups.',
                    style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
              children: [
                AirtelIqFeatureCard(
                  title: 'Meeting Prep',
                  subtitle: 'Briefs & discovery questions',
                  icon: Icons.event_note,
                  iconColor: Colors.blue.shade700,
                  isFeatured: true,
                  onTap: () => context.push('/airtel-iq/ai-coach/meeting-prep'),
                ),
                AirtelIqFeatureCard(
                  title: 'Opportunity Insights',
                  subtitle: 'Upsell & cross-sell logic',
                  icon: Icons.lightbulb,
                  iconColor: Colors.amber.shade700,
                  isFeatured: true,
                  onTap: () => context.push('/airtel-iq/ai-coach/insights'),
                ),
                AirtelIqFeatureCard(
                  title: 'Follow-Up Gen',
                  subtitle: 'Exec summaries & emails',
                  icon: Icons.mark_email_read,
                  iconColor: Colors.green.shade700,
                  onTap: () => context.push('/airtel-iq/ai-coach/follow-ups'),
                ),
                AirtelIqFeatureCard(
                  title: 'Objection Coach',
                  subtitle: 'Recommended responses',
                  icon: Icons.shield,
                  iconColor: AppConstants.primaryColor,
                  onTap: () => context.push('/airtel-iq/objections'), // Routes to existing Phase 8B.1
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: InkWell(
                onTap: () => context.push('/airtel-iq/ai-coach/ask'),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.search, color: Colors.purple.shade700, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ask Airtel IQ',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Enterprise knowledge search experience.',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
