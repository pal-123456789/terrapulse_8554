import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TimeProgressionSlider extends StatefulWidget {
  final double currentTime;
  final double maxTime;
  final ValueChanged<double>? onChanged;
  final bool isPlaying;
  final VoidCallback? onPlayPause;

  const TimeProgressionSlider({
    super.key,
    required this.currentTime,
    required this.maxTime,
    this.onChanged,
    required this.isPlaying,
    this.onPlayPause,
  });

  @override
  State<TimeProgressionSlider> createState() => _TimeProgressionSliderState();
}

class _TimeProgressionSliderState extends State<TimeProgressionSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _playIconController;
  late Animation<double> _playIconAnimation;

  @override
  void initState() {
    super.initState();
    _playIconController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _playIconAnimation = CurvedAnimation(
      parent: _playIconController,
      curve: Curves.easeInOut,
    );

    if (widget.isPlaying) {
      _playIconController.forward();
    }
  }

  @override
  void didUpdateWidget(TimeProgressionSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _playIconController.forward();
      } else {
        _playIconController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _playIconController.dispose();
    super.dispose();
  }

  String _formatTime(double seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = (seconds % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(6.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Simulation Time',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: widget.onPlayPause,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: AnimatedBuilder(
                    animation: _playIconAnimation,
                    builder: (context, child) {
                      return CustomIconWidget(
                        iconName: widget.isPlaying ? 'pause' : 'play_arrow',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 4.w,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Text(
                _formatTime(widget.currentTime),
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.textHighEmphasisLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppTheme.lightTheme.colorScheme.primary,
                      inactiveTrackColor: AppTheme.neutralLightColor,
                      thumbColor: AppTheme.lightTheme.colorScheme.primary,
                      overlayColor: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.2),
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 2.w),
                      trackHeight: 1.w,
                    ),
                    child: Slider(
                      value: widget.currentTime.clamp(0.0, widget.maxTime),
                      min: 0.0,
                      max: widget.maxTime,
                      onChanged: widget.onChanged,
                    ),
                  ),
                ),
              ),
              Text(
                _formatTime(widget.maxTime),
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Speed: ${widget.isPlaying ? '1.0x' : '0.0x'}',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Progress: ${((widget.currentTime / widget.maxTime) * 100).toStringAsFixed(0)}%',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
