import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/customers/models/customer.dart';
import 'package:frontend/features/customers/repositories/customer_repository.dart';

// ---------------------------------------------------------------------------
// Customer List Provider
// ---------------------------------------------------------------------------

class CustomerListNotifier extends StateNotifier<AsyncValue<List<Customer>>> {
  final CustomerRepository _repository;

  CustomerListNotifier(this._repository) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final customers = await _repository.listCustomers();
      state = AsyncValue.data(customers);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => load();

  Future<void> createCustomer(String name, {String? industry}) async {
    await _repository.createCustomer(name, industry: industry);
    await load();
  }

  Future<void> deleteCustomer(String id) async {
    await _repository.deleteCustomer(id);
    await load();
  }
}

final customerListProvider =
    StateNotifierProvider<CustomerListNotifier, AsyncValue<List<Customer>>>(
  (ref) {
    final repository = ref.watch(customerRepositoryProvider);
    return CustomerListNotifier(repository);
  },
);

// ---------------------------------------------------------------------------
// Customer Detail Provider (family — keyed by customer ID)
// ---------------------------------------------------------------------------

class CustomerDetailNotifier extends StateNotifier<AsyncValue<Customer>> {
  final CustomerRepository _repository;
  final String customerId;

  CustomerDetailNotifier(this._repository, this.customerId)
      : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final customer = await _repository.getCustomer(customerId);
      state = AsyncValue.data(customer);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> update(String name, {String? industry}) async {
    try {
      final updated = await _repository.updateCustomer(customerId, name, industry: industry);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final customerDetailProvider = StateNotifierProvider.family<
    CustomerDetailNotifier, AsyncValue<Customer>, String>(
  (ref, customerId) {
    final repository = ref.watch(customerRepositoryProvider);
    return CustomerDetailNotifier(repository, customerId);
  },
);
