import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/core/widgets/airtel_header.dart';
import 'package:frontend/features/airtel_iq/mock_data/airtel_iq_mock_data.dart';
import 'package:frontend/features/airtel_iq/models/airtel_iq_models.dart';
import 'package:frontend/features/airtel_iq/widgets/airtel_iq_search_bar.dart';

class KnowledgeListScreen extends StatefulWidget {
  const KnowledgeListScreen({super.key});

  @override
  State<KnowledgeListScreen> createState() => _KnowledgeListScreenState();
}

class _KnowledgeListScreenState extends State<KnowledgeListScreen> {
  late List<KnowledgeArticle> _articles;

  @override
  void initState() {
    super.initState();
    _articles = AirtelIqMockData.articles;
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _articles = AirtelIqMockData.articles;
      } else {
        _articles = AirtelIqMockData.articles.where((article) {
          return article.title.toLowerCase().contains(query.toLowerCase()) ||
                 article.category.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: const AirtelHeader(
        title: 'Product Knowledge',
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AirtelIqSearchBar(
              hintText: 'Search articles...',
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: _articles.isEmpty
                ? const Center(
                    child: Text(
                      'No articles match your search.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: _articles.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final article = _articles[index];
                      return Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: InkWell(
                          onTap: () => context.push('/airtel-iq/knowledge/${article.id}'),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppConstants.primaryColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        article.category,
                                        style: TextStyle(color: AppConstants.primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      article.readTime,
                                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  article.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  article.summary,
                                  style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
