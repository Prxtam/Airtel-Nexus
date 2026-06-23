import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/widgets/app_error_widget.dart';
import 'package:frontend/core/utils/date_formatter.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';
import 'package:frontend/features/meetings/providers/meeting_provider.dart';
import 'package:frontend/features/tasks/providers/task_provider.dart';
import 'package:frontend/features/auth/models/user.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/users/views/owner_badge.dart';
import 'package:frontend/features/tasks/models/task.dart';
import 'package:frontend/core/widgets/app_drawer.dart';
import 'package:frontend/core/theme/app_theme.dart';
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
      drawer: const AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Greeting Section
              _buildGreetingSection(context, user),
              const Gap(AppSpacing.xl),

              // 2. Hero Card (Personalized Workspace)
              _buildHeroCard(context, user, customersAsync, meetingsAsync, tasksAsync),
              const Gap(AppSpacing.xl),

              // 3. Primary Actions (Airtel Thanks Style Shortcuts)
              _buildPrimaryActions(context),
              const Gap(AppSpacing.xxl),

              // 4. Upcoming Meetings Section
              _buildSectionHeader('Upcoming Meetings', () => context.push('/activities')),
              const Gap(AppSpacing.md),
              _buildUpcomingMeetings(context, meetingsAsync),
              const Gap(AppSpacing.xxl),

              // 5. Recent Customers Section
              _buildSectionHeader('Recent Customers', () => context.push('/customers')),
              const Gap(AppSpacing.md),
              _buildRecentCustomers(context, customersAsync),
              const Gap(AppSpacing.xxl),

              // 6. Key Metrics Row
              const Text('Performance This Month', style: AppTypography.sectionTitle),
              const Gap(AppSpacing.md),
              _buildMonthlyAnalyticsGrid(customersAsync, meetingsAsync, tasksAsync),
              const Gap(AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection(BuildContext context, User? user) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good Morning' : (hour < 17 ? 'Good Afternoon' : 'Good Evening');
    final firstName = user?.fullName?.split(' ').first ?? user?.email.split('@').first ?? 'User';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, size: 28),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        const Gap(AppSpacing.lg),
        Text(
          '$greeting, $firstName',
          style: AppTypography.pageTitle.copyWith(letterSpacing: -0.5),
        ),
      ],
    );
  }

  Widget _buildHeroCard(
    BuildContext context,
    User? user,
    AsyncValue<List<Customer>> customersAsync,
    AsyncValue<List<Meeting>> meetingsAsync,
    AsyncValue<dynamic> tasksAsync,
  ) {
    final now = DateTime.now();

    final customerCount = customersAsync.maybeWhen(data: (list) => '${list.length}', orElse: () => '...');
    final pendingTasksCount = tasksAsync.maybeWhen(
      data: (list) => '${list.where((t) => t.status == TaskStatus.pending).length}',
      orElse: () => '...',
    );
    final meetingsTodayCount = meetingsAsync.maybeWhen(
      data: (list) {
        return '${list.where((m) => m.meetingAt.year == now.year && m.meetingAt.month == now.month && m.meetingAt.day == now.day).length}';
      },
      orElse: () => '...',
    );

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppConstants.primaryColor, Color(0xFFC00000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Overview',
              style: AppTypography.sectionTitle.copyWith(color: Colors.white),
            ),
            const Gap(AppSpacing.lg),
            Text(
              'You have:',
              style: AppTypography.bodyText.copyWith(color: Colors.white70),
            ),
            const Gap(AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _HeroStatItem(customerCount, 'Customers'),
                _HeroStatItem(meetingsTodayCount, 'Meetings\nToday'),
                _HeroStatItem(pendingTasksCount, 'Pending\nTasks'),
              ],
            ),
            const Gap(AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    'Stay on top of your enterprise relationships.',
                    style: AppTypography.bodyText.copyWith(color: Colors.white70, fontSize: 13, height: 1.4),
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/activities'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('View Activities', style: AppTypography.bodyText.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                      const Gap(AppSpacing.sm),
                      const Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildPrimaryActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _ServiceShortcutCard(icon: Icons.person_add, label: "Add\nCustomer", onTap: () => context.push('/customers/create'))),
        const Gap(AppSpacing.md),
        Expanded(child: _ServiceShortcutCard(icon: Icons.calendar_today, label: "Schedule\nMeeting", onTap: () => context.push('/meetings/create'))),
        const Gap(AppSpacing.md),
        Expanded(child: _ServiceShortcutCard(icon: Icons.add_task, label: "Create\nTask", onTap: () => context.push('/tasks/create'))),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.sectionTitle),
        TextButton(
          onPressed: onViewAll,
          style: TextButton.styleFrom(
            foregroundColor: AppConstants.primaryColor,
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text('View All', style: AppTypography.bodyText.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildUpcomingMeetings(BuildContext context, AsyncValue<List<Meeting>> meetingsAsync) {
    return meetingsAsync.when(
      data: (list) {
        final upcoming = list.where((m) => m.meetingAt.isAfter(DateTime.now())).toList()
          ..sort((a, b) => a.meetingAt.compareTo(b.meetingAt));
        
        if (upcoming.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text("No upcoming meetings", style: AppTypography.bodyText.copyWith(color: Colors.grey)),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: upcoming.length > 3 ? 3 : upcoming.length,
          separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
          itemBuilder: (context, index) => _ModernMeetingTile(meeting: upcoming[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading meetings')),
    );
  }

  Widget _buildRecentCustomers(BuildContext context, AsyncValue<List<Customer>> customersAsync) {
    return customersAsync.when(
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text("No recent customers", style: AppTypography.bodyText.copyWith(color: Colors.grey)),
            ),
          );
        }

        final sorted = List<Customer>.from(list)..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sorted.length > 3 ? 3 : sorted.length,
          separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
          itemBuilder: (context, index) => _ModernCustomerTile(customer: sorted[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading customers')),
    );
  }

  Widget _buildMonthlyAnalyticsGrid(
    AsyncValue<List<Customer>> customersAsync,
    AsyncValue<List<Meeting>> meetingsAsync,
    AsyncValue<dynamic> tasksAsync,
  ) {
    final now = DateTime.now();
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.5,
      children: [
        _buildAnalyticsCard(
          'Customers Added',
          customersAsync.maybeWhen(
            data: (list) => '${list.where((c) => c.createdAt.year == now.year && c.createdAt.month == now.month).length}', 
            orElse: () => '…'
          ),
          Icons.people_outline,
        ),
        _buildAnalyticsCard(
          'Meetings Conducted',
          meetingsAsync.maybeWhen(
            data: (list) => '${list.where((m) => m.meetingAt.year == now.year && m.meetingAt.month == now.month && m.meetingAt.isBefore(now.add(const Duration(days: 1)))).length}', 
            orElse: () => '…'
          ),
          Icons.event_note,
        ),
        _buildAnalyticsCard(
          'Pending Tasks',
          tasksAsync.maybeWhen(
            data: (list) => '${list.where((t) => t.status == TaskStatus.pending && t.createdAt.year == now.year && t.createdAt.month == now.month).length}', 
            orElse: () => '…'
          ),
          Icons.pending_actions,
        ),
        _buildAnalyticsCard(
          'Completed Tasks',
          tasksAsync.maybeWhen(
            data: (list) => '${list.where((t) => t.status == TaskStatus.completed && t.updatedAt.year == now.year && t.updatedAt.month == now.month).length}', 
            orElse: () => '…'
          ),
          Icons.task_alt,
        ),
      ],
    );
  }

  /* Preserved for future Profile page
  Widget _buildLifetimeAnalyticsGrid(
    AsyncValue<List<Customer>> customersAsync,
    AsyncValue<List<Meeting>> meetingsAsync,
    AsyncValue<dynamic> tasksAsync,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildAnalyticsCard(
          'Total Customers',
          customersAsync.maybeWhen(data: (list) => '${list.length}', orElse: () => '…'),
          Icons.people_outline,
        ),
        _buildAnalyticsCard(
          'Total Meetings',
          meetingsAsync.maybeWhen(data: (list) => '${list.length}', orElse: () => '…'),
          Icons.event_note,
        ),
        _buildAnalyticsCard(
          'Pending Tasks',
          tasksAsync.maybeWhen(data: (list) => '${list.where((t) => t.status == TaskStatus.pending).length}', orElse: () => '…'),
          Icons.pending_actions,
        ),
        _buildAnalyticsCard(
          'Completed Tasks',
          tasksAsync.maybeWhen(data: (list) => '${list.where((t) => t.status == TaskStatus.completed).length}', orElse: () => '…'),
          Icons.task_alt,
        ),
      ],
    );
  }
  */

  Widget _buildAnalyticsCard(String title, String value, IconData icon) {
    return Card(
      elevation: AppElevation.flat,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppConstants.primaryColor),
                const Spacer(),
                Text(value, style: AppTypography.pageTitle),
              ],
            ),
            const Gap(AppSpacing.sm),
            Text(title, style: AppTypography.caption.copyWith(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _HeroStatItem extends StatelessWidget {
  final String count;
  final String label;

  const _HeroStatItem(this.count, this.label);

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(count, style: AppTypography.pageTitle.copyWith(fontSize: 32, color: Colors.white)),
        Text(label, style: AppTypography.caption.copyWith(color: Colors.white70, height: 1.2)),
      ],
    );
  }
}

class _ServiceShortcutCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ServiceShortcutCard({required this.icon, required this.label, required this.onTap});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.1),
                radius: 16,
                child: Icon(icon, color: AppConstants.primaryColor, size: 18),
              ),
              const Gap(AppSpacing.md),
              Text(
                label,
                style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600, height: 1.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernMeetingTile extends StatelessWidget {
  final Meeting meeting;
  const _ModernMeetingTile({required this.meeting});

  Widget build(BuildContext context) {
    return Card(
      elevation: AppElevation.flat,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(Icons.event, color: Colors.green.shade700),
        ),
        title: Text(meeting.title ?? 'Untitled Meeting', style: AppTypography.bodyText.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            _formatDateTime(meeting.meetingAt),
            style: AppTypography.caption.copyWith(color: Colors.green.shade700, fontWeight: FontWeight.w500),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => context.push('/meetings/${meeting.id}'),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return AppDateFormatter.format(dt);
  }
}

class _ModernCustomerTile extends StatelessWidget {
  final Customer customer;
  const _ModernCustomerTile({required this.customer});

  Widget build(BuildContext context) {
    return Card(
      elevation: AppElevation.flat,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(Icons.business, color: Colors.blue.shade700),
        ),
        title: Text(customer.name, style: AppTypography.bodyText.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: customer.ownerId != null 
              ? OwnerBadge(ownerId: customer.ownerId!)
              : Text('No Owner', style: AppTypography.caption.copyWith(color: Colors.grey)),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => context.push('/customers/${customer.id}'),
      ),
    );
  }
}
