import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_constants.dart';

/// A global header widget to ensure design consistency across the Airtel Nexus app.
/// 
/// Type 2 (Primary Sections): Provide both `title` and `subtitle`.
/// Type 3 (Utility/Detail Pages): Provide only `title`.
class AirtelHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;

  const AirtelHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppConstants.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      toolbarHeight: subtitle != null ? 72.0 : kToolbarHeight,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ],
      ),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize {
    final double height = subtitle != null ? 72.0 : kToolbarHeight;
    return Size.fromHeight(height + (bottom?.preferredSize.height ?? 0.0));
  }
}

/// A global sliver header widget for sliver-based layouts (Type 3).
class AirtelSliverHeader extends StatelessWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool pinned;
  final bool floating;
  final PreferredSizeWidget? bottom;
  
  const AirtelSliverHeader({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.pinned = true,
    this.floating = false,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppConstants.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      pinned: pinned,
      floating: floating,
      leading: leading,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      actions: actions,
      bottom: bottom,
    );
  }
}
