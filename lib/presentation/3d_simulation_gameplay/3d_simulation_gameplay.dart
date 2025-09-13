import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_notification.dart';
import './widgets/disaster_intensity_meter.dart';
import './widgets/educational_hint_button.dart';
import './widgets/educational_info_overlay.dart';
import './widgets/pause_menu_overlay.dart';
import './widgets/time_progression_slider.dart';

class ThreeDSimulationGameplay extends StatefulWidget {
  const ThreeDSimulationGameplay({super.key});

  @override
  State<ThreeDSimulationGameplay> createState() =>
      _ThreeDSimulationGameplayState();
}

class _ThreeDSimulationGameplayState extends State<ThreeDSimulationGameplay>
    with TickerProviderStateMixin {
  // Simulation state
  bool _isSimulationPlaying = false;
  double _currentTime = 0.0;
  double _maxTime = 300.0; // 5 minutes simulation
  double _disasterIntensity = 0.3;
  String _currentDisaster = 'Earthquake';

  // UI state
  bool _isPaused = false;
  bool _showHUD = true;
  bool _hasNewHint = true;
  bool _showAchievement = false;
  bool _showEducationalOverlay = false;

  // Achievement data
  String _achievementTitle = '';
  String _achievementDescription = '';
  String _achievementIcon = '';

  // Educational overlay data
  String _educationalTitle = '';
  String _educationalContent = '';
  List<String> _educationalKeyPoints = [];
  String _educationalImageUrl = '';

  // Animation controllers
  late AnimationController _hudAnimationController;
  late Animation<double> _hudOpacityAnimation;

  // Mock simulation data
  final List<Map<String, dynamic>> _simulationData = [
    {
      "id": 1,
      "disaster": "Earthquake",
      "intensity": 0.3,
      "duration": 120,
      "description":
          "A moderate earthquake simulation showing P-wave and S-wave propagation through different geological layers.",
      "keyPoints": [
        "P-waves travel faster than S-waves through solid rock",
        "Seismic intensity decreases with distance from epicenter",
        "Building resonance frequency affects structural damage",
        "Liquefaction occurs in water-saturated sandy soils"
      ],
      "imageUrl":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000",
    },
    {
      "id": 2,
      "disaster": "Tsunami",
      "intensity": 0.7,
      "duration": 180,
      "description":
          "Tsunami wave generation and coastal impact simulation demonstrating wave physics and coastal engineering principles.",
      "keyPoints": [
        "Tsunami waves travel at speeds up to 800 km/h in deep ocean",
        "Wave height increases dramatically in shallow coastal waters",
        "Wavelength can exceed 200 kilometers in deep water",
        "Multiple wave trains arrive with varying amplitudes"
      ],
      "imageUrl":
          "https://images.unsplash.com/photo-1544551763-46a013bb70d5?fm=jpg&q=60&w=3000",
    },
    {
      "id": 3,
      "disaster": "Hurricane",
      "intensity": 0.8,
      "duration": 240,
      "description":
          "Hurricane formation and intensification showing atmospheric pressure systems and wind dynamics.",
      "keyPoints": [
        "Coriolis effect determines hurricane rotation direction",
        "Eye wall contains the strongest winds and lowest pressure",
        "Storm surge height depends on wind speed and coastal topography",
        "Hurricane categories based on sustained wind speeds"
      ],
      "imageUrl":
          "https://images.unsplash.com/photo-1527482797697-8795b05a13e1?fm=jpg&q=60&w=3000",
    }
  ];

  final List<Map<String, dynamic>> _achievements = [
    {
      "title": "Seismic Explorer",
      "description": "Discovered P-wave vs S-wave differences",
      "icon": "terrain",
      "unlocked": false,
    },
    {
      "title": "Wave Physics Master",
      "description": "Understood tsunami wave propagation",
      "icon": "waves",
      "unlocked": false,
    },
    {
      "title": "Storm Tracker",
      "description": "Analyzed hurricane eye wall dynamics",
      "icon": "cyclone",
      "unlocked": false,
    },
    {
      "title": "Disaster Scientist",
      "description": "Completed all natural disaster simulations",
      "icon": "science",
      "unlocked": false,
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupSimulation();
    _hideSystemUI();
  }

  void _initializeAnimations() {
    _hudAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _hudOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hudAnimationController,
      curve: Curves.easeInOut,
    ));

    _hudAnimationController.forward();
  }

  void _setupSimulation() {
    // Initialize with first disaster scenario
    final firstScenario = _simulationData.first;
    _currentDisaster = firstScenario['disaster'] as String;
    _disasterIntensity = (firstScenario['intensity'] as double);
    _maxTime = (firstScenario['duration'] as int).toDouble();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _showSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void dispose() {
    _hudAnimationController.dispose();
    _showSystemUI();
    super.dispose();
  }

  void _toggleSimulation() {
    setState(() {
      _isSimulationPlaying = !_isSimulationPlaying;
    });

    if (_isSimulationPlaying) {
      _startSimulationTimer();
    }
  }

  void _startSimulationTimer() {
    if (!_isSimulationPlaying) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && _isSimulationPlaying && !_isPaused) {
        setState(() {
          _currentTime += 1.0;

          // Simulate intensity changes over time
          final progress = _currentTime / _maxTime;
          if (progress < 0.3) {
            _disasterIntensity = 0.2 + (progress * 0.4);
          } else if (progress < 0.7) {
            _disasterIntensity = 0.6 + (progress * 0.3);
          } else {
            _disasterIntensity = 0.9 - ((progress - 0.7) * 0.4);
          }

          // Check for achievements
          _checkAchievements();

          if (_currentTime >= _maxTime) {
            _isSimulationPlaying = false;
            _showCompletionAchievement();
          }
        });

        if (_currentTime < _maxTime) {
          _startSimulationTimer();
        }
      }
    });
  }

  void _checkAchievements() {
    // Trigger achievements based on simulation progress
    final progress = _currentTime / _maxTime;

    if (progress > 0.25 && !_achievements[0]['unlocked']) {
      _unlockAchievement(0);
    } else if (progress > 0.5 && !_achievements[1]['unlocked']) {
      _unlockAchievement(1);
    } else if (progress > 0.75 && !_achievements[2]['unlocked']) {
      _unlockAchievement(2);
    }
  }

  void _unlockAchievement(int index) {
    final achievement = _achievements[index];
    setState(() {
      achievement['unlocked'] = true;
      _achievementTitle = achievement['title'] as String;
      _achievementDescription = achievement['description'] as String;
      _achievementIcon = achievement['icon'] as String;
      _showAchievement = true;
    });
  }

  void _showCompletionAchievement() {
    setState(() {
      _achievements[3]['unlocked'] = true;
      _achievementTitle = _achievements[3]['title'] as String;
      _achievementDescription = _achievements[3]['description'] as String;
      _achievementIcon = _achievements[3]['icon'] as String;
      _showAchievement = true;
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _toggleHUD() {
    setState(() {
      _showHUD = !_showHUD;
    });

    if (_showHUD) {
      _hudAnimationController.forward();
    } else {
      _hudAnimationController.reverse();
    }
  }

  void _showEducationalInfo() {
    final currentScenario = _simulationData.firstWhere(
      (scenario) => scenario['disaster'] == _currentDisaster,
      orElse: () => _simulationData.first,
    );

    setState(() {
      _educationalTitle = currentScenario['disaster'] as String;
      _educationalContent = currentScenario['description'] as String;
      _educationalKeyPoints =
          List<String>.from(currentScenario['keyPoints'] as List);
      _educationalImageUrl = currentScenario['imageUrl'] as String;
      _showEducationalOverlay = true;
      _hasNewHint = false;
    });
  }

  void _restartSimulation() {
    setState(() {
      _currentTime = 0.0;
      _isSimulationPlaying = false;
      _isPaused = false;
      _disasterIntensity = 0.3;
      _hasNewHint = true;
    });
  }

  void _exitToMenu() {
    _showSystemUI();
    Navigator.pushReplacementNamed(context, '/main-dashboard');
  }

  void _onTimeChanged(double newTime) {
    setState(() {
      _currentTime = newTime.clamp(0.0, _maxTime);

      // Update intensity based on new time
      final progress = _currentTime / _maxTime;
      if (progress < 0.3) {
        _disasterIntensity = 0.2 + (progress * 0.4);
      } else if (progress < 0.7) {
        _disasterIntensity = 0.6 + (progress * 0.3);
      } else {
        _disasterIntensity = 0.9 - ((progress - 0.7) * 0.4);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleHUD,
        onLongPress: _showEducationalInfo,
        child: Stack(
          children: [
            // 3D Simulation Viewport (Mock with gradient background)
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                    const Color(0xFF0F3460),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: _getDisasterIcon(),
                      color: Colors.white.withValues(alpha: 0.3),
                      size: 20.w,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '3D $_currentDisaster Simulation',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Tap to toggle HUD • Long press for info',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // HUD Elements
            if (_showHUD)
              AnimatedBuilder(
                animation: _hudOpacityAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _hudOpacityAnimation.value,
                    child: Stack(
                      children: [
                        // Disaster Intensity Meter
                        Positioned(
                          top: 8.h,
                          left: 4.w,
                          child: DisasterIntensityMeter(
                            intensity: _disasterIntensity,
                            disasterType: _currentDisaster,
                            onTap: _showEducationalInfo,
                          ),
                        ),

                        // Educational Hint Button
                        Positioned(
                          top: 8.h,
                          right: 4.w,
                          child: EducationalHintButton(
                            onTap: _showEducationalInfo,
                            hasNewHint: _hasNewHint,
                          ),
                        ),

                        // Time Progression Slider
                        Positioned(
                          bottom: 12.h,
                          left: 10.w,
                          right: 10.w,
                          child: TimeProgressionSlider(
                            currentTime: _currentTime,
                            maxTime: _maxTime,
                            onChanged: _onTimeChanged,
                            isPlaying: _isSimulationPlaying,
                            onPlayPause: _toggleSimulation,
                          ),
                        ),

                        // Pause/Menu Button
                        Positioned(
                          top: 8.h,
                          left: 50.w - 7.w,
                          child: GestureDetector(
                            onTap: _togglePause,
                            child: Container(
                              width: 14.w,
                              height: 14.w,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.surface
                                    .withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(7.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.shadowLight,
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: CustomIconWidget(
                                iconName: 'menu',
                                color: AppTheme.textHighEmphasisLight,
                                size: 6.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

            // Pause Menu Overlay
            PauseMenuOverlay(
              isVisible: _isPaused,
              onResume: _togglePause,
              onRestart: () {
                _togglePause();
                _restartSimulation();
              },
              onSettings: () {
                // Settings functionality would be implemented here
                _togglePause();
              },
              onExit: _exitToMenu,
            ),

            // Achievement Notification
            AchievementNotification(
              title: _achievementTitle,
              description: _achievementDescription,
              iconName: _achievementIcon,
              isVisible: _showAchievement,
              onDismiss: () {
                setState(() {
                  _showAchievement = false;
                });
              },
            ),

            // Educational Info Overlay
            EducationalInfoOverlay(
              title: _educationalTitle,
              content: _educationalContent,
              keyPoints: _educationalKeyPoints,
              imageUrl: _educationalImageUrl,
              isVisible: _showEducationalOverlay,
              onClose: () {
                setState(() {
                  _showEducationalOverlay = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getDisasterIcon() {
    switch (_currentDisaster.toLowerCase()) {
      case 'earthquake':
        return 'terrain';
      case 'tsunami':
        return 'waves';
      case 'hurricane':
        return 'cyclone';
      case 'volcano':
        return 'local_fire_department';
      case 'flood':
        return 'water';
      case 'drought':
        return 'wb_sunny';
      default:
        return 'warning';
    }
  }
}