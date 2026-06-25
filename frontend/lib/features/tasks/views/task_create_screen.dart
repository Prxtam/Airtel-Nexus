import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/core/utils/date_formatter.dart';
import 'package:frontend/core/widgets/airtel_header.dart';
import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';
import 'package:frontend/features/tasks/models/task.dart';
import 'package:frontend/features/tasks/providers/task_provider.dart';
import 'package:gap/gap.dart';

class TaskCreateScreen extends ConsumerStatefulWidget {
  const TaskCreateScreen({super.key});

  @override
  ConsumerState<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends ConsumerState<TaskCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskPriority _selectedPriority = TaskPriority.medium;
  DateTime? _selectedDueAt;
  Customer? _selectedCustomer;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppConstants.primaryColor),
        ),
        child: child!,
      ),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppConstants.primaryColor),
        ),
        child: child!,
      ),
    );
    if (!mounted) return;

    setState(() {
      _selectedDueAt = time == null
          ? DateTime(date.year, date.month, date.day, 23, 59)
          : DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(taskListProvider.notifier).createTask(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            priority: _selectedPriority.name,
            dueAt: _selectedDueAt,
            customerId: _selectedCustomer?.id,
          );
      if (mounted) context.pushReplacement('/tasks');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customerListProvider);

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: const AirtelHeader(
        title: 'Create Task',
        automaticallyImplyLeading: true,
        variant: HeaderVariant.compact,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Task Information',
                style: AppTypography.sectionTitle,
              ),
              const Gap(AppSpacing.lg),

              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  hintText: 'e.g. Follow up with Acme Corp',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Title is required';
                  if (v.trim().length > 200) return 'Title must not exceed 200 characters';
                  return null;
                },
              ),
              const Gap(16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'Add more details...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                validator: (v) {
                  if (v != null && v.trim().length > 2000) {
                    return 'Description must not exceed 2000 characters';
                  }
                  return null;
                },
              ),
              const Gap(16),

              // Customer Link (Optional)
              const Text('Link to Customer (optional)', style: TextStyle(fontWeight: FontWeight.w600)),
              const Gap(8),
              customersAsync.when(
                data: (customers) => DropdownButtonFormField<Customer>(
                  initialValue: _selectedCustomer,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                    hintText: 'Select a customer',
                  ),
                  items: [
                    const DropdownMenuItem<Customer>(
                      value: null,
                      child: Text('No Customer'),
                    ),
                    ...customers.map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.name, overflow: TextOverflow.ellipsis),
                        ))
                  ],
                  onChanged: (c) => setState(() => _selectedCustomer = c),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error loading customers: $e', style: const TextStyle(color: Colors.red)),
              ),
              const Gap(16),

              // Priority
              const Text('Priority', style: TextStyle(fontWeight: FontWeight.w600)),
              const Gap(8),
              _PrioritySelector(
                selected: _selectedPriority,
                onChanged: (p) => setState(() => _selectedPriority = p),
              ),
              const Gap(16),

              // Due date
              const Text('Due Date (optional)',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const Gap(8),
              OutlinedButton(
                onPressed: _pickDueDate,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  alignment: Alignment.centerLeft,
                ),
                child: Text(
                  _selectedDueAt == null
                      ? 'Select date & time'
                      : _formatDateTime(_selectedDueAt!),
                ),
              ),
              if (_selectedDueAt != null)
                TextButton(
                  onPressed: () => setState(() => _selectedDueAt = null),
                  child: const Text('Clear due date',
                      style: TextStyle(color: Colors.grey)),
                ),

              if (_errorMessage != null) ...[
                const Gap(16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const Gap(8),
                      Expanded(
                        child: Text(_errorMessage!,
                            style: const TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              ],

              const Gap(32),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppConstants.primaryColor,
                    side: BorderSide(color: AppConstants.primaryColor.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: AppConstants.primaryColor, strokeWidth: 2),
                        )
                      : const Text('Add Task',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) => AppDateFormatter.format(dt);
}

class _PrioritySelector extends StatelessWidget {
  final TaskPriority selected;
  final ValueChanged<TaskPriority> onChanged;

  const _PrioritySelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: TaskPriority.values.map((priority) {
          final isSelected = selected == priority;
          final (label, color) = switch (priority) {
            TaskPriority.high => ('High', AppConstants.primaryColor),
            TaskPriority.medium => ('Medium', Colors.orange),
            TaskPriority.low => ('Low', Colors.grey.shade700),
          };
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(priority),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? color : Colors.grey.shade500,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
