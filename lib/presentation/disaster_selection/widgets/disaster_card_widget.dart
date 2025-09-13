import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DisasterCardWidget extends StatefulWidget {
  final Map<String, dynamic> disaster;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isLocked;

  const DisasterCardWidget({
    super.key,
    required this.disaster,
    required this.onTap,
    required this.onLongPress,
    this.isLocked = false,
  });

  @override
  State<DisasterCardWidget> createState() => _DisasterCardWidgetState();
}

class _DisasterCardWidgetState extends State<DisasterCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.isLocked ? null : widget.onTap,
            onLongPress: widget.onLongPress,
            child: Container(
              margin: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImageSection(colorScheme),
                        _buildContentSection(theme),
                      ],
                    ),
                    if (widget.isLocked) _buildLockedOverlay(colorScheme),
                    _buildDifficultyBadge(colorScheme),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection(ColorScheme colorScheme) {
    return Expanded(
      flex: 3,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: colorScheme.surfaceContainerHighest,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: CustomImageWidget(
                imageUrl: widget.disaster["imageUrl"] as String,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(ThemeData theme) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.disaster["name"] as String,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                _buildStarRating(theme.colorScheme),
              ],
            ),
            _buildDurationInfo(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(ColorScheme colorScheme) {
    final rating = widget.disaster["difficulty"] as int;
    return Row(
      children: List.generate(5, (index) {
        return Padding(
          padding: EdgeInsets.only(right: 0.5.w),
          child: CustomIconWidget(
            iconName: index < rating ? 'star' : 'star_border',
            color: index < rating
                ? AppTheme.warningLight
                : colorScheme.onSurfaceVariant,
            size: 16,
          ),
        );
      }),
    );
  }

  Widget _buildDurationInfo(ThemeData theme) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'access_time',
          color: theme.colorScheme.onSurfaceVariant,
          size: 14,
        ),
        SizedBox(width: 1.w),
        Text(
          widget.disaster["duration"] as String,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyBadge(ColorScheme colorScheme) {
    final difficulty = widget.disaster["difficulty"] as int;
    Color badgeColor;
    String difficultyText;

    switch (difficulty) {
      case 1:
      case 2:
        badgeColor = AppTheme.successLight;
        difficultyText = 'Beginner';
        break;
      case 3:
        badgeColor = AppTheme.warningLight;
        difficultyText = 'Intermediate';
        break;
      case 4:
      case 5:
        badgeColor = AppTheme.errorLight;
        difficultyText = 'Advanced';
        break;
      default:
        badgeColor = colorScheme.primary;
        difficultyText = 'Unknown';
    }

    return Positioned(
      top: 2.w,
      right: 2.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          difficultyText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLockedOverlay(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withValues(alpha: 0.6),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'lock',
              color: Colors.white,
              size: 32,
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                widget.disaster["lockReason"] as String? ?? 'Locked',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
