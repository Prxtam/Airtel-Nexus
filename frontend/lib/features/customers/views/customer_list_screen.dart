import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/widgets/app_empty_widget.dart';
import 'package:frontend/core/widgets/app_error_widget.dart';
import 'package:frontend/core/utils/date_formatter.dart';
import 'package:frontend/core/theme/app_theme.dart';
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
              icon: const Icon(Icons.filter_list, color: Colors.white),
              initialValue: currentSort,
              onSelected: (sort) => ref.read(customerSortProvider.notifier).state = sort,
              itemBuilder: (context) => [
                const PopupMenuItem(value: CustomerSort.nameAsc, child: Text('Name (A-Z)')),
                const PopupMenuItem(value: CustomerSort.nameDesc, child: Text('Name (Z-A)')),
                const PopupMenuItem(value: CustomerSort.newestFirst, child: Text('Newest First')),
                const PopupMenuItem(value: CustomerSort.oldestFirst, child: Text('Oldest First')),
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
      body: Column(
        children: [
          Expanded(
            child: customersAsync.when(
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
                      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
                      child: TextField(
                        onChanged: (val) => ref.read(customerSearchProvider.notifier).state = val,
                        decoration: InputDecoration(
                          hintText: 'Search customers...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 0),
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
          ),
        ],
      ),
    );
  }


  Widget _buildList(BuildContext context, WidgetRef ref, List<Customer> customers) {
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
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 88),
        itemCount: customers.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
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
      elevation: AppElevation.flat,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(Icons.business, color: Colors.blue.shade700, size: 20),
        ),
        title: Text(customer.name, style: AppTypography.bodyText.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customer.industry?.isNotEmpty == true ? customer.industry! : 'Industry not specified',
                style: AppTypography.caption.copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 2),
              Text(
                'Created • ${_formatDateShort(customer.createdAt)}',
                style: AppTypography.caption.copyWith(color: Colors.grey.shade400, fontSize: 11),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => context.push('/customers/${customer.id}'),
      ),
    );
  }

  String _formatDateShort(DateTime dt) {
    return AppDateFormatter.format(dt).split(' • ').first;
  }
}
