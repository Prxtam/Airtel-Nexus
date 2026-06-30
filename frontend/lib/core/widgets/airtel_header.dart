import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/theme/app_theme.dart';

enum HeaderVariant { large, medium, compact }

class AirtelHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final HeaderVariant variant;

  const AirtelHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.variant = HeaderVariant.compact,
  });

  @override
  Widget build(BuildContext context) {
    final double height = _getHeight();
    final double titleSize = _getTitleSize();
    final FontWeight titleWeight = _getTitleWeight();

    Widget content = SafeArea(
      bottom: false,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null)
              leading!
            else if (automaticallyImplyLeading &&
                Navigator.of(context).canPop())
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            if ((leading != null) ||
                (automaticallyImplyLeading && Navigator.of(context).canPop()))
              const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: titleWeight,
                      color: Colors.white,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: AirtelHeaderConstants.subtitleSize,
                        fontWeight: FontWeight.w400,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );

    return Container(
      color: AppConstants.primaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [content, if (bottom != null) bottom!],
      ),
    );
  }

  double _getHeight() {
    switch (variant) {
      case HeaderVariant.large:
        return subtitle != null
            ? AirtelHeaderConstants.largeHeroHeightWithSubtitle
            : AirtelHeaderConstants.largeHeroHeightNoSubtitle;
      case HeaderVariant.medium:
        return AirtelHeaderConstants.mediumHeaderHeight;
      case HeaderVariant.compact:
        return kToolbarHeight;
    }
  }

  double _getTitleSize() {
    switch (variant) {
      case HeaderVariant.large:
        return AirtelHeaderConstants.titleLargeSize;
      case HeaderVariant.medium:
        return AirtelHeaderConstants.titleMediumSize;
      case HeaderVariant.compact:
        return AirtelHeaderConstants.titleCompactSize;
    }
  }

  FontWeight _getTitleWeight() {
    switch (variant) {
      case HeaderVariant.large:
      case HeaderVariant.medium:
        return FontWeight.w700;
      case HeaderVariant.compact:
        return FontWeight.w600;
    }
  }

  @override
  Size get preferredSize {
    final double safeAreaTop = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.single,
    ).padding.top;
    final double height = _getHeight();
    return Size.fromHeight(
      safeAreaTop + height + (bottom?.preferredSize.height ?? 0.0),
    );
  }
}

class AirtelSearchHeader extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final String hintText;
  final ValueChanged<String> onChanged;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;

  const AirtelSearchHeader({
    super.key,
    required this.title,
    this.subtitle,
    required this.hintText,
    required this.onChanged,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final double safeAreaTop = MediaQuery.of(context).padding.top;
    final double redHeight = subtitle != null
        ? AirtelHeaderConstants.largeHeroHeightWithSubtitle
        : AirtelHeaderConstants.largeHeroHeightNoSubtitle;
    final double totalHeight =
        redHeight + AirtelHeaderConstants.searchBarOverlap;

    return Container(
      height: safeAreaTop + totalHeight,
      color: Colors.transparent,
      child: Stack(
        children: [
          // Red Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: safeAreaTop + redHeight,
            child: Container(color: AppConstants.primaryColor),
          ),

          // Header Content
          Positioned(
            top: safeAreaTop,
            left: 0,
            right: 0,
            height: redHeight - AirtelHeaderConstants.searchBarOverlap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (leading != null)
                    leading!
                  else if (automaticallyImplyLeading &&
                      Navigator.of(context).canPop())
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  if ((leading != null) ||
                      (automaticallyImplyLeading &&
                          Navigator.of(context).canPop()))
                    const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: AirtelHeaderConstants.titleLargeSize,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            style: const TextStyle(
                              fontSize: AirtelHeaderConstants.subtitleSize,
                              fontWeight: FontWeight.w400,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (actions != null) ...actions!,
                ],
              ),
            ),
          ),

          // Floating Search Bar
          Positioned(
            bottom: 0,
            left: 16,
            right: 16,
            height: AirtelHeaderConstants.searchBarHeight,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  AirtelHeaderConstants.searchBarRadius,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AirtelHeaderConstants.searchBarRadius,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AirtelHeaderConstants.searchBarRadius,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AirtelHeaderConstants.searchBarRadius,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize {
    final double safeAreaTop = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.single,
    ).padding.top;
    final double redHeight = subtitle != null
        ? AirtelHeaderConstants.largeHeroHeightWithSubtitle
        : AirtelHeaderConstants.largeHeroHeightNoSubtitle;
    return Size.fromHeight(
      safeAreaTop + redHeight + AirtelHeaderConstants.searchBarOverlap,
    );
  }
}

class AirtelSliverHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final bool pinned;
  final bool floating;
  final PreferredSizeWidget? bottom;
  final HeaderVariant variant;

  const AirtelSliverHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.pinned = true,
    this.floating = false,
    this.bottom,
    this.variant = HeaderVariant.large,
  });

  @override
  Widget build(BuildContext context) {
    final double titleSize = variant == HeaderVariant.large
        ? AirtelHeaderConstants.titleLargeSize
        : (variant == HeaderVariant.medium
              ? AirtelHeaderConstants.titleMediumSize
              : AirtelHeaderConstants.titleCompactSize);
    final FontWeight titleWeight = variant == HeaderVariant.compact
        ? FontWeight.w600
        : FontWeight.w700;

    return SliverAppBar(
      backgroundColor: AppConstants.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      pinned: pinned,
      floating: floating,
      leading:
          leading ??
          (Navigator.of(context).canPop()
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null),
      automaticallyImplyLeading:
          false, // Turn off default back button since we handle it manually
      toolbarHeight: variant == HeaderVariant.large
          ? (subtitle != null
                ? AirtelHeaderConstants.largeHeroHeightWithSubtitle
                : AirtelHeaderConstants.largeHeroHeightNoSubtitle)
          : (variant == HeaderVariant.medium
                ? AirtelHeaderConstants.mediumHeaderHeight
                : kToolbarHeight),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: titleWeight,
              color: Colors.white,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: AirtelHeaderConstants.subtitleSize,
                fontWeight: FontWeight.w400,
                color: Colors.white60,
              ),
            ),
          ],
        ],
      ),
      actions: actions,
      bottom: bottom,
    );
  }
}
