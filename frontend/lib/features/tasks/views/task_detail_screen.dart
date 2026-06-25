import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/widgets/app_error_widget.dart';
import 'package:frontend/core/widgets/airtel_header.dart';
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
      appBar: AirtelHeader(
        title: taskAsync.maybeWhen(data: (t) => t.title, orElse: () => 'Task'),
        automaticallyImplyLeading: true,
        variant: HeaderVariant.medium,
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textColor,
                    ),
                  ),
                  const Gap(6),
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

                  // Description
                  if (task.description != null && task.description!.isNotEmpty) ...[
                    const Gap(16),
                    const Divider(height: 1),
                    const Gap(12),
                    Text(task.description!,
                        style: const TextStyle(height: 1.4, color: Colors.black87, fontSize: 14)),
                  ],
                ],
              ),
            ),
          ),

          const Gap(12),

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
                  if (task.dueAt != null) ...[
                    const Text('DUE DATE', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    const Gap(4),
                    Text(
                      _formatDate(task.dueAt!),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _isDueSoon(task.dueAt!) && !isCompleted ? Colors.orange : Colors.black87,
                      ),
                    ),
                    const Gap(16),
                    const Divider(height: 1),
                    const Gap(16),
                  ],
                  _InfoRow(label: 'Created', value: _formatDate(task.createdAt)),
                  if (task.completedAt != null && isCompleted) ...[
                    const Gap(8),
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
          Align(
            alignment: Alignment.center,
            child: OutlinedButton.icon(
              onPressed: _isToggling ? null : () => _toggleStatus(isCompleted),
              icon: _isToggling
                  ? const SizedBox(
                      height: 14,
                      width: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(isCompleted ? Icons.undo : Icons.check, size: 16),
              label: Text(_isToggling ? 'Updating...' : (isCompleted ? 'Mark as Incomplete' : 'Mark as Complete')),
              style: OutlinedButton.styleFrom(
                foregroundColor: isCompleted ? Colors.grey.shade700 : AppConstants.primaryColor,
                side: BorderSide(color: isCompleted ? Colors.grey.shade300 : AppConstants.primaryColor.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
