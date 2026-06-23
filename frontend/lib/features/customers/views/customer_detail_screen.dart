import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/widgets/app_error_widget.dart';
import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';
import 'package:gap/gap.dart';

class CustomerDetailScreen extends ConsumerWidget {
  final String customerId;

  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerAsync = ref.watch(customerDetailProvider(customerId));

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          customerAsync.maybeWhen(data: (c) => c.name, orElse: () => 'Customer'),
        ),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
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
  bool _isSaving = false;
  bool _isDeleting = false;
  String? _editError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer.name);
  }

  @override
  void didUpdateWidget(_CustomerDetailBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing) {
      _nameController.text = widget.customer.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
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
          .update(name);
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Customer Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            AppConstants.primaryColor.withValues(alpha: 0.1),
                        child: Text(
                          widget.customer.name.isNotEmpty
                              ? widget.customer.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 24,
                            color: AppConstants.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Customer',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                            Text(
                              widget.customer.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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
                    const Gap(20),
                    const Divider(),
                    const Gap(12),
                    const Text('Edit Customer Name',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const Gap(8),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: const OutlineInputBorder(),
                        errorText: _editError,
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const Gap(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _isSaving
                              ? null
                              : () {
                                  _nameController.text = widget.customer.name;
                                  setState(() {
                                    _isEditing = false;
                                    _editError = null;
                                  });
                                },
                          child: const Text('Cancel'),
                        ),
                        const Gap(8),
                        ElevatedButton(
                          onPressed: _isSaving ? null : _saveEdit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryColor,
                            foregroundColor: Colors.white,
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

          const Gap(16),

          // Metadata Card
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Record Details',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const Gap(12),
                  _InfoRow(
                    label: 'Created',
                    value: _formatDate(widget.customer.createdAt),
                  ),
                  const Divider(height: 24),
                  _InfoRow(
                    label: 'Last Updated',
                    value: _formatDate(widget.customer.updatedAt),
                  ),
                  const Divider(height: 24),
                  _InfoRow(label: 'ID', value: widget.customer.id),
                ],
              ),
            ),
          ),

          const Gap(32),

          // Delete Button
          OutlinedButton.icon(
            onPressed: _isDeleting ? null : _confirmDelete,
            icon: _isDeleting
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                        color: Colors.red, strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outline, color: Colors.red),
            label: Text(
              _isDeleting ? 'Deleting...' : 'Delete Customer',
              style: const TextStyle(color: Colors.red),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} at ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

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
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        ),
      ],
    );
  }
}
