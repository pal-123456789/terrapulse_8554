import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EducationalInfoOverlay extends StatefulWidget {
  final String title;
  final String content;
  final List<String> keyPoints;
  final String imageUrl;
  final bool isVisible;
  final VoidCallback? onClose;

  const EducationalInfoOverlay({
    super.key,
    required this.title,
    required this.content,
    required this.keyPoints,
    required this.imageUrl,
    required this.isVisible,
    this.onClose,
  });

  @override
  State<EducationalInfoOverlay> createState() => _EducationalInfoOverlayState();
}

class _EducationalInfoOverlayState extends State<EducationalInfoOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(EducationalInfoOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
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
    if (!widget.isVisible && _animationController.isDismissed) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withValues(alpha: 0.8),
            child: SlideTransition(
              position: _slideAnimation,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxHeight: 80.h),
                  margin: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(4.w),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.shadowLight,
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.w),
                            topRight: Radius.circular(4.w),
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'school',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 6.w,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                widget.title,
                                style: AppTheme.lightTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: widget.onClose,
                              child: Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onPrimary
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(2.w),
                                ),
                                child: CustomIconWidget(
                                  iconName: 'close',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 5.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(4.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.imageUrl.isNotEmpty) ...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(3.w),
                                  child: CustomImageWidget(
                                    imageUrl: widget.imageUrl,
                                    width: double.infinity,
                                    height: 25.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                              ],
                              Text(
                                'Scientific Explanation',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: AppTheme.textHighEmphasisLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                widget.content,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme.textHighEmphasisLight,
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'Key Learning Points',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: AppTheme.textHighEmphasisLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              ...widget.keyPoints.map((point) => Padding(
                                    padding: EdgeInsets.only(bottom: 2.h),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 0.5.h),
                                          width: 1.5.w,
                                          height: 1.5.w,
                                          decoration: BoxDecoration(
                                            color: AppTheme
                                                .lightTheme.colorScheme.primary,
                                            borderRadius:
                                                BorderRadius.circular(0.75.w),
                                          ),
                                        ),
                                        SizedBox(width: 3.w),
                                        Expanded(
                                          child: Text(
                                            point,
                                            style: AppTheme
                                                .lightTheme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: AppTheme
                                                  .textHighEmphasisLight,
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(height: 3.h),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  color: AppTheme
                                      .lightTheme.colorScheme.tertiary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(3.w),
                                  border: Border.all(
                                    color: AppTheme
                                        .lightTheme.colorScheme.tertiary
                                        .withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'tips_and_updates',
                                      color: AppTheme
                                          .lightTheme.colorScheme.tertiary,
                                      size: 5.w,
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Text(
                                        'Continue exploring the simulation to discover more scientific phenomena!',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.tertiary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
