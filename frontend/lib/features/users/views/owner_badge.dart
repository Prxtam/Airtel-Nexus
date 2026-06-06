import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/users/providers/user_provider.dart';

class OwnerBadge extends ConsumerWidget {
  final String ownerId;

  const OwnerBadge({super.key, required this.ownerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userListProvider);

    return usersAsync.maybeWhen(
      data: (users) {
        final user = users.firstWhere(
          (u) => u.id == ownerId,
          orElse: () => throw Exception('User not found'),
        );
        return Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Owner: ${user.fullName ?? user.email}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
