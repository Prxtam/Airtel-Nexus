import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/widgets/app_error_widget.dart';
import 'package:frontend/core/widgets/airtel_header.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/core/utils/date_formatter.dart';
import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';
import 'package:frontend/features/meetings/providers/meeting_provider.dart';
import 'package:frontend/features/tasks/models/task.dart';
import 'package:frontend/features/tasks/providers/task_provider.dart';
import 'package:gap/gap.dart';

class CustomerDetailScreen extends ConsumerWidget {
  final String customerId;

  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerAsync = ref.watch(customerDetailProvider(customerId));

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AirtelHeader(
        title: customerAsync.maybeWhen(data: (c) => c.name, orElse: () => 'Customer'),
        automaticallyImplyLeading: true,
        variant: HeaderVariant.medium,
      ),
      body: customerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () =>
              ref.read(customerDetailProvider(customerId).notifier).load(),
        ),
        data: (customer) => _CustomerDetailBody(
          customer: customer,
          customerId: customerId,
        ),
      ),
    );
  }
}

class _CustomerDetailBody extends ConsumerStatefulWidget {
  final Customer customer;
  final String customerId;

  const _CustomerDetailBody({
    required this.customer,
    required this.customerId,
  });

  @override
  ConsumerState<_CustomerDetailBody> createState() =>
      _CustomerDetailBodyState();
}

