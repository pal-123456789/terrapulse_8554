import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementGalleryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> achievements;

  const AchievementGalleryWidget({
    super.key,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievements',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(1.w),
                ),
                child: Text(
                  '${achievements.where((a) => a["unlocked"] as bool).length}/${achievements.length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 25.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: achievements.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                return _buildAchievementCard(context, achievement);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
      BuildContext context, Map<String, dynamic> achievement) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isUnlocked = achievement["unlocked"] as bool;

    return GestureDetector(
      onTap: () => _showAchievementDetails(context, achievement),
      child: Container(
        width: 35.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isUnlocked
              ? colorScheme.primary.withValues(alpha: 0.1)
              : colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(2.w),
          border: Border.all(
            color: isUnlocked
                ? colorScheme.primary.withValues(alpha: 0.3)
                : colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? (achievement["color"] as Color)
                        : colorScheme.onSurface.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: achievement["icon"] as String,
                    color: isUnlocked
                        ? Colors.white
                        : colorScheme.onSurface.withValues(alpha: 0.5),
                    size: 6.w,
                  ),
                ),
                if (!isUnlocked)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'lock',
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        size: 4.w,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              achievement["title"] as String,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isUnlocked
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: _getRarityColor(achievement["rarity"] as String)
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(1.w),
              ),
              child: Text(
                achievement["rarity"] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _getRarityColor(achievement["rarity"] as String),
                  fontWeight: FontWeight.w500,
                  fontSize: 8.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'legendary':
        return const Color(0xFFFF6B35);
      case 'epic':
        return const Color(0xFF9B59B6);
      case 'rare':
        return const Color(0xFF3498DB);
      case 'common':
        return const Color(0xFF2ECC71);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  void _showAchievementDetails(
      BuildContext context, Map<String, dynamic> achievement) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        title: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: achievement["color"] as Color,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: achievement["icon"] as String,
                color: Colors.white,
                size: 5.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                achievement["title"] as String,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievement["description"] as String,
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              'Unlock Criteria:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              achievement["criteria"] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (achievement["unlocked"] as bool) ...[
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.successLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.successLight,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Achievement Unlocked!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.successLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
