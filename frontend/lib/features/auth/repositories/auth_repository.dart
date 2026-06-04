import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/api/dio_client.dart';
import 'package:frontend/features/auth/models/user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});

class AuthRepository {
  final Dio _dio;
  AuthRepository(this._dio);

  Future<String> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    
    if (response.statusCode == 200) {
      return response.data['access_token'] as String;
    } else {
      throw Exception(response.data['detail'] ?? 'Login failed');
    }
  }

  Future<User> getMe() async {
    final response = await _dio.get('/auth/me');
    if (response.statusCode == 200) {
      return User.fromJson(response.data['user'] as Map<String, dynamic>);
    } else {
      throw Exception(response.data['detail'] ?? 'Failed to fetch profile');
    }
  }
}
