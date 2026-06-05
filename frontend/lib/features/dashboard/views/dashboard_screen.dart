import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';
import 'package:frontend/features/meetings/providers/meeting_provider.dart';
import 'package:frontend/features/tasks/providers/task_provider.dart';
import 'package:gap/gap.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final customersAsync = ref.watch(customerListProvider);
    final tasksAsync = ref.watch(taskListProvider);
    final meetingsAsync = ref.watch(meetingListProvider);

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Section
            Text(
              'Welcome, ${user?.fullName ?? user?.email ?? "User"}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Gap(24),

            // Airtel Overview Section
            _buildSectionCard(
              title: 'Airtel Enterprise Services',
              icon: Icons.business,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Empowering businesses with seamless connectivity, IoT solutions, and secure cloud networks. Your partner in digital transformation.',
                    style: TextStyle(color: AppConstants.textColor, height: 1.5),
                  ),
                ],
              ),
            ),
            const Gap(16),

            // Metrics Section
            const Text(
              'Your Metrics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Gap(12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                // Total Customers — live from customerListProvider
                _buildMetricCard(
                  'Total Customers',
                  customersAsync.when(
                    data: (list) => '${list.length}',
                    loading: () => '…',
                    error: (_, __) => '–',
                  ),
                  Icons.people,
                  Colors.blue,
                  onTap: () => context.push('/customers'),
                ),

                // Pending Tasks — live from taskListProvider (filter applied separately)
                _buildMetricCard(
                  'Pending Tasks',
                  tasksAsync.when(
                    data: (list) => '${list.where((t) => t.status.name == 'pending').length}',
                    loading: () => '…',
                    error: (_, __) => '–',
                  ),
                  Icons.task,
                  Colors.orange,
                  onTap: () => context.push('/tasks'),
                ),

                // Upcoming Meetings — live from meetingListProvider
                _buildMetricCard(
                  'Upcoming Meetings',
                  meetingsAsync.when(
                    data: (list) => '${list.where((m) => m.meetingAt.isAfter(DateTime.now())).length}',
                    loading: () => '…',
                    error: (_, __) => '–',
                  ),
                  Icons.event,
                  Colors.green,
                  onTap: () => context.push('/meetings'),
                ),

                // Completed Tasks — live from taskListProvider
                _buildMetricCard(
                  'Completed Tasks',
                  tasksAsync.when(
                    data: (list) => '${list.where((t) => t.status.name == 'completed').length}',
                    loading: () => '…',
                    error: (_, __) => '–',
                  ),
                  Icons.check_circle_outline,
                  Colors.green,
                  onTap: () => context.push('/tasks'),
                ),
              ],
            ),
            const Gap(24),

            // Quick Actions Section
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Gap(12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildActionButton('Add Customer', Icons.person_add,
                    () => context.push('/customers/create')),
                _buildActionButton('Create Task', Icons.add_task,
                    () => context.push('/tasks/create')),
                _buildActionButton('Schedule Meeting', Icons.calendar_today,
                    () => context.push('/meetings/create')),
                _buildActionButton('View Customers', Icons.people_outline,
                    () => context.push('/customers')),
                _buildActionButton('View Tasks', Icons.checklist,
                    () => context.push('/tasks')),
                _buildActionButton('View Meetings', Icons.event_note,
                    () => context.push('/meetings')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppConstants.primaryColor),
                const Gap(8),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Gap(12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const Gap(8),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Gap(4),
              Text(title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppConstants.primaryColor),
            const Gap(8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
