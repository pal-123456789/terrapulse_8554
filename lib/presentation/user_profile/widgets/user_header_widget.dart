import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UserHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserHeaderWidget({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildAvatar(context),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildUserInfo(context),
              ),
              _buildSettingsButton(context),
            ],
          ),
          SizedBox(height: 3.h),
          _buildLevelProgress(context),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.onPrimary,
              width: 0.5.w,
            ),
          ),
          child: ClipOval(
            child: CustomImageWidget(
              imageUrl: userData["avatar"] as String,
              width: 20.w,
              height: 20.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: AppTheme.successLight,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.onPrimary,
                width: 0.3.w,
              ),
            ),
            child: CustomIconWidget(
              iconName: 'check',
              color: Colors.white,
              size: 3.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userData["username"] as String,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 0.5.h),
        Text(
          userData["title"] as String,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onPrimary.withValues(alpha: 0.8),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'star',
              color: AppTheme.warningLight,
              size: 4.w,
            ),
            SizedBox(width: 1.w),
            Text(
              'Level ${userData["level"]}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/main-dashboard'),
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: colorScheme.onPrimary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: CustomIconWidget(
          iconName: 'settings',
          color: colorScheme.onPrimary,
          size: 5.w,
        ),
      ),
    );
  }

  Widget _buildLevelProgress(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress =
        (userData["experience"] as int) / (userData["nextLevelExp"] as int);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress to Level ${(userData["level"] as int) + 1}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onPrimary.withValues(alpha: 0.8),
              ),
            ),
            Text(
              '${userData["experience"]}/${userData["nextLevelExp"]} XP',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          height: 1.h,
          decoration: BoxDecoration(
            color: colorScheme.onPrimary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(0.5.h),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.warningLight,
                borderRadius: BorderRadius.circular(0.5.h),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
