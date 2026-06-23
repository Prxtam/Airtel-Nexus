import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/core/utils/date_formatter.dart';
import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';
import 'package:frontend/features/meetings/providers/meeting_provider.dart';
import 'package:gap/gap.dart';

class MeetingCreateScreen extends ConsumerStatefulWidget {
  const MeetingCreateScreen({super.key});

  @override
  ConsumerState<MeetingCreateScreen> createState() =>
      _MeetingCreateScreenState();
}

class _MeetingCreateScreenState extends ConsumerState<MeetingCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  Customer? _selectedCustomer;
  DateTime? _selectedMeetingAt;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
              primary: AppConstants.primaryColor),
        ),
        child: child!,
      ),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
              primary: AppConstants.primaryColor),
        ),
        child: child!,
      ),
    );
    if (!mounted) return;

    setState(() {
      _selectedMeetingAt = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? 10,
        time?.minute ?? 0,
      );
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCustomer == null) {
      setState(() => _errorMessage = 'Please select a customer.');
      return;
    }
    if (_selectedMeetingAt == null) {
      setState(() => _errorMessage = 'Please select a date and time.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(meetingListProvider.notifier).createMeeting(
            customerId: _selectedCustomer!.id,
            title: _titleController.text.trim().isEmpty
                ? null
                : _titleController.text.trim(),
            meetingAt: _selectedMeetingAt!,
          );
      if (mounted) context.pushReplacement('/meetings');
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
      appBar: AppBar(
        title: const Text('Schedule Meeting'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: customersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const Gap(12),
                Text(e.toString(), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        data: (customers) => customers.isEmpty
            ? _buildNoCustomersState(context)
            : _buildForm(context, customers),
      ),
    );
  }

  Widget _buildNoCustomersState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_outline,
                size: 64, color: Colors.grey.shade400),
            const Gap(16),
            const Text(
              'No customers yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Gap(8),
            Text(
              'You need at least one customer before scheduling a meeting.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, height: 1.5),
            ),
            const Gap(24),
            ElevatedButton.icon(
              onPressed: () => context.push('/customers/create'),
              icon: const Icon(Icons.person_add),
              label: const Text('Add a Customer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, List<Customer> customers) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Meeting Information',
              style: AppTypography.sectionTitle,
            ),
            const Gap(AppSpacing.lg),

            // Customer Dropdown
            const Text('Customer *',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const Gap(8),
            DropdownButtonFormField<Customer>(
              initialValue: _selectedCustomer,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
                hintText: 'Select a customer',
              ),
              items: customers
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.name,
                            overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: (c) => setState(() => _selectedCustomer = c),
              validator: (v) =>
                  v == null ? 'Please select a customer' : null,
            ),
            const Gap(16),

            // Title (optional)
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Meeting Title (optional)',
                hintText: 'e.g. Q3 Review with Acme',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) {
                if (v != null && v.trim().length > 250) {
                  return 'Title must not exceed 250 characters';
                }
                return null;
              },
            ),
            const Gap(16),

            // Date & Time
            const Text('Date & Time *',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const Gap(8),
            OutlinedButton.icon(
              onPressed: _pickDateTime,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _selectedMeetingAt == null
                    ? 'Select date & time'
                    : _formatDateTime(_selectedMeetingAt!),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 16),
                alignment: Alignment.centerLeft,
              ),
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
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 20),
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
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Schedule Meeting',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return AppDateFormatter.format(dt);
  }
}
