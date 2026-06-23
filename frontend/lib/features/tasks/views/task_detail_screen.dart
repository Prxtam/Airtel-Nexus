import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/widgets/app_error_widget.dart';
import 'package:frontend/core/utils/date_formatter.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';
import 'package:frontend/features/tasks/models/task.dart';
import 'package:frontend/features/tasks/providers/task_provider.dart';
import 'package:gap/gap.dart';

class TaskDetailScreen extends ConsumerWidget {
  final String taskId;
  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskDetailProvider(taskId));

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          taskAsync.maybeWhen(data: (t) => t.title, orElse: () => 'Task'),
        ),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: taskAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.read(taskDetailProvider(taskId).notifier).load(),
        ),
        data: (task) => _TaskDetailBody(task: task, taskId: taskId),
      ),
    );
  }
}

class _TaskDetailBody extends ConsumerStatefulWidget {
  final Task task;
  final String taskId;
  const _TaskDetailBody({required this.task, required this.taskId});

  @override
  ConsumerState<_TaskDetailBody> createState() => _TaskDetailBodyState();
}

class _TaskDetailBodyState extends ConsumerState<_TaskDetailBody> {
  bool _isToggling = false;

  Future<void> _toggleStatus(bool isCurrentlyCompleted) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(isCurrentlyCompleted ? 'Do you want to mark this task as incomplete?' : 'Do you want to mark this task as complete?', style: const TextStyle(color: Colors.black, fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isCurrentlyCompleted ? Colors.orange : Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isToggling = true);
    try {
      await ref.read(taskDetailProvider(widget.taskId).notifier).toggleStatus();
      // Invalidate the list so it refreshes when the user navigates back
      ref.invalidate(taskListProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isToggling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final isCompleted = task.status == TaskStatus.completed;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Main card
          Card(
            elevation: 2,
            color: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status + title row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isCompleted ? Colors.green : Colors.grey,
                        size: 28,
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.textColor,
                              ),
                            ),
                            const Gap(8),
                            // Metadata Row for Customer
                            Consumer(
                              builder: (context, ref, child) {
                                if (task.customerId == null) {
                                  return const Text('Internal Task', style: TextStyle(color: Colors.black87, fontSize: 13));
                                }
                                final customerAsync = ref.watch(customerDetailProvider(task.customerId!));
                                final customerName = customerAsync.valueOrNull?.name ?? 'Loading...';
                                return Text('Customer: $customerName', style: const TextStyle(color: Colors.black87, fontSize: 13));
                              },
                            ),
                            const Gap(12),
                            Row(
                              children: [
                                _PriorityChip(priority: task.priority),
                                const Gap(8),
                                _StatusChip(status: task.status),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Description
                  if (task.description != null && task.description!.isNotEmpty) ...[
                    const Gap(16),
                    const Divider(),
                    const Gap(8),
                    const Text('Description',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 12)),
                    const Gap(4),
                    Text(task.description!,
                        style: const TextStyle(height: 1.5)),
                  ],
                ],
              ),
            ),
          ),

          const Gap(16),

          // Dates card
          Card(
            elevation: 1,
            color: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Timeline',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Gap(16),
                  _InfoRow(label: 'Created', value: _formatDate(task.createdAt)),
                  if (task.dueAt != null) ...[
                    const Gap(12),
                    _InfoRow(
                      label: 'Due',
                      value: _formatDate(task.dueAt!),
                      valueColor: _isDueSoon(task.dueAt!) && !isCompleted
                          ? Colors.orange
                          : null,
                    ),
                  ],
                  if (task.completedAt != null) ...[
                    const Gap(12),
                    _InfoRow(
                      label: 'Completed',
                      value: _formatDate(task.completedAt!),
                      valueColor: Colors.green,
                    ),
                  ],
                ],
              ),
            ),
          ),

          const Gap(24),

          // Complete/Incomplete Toggle Button
          const Gap(32),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: _isToggling ? null : () => _toggleStatus(isCompleted),
              icon: _isToggling
                  ? SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(color: isCompleted ? Colors.orange : Colors.white, strokeWidth: 2),
                    )
                  : Icon(isCompleted ? Icons.undo : Icons.check_circle_outline, size: 18),
              label: Text(_isToggling ? 'Updating...' : (isCompleted ? 'Mark as Incomplete' : 'Mark as Complete')),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted ? Colors.grey.shade200 : Colors.green,
                foregroundColor: isCompleted ? Colors.black87 : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: isCompleted ? 0 : 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) => AppDateFormatter.format(dt);

  bool _isDueSoon(DateTime dueAt) =>
      dueAt.difference(DateTime.now()).inDays <= 2;
}

class _PriorityChip extends StatelessWidget {
  final TaskPriority priority;
  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (priority) {
      TaskPriority.high => ('High Priority', AppConstants.primaryColor),
      TaskPriority.medium => ('Medium Priority', Colors.orange),
      TaskPriority.low => ('Low Priority', Colors.grey),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final TaskStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final isPending = status == TaskStatus.pending;
    final color = isPending ? Colors.blue : Colors.green;
    final label = isPending ? 'Pending' : 'Completed';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label,
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ),
        Expanded(
          child: Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: valueColor)),
        ),
      ],
    );
  }
}
