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
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                context.push('/profile');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    _formatRole(user != null && user.roles.isNotEmpty ? user.roles.first : 'No Role'),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. My Workspace
          _buildSectionHeader('My Workspace'),
          _buildDrawerItem(
            icon: Icons.person_outline,
            title: 'My Profile',
            onTap: () {
              Navigator.pop(context);
              context.push('/profile');
            },
          ),
          _buildDrawerItem(
            icon: Icons.people_outline,
            title: 'Customers',
            onTap: () {
              Navigator.pop(context);
              context.push('/customers');
            },
          ),
          _buildDrawerItem(
            icon: Icons.handshake_outlined,
            title: 'Meetings',
            onTap: () {
              Navigator.pop(context);
              context.push('/meetings');
            },
          ),
          _buildDrawerItem(
            icon: Icons.task_alt,
            title: 'Tasks',
            onTap: () {
              Navigator.pop(context);
              context.push('/tasks');
            },
          ),
          const Divider(),

          // 3. Airtel Assist
          _buildSectionHeader('Airtel Assist'),
          _buildDrawerItem(
            icon: Icons.smart_toy_outlined,
            title: 'Sales Coach',
            onTap: () {
              Navigator.pop(context);
              context.push('/airtel-iq/ai-coach');
            },
          ),
          _buildDrawerItem(
            icon: Icons.menu_book_outlined,
            title: 'Industry Playbooks',
            onTap: () {
              Navigator.pop(context);
              context.push('/airtel-iq/playbooks');
            },
          ),
          _buildDrawerItem(
            icon: Icons.inventory_2_outlined,
            title: 'Airtel Products',
            onTap: () {
              Navigator.pop(context);
              context.push('/airtel-iq/products');
            },
          ),
          _buildDrawerItem(
            icon: Icons.library_books_outlined,
            title: 'Knowledge Hub',
            onTap: () {
              Navigator.pop(context);
              context.push('/airtel-iq/knowledge-hub');
            },
          ),
          _buildDrawerItem(
            icon: Icons.info_outline,
            title: 'About Airtel',
            onTap: () {
              Navigator.pop(context);
              context.push('/airtel-iq/about');
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

  String _formatRole(String role) {
    if (role.isEmpty || role == 'No Role') return role;
    return role.split('_').map((word) {
      if (word.isEmpty) return '';
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
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
