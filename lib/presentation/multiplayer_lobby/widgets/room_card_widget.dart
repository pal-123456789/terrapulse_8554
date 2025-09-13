import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RoomCardWidget extends StatelessWidget {
  final Map<String, dynamic> roomData;
  final VoidCallback? onJoin;

  const RoomCardWidget({
    super.key,
    required this.roomData,
    this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String roomName = (roomData['roomName'] as String?) ?? 'Unknown Room';
    final String disasterType =
        (roomData['disasterType'] as String?) ?? 'Unknown';
    final int currentPlayers = (roomData['currentPlayers'] as int?) ?? 0;
    final int maxPlayers = (roomData['maxPlayers'] as int?) ?? 4;
    final String difficulty = (roomData['difficulty'] as String?) ?? 'Medium';
    final String hostRegion = (roomData['hostRegion'] as String?) ?? 'Unknown';
    final int estimatedDuration = (roomData['estimatedDuration'] as int?) ?? 30;
    final List<dynamic> playerAvatars =
        (roomData['playerAvatars'] as List<dynamic>?) ?? [];
    final bool isPrivate = (roomData['isPrivate'] as bool?) ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRoomHeader(context, colorScheme, roomName, isPrivate),
            SizedBox(height: 2.h),
            _buildDisasterInfo(context, colorScheme, disasterType, difficulty),
            SizedBox(height: 2.h),
            _buildPlayerInfo(context, colorScheme, currentPlayers, maxPlayers,
                playerAvatars),
            SizedBox(height: 2.h),
            _buildRoomDetails(
                context, colorScheme, hostRegion, estimatedDuration),
            SizedBox(height: 3.h),
            _buildJoinButton(context, colorScheme, currentPlayers, maxPlayers),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomHeader(BuildContext context, ColorScheme colorScheme,
      String roomName, bool isPrivate) {
    return Row(
      children: [
        Expanded(
          child: Text(
            roomName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isPrivate) ...[
          SizedBox(width: 2.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.warningLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'lock',
                  size: 12,
                  color: AppTheme.warningLight,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Private',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.warningLight,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDisasterInfo(BuildContext context, ColorScheme colorScheme,
      String disasterType, String difficulty) {
    Color difficultyColor = _getDifficultyColor(difficulty);
    IconData disasterIcon = _getDisasterIcon(disasterType);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: _getIconName(disasterIcon),
            size: 20,
            color: colorScheme.primary,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                disasterType,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
              ),
              SizedBox(height: 0.5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: difficultyColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  difficulty,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: difficultyColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerInfo(BuildContext context, ColorScheme colorScheme,
      int currentPlayers, int maxPlayers, List<dynamic> playerAvatars) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Players',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  Text(
                    '$currentPlayers/$maxPlayers',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: currentPlayers / maxPlayers,
                      backgroundColor:
                          colorScheme.outline.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        currentPlayers == maxPlayers
                            ? AppTheme.errorLight
                            : colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 4.w),
        _buildPlayerAvatars(context, playerAvatars, colorScheme),
      ],
    );
  }

  Widget _buildPlayerAvatars(BuildContext context, List<dynamic> playerAvatars,
      ColorScheme colorScheme) {
    return SizedBox(
      height: 8.w,
      child: Stack(
        children: [
          for (int i = 0; i < playerAvatars.length && i < 3; i++)
            Positioned(
              left: i * 5.w,
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: (playerAvatars[i]
                            as Map<String, dynamic>?)?['avatar'] as String? ??
                        'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
                    width: 8.w,
                    height: 8.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          if (playerAvatars.length > 3)
            Positioned(
              left: 3 * 5.w,
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+${playerAvatars.length - 3}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRoomDetails(BuildContext context, ColorScheme colorScheme,
      String hostRegion, int estimatedDuration) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'public',
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 2.w),
              Text(
                hostRegion,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'schedule',
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 2.w),
            Text(
              '${estimatedDuration}min',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildJoinButton(BuildContext context, ColorScheme colorScheme,
      int currentPlayers, int maxPlayers) {
    final bool isFull = currentPlayers >= maxPlayers;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isFull ? null : onJoin,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFull
              ? colorScheme.outline.withValues(alpha: 0.2)
              : colorScheme.primary,
          foregroundColor:
              isFull ? colorScheme.onSurfaceVariant : colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          isFull ? 'Room Full' : 'Join Room',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppTheme.successLight;
      case 'medium':
        return AppTheme.warningLight;
      case 'hard':
        return AppTheme.errorLight;
      default:
        return AppTheme.warningLight;
    }
  }

  IconData _getDisasterIcon(String disasterType) {
    switch (disasterType.toLowerCase()) {
      case 'earthquake':
        return Icons.terrain;
      case 'tsunami':
        return Icons.waves;
      case 'hurricane':
        return Icons.cyclone;
      case 'volcanic eruption':
        return Icons.local_fire_department;
      case 'flood':
        return Icons.water;
      case 'drought':
        return Icons.wb_sunny;
      case 'wildfire':
        return Icons.whatshot;
      case 'tornado':
        return Icons.tornado;
      default:
        return Icons.warning;
    }
  }

  String _getIconName(IconData iconData) {
    switch (iconData) {
      case Icons.terrain:
        return 'terrain';
      case Icons.waves:
        return 'waves';
      case Icons.cyclone:
        return 'cyclone';
      case Icons.local_fire_department:
        return 'local_fire_department';
      case Icons.water:
        return 'water';
      case Icons.wb_sunny:
        return 'wb_sunny';
      case Icons.whatshot:
        return 'whatshot';
      case Icons.tornado:
        return 'tornado';
      default:
        return 'warning';
    }
  }
}
