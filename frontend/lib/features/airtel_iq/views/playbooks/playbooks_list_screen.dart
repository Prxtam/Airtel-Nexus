import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/airtel_iq/mock_data/airtel_iq_mock_data.dart';
import 'package:frontend/features/airtel_iq/models/airtel_iq_models.dart';
import 'package:frontend/features/airtel_iq/widgets/airtel_iq_search_bar.dart';

class PlaybooksListScreen extends StatefulWidget {
  const PlaybooksListScreen({super.key});

  @override
  State<PlaybooksListScreen> createState() => _PlaybooksListScreenState();
}

class _PlaybooksListScreenState extends State<PlaybooksListScreen> {
  late List<SalesPlaybook> _playbooks;

  @override
  void initState() {
    super.initState();
    _playbooks = AirtelIqMockData.playbooks;
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _playbooks = AirtelIqMockData.playbooks;
      } else {
        _playbooks = AirtelIqMockData.playbooks.where((pb) {
          return pb.industry.toLowerCase().contains(query.toLowerCase()) ||
                 pb.overview.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Sales Playbooks'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AirtelIqSearchBar(
              hintText: 'Search industries or strategies...',
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: _playbooks.isEmpty
                ? const Center(
                    child: Text(
                      'No playbooks match your search.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: _playbooks.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final pb = _playbooks[index];
                      return Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: InkWell(
                          onTap: () => context.push('/airtel-iq/playbooks/${pb.id}'),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.assignment_outlined, color: Colors.green.shade700, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        pb.industry,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  pb.overview,
                                  style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Open Playbook',
                                      style: TextStyle(color: AppConstants.primaryColor, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(Icons.arrow_forward, size: 16, color: AppConstants.primaryColor),
                                  ],
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
