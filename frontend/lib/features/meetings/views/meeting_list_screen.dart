import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/core/widgets/app_empty_widget.dart';
import 'package:frontend/core/widgets/app_error_widget.dart';
import 'package:frontend/core/utils/date_formatter.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:frontend/features/meetings/providers/meeting_provider.dart';
import 'package:frontend/features/meetings/providers/meeting_filter_provider.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';
import 'package:gap/gap.dart';

class MeetingListScreen extends ConsumerWidget {
  final bool hideAppBar;
  const MeetingListScreen({super.key, this.hideAppBar = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meetingsAsync = ref.watch(filteredMeetingListProvider);

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: hideAppBar ? null : AppBar(
        title: const Text('Meetings'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: const [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/meetings/create'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Filters
          const _MeetingFilters(),

          // List
          Expanded(
            child: meetingsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => AppErrorWidget(
                message: e.toString(),
                onRetry: () => ref.read(meetingListProvider.notifier).refresh(),
              ),
              data: (meetings) => _buildList(context, ref, meetings),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
      BuildContext context, WidgetRef ref, List<Meeting> meetings) {
    if (meetings.isEmpty) {
      final rawAsync = ref.read(meetingListProvider);
      final hasNoMeetingsAtAll = rawAsync.maybeWhen(
        data: (list) => list.isEmpty,
        orElse: () => false,
      );

      if (hasNoMeetingsAtAll) {
         return AppEmptyWidget(
          icon: Icons.event_outlined,
          message: 'No meetings yet.\nTap + to schedule your first meeting.',
          actionLabel: 'Schedule Meeting',
          onAction: () => context.push('/meetings/create'),
        );
      } else {
        return const Center(
          child: Text(
            'No meetings match your search or filters.',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }
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

class _MeetingFilters extends ConsumerWidget {
  const _MeetingFilters();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTimeFilter = ref.watch(meetingTimeFilterProvider);
    final currentCustomerId = ref.watch(meetingCustomerFilterProvider);
    final customersAsync = ref.watch(customerListProvider);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search
          TextField(
            onChanged: (val) => ref.read(meetingSearchProvider.notifier).state = val,
            decoration: InputDecoration(
              hintText: 'Search meetings...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            ),
          ),
          const Gap(12),
          
          Row(
            children: [
              // Time Filter
              Expanded(
                child: SegmentedButton<MeetingTimeFilter>(
                  segments: const [
                    ButtonSegment(value: MeetingTimeFilter.all, label: Text('All')),
                    ButtonSegment(value: MeetingTimeFilter.upcoming, label: Text('Upcoming')),
                    ButtonSegment(value: MeetingTimeFilter.past, label: Text('Past')),
                  ],
                  selected: {currentTimeFilter},
                  onSelectionChanged: (set) {
                    ref.read(meetingTimeFilterProvider.notifier).state = set.first;
                  },
                  style: SegmentedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),

          // Customer Filter
          customersAsync.maybeWhen(
            data: (customers) {
              if (customers.isEmpty) return const SizedBox.shrink();
              return DropdownButtonFormField<String?>(
                initialValue: currentCustomerId,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  prefixIcon: const Icon(Icons.business, size: 20),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  isDense: true,
                ),
                hint: const Text('Filter by Customer'),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('All Customers'),
                  ),
                  ...customers.map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.name, overflow: TextOverflow.ellipsis),
                      )),
                ],
                onChanged: (val) {
                  ref.read(meetingCustomerFilterProvider.notifier).state = val;
                },
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _MeetingTile extends StatelessWidget {
  final Meeting meeting;
  const _MeetingTile({required this.meeting});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    switch (meeting.status) {
      case MeetingStatus.scheduled:
        statusColor = Colors.blue;
        statusIcon = Icons.event;
        break;
      case MeetingStatus.awaitingConfirmation:
        statusColor = Colors.orange.shade800;
        statusIcon = Icons.help_outline;
        break;
      case MeetingStatus.conducted:
        statusColor = Colors.green;
        statusIcon = Icons.event_available;
        break;
    }

    return Card(
      elevation: AppElevation.flat,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            statusIcon,
            color: statusColor,
          ),
        ),
        title: Text(
          meeting.title ?? 'Untitled Meeting',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatDateTime(meeting.meetingAt),
                style: TextStyle(
                    fontSize: 12,
                    color: statusColor),
              ),
            ],
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
