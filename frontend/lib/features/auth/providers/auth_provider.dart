import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/models/user.dart';
import 'package:frontend/features/auth/repositories/auth_repository.dart';

enum AuthStatus { initial, unauthenticated, authenticated }

class AuthState {
  final AuthStatus status;
  final User? user;
  
  AuthState({required this.status, this.user});
  
  AuthState copyWith({AuthStatus? status, User? user}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState(status: AuthStatus.initial)) {
    _init();
  }

  Future<void> _init() async {
    final user = await _repository.getMe();
    if (user != null) {
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> loginLocally({
    required String fullName,
    required String role,
    String? employeeId,
    String? circle,
  }) async {
    await _repository.loginLocally(
      fullName: fullName,
      role: role,
      employeeId: employeeId,
      circle: circle,
    );
    
    final user = await _repository.getMe();
    state = state.copyWith(status: AuthStatus.authenticated, user: user);
  }

  Future<void> updateUser({
    required String fullName,
    required String role,
    String? employeeId,
    String? circle,
  }) async {
    final currentUser = state.user;
    if (currentUser == null) return;

    String internalRole = 'account_manager';

    final updatedUser = currentUser.copyWith(
      fullName: fullName,
      roles: [internalRole],
      employeeId: employeeId,
      circle: circle,
    );

    await _repository.updateUser(updatedUser);
    state = state.copyWith(user: updatedUser);
  }

  Future<void> logout() async {
    await _repository.logout();
    state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
