import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomAppBarVariant {
  standard,
  immersive,
  gaming,
  scientific,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = CustomAppBarVariant.standard,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: _buildTitle(context),
      centerTitle: centerTitle,
      backgroundColor: _getBackgroundColor(colorScheme),
      foregroundColor: _getForegroundColor(colorScheme),
      elevation: _getElevation(),
      leading: _buildLeading(context),
      actions: _buildActions(context),
      automaticallyImplyLeading: automaticallyImplyLeading,
      titleTextStyle: _getTitleTextStyle(context),
      iconTheme: IconThemeData(
        color: _getForegroundColor(colorScheme),
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: _getForegroundColor(colorScheme),
        size: 24,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    switch (variant) {
      case CustomAppBarVariant.immersive:
        return AnimatedOpacity(
          opacity: 0.9,
          duration: const Duration(milliseconds: 200),
          child: Text(title),
        );
      case CustomAppBarVariant.gaming:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.games,
              size: 20,
              color: _getForegroundColor(Theme.of(context).colorScheme),
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        );
      case CustomAppBarVariant.scientific:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.science,
              size: 20,
              color: _getForegroundColor(Theme.of(context).colorScheme),
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        );
      default:
        return Text(title);
    }
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        tooltip: 'Back',
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    final defaultActions = <Widget>[];

    // Add navigation actions based on variant
    switch (variant) {
      case CustomAppBarVariant.gaming:
        defaultActions.addAll([
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () => Navigator.pushNamed(context, '/user-profile'),
            tooltip: 'Profile',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/main-dashboard'),
            tooltip: 'Settings',
          ),
        ]);
        break;
      case CustomAppBarVariant.scientific:
        defaultActions.addAll([
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () =>
                Navigator.pushNamed(context, '/disaster-selection'),
            tooltip: 'Information',
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => Navigator.pushNamed(context, '/user-profile'),
            tooltip: 'Profile',
          ),
        ]);
        break;
      case CustomAppBarVariant.immersive:
        defaultActions.add(
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: () =>
                Navigator.pushNamed(context, '/3d-simulation-gameplay'),
            tooltip: 'Fullscreen',
          ),
        );
        break;
      default:
        defaultActions.add(
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Navigator.pushNamed(context, '/main-dashboard'),
            tooltip: 'Menu',
          ),
        );
    }

    if (actions != null) {
      defaultActions.addAll(actions!);
    }

    return defaultActions.isNotEmpty ? defaultActions : null;
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    if (backgroundColor != null) return backgroundColor!;

    switch (variant) {
      case CustomAppBarVariant.immersive:
        return Colors.transparent;
      case CustomAppBarVariant.gaming:
        return colorScheme.primary;
      case CustomAppBarVariant.scientific:
        return colorScheme.surface;
      default:
        return colorScheme.primary;
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme) {
    if (foregroundColor != null) return foregroundColor!;

    switch (variant) {
      case CustomAppBarVariant.immersive:
        return colorScheme.onSurface;
      case CustomAppBarVariant.gaming:
        return colorScheme.onPrimary;
      case CustomAppBarVariant.scientific:
        return colorScheme.onSurface;
      default:
        return colorScheme.onPrimary;
    }
  }

  double _getElevation() {
    if (elevation != null) return elevation!;

    switch (variant) {
      case CustomAppBarVariant.immersive:
        return 0;
      case CustomAppBarVariant.gaming:
        return 4.0;
      case CustomAppBarVariant.scientific:
        return 2.0;
      default:
        return 4.0;
    }
  }

  TextStyle _getTitleTextStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (variant) {
      case CustomAppBarVariant.gaming:
        return GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _getForegroundColor(colorScheme),
        );
      case CustomAppBarVariant.scientific:
        return GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _getForegroundColor(colorScheme),
          letterSpacing: 0.15,
        );
      case CustomAppBarVariant.immersive:
        return GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _getForegroundColor(colorScheme),
        );
      default:
        return GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _getForegroundColor(colorScheme),
        );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
