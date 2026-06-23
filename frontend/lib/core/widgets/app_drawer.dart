import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    String initials = 'U';
    if (user != null && user.fullName != null && user.fullName!.isNotEmpty) {
      final parts = user.fullName!.trim().split(' ');
      if (parts.length > 1) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else {
        initials = parts[0][0].toUpperCase();
      }
    }

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 1. Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppConstants.primaryColor, Color(0xFFC00000)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 24,
                          color: AppConstants.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close drawer
                        context.push('/profile');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'View Profile',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  user?.fullName ?? 'Unknown User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user != null && user.roles.isNotEmpty ? user.roles.first : 'No Role',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // 2. My Workspace
          _buildSectionHeader('My Workspace'),
          _buildDrawerItem(
            icon: Icons.person_outline,
            title: 'Profile',
            onTap: () {
              Navigator.pop(context);
              context.push('/profile');
            },
          ),
          const Divider(),

          // 3. Sales Tools
          _buildSectionHeader('Sales Tools'),
          _buildDrawerItem(
            icon: Icons.smart_toy_outlined,
            title: 'Airtel IQ',
            onTap: () {
              Navigator.pop(context);
              context.push('/knowledge');
            },
          ),
          const Divider(),

          // 4. Account
          _buildSectionHeader('Account'),
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Logout',
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 12, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.grey.shade700, size: 24),
      title: Text(
        title,
        style: TextStyle(color: textColor ?? Colors.grey.shade900, fontWeight: FontWeight.w500),
      ),
      dense: true,
      horizontalTitleGap: 8,
      onTap: onTap,
    );
  }
}
