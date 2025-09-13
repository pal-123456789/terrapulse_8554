import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomBottomBarVariant {
  standard,
  gaming,
  scientific,
  contextual,
}

class CustomBottomBar extends StatefulWidget {
  final CustomBottomBarVariant variant;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;

  const CustomBottomBar({
    super.key,
    this.variant = CustomBottomBarVariant.standard,
    this.currentIndex = 0,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * 100),
          child: _buildBottomBar(context, colorScheme),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, ColorScheme colorScheme) {
    switch (widget.variant) {
      case CustomBottomBarVariant.gaming:
        return _buildGamingBottomBar(context, colorScheme);
      case CustomBottomBarVariant.scientific:
        return _buildScientificBottomBar(context, colorScheme);
      case CustomBottomBarVariant.contextual:
        return _buildContextualBottomBar(context, colorScheme);
      default:
        return _buildStandardBottomBar(context, colorScheme);
    }
  }

  Widget _buildStandardBottomBar(
      BuildContext context, ColorScheme colorScheme) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: (index) {
        _handleNavigation(context, index);
        widget.onTap?.call(index);
      },
      backgroundColor: widget.backgroundColor ?? colorScheme.surface,
      selectedItemColor: widget.selectedItemColor ?? colorScheme.primary,
      unselectedItemColor:
          widget.unselectedItemColor ?? colorScheme.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: widget.elevation ?? 8.0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Multiplayer',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildGamingBottomBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildGamingNavItem(
                context,
                icon: Icons.dashboard,
                label: 'Dashboard',
                index: 0,
                isSelected: widget.currentIndex == 0,
              ),
              _buildGamingNavItem(
                context,
                icon: Icons.videogame_asset,
                label: 'Play',
                index: 1,
                isSelected: widget.currentIndex == 1,
              ),
              _buildGamingNavItem(
                context,
                icon: Icons.people,
                label: 'Lobby',
                index: 2,
                isSelected: widget.currentIndex == 2,
              ),
              _buildGamingNavItem(
                context,
                icon: Icons.account_circle,
                label: 'Profile',
                index: 3,
                isSelected: widget.currentIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScientificBottomBar(
      BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildScientificNavItem(
                context,
                icon: Icons.home,
                label: 'Home',
                index: 0,
                isSelected: widget.currentIndex == 0,
              ),
              _buildScientificNavItem(
                context,
                icon: Icons.science,
                label: 'Disasters',
                index: 1,
                isSelected: widget.currentIndex == 1,
              ),
              _buildScientificNavItem(
                context,
                icon: Icons.view_in_ar,
                label: '3D View',
                index: 2,
                isSelected: widget.currentIndex == 2,
              ),
              _buildScientificNavItem(
                context,
                icon: Icons.person,
                label: 'Profile',
                index: 3,
                isSelected: widget.currentIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContextualBottomBar(
      BuildContext context, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildContextualNavItem(
                context,
                icon: Icons.home,
                index: 0,
                isSelected: widget.currentIndex == 0,
              ),
              _buildContextualNavItem(
                context,
                icon: Icons.explore,
                index: 1,
                isSelected: widget.currentIndex == 1,
              ),
              _buildContextualNavItem(
                context,
                icon: Icons.group,
                index: 2,
                isSelected: widget.currentIndex == 2,
              ),
              _buildContextualNavItem(
                context,
                icon: Icons.person,
                index: 3,
                isSelected: widget.currentIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGamingNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isSelected
        ? (widget.selectedItemColor ?? colorScheme.primary)
        : (widget.unselectedItemColor ?? colorScheme.onSurfaceVariant);

    return GestureDetector(
      onTap: () {
        _handleNavigation(context, index);
        widget.onTap?.call(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScientificNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isSelected
        ? (widget.selectedItemColor ?? colorScheme.primary)
        : (widget.unselectedItemColor ?? colorScheme.onSurfaceVariant);

    return GestureDetector(
      onTap: () {
        _handleNavigation(context, index);
        widget.onTap?.call(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextualNavItem(
    BuildContext context, {
    required IconData icon,
    required int index,
    required bool isSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isSelected
        ? (widget.selectedItemColor ?? colorScheme.primary)
        : (widget.unselectedItemColor ?? colorScheme.onSurfaceVariant);

    return GestureDetector(
      onTap: () {
        _handleNavigation(context, index);
        widget.onTap?.call(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/main-dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/disaster-selection');
        break;
      case 2:
        Navigator.pushNamed(context, '/multiplayer-lobby');
        break;
      case 3:
        Navigator.pushNamed(context, '/user-profile');
        break;
    }
  }
}
