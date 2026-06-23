import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    final initials = (user?.fullName?.isNotEmpty ?? false)
        ? user!.fullName!.trim().split(' ').map((p) => p[0]).take(2).join().toUpperCase()
        : 'U';

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),

            // Avatar
            CircleAvatar(
              radius: 48,
              backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.1),
              child: Text(
                initials,
                style: AppTypography.pageTitle.copyWith(fontSize: 36, color: AppConstants.primaryColor),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Name
            Text(
              user?.fullName ?? 'Unknown User',
              style: AppTypography.sectionTitle,
            ),
            const SizedBox(height: AppSpacing.sm),

            // Role badge
            if (user?.roles.isNotEmpty == true)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  user!.roles.first,
                  style: AppTypography.caption.copyWith(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            const SizedBox(height: AppSpacing.xxl),

            // Logout
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => ref.read(authProvider.notifier).logout(),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
