import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlayerListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> players;
  final String? currentUserId;
  final Function(String playerId)? onKickPlayer;
  final bool isHost;

  const PlayerListWidget({
    super.key,
    required this.players,
    this.currentUserId,
    this.onKickPlayer,
    this.isHost = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'people',
                  size: 20,
                  color: colorScheme.primary,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Players (${players.length})',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: players.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: colorScheme.outline.withValues(alpha: 0.1),
            ),
            itemBuilder: (context, index) {
              final player = players[index];
              return _buildPlayerItem(context, colorScheme, player, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerItem(BuildContext context, ColorScheme colorScheme,
      Map<String, dynamic> player, int index) {
    final String playerId = (player['id'] as String?) ?? '';
    final String username = (player['username'] as String?) ?? 'Unknown Player';
    final String avatar = (player['avatar'] as String?) ??
        'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png';
    final int experienceLevel = (player['experienceLevel'] as int?) ?? 1;
    final String status = (player['status'] as String?) ?? 'ready';
    final bool isCurrentUser = playerId == currentUserId;
    final bool isPlayerHost = (player['isHost'] as bool?) ?? false;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          _buildPlayerAvatar(avatar, status, colorScheme),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        username,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'You',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                    if (isPlayerHost) ...[
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.warningLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'star',
                              size: 10,
                              color: AppTheme.warningLight,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'Host',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: AppTheme.warningLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      'Level $experienceLevel',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    SizedBox(width: 3.w),
                    _buildStatusIndicator(context, colorScheme, status),
                  ],
                ),
              ],
            ),
          ),
          if (isHost && !isCurrentUser && !isPlayerHost)
            _buildKickButton(context, colorScheme, playerId),
        ],
      ),
    );
  }

  Widget _buildPlayerAvatar(
      String avatar, String status, ColorScheme colorScheme) {
    return Stack(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _getStatusColor(status, colorScheme),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: CustomImageWidget(
              imageUrl: avatar,
              width: 12.w,
              height: 12.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 3.w,
            height: 3.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getStatusColor(status, colorScheme),
              border: Border.all(
                color: colorScheme.surface,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(
      BuildContext context, ColorScheme colorScheme, String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: _getStatusColor(status, colorScheme).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _getStatusText(status),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _getStatusColor(status, colorScheme),
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  Widget _buildKickButton(
      BuildContext context, ColorScheme colorScheme, String playerId) {
    return IconButton(
      onPressed: () => onKickPlayer?.call(playerId),
      icon: CustomIconWidget(
        iconName: 'remove_circle_outline',
        size: 20,
        color: AppTheme.errorLight,
      ),
      tooltip: 'Remove Player',
      constraints: BoxConstraints(
        minWidth: 8.w,
        minHeight: 8.w,
      ),
    );
  }

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'ready':
        return AppTheme.successLight;
      case 'configuring':
        return AppTheme.warningLight;
      case 'disconnected':
        return AppTheme.errorLight;
      case 'loading':
        return colorScheme.primary;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'ready':
        return 'Ready';
      case 'configuring':
        return 'Setting up';
      case 'disconnected':
        return 'Offline';
      case 'loading':
        return 'Loading';
      default:
        return 'Unknown';
    }
  }
}
