import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/tasks/models/task.dart';
import 'package:frontend/features/tasks/providers/task_provider.dart';

enum TaskPriorityFilter { all, high, medium, low }

// Search state
final taskSearchProvider = StateProvider.autoDispose<String>((ref) => '');

// Priority filter state
final taskPriorityFilterProvider =
    StateProvider.autoDispose<TaskPriorityFilter>(
        (ref) => TaskPriorityFilter.all);

// Team filter state (null = show all)
final taskTeamFilterProvider = StateProvider.autoDispose<String?>((ref) => null);

// Derived filtered list
final filteredTaskListProvider =
    Provider.autoDispose<AsyncValue<List<Task>>>((ref) {
  final rawAsync = ref.watch(taskListProvider);
  final search = ref.watch(taskSearchProvider);
  final priority = ref.watch(taskPriorityFilterProvider);
  final teamFilterId = ref.watch(taskTeamFilterProvider);

  return rawAsync.whenData((list) {
    var result = list;
    
    // 0. Filter by team
    if (teamFilterId != null) {
      result = result.where((t) => t.userId == teamFilterId).toList();
    }

    // 1. Filter by priority
    if (priority != TaskPriorityFilter.all) {
      result = result.where((t) => t.priority.name == priority.name).toList();
    }

    // 2. Filter by search query
    if (search.isNotEmpty) {
      result = result.where((t) {
        return t.title.toLowerCase().contains(search.toLowerCase());
      }).toList();
    }

    return result;
  });
});
