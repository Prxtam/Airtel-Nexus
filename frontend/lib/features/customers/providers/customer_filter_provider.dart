import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';

enum CustomerSort { nameAsc, nameDesc, newestFirst, oldestFirst }

// Search state
final customerSearchProvider = StateProvider.autoDispose<String>((ref) => '');

// Sort state
final customerSortProvider = StateProvider.autoDispose<CustomerSort>(
  (ref) => CustomerSort.nameAsc,
);

// Team filter removed as app is now offline-first for individual AM.

// Derived filtered & sorted list
final filteredCustomerListProvider =
    Provider.autoDispose<AsyncValue<List<Customer>>>((ref) {
      final rawAsync = ref.watch(customerListProvider);
      final search = ref.watch(customerSearchProvider);
      final sort = ref.watch(customerSortProvider);
      return rawAsync.whenData((list) {
        // 1. Filter by search query
        var result = list.where((c) {
          if (search.isEmpty) return true;
          return c.name.toLowerCase().contains(search.toLowerCase());
        }).toList();

        // 2. Sort
        result.sort((a, b) {
          switch (sort) {
            case CustomerSort.nameAsc:
              return a.name.compareTo(b.name);
            case CustomerSort.nameDesc:
              return b.name.compareTo(a.name);
            case CustomerSort.newestFirst:
              return b.createdAt.compareTo(a.createdAt);
            case CustomerSort.oldestFirst:
              return a.createdAt.compareTo(b.createdAt);
          }
        });

        return result;
      });
    });
