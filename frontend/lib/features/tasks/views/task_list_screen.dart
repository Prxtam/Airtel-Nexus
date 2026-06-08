import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/widgets/app_empty_widget.dart';
import 'package:frontend/core/widgets/app_error_widget.dart';
import 'package:frontend/features/tasks/models/task.dart';
import 'package:frontend/features/tasks/providers/task_provider.dart';
import 'package:frontend/features/tasks/providers/task_filter_provider.dart';
import 'package:frontend/features/users/views/team_filter_dropdown.dart';
import 'package:frontend/features/users/views/owner_badge.dart';
import 'package:gap/gap.dart';

class TaskListScreen extends ConsumerWidget {
  final bool hideAppBar;
  const TaskListScreen({super.key, this.hideAppBar = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(filteredTaskListProvider);
    final notifier = ref.read(taskListProvider.notifier);

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: hideAppBar ? null : AppBar(
        title: const Text('Tasks'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          TeamFilterDropdown(
            currentValue: ref.watch(taskTeamFilterProvider),
            onChanged: (val) => ref.read(taskTeamFilterProvider.notifier).state = val,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tasks/create'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Status filter (API level)
          _FilterBar(notifier: notifier),

          // Priority filter (Client level)
          const _PriorityFilterBar(),

          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: (val) => ref.read(taskSearchProvider.notifier).state = val,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
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
          ),

          // Task list
          Expanded(
            child: tasksAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => AppErrorWidget(
                message: e.toString(),
                onRetry: () => notifier.refresh(),
              ),
              data: (tasks) => _buildList(context, ref, tasks, notifier),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List<Task> tasks,
      TaskListNotifier notifier) {
    if (tasks.isEmpty) {
      final rawTasksAsync = ref.read(taskListProvider);
      final hasNoTasksAtAll = rawTasksAsync.maybeWhen(
        data: (list) => list.isEmpty,
        orElse: () => false,
      );

      if (hasNoTasksAtAll) {
        final filter = notifier.currentFilter;
        final msg = filter == TaskStatusFilter.all
            ? 'No tasks yet.\nTap + to create your first task.'
            : 'No ${filter.label.toLowerCase()} tasks.';
        return AppEmptyWidget(
          icon: Icons.task_outlined,
          message: msg,
          actionLabel: filter == TaskStatusFilter.all ? 'Create Task' : null,
          onAction: filter == TaskStatusFilter.all
              ? () => context.push('/tasks/create')
              : null,
        );
      } else {
         return const Center(
          child: Text(
            'No tasks match your search or filters.',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }
    }

    return RefreshIndicator(
      color: AppConstants.primaryColor,
      onRefresh: () => notifier.refresh(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        itemCount: tasks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return _TaskTile(task: tasks[index]);
        },
      ),
    );
  }
}

class _FilterBar extends ConsumerWidget {
  final TaskListNotifier notifier;
  const _FilterBar({required this.notifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = notifier.currentFilter;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: TaskStatusFilter.values.map((filter) {
          final isSelected = currentFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter.label),
              selected: isSelected,
              onSelected: (_) => notifier.setFilter(filter),
              selectedColor: AppConstants.primaryColor.withValues(alpha: 0.15),
              checkmarkColor: AppConstants.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? AppConstants.primaryColor : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppConstants.primaryColor : Colors.grey.shade300,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PriorityFilterBar extends ConsumerWidget {
  const _PriorityFilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPriority = ref.watch(taskPriorityFilterProvider);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
           const Text('Priority:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
           const Gap(8),
           ...TaskPriorityFilter.values.map((priority) {
            final isSelected = currentPriority == priority;
            String label = priority.name[0].toUpperCase() + priority.name.substring(1);
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text(label, style: const TextStyle(fontSize: 12)),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                     ref.read(taskPriorityFilterProvider.notifier).state = priority;
                  }
                },
                selectedColor: Colors.blue.withValues(alpha: 0.15),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? Colors.blue.shade300 : Colors.grey.shade300,
                ),
                padding: EdgeInsets.zero,
              ),
            );
          }),
        ]
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final Task task;
  const _TaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == TaskStatus.completed;

    return Card(
      elevation: 0,
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
            color: (isCompleted ? Colors.green : Colors.orange).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isCompleted ? Icons.check_circle : Icons.pending_actions,
            color: isCompleted ? Colors.green.shade700 : Colors.orange.shade700,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? Colors.grey : AppConstants.textColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OwnerBadge(ownerId: task.userId),
              const SizedBox(height: 6),
              Row(
                children: [
                  _PriorityBadge(priority: task.priority),
                  if (task.dueAt != null) ...[
                    const Gap(8),
                    Icon(Icons.schedule, size: 12, color: Colors.grey.shade500),
                    const Gap(2),
                    Text(
                      _formatDate(task.dueAt!),
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => context.push('/tasks/${task.id}'),
      ),
    );
  }

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';
}

class _PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (priority) {
      TaskPriority.high => ('High', AppConstants.primaryColor),
      TaskPriority.medium => ('Medium', Colors.orange),
      TaskPriority.low => ('Low', Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
