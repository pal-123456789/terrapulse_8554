import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConnectionStatusWidget extends StatefulWidget {
  final int activePlayersCount;
  final String connectionQuality;
  final VoidCallback? onSettingsPressed;

  const ConnectionStatusWidget({
    super.key,
    required this.activePlayersCount,
    required this.connectionQuality,
    this.onSettingsPressed,
  });

  @override
  State<ConnectionStatusWidget> createState() => _ConnectionStatusWidgetState();
}

class _ConnectionStatusWidgetState extends State<ConnectionStatusWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  bool _isReconnecting = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
    _checkConnectivity();
    _listenToConnectivityChanges();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() {
        _connectionStatus = connectivityResult;
      });
    }
  }

  void _listenToConnectivityChanges() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (mounted) {
        setState(() {
          _connectionStatus = result;
          if (result != ConnectivityResult.none && _isReconnecting) {
            _isReconnecting = false;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildConnectionIndicator(context, colorScheme),
          SizedBox(width: 4.w),
          Expanded(
            child: _buildConnectionInfo(context, colorScheme),
          ),
          _buildActivePlayersCount(context, colorScheme),
          SizedBox(width: 2.w),
          _buildSettingsButton(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildConnectionIndicator(
      BuildContext context, ColorScheme colorScheme) {
    final connectionColor = _getConnectionColor();
    final connectionIcon = _getConnectionIcon();

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale:
              widget.connectionQuality == 'poor' ? _pulseAnimation.value : 1.0,
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: connectionColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: connectionIcon,
              size: 20,
              color: connectionColor,
            ),
          ),
        );
      },
    );
  }

  Widget _buildConnectionInfo(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getConnectionTitle(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          _getConnectionSubtitle(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _buildActivePlayersCount(
      BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'people',
            size: 16,
            color: colorScheme.primary,
          ),
          SizedBox(width: 1.w),
          Text(
            '${widget.activePlayersCount}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context, ColorScheme colorScheme) {
    return IconButton(
      onPressed: widget.onSettingsPressed,
      icon: CustomIconWidget(
        iconName: 'settings',
        size: 20,
        color: colorScheme.onSurfaceVariant,
      ),
      tooltip: 'Lobby Settings',
      constraints: BoxConstraints(
        minWidth: 8.w,
        minHeight: 8.w,
      ),
    );
  }

  Color _getConnectionColor() {
    if (_connectionStatus == ConnectivityResult.none || _isReconnecting) {
      return AppTheme.errorLight;
    }

    switch (widget.connectionQuality.toLowerCase()) {
      case 'excellent':
      case 'good':
        return AppTheme.successLight;
      case 'moderate':
        return AppTheme.warningLight;
      case 'poor':
        return AppTheme.errorLight;
      default:
        return AppTheme.warningLight;
    }
  }

  String _getConnectionIcon() {
    if (_connectionStatus == ConnectivityResult.none) {
      return 'wifi_off';
    }

    if (_isReconnecting) {
      return 'sync';
    }

    switch (widget.connectionQuality.toLowerCase()) {
      case 'excellent':
        return 'signal_wifi_4_bar';
      case 'good':
        return 'signal_wifi_4_bar';
      case 'moderate':
        return 'signal_wifi_2_bar';
      case 'poor':
        return 'signal_wifi_1_bar';
      default:
        return 'signal_wifi_2_bar';
    }
  }

  String _getConnectionTitle() {
    if (_connectionStatus == ConnectivityResult.none) {
      return 'No Connection';
    }

    if (_isReconnecting) {
      return 'Reconnecting...';
    }

    switch (widget.connectionQuality.toLowerCase()) {
      case 'excellent':
        return 'Excellent Connection';
      case 'good':
        return 'Good Connection';
      case 'moderate':
        return 'Moderate Connection';
      case 'poor':
        return 'Poor Connection';
      default:
        return 'Connected';
    }
  }

  String _getConnectionSubtitle() {
    if (_connectionStatus == ConnectivityResult.none) {
      return 'Check your internet connection';
    }

    if (_isReconnecting) {
      return 'Attempting to reconnect...';
    }

    switch (widget.connectionQuality.toLowerCase()) {
      case 'excellent':
        return 'Optimal for multiplayer gaming';
      case 'good':
        return 'Great for real-time simulation';
      case 'moderate':
        return 'May experience slight delays';
      case 'poor':
        return 'Consider switching networks';
      default:
        return 'Connection established';
    }
  }

  void _handleReconnection() {
    setState(() {
      _isReconnecting = true;
    });

    // Simulate reconnection attempt
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isReconnecting = false;
        });
      }
    });
  }
}
