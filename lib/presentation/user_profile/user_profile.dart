import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_gallery_widget.dart';
import './widgets/progress_tracking_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/statistics_card_widget.dart';
import './widgets/user_header_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Mock user data
  final Map<String, dynamic> userData = {
    "id": 1,
    "username": "EarthGuardian",
    "title": "Disaster Response Expert",
    "avatar":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "level": 15,
    "experience": 2450,
    "nextLevelExp": 3000,
    "joinDate": DateTime.now().subtract(const Duration(days: 180)),
    "lastActive": DateTime.now().subtract(const Duration(minutes: 5)),
  };

  final List<Map<String, dynamic>> statisticsData = [
    {
      "icon": "access_time",
      "label": "Simulation Hours",
      "value": "127h",
      "color": Color(0xFF3498DB),
    },
    {
      "icon": "science",
      "label": "Disasters Mastered",
      "value": "8/12",
      "color": Color(0xFF2ECC71),
    },
    {
      "icon": "lightbulb",
      "label": "Facts Learned",
      "value": "342",
      "color": Color(0xFFF39C12),
    },
    {
      "icon": "emoji_events",
      "label": "Multiplayer Wins",
      "value": "23",
      "color": Color(0xFF9B59B6),
    },
    {
      "icon": "local_fire_department",
      "label": "Current Streak",
      "value": "12 days",
      "color": Color(0xFFFF6B35),
    },
    {
      "icon": "leaderboard",
      "label": "Global Rank",
      "value": "#1,247",
      "color": Color(0xFF1B365D),
    },
  ];

  final List<Map<String, dynamic>> achievementsData = [
    {
      "id": 1,
      "title": "Earthquake Expert",
      "description":
          "Master all earthquake simulation levels with perfect scores.",
      "icon": "terrain",
      "color": Color(0xFF8B4513),
      "rarity": "Epic",
      "unlocked": true,
      "criteria": "Complete all 15 earthquake levels with 95%+ accuracy",
      "unlockedDate": DateTime.now().subtract(Duration(days: 30)),
    },
    {
      "id": 2,
      "title": "Tsunami Survivor",
      "description":
          "Successfully navigate through all tsunami evacuation scenarios.",
      "icon": "waves",
      "color": Color(0xFF1E88E5),
      "rarity": "Legendary",
      "unlocked": true,
      "criteria": "Save 1000+ virtual lives in tsunami simulations",
      "unlockedDate": DateTime.now().subtract(Duration(days: 15)),
    },
    {
      "id": 3,
      "title": "Hurricane Hunter",
      "description":
          "Track and predict hurricane paths with exceptional accuracy.",
      "icon": "cyclone",
      "color": Color(0xFF43A047),
      "rarity": "Rare",
      "unlocked": false,
      "criteria": "Achieve 90%+ accuracy in 20 hurricane prediction challenges",
      "unlockedDate": null,
    },
    {
      "id": 4,
      "title": "Volcano Vigilant",
      "description":
          "Predict volcanic eruptions and coordinate emergency responses.",
      "icon": "local_fire_department",
      "color": Color(0xFFFF5722),
      "rarity": "Epic",
      "unlocked": true,
      "criteria": "Successfully predict 10 volcanic eruptions in simulation",
      "unlockedDate": DateTime.now().subtract(Duration(days: 7)),
    },
    {
      "id": 5,
      "title": "Flood Fighter",
      "description":
          "Design effective flood management and evacuation strategies.",
      "icon": "water",
      "color": Color(0xFF2196F3),
      "rarity": "Common",
      "unlocked": false,
      "criteria": "Complete flood management course with 85%+ score",
      "unlockedDate": null,
    },
  ];

  final List<Map<String, dynamic>> progressData = [
    {
      "category": "Earthquakes",
      "icon": "terrain",
      "color": Color(0xFF8B4513),
      "completion": 95.0,
      "skillRating": 5,
      "completedLevels": 14,
      "totalLevels": 15,
    },
    {
      "category": "Tsunamis",
      "icon": "waves",
      "color": Color(0xFF1E88E5),
      "completion": 88.0,
      "skillRating": 4,
      "completedLevels": 11,
      "totalLevels": 12,
    },
    {
      "category": "Hurricanes",
      "icon": "cyclone",
      "color": Color(0xFF43A047),
      "completion": 67.0,
      "skillRating": 3,
      "completedLevels": 8,
      "totalLevels": 12,
    },
    {
      "category": "Volcanoes",
      "icon": "local_fire_department",
      "color": Color(0xFFFF5722),
      "completion": 75.0,
      "skillRating": 4,
      "completedLevels": 9,
      "totalLevels": 12,
    },
    {
      "category": "Floods",
      "icon": "water",
      "color": Color(0xFF2196F3),
      "completion": 42.0,
      "skillRating": 2,
      "completedLevels": 5,
      "totalLevels": 12,
    },
    {
      "category": "Droughts",
      "icon": "wb_sunny",
      "color": Color(0xFFFFC107),
      "completion": 25.0,
      "skillRating": 1,
      "completedLevels": 3,
      "totalLevels": 12,
    },
  ];

  final List<Map<String, dynamic>> recentActivities = [
    {
      "id": 1,
      "type": "simulation",
      "title": "Earthquake Level 14 Completed",
      "description":
          "Achieved 98% accuracy in San Francisco earthquake simulation",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "points": 150,
    },
    {
      "id": 2,
      "type": "achievement",
      "title": "Volcano Vigilant Unlocked",
      "description": "Successfully predicted 10 volcanic eruptions",
      "timestamp": DateTime.now().subtract(Duration(hours: 5)),
      "points": 500,
    },
    {
      "id": 3,
      "type": "encyclopedia",
      "title": "Seismic Waves Article Read",
      "description": "Learned about P-waves, S-waves, and surface waves",
      "timestamp": DateTime.now().subtract(Duration(hours: 8)),
      "points": 25,
    },
    {
      "id": 4,
      "type": "multiplayer",
      "title": "Disaster Response Challenge Won",
      "description": "Led team to victory in tsunami evacuation scenario",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "points": 200,
    },
    {
      "id": 5,
      "type": "level_up",
      "title": "Reached Level 15",
      "description": "Unlocked advanced hurricane tracking simulations",
      "timestamp": DateTime.now().subtract(Duration(days: 2)),
      "points": 1000,
    },
    {
      "id": 6,
      "type": "simulation",
      "title": "Hurricane Path Prediction",
      "description": "Completed Category 4 hurricane tracking exercise",
      "timestamp": DateTime.now().subtract(Duration(days: 3)),
      "points": 120,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showShareProfile,
            icon: CustomIconWidget(
              iconName: 'share',
              color: colorScheme.onSurface,
              size: 6.w,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Export Data'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help),
                    SizedBox(width: 8),
                    Text('Help'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          indicatorColor: colorScheme.primary,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Progress'),
            Tab(text: 'Achievements'),
            Tab(text: 'Activity'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            )
          : Column(
              children: [
                UserHeaderWidget(userData: userData),
                SizedBox(height: 2.h),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(),
                      _buildProgressTab(),
                      _buildAchievementsTab(),
                      _buildActivityTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          StatisticsCardWidget(statistics: statisticsData),
          SizedBox(height: 3.h),
          RecentActivityWidget(activities: recentActivities),
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          ProgressTrackingWidget(progressData: progressData),
          SizedBox(height: 3.h),
          _buildLearningRecommendations(),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          AchievementGalleryWidget(achievements: achievementsData),
          SizedBox(height: 3.h),
          _buildAchievementStats(),
        ],
      ),
    );
  }

  Widget _buildActivityTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          RecentActivityWidget(activities: recentActivities),
          SizedBox(height: 3.h),
          _buildActivityCalendar(),
        ],
      ),
    );
  }

  Widget _buildLearningRecommendations() {
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
          Text(
            'Recommended Learning',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          _buildRecommendationCard(
            'Complete Flood Management Course',
            'Boost your flood disaster skills to level 3',
            Icons.water,
            const Color(0xFF2196F3),
            () => Navigator.pushNamed(context, '/disaster-selection'),
          ),
          SizedBox(height: 2.h),
          _buildRecommendationCard(
            'Hurricane Prediction Challenge',
            'Unlock Hurricane Hunter achievement',
            Icons.cyclone,
            const Color(0xFF43A047),
            () => Navigator.pushNamed(context, '/3d-simulation-gameplay'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(2.w),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 5.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: color,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementStats() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final unlockedCount =
        achievementsData.where((a) => a["unlocked"] as bool).length;
    final totalCount = achievementsData.length;

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
          Text(
            'Achievement Statistics',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Unlocked',
                  unlockedCount.toString(),
                  AppTheme.successLight,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  'Remaining',
                  (totalCount - unlockedCount).toString(),
                  AppTheme.warningLight,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  'Completion',
                  '${((unlockedCount / totalCount) * 100).toStringAsFixed(0)}%',
                  colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCalendar() {
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
          Text(
            'Activity Streak',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.successLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'local_fire_department',
                  color: AppTheme.successLight,
                  size: 6.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  '12 Day Streak!',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.successLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Keep up the great work! Complete a simulation today to maintain your streak.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showShareProfile() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: colorScheme.outline,
                borderRadius: BorderRadius.circular(0.5.h),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Share Profile',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'copy',
                color: colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Copy Profile Link'),
              onTap: () {
                Clipboard.setData(const ClipboardData(
                  text: 'https://terrapulse.app/profile/earthguardian',
                ));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile link copied!')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Share Achievements'),
              onTap: () {
                Navigator.pop(context);
                // Platform-specific sharing would be implemented here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sharing achievements...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'settings':
        Navigator.pushNamed(context, '/main-dashboard');
        break;
      case 'export':
        _exportLearningData();
        break;
      case 'help':
        _showHelpDialog();
        break;
    }
  }

  void _exportLearningData() {
    setState(() => _isLoading = true);

    // Simulate export process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Learning report exported successfully!'),
          backgroundColor: AppTheme.successLight,
        ),
      );
    });
  }

  void _showHelpDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        title: const Text('Profile Help'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your profile tracks your learning journey through natural disaster simulations.',
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              '• Overview: View your key statistics and recent activity',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              '• Progress: Track mastery across disaster categories',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              '• Achievements: Unlock badges by completing challenges',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              '• Activity: See your complete learning history',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
