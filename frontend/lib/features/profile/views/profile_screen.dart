import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';
import 'package:frontend/features/auth/models/user.dart';
import 'package:gap/gap.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  String _formatRole(String role) {
    if (role.isEmpty || role == 'No Role') return role;
    return role.split('_').map((word) {
      if (word.isEmpty) return '';
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }

  String _formatRoleForInput(String internalRole) {
    if (internalRole == 'zonal_sales_manager') return 'Zonal Sales Manager';
    if (internalRole == 'circle_business_head') return 'Circle Business Head';
    return 'Account Manager';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    final initials = (user?.fullName?.isNotEmpty ?? false)
        ? user!.fullName!.trim().split(' ').map((p) => p[0]).take(2).join().toUpperCase()
        : 'U';

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            const Gap(AppSpacing.lg),

            // Avatar
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.1),
                child: Text(
                  initials,
                  style: AppTypography.pageTitle.copyWith(fontSize: 36, color: AppConstants.primaryColor),
                ),
              ),
            ),
            const Gap(AppSpacing.xxl),

            // Personal Information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Personal Information', style: AppTypography.sectionTitle),
                if (user != null)
                  IconButton(
                    icon: Icon(Icons.edit_outlined, color: AppConstants.primaryColor, size: 20),
                    onPressed: () => _showEditProfileSheet(context, ref, user),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const Gap(AppSpacing.md),
            Card(
              elevation: AppElevation.flat,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    _buildInfoRow('Name', user?.fullName ?? 'Unknown User'),
                    const Divider(height: AppSpacing.lg),
                    _buildInfoRow('Role', _formatRole(user != null && user.roles.isNotEmpty ? user.roles.first : 'No Role')),
                    const Divider(height: AppSpacing.lg),
                    _buildInfoRow('Employee ID', user?.employeeId ?? 'Not set'),
                    const Divider(height: AppSpacing.lg),
                    _buildInfoRow('Circle', user?.circle ?? 'Not set'),
                  ],
                ),
              ),
            ),

            const Gap(AppSpacing.xxl),

            // Workspace Information
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Workspace Information', style: AppTypography.sectionTitle),
            ),
            const Gap(AppSpacing.md),
            Card(
              elevation: AppElevation.flat,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    _buildInfoRow('Mode', 'Offline-first'),
                    const Divider(height: AppSpacing.lg),
                    _buildInfoRow('Storage', 'Local device'),
                    const Divider(height: AppSpacing.lg),
                    _buildInfoRow('Version', 'Airtel Nexus v1.0'),
                  ],
                ),
              ),
            ),

            const Gap(AppSpacing.xxl),

            // About Airtel Nexus
            Align(
              alignment: Alignment.centerLeft,
              child: Text('About Airtel Nexus', style: AppTypography.sectionTitle),
            ),
            const Gap(AppSpacing.md),
            Card(
              elevation: AppElevation.flat,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'Airtel Nexus is a productivity and sales enablement platform designed to help Account Managers organize customer relationships, meetings, tasks, and enterprise knowledge in a single workspace.',
                  style: AppTypography.bodyText.copyWith(color: Colors.grey.shade700, height: 1.4),
                ),
              ),
            ),

            const Gap(AppSpacing.xxl),
            const Gap(AppSpacing.xxl),

            // Logout (Small and less aggressive)
            Center(
              child: SizedBox(
                width: 140, // specifically requested to be smaller
                child: OutlinedButton(
                  onPressed: () => ref.read(authProvider.notifier).logout(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    side: BorderSide(color: Colors.grey.shade400),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.normal)),
                ),
              ),
            ),
            const Gap(AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.bodyText.copyWith(color: Colors.grey.shade600)),
        const Gap(AppSpacing.md),
        Expanded(
          child: Text(
            value, 
            style: AppTypography.bodyText.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  void _showEditProfileSheet(BuildContext context, WidgetRef ref, User user) {
    final nameController = TextEditingController(text: user.fullName);
    final roleValue = user.roles.isNotEmpty ? _formatRoleForInput(user.roles.first) : 'Account Manager';
    final roleController = TextEditingController(text: roleValue);
    final employeeIdController = TextEditingController(text: user.employeeId);
    final circleController = TextEditingController(text: user.circle);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Edit Personal Information', style: AppTypography.sectionTitle),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(sheetContext),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const Gap(AppSpacing.lg),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
                ),
              ),
              const Gap(AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: roleValue,
                items: ['Account Manager', 'Zonal Sales Manager', 'Circle Business Head'].map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                onChanged: (val) {
                  if (val != null) roleController.text = val;
                },
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
                ),
              ),
              const Gap(AppSpacing.md),
              TextField(
                controller: employeeIdController,
                decoration: InputDecoration(
                  labelText: 'Employee ID (Optional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
                ),
              ),
              const Gap(AppSpacing.md),
              TextField(
                controller: circleController,
                decoration: InputDecoration(
                  labelText: 'Circle (Optional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
                ),
              ),
              const Gap(AppSpacing.xl),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(authProvider.notifier).updateUser(
                    fullName: nameController.text.trim(),
                    role: roleController.text,
                    employeeId: employeeIdController.text.trim().isEmpty ? null : employeeIdController.text.trim(),
                    circle: circleController.text.trim().isEmpty ? null : circleController.text.trim(),
                  );
                  if (sheetContext.mounted) Navigator.pop(sheetContext);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  elevation: 0,
                ),
                child: Text('Save Changes', style: AppTypography.bodyText.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
              const Gap(AppSpacing.xl),
            ],
          ),
        );
      },
    );
  }
}
