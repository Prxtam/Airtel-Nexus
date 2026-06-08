import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/airtel_iq/mock_data/airtel_iq_mock_data.dart';
import 'package:frontend/features/airtel_iq/models/airtel_iq_models.dart';
import 'package:frontend/features/airtel_iq/widgets/airtel_iq_search_bar.dart';

class ObjectionHandlingScreen extends StatefulWidget {
  const ObjectionHandlingScreen({super.key});

  @override
  State<ObjectionHandlingScreen> createState() => _ObjectionHandlingScreenState();
}

class _ObjectionHandlingScreenState extends State<ObjectionHandlingScreen> {
  late List<Objection> _objections;

  @override
  void initState() {
    super.initState();
    _objections = AirtelIqMockData.objections;
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _objections = AirtelIqMockData.objections;
      } else {
        _objections = AirtelIqMockData.objections.where((objection) {
          return objection.objection.toLowerCase().contains(query.toLowerCase()) ||
                 objection.category.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Objection Handling'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AirtelIqSearchBar(
              hintText: 'Search objections (e.g. pricing, competition)...',
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: _objections.isEmpty
                ? const Center(
                    child: Text(
                      'No objections match your search.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: _objections.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _ObjectionCard(objection: _objections[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ObjectionCard extends StatelessWidget {
  final Objection objection;

  const _ObjectionCard({required this.objection});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: Text(
          objection.objection,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            objection.category,
            style: TextStyle(color: AppConstants.primaryColor, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 8),
          const Text(
            'Recommended Response',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            objection.recommendedResponse,
            style: TextStyle(color: Colors.grey.shade700, height: 1.4),
          ),
          const SizedBox(height: 16),
          const Text(
            'Suggested Follow-Up Question',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    objection.suggestedFollowUp,
                    style: TextStyle(color: Colors.blue.shade900, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
