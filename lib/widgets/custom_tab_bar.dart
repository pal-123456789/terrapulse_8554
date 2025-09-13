import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomTabBarVariant {
  standard,
  scientific,
  gaming,
  minimal,
}

class CustomTabBar extends StatefulWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final CustomTabBarVariant variant;
  final TabController? controller;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.variant = CustomTabBarVariant.standard,
    this.controller,
    this.onTap,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.isScrollable = false,
    this.padding,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

class _CustomTabBarState extends State<CustomTabBar>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isControllerInternal = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _tabController = TabController(
        length: widget.tabs.length,
        vsync: this,
      );
      _isControllerInternal = true;
    } else {
      _tabController = widget.controller!;
    }
  }

  @override
  void dispose() {
    if (_isControllerInternal) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (widget.variant) {
      case CustomTabBarVariant.scientific:
        return _buildScientificTabBar(context, colorScheme);
      case CustomTabBarVariant.gaming:
        return _buildGamingTabBar(context, colorScheme);
      case CustomTabBarVariant.minimal:
        return _buildMinimalTabBar(context, colorScheme);
      default:
        return _buildStandardTabBar(context, colorScheme);
    }
  }

  Widget _buildStandardTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      color: widget.backgroundColor ?? colorScheme.surface,
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        onTap: (index) {
          _handleTabNavigation(context, index);
          widget.onTap?.call(index);
        },
        isScrollable: widget.isScrollable,
        labelColor: widget.selectedColor ?? colorScheme.primary,
        unselectedLabelColor:
            widget.unselectedColor ?? colorScheme.onSurfaceVariant,
        indicatorColor: widget.indicatorColor ?? colorScheme.primary,
        indicatorWeight: 2,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        tabs: widget.tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  Widget _buildScientificTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        onTap: (index) {
          _handleTabNavigation(context, index);
          widget.onTap?.call(index);
        },
        isScrollable: widget.isScrollable,
        labelColor: widget.selectedColor ?? colorScheme.primary,
        unselectedLabelColor:
            widget.unselectedColor ?? colorScheme.onSurfaceVariant,
        indicatorColor: widget.indicatorColor ?? colorScheme.primary,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        tabs: widget.tabs.asMap().entries.map((entry) {
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _getScientificIcon(entry.key),
                const SizedBox(width: 8),
                Text(entry.value),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGamingTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (index) {
          _handleTabNavigation(context, index);
          widget.onTap?.call(index);
        },
        isScrollable: widget.isScrollable,
        labelColor: widget.selectedColor ?? colorScheme.onPrimary,
        unselectedLabelColor:
            widget.unselectedColor ?? colorScheme.onSurfaceVariant,
        indicator: BoxDecoration(
          color: widget.indicatorColor ?? colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: widget.tabs.asMap().entries.map((entry) {
          return Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getGamingIcon(entry.key),
                  const SizedBox(width: 8),
                  Text(entry.value),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMinimalTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: TabBar(
        controller: _tabController,
        onTap: (index) {
          _handleTabNavigation(context, index);
          widget.onTap?.call(index);
        },
        isScrollable: widget.isScrollable,
        labelColor: widget.selectedColor ?? colorScheme.primary,
        unselectedLabelColor:
            widget.unselectedColor ?? colorScheme.onSurfaceVariant,
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        tabs: widget.tabs.map((tab) {
          final isSelected = _tabController.index == widget.tabs.indexOf(tab);
          return Tab(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (widget.selectedColor ?? colorScheme.primary)
                        .withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(tab),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _getScientificIcon(int index) {
    final icons = [
      Icons.home,
      Icons.science,
      Icons.view_in_ar,
      Icons.group,
      Icons.person,
    ];

    return Icon(
      icons[index % icons.length],
      size: 16,
    );
  }

  Widget _getGamingIcon(int index) {
    final icons = [
      Icons.dashboard,
      Icons.videogame_asset,
      Icons.people,
      Icons.leaderboard,
      Icons.settings,
    ];

    return Icon(
      icons[index % icons.length],
      size: 16,
    );
  }

  void _handleTabNavigation(BuildContext context, int index) {
    // Navigate based on tab index and current context
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/main-dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/disaster-selection');
        break;
      case 2:
        Navigator.pushNamed(context, '/3d-simulation-gameplay');
        break;
      case 3:
        Navigator.pushNamed(context, '/multiplayer-lobby');
        break;
      case 4:
        Navigator.pushNamed(context, '/user-profile');
        break;
    }
  }
}
