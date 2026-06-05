import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/widgets/app_empty_widget.dart';
import 'package:frontend/core/widgets/app_error_widget.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:frontend/features/meetings/providers/meeting_provider.dart';
import 'package:gap/gap.dart';

class MeetingListScreen extends ConsumerWidget {
  const MeetingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meetingsAsync = ref.watch(meetingListProvider);

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Meetings'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/meetings/create'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: meetingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.read(meetingListProvider.notifier).refresh(),
        ),
        data: (meetings) => _buildList(context, ref, meetings),
      ),
    );
  }

  Widget _buildList(
      BuildContext context, WidgetRef ref, List<Meeting> meetings) {
    if (meetings.isEmpty) {
      return AppEmptyWidget(
        icon: Icons.event_outlined,
        message: 'No meetings yet.\nTap + to schedule your first meeting.',
        actionLabel: 'Schedule Meeting',
        onAction: () => context.push('/meetings/create'),
      );
    }

    return RefreshIndicator(
      color: AppConstants.primaryColor,
      onRefresh: () => ref.read(meetingListProvider.notifier).refresh(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        itemCount: meetings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) =>
            _MeetingTile(meeting: meetings[index]),
      ),
    );
  }
}

class _MeetingTile extends StatelessWidget {
  final Meeting meeting;
  const _MeetingTile({required this.meeting});

  @override
  Widget build(BuildContext context) {
    final isUpcoming = meeting.meetingAt.isAfter(DateTime.now());
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: (isUpcoming ? Colors.green : Colors.grey)
              .withValues(alpha: 0.12),
          child: Icon(
            isUpcoming ? Icons.event : Icons.event_available,
            color: isUpcoming ? Colors.green : Colors.grey,
          ),
        ),
        title: Text(
          meeting.title ?? 'Untitled Meeting',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(2),
            Text(
              _formatDateTime(meeting.meetingAt),
              style: TextStyle(
                  fontSize: 12,
                  color: isUpcoming ? Colors.green.shade700 : Colors.grey),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => context.push('/meetings/${meeting.id}'),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final local = dt.toLocal();
    return '${local.day}/${local.month}/${local.year}  ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}