class _CustomerDetailBodyState extends ConsumerState<_CustomerDetailBody> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _industryController;
  bool _isSaving = false;
  bool _isDeleting = false;
  String? _editError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer.name);
    _industryController = TextEditingController(text: widget.customer.industry ?? '');
  }

  @override
  void didUpdateWidget(_CustomerDetailBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing) {
      _nameController.text = widget.customer.name;
      _industryController.text = widget.customer.industry ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _industryController.dispose();
    super.dispose();
  }

  Future<void> _saveEdit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _editError = 'Name cannot be empty');
      return;
    }

    setState(() {
      _isSaving = true;
      _editError = null;
    });

    try {
      await ref
          .read(customerDetailProvider(widget.customerId).notifier)
          .update(
            name,
            industry: _industryController.text.trim().isEmpty ? null : _industryController.text.trim(),
          );
      // Also refresh the list so it stays in sync
      ref.invalidate(customerListProvider);
      if (mounted) {
        setState(() => _isEditing = false);
      }
    } catch (e) {
      setState(() {
        _editError = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer'),
        content: Text(
          'Are you sure you want to delete "${widget.customer.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isDeleting = true);

    try {
      await ref
          .read(customerListProvider.notifier)
          .deleteCustomer(widget.customerId);
      if (mounted) context.pop();
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
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Fetch data
    final meetingsAsync = ref.watch(meetingListProvider);
    final tasksAsync = ref.watch(taskListProvider);

    // 2. Filter data
    final customerMeetings = meetingsAsync.maybeWhen(
      data: (list) => list.where((m) => m.customerId == widget.customerId).toList(),
      orElse: () => [],
    );

    final customerTasks = tasksAsync.maybeWhen(
      data: (list) => list.where((t) => t.customerId == widget.customerId).toList(),
      orElse: () => [],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Identity Card
          Card(
            elevation: AppElevation.flat,
            color: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                side: BorderSide(color: Colors.grey.shade200)),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor:
                                AppConstants.primaryColor.withValues(alpha: 0.1),
                            child: Text(
                              widget.customer.name.isNotEmpty
                                  ? widget.customer.name[0].toUpperCase()
                                  : '?',
                                style: AppTypography.pageTitle.copyWith(
                                  color: AppConstants.primaryColor,
                                  fontSize: 24,
                                ),
                            ),
                          ),
                          const Gap(AppSpacing.lg),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.customer.name,
                                style: AppTypography.pageTitle.copyWith(fontSize: 20),
                              ),
                              const Gap(4),
                              Text(
                                widget.customer.industry?.isNotEmpty == true ? widget.customer.industry! : 'Industry not specified',
                                style: AppTypography.caption.copyWith(color: Colors.grey.shade600),
                              ),
                              const Gap(2),
                              Text(
                                'Created on ${AppDateFormatter.format(widget.customer.createdAt)}',
                                style: AppTypography.caption.copyWith(color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (!_isEditing)
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          color: AppConstants.primaryColor,
                          tooltip: 'Edit Name',
                          onPressed: () => setState(() => _isEditing = true),
                        ),
                    ],
                  ),
                  if (_isEditing) ...[
                    const Gap(AppSpacing.xl),
                    const Divider(),
                    const Gap(AppSpacing.md),
                    Text('Edit Customer Name', style: AppTypography.sectionTitle),
                    const Gap(AppSpacing.md),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        errorText: _editError,
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const Gap(AppSpacing.sm),
                    TextField(
                      controller: _industryController,
                      decoration: InputDecoration(
                        labelText: 'Industry (Optional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const Gap(AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _isSaving
                              ? null
                              : () {
                                  _nameController.text = widget.customer.name;
                                  _industryController.text = widget.customer.industry ?? '';
                                  setState(() {
                                    _isEditing = false;
                                    _editError = null;
                                  });
                                },
                          child: const Text('Cancel'),
                        ),
                        const Gap(AppSpacing.sm),
                        ElevatedButton(
                          onPressed: _isSaving ? null : _saveEdit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          const Gap(AppSpacing.xl),

          // Overview Section
          Text('Overview', style: AppTypography.sectionTitle),
          const Gap(AppSpacing.sm),
          Card(
            elevation: AppElevation.flat,
            color: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn('Meetings', customerMeetings.length.toString()),
                  _buildStatColumn('Tasks', customerTasks.length.toString()),
                ],
              ),
            ),
          ),

          const Gap(AppSpacing.xl),

          // Meetings Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Meetings', style: AppTypography.sectionTitle),
              if (customerMeetings.isNotEmpty)
                TextButton.icon(
                  onPressed: () => context.push('/meetings/create'),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Meeting'),
                ),
            ],
          ),
          const Gap(AppSpacing.sm),
          if (customerMeetings.isEmpty)
            _buildEmptyState(Icons.event_outlined, 'No meetings yet.', () => context.push('/meetings/create'))
          else
            Card(
              elevation: AppElevation.flat,
              color: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Column(
                children: customerMeetings.map((meeting) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.1),
                    child: const Icon(Icons.event, color: AppConstants.primaryColor, size: 20),
                  ),
                  title: Text(meeting.title ?? 'Meeting', style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(AppDateFormatter.format(meeting.meetingAt)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/meetings/${meeting.id}'),
                )).toList(),
              ),
            ),

          const Gap(AppSpacing.xl),

          // Tasks Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tasks', style: AppTypography.sectionTitle),
              if (customerTasks.isNotEmpty)
                TextButton.icon(
                  onPressed: () => context.push('/tasks/create'),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Task'),
                ),
            ],
          ),
          const Gap(AppSpacing.sm),
          if (customerTasks.isEmpty)
            _buildEmptyState(Icons.check_circle_outline, 'No pending tasks.', () => context.push('/tasks/create'))
          else
            Card(
              elevation: AppElevation.flat,
              color: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Column(
                children: customerTasks.map((task) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: task.status == TaskStatus.completed ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                    child: Icon(
                      task.status == TaskStatus.completed ? Icons.check : Icons.circle_outlined,
                      color: task.status == TaskStatus.completed ? Colors.green : Colors.orange,
                      size: 20,
                    ),
                  ),
                  title: Text(task.title, style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decoration: task.status == TaskStatus.completed ? TextDecoration.lineThrough : null,
                  )),
                  subtitle: Text(task.dueAt != null ? 'Due ${AppDateFormatter.format(task.dueAt!)}' : 'No due date'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/tasks/${task.id}'),
                )).toList(),
              ),
            ),

          const Gap(AppSpacing.xl),

          // Delete Button (Small and Less Aggressive)
          Center(
            child: OutlinedButton.icon(
              onPressed: _isDeleting ? null : _confirmDelete,
              icon: _isDeleting
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                          color: Colors.red, strokeWidth: 2),
                    )
                  : const Icon(Icons.delete_outline, color: Colors.red, size: 18),
              label: Text(
                _isDeleting ? 'Deleting...' : 'Delete Customer',
                style: const TextStyle(color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
            ),
          ),
          const Gap(AppSpacing.xl),
        ],
      ),
    );
  }



  Widget _buildEmptyState(IconData icon, String message, VoidCallback? onAction) {
    return Card(
      elevation: AppElevation.flat,
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey),
        title: Text(message, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        trailing: onAction != null
            ? TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Create New'),
              )
            : null,
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTypography.pageTitle.copyWith(color: AppConstants.primaryColor)),
        Text(label, style: AppTypography.caption.copyWith(color: Colors.grey.shade600)),
      ],
    );
  }
}
