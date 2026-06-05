import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/widgets/app_empty_widget.dart';
import 'package:frontend/core/widgets/app_error_widget.dart';
import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';
import 'package:frontend/features/customers/providers/customer_filter_provider.dart';

class CustomerListScreen extends ConsumerWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(filteredCustomerListProvider);
    final rawCustomersAsync = ref.watch(customerListProvider);
    final currentSort = ref.watch(customerSortProvider);

    final hasNoCustomersAtAll = rawCustomersAsync.maybeWhen(
      data: (list) => list.isEmpty,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Customers'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (!hasNoCustomersAtAll)
            PopupMenuButton<CustomerSort>(
              icon: const Icon(Icons.sort),
              initialValue: currentSort,
              onSelected: (sort) => ref.read(customerSortProvider.notifier).state = sort,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: CustomerSort.nameAsc,
                  child: Text('Name (A-Z)'),
                ),
                const PopupMenuItem(
                  value: CustomerSort.nameDesc,
                  child: Text('Name (Z-A)'),
                ),
                const PopupMenuItem(
                  value: CustomerSort.newestFirst,
                  child: Text('Newest First'),
                ),
                const PopupMenuItem(
                  value: CustomerSort.oldestFirst,
                  child: Text('Oldest First'),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/customers/create'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: customersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.read(customerListProvider.notifier).refresh(),
        ),
        data: (customers) {
          if (hasNoCustomersAtAll) {
             return AppEmptyWidget(
              icon: Icons.people_outline,
              message: 'No customers yet.\nTap + to add your first customer.',
              actionLabel: 'Add Customer',
              onAction: () => context.push('/customers/create'),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  onChanged: (val) => ref.read(customerSearchProvider.notifier).state = val,
                  decoration: InputDecoration(
                    hintText: 'Search customers...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  ),
                ),
              ),
              Expanded(
                child: _buildList(context, ref, customers),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildList(
      BuildContext context, WidgetRef ref, List<Customer> customers) {
    if (customers.isEmpty) {
      return const Center(
        child: Text(
          'No customers found matching your search.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      color: AppConstants.primaryColor,
      onRefresh: () => ref.read(customerListProvider.notifier).refresh(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        itemCount: customers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final customer = customers[index];
          return _CustomerTile(customer: customer);
        },
      ),
    );
  }
}

class _CustomerTile extends StatelessWidget {
  final Customer customer;
  const _CustomerTile({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.1),
          child: Text(
            customer.name.isNotEmpty
                ? customer.name[0].toUpperCase()
                : '?',
            style: const TextStyle(
              color: AppConstants.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          customer.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Added ${_formatDate(customer.createdAt)}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => context.push('/customers/${customer.id}'),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
