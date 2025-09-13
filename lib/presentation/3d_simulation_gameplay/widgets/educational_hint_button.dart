import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EducationalHintButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool hasNewHint;

  const EducationalHintButton({
    super.key,
    this.onTap,
    this.hasNewHint = false,
  });

  @override
  State<EducationalHintButton> createState() => _EducationalHintButtonState();
}

class _EducationalHintButtonState extends State<EducationalHintButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.hasNewHint) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(EducationalHintButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasNewHint != oldWidget.hasNewHint) {
      if (widget.hasNewHint) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _animationController.reset();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.hasNewHint ? _scaleAnimation.value : 1.0,
            child: Container(
              width: 14.w,
              height: 14.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                borderRadius: BorderRadius.circular(7.w),
                boxShadow: [
                  BoxShadow(
                    color: widget.hasNewHint
                        ? AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: _glowAnimation.value)
                        : AppTheme.shadowLight,
                    blurRadius: widget.hasNewHint ? 16 : 8,
                    spreadRadius: widget.hasNewHint ? 4 : 0,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'lightbulb',
                    color: AppTheme.lightTheme.colorScheme.onTertiary,
                    size: 6.w,
                  ),
                  if (widget.hasNewHint)
                    Positioned(
                      top: 1.w,
                      right: 1.w,
                      child: Container(
                        width: 3.w,
                        height: 3.w,
                        decoration: BoxDecoration(
                          color: AppTheme.errorLight,
                          borderRadius: BorderRadius.circular(1.5.w),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.onTertiary,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
