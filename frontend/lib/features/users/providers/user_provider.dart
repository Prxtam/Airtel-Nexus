import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/users/models/user_admin.dart';
import 'package:frontend/features/users/repositories/user_repository.dart';

class UserListNotifier extends StateNotifier<AsyncValue<List<UserAdmin>>> {
  final UserRepository _repository;

  UserListNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      state = const AsyncValue.loading();
      final users = await _repository.getUsers();
      state = AsyncValue.data(users);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateRole(String userId, String role) async {
    try {
      final updatedUser = await _repository.updateRole(userId, role);
      _updateUserInState(updatedUser);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateManager(String userId, String? managerId) async {
    try {
      final updatedUser = await _repository.updateManager(userId, managerId);
      _updateUserInState(updatedUser);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateStatus(String userId, bool isActive) async {
    try {
      final updatedUser = await _repository.updateStatus(userId, isActive);
      _updateUserInState(updatedUser);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String userId, String newPassword) async {
    try {
      await _repository.resetPassword(userId, newPassword);
    } catch (e) {
      rethrow;
    }
  }

  void _updateUserInState(UserAdmin updatedUser) {
    if (state is AsyncData) {
      final currentList = state.value!;
      final index = currentList.indexWhere((u) => u.id == updatedUser.id);
      if (index != -1) {
        final newList = List<UserAdmin>.from(currentList);
        newList[index] = updatedUser;
        state = AsyncValue.data(newList);
      }
    }
  }
}

final userListProvider = StateNotifierProvider<UserListNotifier, AsyncValue<List<UserAdmin>>>((ref) {
  return UserListNotifier(ref.watch(userRepositoryProvider));
});
