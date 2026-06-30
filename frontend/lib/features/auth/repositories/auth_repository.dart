import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/storage/hive_service.dart';
import 'package:frontend/features/auth/models/user.dart';
import 'package:uuid/uuid.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

class AuthRepository {
  Future<void> loginLocally({
    required String fullName,
    required String role,
    String? employeeId,
    String? circle,
  }) async {
    final userBox = HiveService.userBox;

    String internalRole = 'account_manager';

    final user = User(
      id: const Uuid().v4(),
      email:
          employeeId ??
          '${fullName.replaceAll(' ', '.').toLowerCase()}@airtel.com',
      fullName: fullName,
      roles: [internalRole],
      employeeId: employeeId,
      circle: circle,
    );

    await userBox.put('current_user', user);
  }

  Future<User?> getMe() async {
    final userBox = HiveService.userBox;
    return userBox.get('current_user');
  }

  Future<void> updateUser(User user) async {
    final userBox = HiveService.userBox;
    await userBox.put('current_user', user);
  }

  Future<void> logout() async {
    final userBox = HiveService.userBox;
    await userBox.delete('current_user');
  }
}
