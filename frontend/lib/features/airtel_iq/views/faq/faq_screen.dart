import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/features/airtel_iq/mock_data/airtel_iq_mock_data.dart';
import 'package:frontend/features/airtel_iq/models/airtel_iq_models.dart';
import 'package:frontend/features/airtel_iq/widgets/airtel_iq_search_bar.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late List<FaqItem> _faqs;

  @override
  void initState() {
    super.initState();
    _faqs = AirtelIqMockData.faqs;
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _faqs = AirtelIqMockData.faqs;
      } else {
        _faqs = AirtelIqMockData.faqs.where((faq) {
          return faq.question.toLowerCase().contains(query.toLowerCase()) ||
                 faq.category.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('FAQ Library'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AirtelIqSearchBar(
              hintText: 'Search FAQs...',
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: _faqs.isEmpty
                ? const Center(
                    child: Text(
                      'No FAQs match your search.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: _faqs.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final faq = _faqs[index];
                      return Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            faq.question,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              faq.category,
                              style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ),
                          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            const SizedBox(height: 8),
                            Text(
                              faq.answer,
                              style: TextStyle(color: Colors.grey.shade700, height: 1.4, fontSize: 15),
                            ),
                          ],
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
