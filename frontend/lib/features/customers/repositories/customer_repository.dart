import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/storage/hive_service.dart';
import 'package:frontend/features/customers/models/customer.dart';
import 'package:uuid/uuid.dart';

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository();
});

class CustomerRepository {
  Future<List<Customer>> listCustomers() async {
    final box = HiveService.customersBox;
    // Return sorted by latest created first
    final customers = box.values.toList();
    customers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return customers;
  }

  Future<Customer> getCustomer(String id) async {
    final box = HiveService.customersBox;
    final customer = box.get(id);
    if (customer == null) {
      throw Exception('Customer not found');
    }
    return customer;
  }

  Future<Customer> createCustomer(String name, {String? industry}) async {
    final box = HiveService.customersBox;
    final userBox = HiveService.userBox;
    final currentUser = userBox.get('current_user');

    final now = DateTime.now();
    final newCustomer = Customer(
      id: const Uuid().v4(),
      ownerId: currentUser?.id,
      name: name,
      industry: industry,
      createdAt: now,
      updatedAt: now,
    );

    await box.put(newCustomer.id, newCustomer);
    return newCustomer;
  }

  Future<Customer> updateCustomer(
    String id,
    String name, {
    String? industry,
  }) async {
    final box = HiveService.customersBox;
    final existingCustomer = box.get(id);

    if (existingCustomer == null) {
      throw Exception('Customer not found');
    }

    final updatedCustomer = Customer(
      id: existingCustomer.id,
      ownerId: existingCustomer.ownerId,
      name: name,
      industry: industry,
      createdAt: existingCustomer.createdAt,
      updatedAt: DateTime.now(),
    );

    await box.put(updatedCustomer.id, updatedCustomer);
    return updatedCustomer;
  }

  Future<void> deleteCustomer(String id) async {
    final box = HiveService.customersBox;
    await box.delete(id);
  }
}
