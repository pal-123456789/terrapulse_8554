import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/continue_learning_widget.dart';
import './widgets/daily_challenge_widget.dart';
import './widgets/disaster_card_widget.dart';
import './widgets/hero_section_widget.dart';
import './widgets/progress_tracking_widget.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;

  // Mock data
  final List<Map<String, dynamic>> disasterTypes = [
    {
      "id": 1,
      "name": "Earthquake",
      "description":
          "Learn about seismic activities and tectonic plate movements",
      "iconName": "vibration",
      "difficulty": "Medium",
      "completionPercentage": 75,
      "estimatedTime": "15 min",
      "image":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 2,
      "name": "Tsunami",
      "description": "Explore massive ocean waves and their devastating impact",
      "iconName": "waves",
      "difficulty": "Hard",
      "completionPercentage": 45,
      "estimatedTime": "20 min",
      "image":
          "https://images.unsplash.com/photo-1544551763-46a013bb70d5?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 3,
      "name": "Hurricane",
      "description":
          "Understand tropical cyclones and extreme weather patterns",
      "iconName": "cyclone",
      "difficulty": "Medium",
      "completionPercentage": 90,
      "estimatedTime": "18 min",
      "image":
          "https://images.unsplash.com/photo-1527482797697-8795b05a13e1?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 4,
      "name": "Volcanic Eruption",
      "description": "Discover the power of volcanic activities and lava flows",
      "iconName": "local_fire_department",
      "difficulty": "Hard",
      "completionPercentage": 30,
      "estimatedTime": "25 min",
      "image":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 5,
      "name": "Flood",
      "description":
          "Study water-related disasters and their environmental impact",
      "iconName": "water_damage",
      "difficulty": "Easy",
      "completionPercentage": 100,
      "estimatedTime": "12 min",
      "image":
          "https://images.unsplash.com/photo-1547036967-23d11aacaee0?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 6,
      "name": "Drought",
      "description": "Learn about water scarcity and climate change effects",
      "iconName": "wb_sunny",
      "difficulty": "Easy",
      "completionPercentage": 60,
      "estimatedTime": "10 min",
      "image":
          "https://images.unsplash.com/photo-1516298773066-c48f8e9bd92b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
  ];

  final Map<String, dynamic> progressData = {
    "learningStreak": 7,
    "disastersMastered": 12,
    "factsDiscovered": 156,
    "currentLevel": 8,
    "overallProgress": 68,
  };

  final Map<String, dynamic> dailyChallenge = {
    "title": "Master the Richter Scale",
    "description":
        "Complete 3 earthquake simulations and identify magnitude levels correctly",
    "rewardPoints": 250,
    "timeRemaining": "14h 32m",
    "progress": 1,
    "target": 3,
  };

  final List<Map<String, dynamic>> recentContent = [
    {
      "id": 1,
      "title": "Tsunami Formation Basics",
      "description":
          "Understanding how underwater earthquakes create massive waves",
      "type": "Simulation",
      "lastAccessed": "2 hours ago",
      "thumbnail":
          "https://images.unsplash.com/photo-1544551763-46a013bb70d5?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 2,
      "title": "Volcanic Activity Encyclopedia",
      "description":
          "Comprehensive guide to different types of volcanic eruptions",
      "type": "Encyclopedia",
      "lastAccessed": "1 day ago",
      "thumbnail":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 3,
      "title": "Hurricane Eye Challenge",
      "description": "Navigate through the eye of a Category 5 hurricane",
      "type": "Challenge",
      "lastAccessed": "3 days ago",
      "thumbnail":
          "https://images.unsplash.com/photo-1527482797697-8795b05a13e1?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
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

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _showDisasterQuickActions(
      BuildContext context, Map<String, dynamic> disaster) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              disaster["name"] as String,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    context,
                    icon: 'bookmark',
                    label: 'Bookmark',
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildQuickActionButton(
                    context,
                    icon: 'share',
                    label: 'Share',
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildQuickActionButton(
                    context,
                    icon: 'info',
                    label: 'Details',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/disaster-selection');
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: colorScheme.primary,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.1),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'person',
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back!",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    "Level ${progressData["currentLevel"]} Explorer",
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/user-profile'),
            icon: CustomIconWidget(
              iconName: 'settings',
              color: colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: Column(
          children: [
            // Tab Bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: TabBar(
                controller: _tabController,
                labelColor: colorScheme.primary,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                indicatorColor: colorScheme.primary,
                indicatorWeight: 2,
                labelStyle: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
                tabs: const [
                  Tab(text: "Dashboard"),
                  Tab(text: "Play"),
                  Tab(text: "Encyclopedia"),
                  Tab(text: "Profile"),
                ],
              ),
            ),
            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Dashboard Tab
                  _buildDashboardTab(),
                  // Play Tab
                  _buildPlayTab(),
                  // Encyclopedia Tab
                  _buildEncyclopediaTab(),
                  // Profile Tab
                  _buildProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/disaster-selection'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'play_arrow',
          color: colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          "Start New Simulation",
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          // Hero Section
          const HeroSectionWidget(),
          SizedBox(height: 2.h),
          // Disaster Types Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Disaster Simulations",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/disaster-selection'),
                  child: Text(
                    "View All",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 32.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: disasterTypes.length,
              itemBuilder: (context, index) {
                final disaster = disasterTypes[index];
                return DisasterCardWidget(
                  disaster: disaster,
                  onTap: () =>
                      Navigator.pushNamed(context, '/3d-simulation-gameplay'),
                  onLongPress: () =>
                      _showDisasterQuickActions(context, disaster),
                );
              },
            ),
          ),
          SizedBox(height: 2.h),
          // Daily Challenge
          DailyChallengeWidget(
            challengeData: dailyChallenge,
            onTap: () =>
                Navigator.pushNamed(context, '/3d-simulation-gameplay'),
          ),
          SizedBox(height: 2.h),
          // Progress Tracking
          ProgressTrackingWidget(progressData: progressData),
          SizedBox(height: 2.h),
          // Continue Learning
          ContinueLearningWidget(recentContent: recentContent),
          SizedBox(height: 10.h), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildPlayTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              "Choose Your Adventure",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 0.8,
            ),
            itemCount: disasterTypes.length,
            itemBuilder: (context, index) {
              final disaster = disasterTypes[index];
              return GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, '/3d-simulation-gameplay'),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .shadow
                            .withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: CustomImageWidget(
                            imageUrl: disaster["image"] as String,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                disaster["name"] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                "${disaster["completionPercentage"]}% Complete",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildEncyclopediaTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              "Scientific Knowledge Base",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: recentContent.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final content = recentContent[index];
              return GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, '/disaster-selection'),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .shadow
                            .withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomImageWidget(
                            imageUrl: content["thumbnail"] as String,
                            width: 20.w,
                            height: 20.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              content["title"] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              content["description"] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          // Progress Tracking
          ProgressTrackingWidget(progressData: progressData),
          SizedBox(height: 2.h),
          // Quick Actions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Quick Actions",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildProfileActionCard(
                        context,
                        icon: 'person',
                        title: 'View Profile',
                        onTap: () =>
                            Navigator.pushNamed(context, '/user-profile'),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _buildProfileActionCard(
                        context,
                        icon: 'group',
                        title: 'Multiplayer',
                        onTap: () =>
                            Navigator.pushNamed(context, '/multiplayer-lobby'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildProfileActionCard(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
