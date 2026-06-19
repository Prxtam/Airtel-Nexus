import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';

class OwnerBadge extends ConsumerWidget {
  final String ownerId;

  const OwnerBadge({super.key, required this.ownerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    
    if (user == null) return const SizedBox.shrink();

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
  }
}
