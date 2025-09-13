import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DisasterIntensityMeter extends StatefulWidget {
  final double intensity;
  final String disasterType;
  final VoidCallback? onTap;

  const DisasterIntensityMeter({
    super.key,
    required this.intensity,
    required this.disasterType,
    this.onTap,
  });

  @override
  State<DisasterIntensityMeter> createState() => _DisasterIntensityMeterState();
}

class _DisasterIntensityMeterState extends State<DisasterIntensityMeter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.intensity > 0.7) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(DisasterIntensityMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.intensity > 0.7 && oldWidget.intensity <= 0.7) {
      _animationController.repeat(reverse: true);
    } else if (widget.intensity <= 0.7 && oldWidget.intensity > 0.7) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getIntensityColor() {
    if (widget.intensity <= 0.3) {
      return AppTheme.successLight;
    } else if (widget.intensity <= 0.6) {
      return AppTheme.warningLight;
    } else {
      return AppTheme.errorLight;
    }
  }

  String _getIntensityLabel() {
    if (widget.intensity <= 0.3) {
      return 'Low';
    } else if (widget.intensity <= 0.6) {
      return 'Moderate';
    } else if (widget.intensity <= 0.8) {
      return 'High';
    } else {
      return 'Extreme';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.intensity > 0.7 ? _pulseAnimation.value : 1.0,
            child: Container(
              width: 25.w,
              height: 12.h,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(4.w),
                border: Border.all(
                  color: _getIntensityColor(),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getIntensityColor().withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: _getDisasterIcon(),
                    color: _getIntensityColor(),
                    size: 6.w,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.disasterType,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.textHighEmphasisLight,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Container(
                    width: double.infinity,
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: AppTheme.neutralLightColor,
                      borderRadius: BorderRadius.circular(0.5.h),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: widget.intensity,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getIntensityColor(),
                          borderRadius: BorderRadius.circular(0.5.h),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _getIntensityLabel(),
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: _getIntensityColor(),
                      fontWeight: FontWeight.w700,
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

  String _getDisasterIcon() {
    switch (widget.disasterType.toLowerCase()) {
      case 'earthquake':
        return 'terrain';
      case 'tsunami':
        return 'waves';
      case 'hurricane':
        return 'cyclone';
      case 'volcano':
        return 'local_fire_department';
      case 'flood':
        return 'water';
      case 'drought':
        return 'wb_sunny';
      default:
        return 'warning';
    }
  }
}
