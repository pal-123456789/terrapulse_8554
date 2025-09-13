import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/chat_widget.dart';
import './widgets/connection_status_widget.dart';
import './widgets/create_room_modal.dart';
import './widgets/player_list_widget.dart';
import './widgets/room_card_widget.dart';

class MultiplayerLobby extends StatefulWidget {
  const MultiplayerLobby({super.key});

  @override
  State<MultiplayerLobby> createState() => _MultiplayerLobbyState();
}

class _MultiplayerLobbyState extends State<MultiplayerLobby>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _showChat = false;
  String _connectionQuality = 'good';
  int _activePlayersCount = 127;
  bool _isLoading = true;
  String? _currentUserId = 'user_123';

  // Mock data
  final List<Map<String, dynamic>> _availableRooms = [
    {
      'id': 'room_1',
      'roomName': 'Earthquake Masters',
      'disasterType': 'Earthquake',
      'currentPlayers': 3,
      'maxPlayers': 4,
      'difficulty': 'Hard',
      'hostRegion': 'North America',
      'estimatedDuration': 45,
      'isPrivate': false,
      'playerAvatars': [
        {
          'avatar':
              'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'
        },
        {
          'avatar':
              'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'
        },
        {
          'avatar':
              'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'
        },
      ],
    },
    {
      'id': 'room_2',
      'roomName': 'Tsunami Response Team',
      'disasterType': 'Tsunami',
      'currentPlayers': 2,
      'maxPlayers': 4,
      'difficulty': 'Medium',
      'hostRegion': 'Asia Pacific',
      'estimatedDuration': 30,
      'isPrivate': false,
      'playerAvatars': [
        {
          'avatar':
              'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'
        },
        {
          'avatar':
              'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'
        },
      ],
    },
    {
      'id': 'room_3',
      'roomName': 'Hurricane Hunters',
      'disasterType': 'Hurricane',
      'currentPlayers': 4,
      'maxPlayers': 4,
      'difficulty': 'Expert',
      'hostRegion': 'Europe',
      'estimatedDuration': 60,
      'isPrivate': true,
      'playerAvatars': [
        {
          'avatar':
              'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'
        },
        {
          'avatar':
              'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'
        },
        {
          'avatar':
              'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'
        },
        {
          'avatar':
              'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'
        },
      ],
    },
    {
      'id': 'room_4',
      'roomName': 'Volcanic Crisis',
      'disasterType': 'Volcanic Eruption',
      'currentPlayers': 1,
      'maxPlayers': 3,
      'difficulty': 'Easy',
      'hostRegion': 'South America',
      'estimatedDuration': 25,
      'isPrivate': false,
      'playerAvatars': [
        {
          'avatar':
              'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'
        },
      ],
    },
    {
      'id': 'room_5',
      'roomName': 'Flood Defense Squad',
      'disasterType': 'Flood',
      'currentPlayers': 2,
      'maxPlayers': 6,
      'difficulty': 'Medium',
      'hostRegion': 'Africa',
      'estimatedDuration': 40,
      'isPrivate': false,
      'playerAvatars': [
        {
          'avatar':
              'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'
        },
        {
          'avatar':
              'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'
        },
      ],
    },
  ];

  final List<Map<String, dynamic>> _currentRoomPlayers = [
    {
      'id': 'user_123',
      'username': 'DisasterExpert',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'experienceLevel': 15,
      'status': 'ready',
      'isHost': true,
    },
    {
      'id': 'user_456',
      'username': 'EarthquakeHunter',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'experienceLevel': 8,
      'status': 'configuring',
      'isHost': false,
    },
    {
      'id': 'user_789',
      'username': 'TsunamiWatcher',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'experienceLevel': 12,
      'status': 'ready',
      'isHost': false,
    },
  ];

  final List<Map<String, dynamic>> _chatMessages = [
    {
      'id': 'msg_1',
      'senderId': 'user_456',
      'senderName': 'EarthquakeHunter',
      'content': 'Ready for the earthquake simulation!',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
    },
    {
      'id': 'msg_2',
      'senderId': 'user_789',
      'senderName': 'TsunamiWatcher',
      'content': 'Great observation! Let\'s analyze the seismic data.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 3)),
    },
    {
      'id': 'msg_3',
      'senderId': 'user_123',
      'senderName': 'DisasterExpert',
      'content': 'Excellent teamwork everyone. Starting in 2 minutes.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 1)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeLobby();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeLobby() async {
    // Simulate loading and network check
    await Future.delayed(const Duration(seconds: 2));

    final connectivityResult = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() {
        _isLoading = false;
        _connectionQuality =
            connectivityResult != ConnectivityResult.none ? 'good' : 'poor';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: colorScheme.primary,
              ),
              SizedBox(height: 3.h),
              Text(
                'Connecting to multiplayer lobby...',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: _buildAppBar(context, colorScheme),
      body: Column(
        children: [
          _buildConnectionStatus(context, colorScheme),
          _buildTabBar(context, colorScheme),
          Expanded(
            child: _buildTabBarView(context, colorScheme),
          ),
          if (_showChat) _buildChatSection(context, colorScheme),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context, colorScheme),
      bottomNavigationBar: CustomBottomBar(
        variant: CustomBottomBarVariant.gaming,
        currentIndex: 2,
        onTap: (index) => _handleBottomNavigation(context, index),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, ColorScheme colorScheme) {
    return CustomAppBar(
      title: 'Multiplayer Lobby',
      variant: CustomAppBarVariant.gaming,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _showChat = !_showChat;
            });
          },
          icon: Stack(
            children: [
              CustomIconWidget(
                iconName: 'chat',
                size: 24,
                color: colorScheme.onPrimary,
              ),
              if (_chatMessages.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 3.w,
                    height: 3.w,
                    decoration: BoxDecoration(
                      color: AppTheme.errorLight,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          tooltip: 'Toggle Chat',
        ),
        IconButton(
          onPressed: _handleQuickJoin,
          icon: CustomIconWidget(
            iconName: 'flash_on',
            size: 24,
            color: colorScheme.onPrimary,
          ),
          tooltip: 'Quick Join',
        ),
      ],
    );
  }

  Widget _buildConnectionStatus(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: ConnectionStatusWidget(
        activePlayersCount: _activePlayersCount,
        connectionQuality: _connectionQuality,
        onSettingsPressed: _handleLobbySettings,
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, ColorScheme colorScheme) {
    return CustomTabBar(
      tabs: const ['Available Rooms', 'My Room', 'Quick Match'],
      variant: CustomTabBarVariant.gaming,
      controller: _tabController,
      onTap: (index) {
        // Tab navigation handled by CustomTabBar
      },
    );
  }

  Widget _buildTabBarView(BuildContext context, ColorScheme colorScheme) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildAvailableRoomsTab(context, colorScheme),
        _buildMyRoomTab(context, colorScheme),
        _buildQuickMatchTab(context, colorScheme),
      ],
    );
  }

  Widget _buildAvailableRoomsTab(
      BuildContext context, ColorScheme colorScheme) {
    return RefreshIndicator(
      onRefresh: _refreshRooms,
      child: _availableRooms.isEmpty
          ? _buildEmptyState(
              context,
              colorScheme,
              'No rooms available',
              'Create a new room or try refreshing',
              'meeting_room',
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              itemCount: _availableRooms.length,
              itemBuilder: (context, index) {
                final room = _availableRooms[index];
                return RoomCardWidget(
                  roomData: room,
                  onJoin: () => _handleJoinRoom(room),
                );
              },
            ),
    );
  }

  Widget _buildMyRoomTab(BuildContext context, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          PlayerListWidget(
            players: _currentRoomPlayers,
            currentUserId: _currentUserId,
            isHost: true,
            onKickPlayer: _handleKickPlayer,
          ),
          SizedBox(height: 3.h),
          _buildRoomControls(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildQuickMatchTab(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'flash_on',
            size: 64,
            color: colorScheme.primary,
          ),
          SizedBox(height: 3.h),
          Text(
            'Quick Match',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Get matched with players of similar skill level for instant gameplay',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleQuickMatch,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Find Match',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          OutlinedButton(
            onPressed: _handleCustomizeQuickMatch,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Customize Preferences',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomControls(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
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
          Text(
            'Room Controls',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleStartSimulation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successLight,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Start Simulation',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: _handleRoomSettings,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Room Settings',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _handleLeaveRoom,
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.errorLight,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Leave Room',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatSection(BuildContext context, ColorScheme colorScheme) {
    return ChatWidget(
      messages: _chatMessages,
      currentUserId: _currentUserId,
      onSendMessage: _handleSendMessage,
    );
  }

  Widget _buildFloatingActionButton(
      BuildContext context, ColorScheme colorScheme) {
    return FloatingActionButton.extended(
      onPressed: _handleCreateRoom,
      icon: CustomIconWidget(
        iconName: 'add',
        size: 24,
        color: colorScheme.onPrimary,
      ),
      label: Text(
        'Create Room',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onPrimary,
        ),
      ),
      backgroundColor: colorScheme.primary,
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ColorScheme colorScheme,
    String title,
    String subtitle,
    String iconName,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            SizedBox(height: 3.h),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Event Handlers
  void _handleBottomNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/main-dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/disaster-selection');
        break;
      case 2:
        // Current screen
        break;
      case 3:
        Navigator.pushNamed(context, '/user-profile');
        break;
    }
  }

  void _handleCreateRoom() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateRoomModal(
        onCreateRoom: (roomConfig) {
          // Handle room creation
          setState(() {
            _availableRooms.insert(0, {
              'id': 'room_${DateTime.now().millisecondsSinceEpoch}',
              ...roomConfig,
              'currentPlayers': 1,
              'playerAvatars': [
                {
                  'avatar':
                      'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'
                },
              ],
            });
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Room "${roomConfig['roomName']}" created successfully!'),
              backgroundColor: AppTheme.successLight,
            ),
          );
        },
      ),
    );
  }

  void _handleJoinRoom(Map<String, dynamic> room) {
    final int currentPlayers = (room['currentPlayers'] as int?) ?? 0;
    final int maxPlayers = (room['maxPlayers'] as int?) ?? 4;

    if (currentPlayers >= maxPlayers) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Room is full!'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
      return;
    }

    // Navigate to 3D simulation
    Navigator.pushNamed(context, '/3d-simulation-gameplay');
  }

  void _handleQuickJoin() {
    final availableRoom = _availableRooms.where((room) {
      final int currentPlayers = (room['currentPlayers'] as int?) ?? 0;
      final int maxPlayers = (room['maxPlayers'] as int?) ?? 4;
      return currentPlayers < maxPlayers &&
          !(room['isPrivate'] as bool? ?? false);
    }).toList();

    if (availableRoom.isNotEmpty) {
      _handleJoinRoom(availableRoom.first);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No available rooms for quick join'),
        ),
      );
    }
  }

  void _handleQuickMatch() {
    // Simulate matchmaking
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 2.h),
            const Text('Finding players...'),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, '/3d-simulation-gameplay');
    });
  }

  void _handleCustomizeQuickMatch() {
    // Show quick match preferences
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quick match customization coming soon!'),
      ),
    );
  }

  void _handleStartSimulation() {
    Navigator.pushNamed(context, '/3d-simulation-gameplay');
  }

  void _handleRoomSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Room settings opened'),
      ),
    );
  }

  void _handleLeaveRoom() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Room'),
        content: const Text('Are you sure you want to leave the room?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _tabController.animateTo(0);
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  void _handleKickPlayer(String playerId) {
    setState(() {
      _currentRoomPlayers
          .removeWhere((player) => (player['id'] as String?) == playerId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Player removed from room'),
      ),
    );
  }

  void _handleSendMessage(String message) {
    setState(() {
      _chatMessages.add({
        'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
        'senderId': _currentUserId,
        'senderName': 'You',
        'content': message,
        'timestamp': DateTime.now(),
      });
    });
  }

  void _handleLobbySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lobby settings opened'),
      ),
    );
  }

  Future<void> _refreshRooms() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Simulate refreshing rooms
      _activePlayersCount = 127 + (DateTime.now().millisecond % 50);
    });
  }
}