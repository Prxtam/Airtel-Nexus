import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/features/airtel_iq/services/knowledge_search_service.dart';
import 'package:frontend/features/airtel_iq/widgets/airtel_iq_search_bar.dart';

class AskAirtelIqScreen extends StatefulWidget {
  const AskAirtelIqScreen({super.key});

  @override
  State<AskAirtelIqScreen> createState() => _AskAirtelIqScreenState();
}

class _AskAirtelIqScreenState extends State<AskAirtelIqScreen> {
  String _searchQuery = '';
  KnowledgeSearchResult? _result;
  final KnowledgeSearchService _searchService = KnowledgeSearchService();

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (query.length > 2) {
        _result = _searchService.search(query);
      } else {
        _result = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Ask Airtel IQ'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            color: AppConstants.primaryColor,
            child: AirtelIqSearchBar(
              hintText: 'Search products, FAQs, playbooks, objections...',
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_searchQuery.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.manage_search, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'What are you looking for?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Search across all Airtel enterprise knowledge.',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    if (_searchQuery.length <= 2) {
      return const Center(child: Text('Keep typing to search...', style: TextStyle(color: Colors.grey)));
    }

    if (_result != null && _result!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text('No relevant Airtel IQ knowledge found.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    return SelectionArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          if (_result!.products.isNotEmpty) ...[
            const Text('Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._result!.products.map((p) => _buildResultCard(
                  title: p.name,
                  subtitle: p.shortDescription,
                  icon: Icons.shopping_bag_outlined,
                  iconColor: Colors.purple,
                  onTap: () => context.push('/airtel-iq/products/${p.id}'),
                )),
            const SizedBox(height: 16),
          ],
          if (_result!.articles.isNotEmpty) ...[
            const Text('Knowledge Articles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._result!.articles.map((a) => _buildResultCard(
                  title: a.title,
                  subtitle: a.summary,
                  icon: Icons.menu_book,
                  iconColor: Colors.blue,
                  onTap: () => context.push('/airtel-iq/knowledge/${a.id}'),
                )),
            const SizedBox(height: 16),
          ],
          if (_result!.playbooks.isNotEmpty) ...[
            const Text('Sales Playbooks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._result!.playbooks.map((pb) => _buildResultCard(
                  title: pb.industry,
                  subtitle: pb.overview,
                  icon: Icons.assignment_outlined,
                  iconColor: Colors.green,
                  onTap: () => context.push('/airtel-iq/playbooks/${pb.id}'),
                )),
            const SizedBox(height: 16),
          ],
          if (_result!.faqs.isNotEmpty) ...[
            const Text('FAQs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._result!.faqs.map((f) => _buildResultCard(
                  title: f.question,
                  subtitle: f.answer,
                  icon: Icons.question_answer_outlined,
                  iconColor: Colors.orange,
                  onTap: () => context.push('/airtel-iq/faq'),
                )),
            const SizedBox(height: 16),
          ],
          if (_result!.objections.isNotEmpty) ...[
            const Text('Objections', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._result!.objections.map((o) => _buildResultCard(
                  title: o.objection,
                  subtitle: o.recommendedResponse,
                  icon: Icons.shield_outlined,
                  iconColor: AppConstants.primaryColor,
                  onTap: () => context.push('/airtel-iq/objections'),
                )),
            const SizedBox(height: 32),
          ],
        ],
      ),
    );
  }

  Widget _buildResultCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      ),
    );
  }
}
