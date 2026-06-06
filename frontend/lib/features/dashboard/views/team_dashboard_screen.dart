import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';
import 'package:frontend/features/meetings/providers/meeting_provider.dart';
import 'package:frontend/features/tasks/providers/task_provider.dart';
import 'package:gap/gap.dart';

class TeamDashboardScreen extends ConsumerWidget {
  const TeamDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final customersAsync = ref.watch(customerListProvider);
    final tasksAsync = ref.watch(taskListProvider);
    final meetingsAsync = ref.watch(meetingListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Team Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Team Performance Metrics',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildMetricCard(
                  'Team Customers',
                  customersAsync.when(
                    data: (list) => '${list.where((c) => c.ownerId != user?.id).length}',
                    loading: () => '...',
                    error: (_, __) => '-',
                  ),
                  Icons.people,
                  Colors.blue,
                ),
                _buildMetricCard(
                  'Team Pending Tasks',
                  tasksAsync.when(
                    data: (list) => '${list.where((t) => t.userId != user?.id && t.status.name == 'pending').length}',
                    loading: () => '...',
                    error: (_, __) => '-',
                  ),
                  Icons.task,
                  Colors.orange,
                ),
                _buildMetricCard(
                  'Team Completed Tasks',
                  tasksAsync.when(
                    data: (list) => '${list.where((t) => t.userId != user?.id && t.status.name == 'completed').length}',
                    loading: () => '...',
                    error: (_, __) => '-',
                  ),
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildMetricCard(
                  'Team Upcoming Meetings',
                  meetingsAsync.when(
                    data: (list) => '${list.where((m) => m.createdByUserId != user?.id && m.meetingAt.isAfter(DateTime.now())).length}',
                    loading: () => '...',
                    error: (_, __) => '-',
                  ),
                  Icons.event,
                  Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const Gap(8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Gap(4),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
