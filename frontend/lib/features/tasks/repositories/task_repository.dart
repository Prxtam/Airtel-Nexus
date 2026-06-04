import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/api/dio_client.dart';
import 'package:frontend/features/tasks/models/task.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TaskRepository(dio);
});

class TaskRepository {
  final Dio _dio;
  TaskRepository(this._dio);

  Future<List<Task>> listTasks({String? status}) async {
    final queryParams = status != null ? {'status': status} : null;
    final response = await _dio.get('/tasks', queryParameters: queryParams);
    if (response.statusCode == 200) {
      final list = response.data['tasks'] as List<dynamic>;
      return list.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception(response.data['detail'] ?? 'Failed to load tasks');
  }

  Future<Task> getTask(String id) async {
    final response = await _dio.get('/tasks/$id');
    if (response.statusCode == 200) {
      return Task.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception(response.data['detail'] ?? 'Task not found');
  }

  Future<Task> createTask({
    required String title,
    String? description,
    required String priority,
    DateTime? dueAt,
  }) async {
    final response = await _dio.post('/tasks', data: {
      'title': title,
      if (description != null && description.isNotEmpty) 'description': description,
      'priority': priority,
      if (dueAt != null) 'due_at': dueAt.toUtc().toIso8601String(),
    });
    if (response.statusCode == 201) {
      return Task.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception(response.data['detail'] ?? 'Failed to create task');
  }

  Future<Task> completeTask(String id) async {
    final response = await _dio.post('/tasks/$id/complete');
    if (response.statusCode == 200) {
      return Task.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception(response.data['detail'] ?? 'Failed to complete task');
  }
}
