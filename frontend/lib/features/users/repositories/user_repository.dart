import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/api/dio_client.dart';
import 'package:frontend/features/users/models/user_admin.dart';

class UserRepository {
  final Dio _dio;

  UserRepository(this._dio);

  Future<List<UserAdmin>> getUsers() async {
    final response = await _dio.get('/users');
    return (response.data as List).map((json) => UserAdmin.fromJson(json)).toList();
  }

  Future<UserAdmin> updateRole(String userId, String role) async {
    final response = await _dio.patch(
      '/users/$userId/roles',
      data: {'role': role},
    );
    return UserAdmin.fromJson(response.data);
  }

  Future<UserAdmin> updateManager(String userId, String? managerId) async {
    final response = await _dio.patch(
      '/users/$userId/manager',
      data: {'manager_id': managerId},
    );
    return UserAdmin.fromJson(response.data);
  }

  Future<UserAdmin> updateStatus(String userId, bool isActive) async {
    final response = await _dio.patch(
      '/users/$userId/status',
      data: {'is_active': isActive},
    );
    return UserAdmin.fromJson(response.data);
  }

  Future<void> resetPassword(String userId, String newPassword) async {
    await _dio.post(
      '/users/$userId/reset-password',
      data: {'new_password': newPassword},
    );
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(dioProvider));
});
