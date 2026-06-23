import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/tasks/models/task.dart';
import 'package:frontend/features/tasks/repositories/task_repository.dart';

// ---------------------------------------------------------------------------
// Filter enum (frontend-only — maps to the backend ?status= query param)
// ---------------------------------------------------------------------------

enum TaskStatusFilter { all, pending, completed }

extension TaskStatusFilterExtension on TaskStatusFilter {
  String? get apiValue {
    switch (this) {
      case TaskStatusFilter.pending:
        return 'pending';
      case TaskStatusFilter.completed:
        return 'completed';
      case TaskStatusFilter.all:
        return null;
    }
  }

  String get label {
    switch (this) {
      case TaskStatusFilter.all:
        return 'All';
      case TaskStatusFilter.pending:
        return 'Pending';
      case TaskStatusFilter.completed:
        return 'Completed';
    }
  }
}

// ---------------------------------------------------------------------------
// Task List Provider
// ---------------------------------------------------------------------------

class TaskListNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TaskRepository _repository;
  TaskStatusFilter _statusFilter = TaskStatusFilter.all;

  TaskListNotifier(this._repository) : super(const AsyncValue.loading()) {
    load();
  }

  TaskStatusFilter get currentFilter => _statusFilter;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final tasks = await _repository.listTasks(status: _statusFilter.apiValue);
      state = AsyncValue.data(tasks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => load();

  Future<void> setFilter(TaskStatusFilter filter) async {
    _statusFilter = filter;
    await load();
  }

  Future<void> createTask({
    required String title,
    String? description,
    required String priority,
    DateTime? dueAt,
    String? customerId,
  }) async {
    await _repository.createTask(
      title: title,
      description: description,
      priority: priority,
      dueAt: dueAt,
      customerId: customerId,
    );
    await load();
  }

  Future<void> completeTask(String taskId) async {
    await _repository.completeTask(taskId);
    await load();
  }
}

final taskListProvider =
    StateNotifierProvider<TaskListNotifier, AsyncValue<List<Task>>>(
  (ref) {
    final repository = ref.watch(taskRepositoryProvider);
    return TaskListNotifier(repository);
  },
);

// ---------------------------------------------------------------------------
// Task Detail Provider (family — keyed by task ID)
// ---------------------------------------------------------------------------

class TaskDetailNotifier extends StateNotifier<AsyncValue<Task>> {
  final TaskRepository _repository;
  final String taskId;

  TaskDetailNotifier(this._repository, this.taskId)
      : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final task = await _repository.getTask(taskId);
      state = AsyncValue.data(task);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> complete() async {
    try {
      final updated = await _repository.completeTask(taskId);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleStatus() async {
    try {
      final updated = await _repository.toggleTaskStatus(taskId);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final taskDetailProvider = StateNotifierProvider.family<
    TaskDetailNotifier, AsyncValue<Task>, String>(
  (ref, taskId) {
    final repository = ref.watch(taskRepositoryProvider);
    return TaskDetailNotifier(repository, taskId);
  },
);
