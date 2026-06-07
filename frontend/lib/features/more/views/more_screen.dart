import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('More'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // Header
          if (user != null)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.1),
                    child: Text(
                      (user.fullName?.isNotEmpty ?? false) ? user.fullName![0].toUpperCase() : 'U',
                      style: const TextStyle(fontSize: 24, color: AppConstants.primaryColor),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName ?? 'Unknown User',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user.email,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            user.roles.isNotEmpty ? user.roles.first : 'No Role',
                            style: const TextStyle(fontSize: 12, color: AppConstants.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),

          // Standard Options
          _buildListTile(
            icon: Icons.person_outline,
            title: 'Profile',
            onTap: () => context.push('/profile'),
          ),
          _buildListTile(
            icon: Icons.notifications_none,
            title: 'Notifications',
            onTap: () {}, // Placeholder
          ),
          _buildListTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {}, // Placeholder
          ),

          // Role-Based Options
          if (user != null && user.isZSM && !user.isAdmin && !user.isCBH) ...[
            const Divider(),
            _buildListTile(
              icon: Icons.group_outlined,
              title: 'Team Dashboard',
              onTap: () => context.push('/team'),
            ),
          ],
          if (user?.isAdmin ?? false) ...[
            const Divider(),
            _buildListTile(
              icon: Icons.admin_panel_settings_outlined,
              title: 'Admin Panel',
              onTap: () => context.push('/admin'),
            ),
          ],

          const Divider(),
          _buildListTile(
            icon: Icons.logout,
            title: 'Logout',
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Colors.grey.shade700),
        title: Text(
          title,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
