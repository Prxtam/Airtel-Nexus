import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';
import 'package:frontend/features/users/providers/user_provider.dart';

class TeamFilterDropdown extends ConsumerWidget {
  final String? currentValue;
  final ValueChanged<String?> onChanged;

  const TeamFilterDropdown({
    super.key,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    // Only CBH and ZSM should see team filters
    if (user == null || (!user.isCBH && !user.isZSM && !user.isAdmin)) {
      return const SizedBox.shrink();
    }

    final usersAsync = ref.watch(userListProvider);

    return usersAsync.maybeWhen(
      data: (users) {
        if (users.isEmpty) return const SizedBox.shrink();

        return PopupMenuButton<String?>(
          icon: const Icon(Icons.group),
          tooltip: 'Filter by Team Member',
          initialValue: currentValue,
          onSelected: onChanged,
          itemBuilder: (context) {
            return [
              const PopupMenuItem<String?>(
                value: null,
                child: Text('All Team Members', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const PopupMenuDivider(),
              ...users.map((u) {
                return PopupMenuItem<String?>(
                  value: u.id,
                  child: Text(
                    u.fullName ?? u.email,
                    style: TextStyle(
                      fontWeight: currentValue == u.id ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }),
            ];
          },
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
