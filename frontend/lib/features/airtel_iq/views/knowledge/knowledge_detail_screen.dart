import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/widgets/airtel_header.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/features/airtel_iq/mock_data/airtel_iq_mock_data.dart';

class KnowledgeDetailScreen extends StatelessWidget {
  final String articleId;

  const KnowledgeDetailScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    final article = AirtelIqMockData.articles.firstWhere(
      (a) => a.id == articleId,
      orElse: () => AirtelIqMockData.articles.first,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AirtelHeader(
        title: 'Article',
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  article.category.toUpperCase(),
                  style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 12),
                ),
                Text(
                  article.readTime,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              article.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.2),
            ),
            const SizedBox(height: 16),
            Text(
              article.summary,
              style: const TextStyle(fontSize: 18, color: Colors.black54, fontStyle: FontStyle.italic, height: 1.4),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Text(
              article.content,
              style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.6),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'Key Takeaways',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...article.keyTakeaways.map((takeaway) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(
                                takeaway,
                                style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
