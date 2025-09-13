import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DisasterDetailModalWidget extends StatefulWidget {
  final Map<String, dynamic> disaster;
  final VoidCallback onStartSimulation;

  const DisasterDetailModalWidget({
    super.key,
    required this.disaster,
    required this.onStartSimulation,
  });

  @override
  State<DisasterDetailModalWidget> createState() =>
      _DisasterDetailModalWidgetState();
}

class _DisasterDetailModalWidgetState extends State<DisasterDetailModalWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

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
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            GestureDetector(
              onTap: _closeModal,
              child: Container(
                color:
                    Colors.black.withValues(alpha: 0.5 * _fadeAnimation.value),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: Offset(0,
                    MediaQuery.of(context).size.height * _slideAnimation.value),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxHeight: 85.h,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(theme),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildImageSection(colorScheme),
                              SizedBox(height: 3.h),
                              _buildInfoSection(theme),
                              SizedBox(height: 3.h),
                              _buildDescriptionSection(theme),
                              SizedBox(height: 3.h),
                              _buildLearningObjectives(theme),
                              SizedBox(height: 4.h),
                            ],
                          ),
                        ),
                      ),
                      _buildActionButton(theme),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.disaster["name"] as String,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: _closeModal,
                child: CustomIconWidget(
                  iconName: 'close',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      height: 25.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: colorScheme.surfaceContainerHighest,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CustomImageWidget(
          imageUrl: widget.disaster["imageUrl"] as String,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInfoSection(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            'Difficulty',
            _buildStarRating(theme.colorScheme),
            theme,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildInfoCard(
            'Duration',
            Text(
              widget.disaster["duration"] as String,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            theme,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildInfoCard(
            'Category',
            Text(
              widget.disaster["category"] as String,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            theme,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, Widget content, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 0.5.h),
          content,
        ],
      ),
    );
  }

  Widget _buildStarRating(ColorScheme colorScheme) {
    final rating = widget.disaster["difficulty"] as int;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _buildDescriptionSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About This Disaster',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          widget.disaster["description"] as String,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.5,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildLearningObjectives(ThemeData theme) {
    final objectives =
        (widget.disaster["learningObjectives"] as List).cast<String>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learning Objectives',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 1.h),
        ...objectives.map((objective) => Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 0.5.h),
                    child: CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.successLight,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      objective,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildActionButton(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _closeModal();
              widget.onStartSimulation();
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'play_arrow',
                  color: theme.colorScheme.onPrimary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Start Simulation',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _closeModal() {
    _animationController.reverse().then((_) {
      Navigator.pop(context);
    });
  }
}
