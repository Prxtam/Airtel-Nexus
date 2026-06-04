import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/core/storage/secure_storage.dart';
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
  final FlutterSecureStorage _storage;

  AuthNotifier(this._repository, this._storage) : super(AuthState(status: AuthStatus.initial)) {
    _init();
  }

  Future<void> _init() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token != null) {
      try {
        final user = await _repository.getMe();
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
      } catch (e) {
        await _storage.delete(key: 'jwt_token');
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    final token = await _repository.login(email, password);
    await _storage.write(key: 'jwt_token', value: token);
    
    final user = await _repository.getMe();
    state = state.copyWith(status: AuthStatus.authenticated, user: user);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthNotifier(repository, storage);
});
