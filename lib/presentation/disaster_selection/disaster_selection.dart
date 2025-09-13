import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/disaster_card_widget.dart';
import './widgets/disaster_detail_modal_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/search_bar_widget.dart';

class DisasterSelection extends StatefulWidget {
  const DisasterSelection({super.key});

  @override
  State<DisasterSelection> createState() => _DisasterSelectionState();
}

class _DisasterSelectionState extends State<DisasterSelection>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _searchQuery = '';
  Map<String, dynamic> _currentFilters = {
    'difficulty': 'all',
    'duration': 'all',
    'status': 'all',
    'category': 'all',
  };

  List<Map<String, dynamic>> _filteredDisasters = [];

  final List<Map<String, dynamic>> _disasters = [
    {
      "id": 1,
      "name": "Earthquake Simulation",
      "description":
          """Experience the devastating power of seismic activity through realistic earthquake simulations. Learn about tectonic plate movements, fault lines, and the science behind ground shaking. Understand how buildings respond to different magnitudes and frequencies of seismic waves.""",
      "difficulty": 3,
      "duration": "25-35 min",
      "category": "Geological",
      "imageUrl":
          "https://images.pexels.com/photos/1108572/pexels-photo-1108572.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isLocked": false,
      "completionStatus": "completed",
      "learningObjectives": [
        "Understand seismic wave propagation and ground motion",
        "Learn about earthquake magnitude scales and measurement",
        "Explore building design for earthquake resistance",
        "Analyze the relationship between fault types and earthquake patterns"
      ]
    },
    {
      "id": 2,
      "name": "Tsunami Wave Dynamics",
      "description":
          """Dive deep into the physics of tsunami generation and propagation across ocean basins. Explore how underwater earthquakes, volcanic eruptions, and landslides create these massive waves. Study wave behavior, coastal impact, and early warning systems.""",
      "difficulty": 4,
      "duration": "40-50 min",
      "category": "Hydrological",
      "imageUrl":
          "https://images.pexels.com/photos/1001682/pexels-photo-1001682.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isLocked": false,
      "completionStatus": "progress",
      "learningObjectives": [
        "Understand tsunami generation mechanisms",
        "Study wave propagation across ocean basins",
        "Learn about coastal inundation patterns",
        "Explore early warning system technologies"
      ]
    },
    {
      "id": 3,
      "name": "Hurricane Formation",
      "description":
          """Witness the birth and evolution of tropical cyclones in this immersive meteorological simulation. Study atmospheric conditions, wind patterns, and the role of ocean temperatures in hurricane development. Experience the eye wall dynamics and storm surge phenomena.""",
      "difficulty": 5,
      "duration": "45-60 min",
      "category": "Meteorological",
      "imageUrl":
          "https://images.pexels.com/photos/1446076/pexels-photo-1446076.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isLocked": true,
      "lockReason": "Complete 2 intermediate disasters to unlock",
      "completionStatus": "not_started",
      "learningObjectives": [
        "Study tropical cyclone formation conditions",
        "Understand Coriolis effect and wind circulation",
        "Learn about storm surge and coastal flooding",
        "Explore hurricane tracking and prediction methods"
      ]
    },
    {
      "id": 4,
      "name": "Volcanic Eruption",
      "description":
          """Experience the raw power of volcanic activity through detailed magma dynamics simulation. Learn about different eruption types, lava flows, and pyroclastic phenomena. Study the geological processes that lead to volcanic activity.""",
      "difficulty": 4,
      "duration": "35-45 min",
      "category": "Geological",
      "imageUrl":
          "https://images.pexels.com/photos/1666021/pexels-photo-1666021.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isLocked": true,
      "lockReason": "Complete 3 earthquake levels to unlock",
      "completionStatus": "not_started",
      "learningObjectives": [
        "Understand magma formation and composition",
        "Study different types of volcanic eruptions",
        "Learn about pyroclastic flows and lava dynamics",
        "Explore volcanic hazard assessment methods"
      ]
    },
    {
      "id": 5,
      "name": "Flash Flood Dynamics",
      "description":
          """Explore rapid water flow dynamics in urban and natural environments. Study rainfall patterns, watershed behavior, and flood propagation through different terrains. Learn about flood prediction and mitigation strategies.""",
      "difficulty": 2,
      "duration": "20-30 min",
      "category": "Hydrological",
      "imageUrl":
          "https://images.pexels.com/photos/552789/pexels-photo-552789.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isLocked": false,
      "completionStatus": "not_started",
      "learningObjectives": [
        "Study rapid water flow dynamics",
        "Understand watershed and drainage systems",
        "Learn about urban flood management",
        "Explore early warning and evacuation procedures"
      ]
    },
    {
      "id": 6,
      "name": "Wildfire Spread",
      "description":
          """Analyze fire behavior and spread patterns through different vegetation types and weather conditions. Study combustion science, wind effects, and terrain influence on fire propagation. Learn about fire suppression techniques and prevention strategies.""",
      "difficulty": 3,
      "duration": "30-40 min",
      "category": "Climatological",
      "imageUrl":
          "https://images.pexels.com/photos/1112080/pexels-photo-1112080.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isLocked": false,
      "completionStatus": "completed",
      "learningObjectives": [
        "Understand fire behavior and spread mechanics",
        "Study weather influence on fire propagation",
        "Learn about vegetation types and fire susceptibility",
        "Explore firefighting strategies and techniques"
      ]
    },
    {
      "id": 7,
      "name": "Tornado Formation",
      "description":
          """Experience the formation of tornadoes through detailed atmospheric simulation. Study supercell thunderstorms, wind shear, and the conditions that create these powerful vortices. Learn about tornado classification and damage assessment.""",
      "difficulty": 5,
      "duration": "35-45 min",
      "category": "Meteorological",
      "imageUrl":
          "https://images.pexels.com/photos/1119974/pexels-photo-1119974.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isLocked": true,
      "lockReason": "Complete hurricane simulation first",
      "completionStatus": "not_started",
      "learningObjectives": [
        "Study supercell thunderstorm dynamics",
        "Understand wind shear and vortex formation",
        "Learn about tornado classification systems",
        "Explore storm chasing and safety procedures"
      ]
    },
    {
      "id": 8,
      "name": "Drought Conditions",
      "description":
          """Explore long-term climate patterns and water scarcity through comprehensive drought simulation. Study precipitation patterns, soil moisture, and agricultural impacts. Learn about drought monitoring and water resource management.""",
      "difficulty": 2,
      "duration": "25-35 min",
      "category": "Climatological",
      "imageUrl":
          "https://images.pexels.com/photos/1423600/pexels-photo-1423600.jpeg?auto=compress&cs=tinysrgb&w=800",
      "isLocked": false,
      "completionStatus": "progress",
      "learningObjectives": [
        "Understand long-term climate patterns",
        "Study soil moisture and evapotranspiration",
        "Learn about agricultural drought impacts",
        "Explore water conservation strategies"
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _filteredDisasters = List.from(_disasters);
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _filterDisasters() {
    setState(() {
      _filteredDisasters = _disasters.where((disaster) {
        // Search query filter
        if (_searchQuery.isNotEmpty) {
          final name = (disaster["name"] as String).toLowerCase();
          final category = (disaster["category"] as String).toLowerCase();
          final query = _searchQuery.toLowerCase();

          if (!name.contains(query) && !category.contains(query)) {
            return false;
          }
        }

        // Difficulty filter
        if (_currentFilters['difficulty'] != 'all') {
          final difficulty = disaster["difficulty"] as int;
          switch (_currentFilters['difficulty']) {
            case 'beginner':
              if (difficulty > 2) return false;
              break;
            case 'intermediate':
              if (difficulty != 3) return false;
              break;
            case 'advanced':
              if (difficulty < 4) return false;
              break;
          }
        }

        // Duration filter
        if (_currentFilters['duration'] != 'all') {
          final duration = disaster["duration"] as String;
          switch (_currentFilters['duration']) {
            case 'quick':
              if (!duration.contains('15-') &&
                  !duration.contains('20-') &&
                  !duration.contains('25-')) {
                return false;
              }
              break;
            case 'medium':
              if (!duration.contains('30-') && !duration.contains('35-')) {
                return false;
              }
              break;
            case 'long':
              if (!duration.contains('40-') &&
                  !duration.contains('45-') &&
                  !duration.contains('50-') &&
                  !duration.contains('60')) {
                return false;
              }
              break;
          }
        }

        // Status filter
        if (_currentFilters['status'] != 'all') {
          final status = disaster["completionStatus"] as String;
          if (status != _currentFilters['status']) return false;
        }

        // Category filter
        if (_currentFilters['category'] != 'all') {
          final category = (disaster["category"] as String).toLowerCase();
          if (category != _currentFilters['category']) return false;
        }

        return true;
      }).toList();
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _currentFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _currentFilters = filters;
          });
          _filterDisasters();
        },
      ),
    );
  }

  void _showDisasterDetail(Map<String, dynamic> disaster) {
    if (disaster["isLocked"] == true) return;

    showDialog(
      context: context,
      builder: (context) => DisasterDetailModalWidget(
        disaster: disaster,
        onStartSimulation: () {
          Navigator.pushNamed(context, '/3d-simulation-gameplay');
        },
      ),
    );
  }

  void _showContextMenu(Map<String, dynamic> disaster) {
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildContextMenu(disaster),
    );
  }

  Widget _buildContextMenu(Map<String, dynamic> disaster) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              disaster["name"] as String,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Divider(height: 1, color: colorScheme.outline.withValues(alpha: 0.2)),
          _buildContextMenuItem(
            icon: 'favorite_border',
            title: 'Add to Favorites',
            onTap: () {
              Navigator.pop(context);
              // Add to favorites functionality
            },
            theme: theme,
          ),
          _buildContextMenuItem(
            icon: 'info_outline',
            title: 'View Educational Content',
            onTap: () {
              Navigator.pop(context);
              // Show educational content
            },
            theme: theme,
          ),
          _buildContextMenuItem(
            icon: 'check_circle_outline',
            title: 'Check Prerequisites',
            onTap: () {
              Navigator.pop(context);
              // Show prerequisites
            },
            theme: theme,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: theme.colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium,
      ),
      onTap: onTap,
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
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Disaster Selection',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              SearchBarWidget(
                hintText: 'Search disasters...',
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                  _filterDisasters();
                },
                onFilterTap: _showFilterBottomSheet,
              ),
              Expanded(
                child: _filteredDisasters.isEmpty
                    ? _buildEmptyState(theme)
                    : _buildDisasterGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: theme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No disasters found',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Try adjusting your search or filters',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisasterGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        final childAspectRatio = constraints.maxWidth > 600 ? 0.8 : 0.75;

        return GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 2.w,
            mainAxisSpacing: 2.w,
          ),
          itemCount: _filteredDisasters.length,
          itemBuilder: (context, index) {
            final disaster = _filteredDisasters[index];
            return DisasterCardWidget(
              disaster: disaster,
              isLocked: disaster["isLocked"] as bool,
              onTap: () => _showDisasterDetail(disaster),
              onLongPress: () => _showContextMenu(disaster),
            );
          },
        );
      },
    );
  }
}