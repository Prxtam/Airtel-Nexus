import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/airtel_iq/mock_data/airtel_iq_mock_data.dart';

class PlaybookDetailScreen extends StatelessWidget {
  final String playbookId;

  const PlaybookDetailScreen({super.key, required this.playbookId});

  @override
  Widget build(BuildContext context) {
    final playbook = AirtelIqMockData.playbooks.firstWhere(
      (pb) => pb.id == playbookId,
      orElse: () => AirtelIqMockData.playbooks.first,
    );

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Playbook'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Sales Playbook',
                  style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                playbook.industry,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Text(
                playbook.overview,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 24),
              _buildSection('Common Pain Points', playbook.painPoints, Icons.warning_amber_rounded, Colors.red),
              const SizedBox(height: 24),
              _buildSection('Discovery Questions', playbook.discoveryQuestions, Icons.search, Colors.blue),
              const SizedBox(height: 24),
              _buildSection('Recommended Solutions', playbook.recommendedSolutions, Icons.check_circle_outline, Colors.green),
              const SizedBox(height: 24),
              _buildSection('Cross-Sell Opportunities', playbook.crossSellOpportunities, Icons.compare_arrows, Colors.purple),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 14, height: 1.4),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
