import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/api/dio_client.dart';
import 'package:frontend/features/customers/models/customer.dart';

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CustomerRepository(dio);
});

class CustomerRepository {
  final Dio _dio;
  CustomerRepository(this._dio);

  Future<List<Customer>> listCustomers() async {
    final response = await _dio.get('/customers');
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final list = data['customers'] as List<dynamic>;
      return list
          .map((e) => Customer.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(response.data['detail'] ?? 'Failed to load customers');
  }

  Future<Customer> getCustomer(String id) async {
    final response = await _dio.get('/customers/$id');
    if (response.statusCode == 200) {
      return Customer.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception(response.data['detail'] ?? 'Customer not found');
  }

  Future<Customer> createCustomer(String name) async {
    final response = await _dio.post('/customers', data: {'name': name});
    if (response.statusCode == 201) {
      return Customer.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception(response.data['detail'] ?? 'Failed to create customer');
  }

  Future<Customer> updateCustomer(String id, String name) async {
    final response = await _dio.patch('/customers/$id', data: {'name': name});
    if (response.statusCode == 200) {
      return Customer.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception(response.data['detail'] ?? 'Failed to update customer');
  }

  Future<void> deleteCustomer(String id) async {
    final response = await _dio.delete('/customers/$id');
    if (response.statusCode != 204) {
      throw Exception(response.data['detail'] ?? 'Failed to delete customer');
    }
  }
}
