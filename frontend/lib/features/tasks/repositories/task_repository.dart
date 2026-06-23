import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/storage/hive_service.dart';
import 'package:frontend/features/tasks/models/task.dart';
import 'package:uuid/uuid.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

class TaskRepository {
  Future<List<Task>> listTasks({String? status}) async {
    final box = HiveService.tasksBox;
    var tasks = box.values.toList();
    
    if (status != null) {
      tasks = tasks.where((t) => t.status.name == status).toList();
    }
    
    // Sort by due date (closest first), nulls at the end
    tasks.sort((a, b) {
      if (a.dueAt == null && b.dueAt == null) return 0;
      if (a.dueAt == null) return 1;
      if (b.dueAt == null) return -1;
      return a.dueAt!.compareTo(b.dueAt!);
    });
    
    return tasks;
  }

  Future<Task> getTask(String id) async {
    final box = HiveService.tasksBox;
    final task = box.get(id);
    if (task == null) {
      throw Exception('Task not found');
    }
    return task;
  }

  Future<Task> createTask({
    required String title,
    String? description,
    required String priority,
    DateTime? dueAt,
    String? customerId,
  }) async {
    final box = HiveService.tasksBox;
    final currentUser = HiveService.userBox.get('current_user');
    final now = DateTime.now();

    // Map string priority back to enum safely
    TaskPriority mappedPriority;
    switch (priority.toLowerCase()) {
      case 'low': mappedPriority = TaskPriority.low; break;
      case 'high': mappedPriority = TaskPriority.high; break;
      case 'medium': 
      default: mappedPriority = TaskPriority.medium; break;
    }

    final newTask = Task(
      id: const Uuid().v4(),
      userId: currentUser?.id ?? 'unknown_user',
      title: title,
      description: description,
      priority: mappedPriority,
      status: TaskStatus.pending,
      dueAt: dueAt,
      completedAt: null,
      createdAt: now,
      updatedAt: now,
      customerId: customerId,
    );

    await box.put(newTask.id, newTask);
    return newTask;
  }

  Future<Task> completeTask(String id) async {
    final box = HiveService.tasksBox;
    final existing = box.get(id);
    
    if (existing == null) {
      throw Exception('Task not found');
    }

    final updated = Task(
      id: existing.id,
      userId: existing.userId,
      title: existing.title,
      description: existing.description,
      priority: existing.priority,
      status: TaskStatus.completed,
      dueAt: existing.dueAt,
      completedAt: DateTime.now(),
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
      customerId: existing.customerId,
    );

    await box.put(updated.id, updated);
    return updated;
  }

  Future<Task> updateTask(
    String id, {
    String? title,
    String? description,
    TaskPriority? priority,
    DateTime? dueAt,
    String? customerId,
  }) async {
    final box = HiveService.tasksBox;
    final existing = box.get(id);

    if (existing == null) {
      throw Exception('Task not found');
    }

    final updated = Task(
      id: existing.id,
      userId: existing.userId,
      title: title ?? existing.title,
      description: description ?? existing.description,
      priority: priority ?? existing.priority,
      status: existing.status,
      dueAt: dueAt ?? existing.dueAt,
      completedAt: existing.completedAt,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
      customerId: customerId ?? existing.customerId,
    );

    await box.put(updated.id, updated);
    return updated;
  }

  Future<void> deleteTask(String id) async {
    final box = HiveService.tasksBox;
    await box.delete(id);
  }
}
