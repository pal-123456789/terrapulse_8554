import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/loading_indicator_widget.dart';
import './widgets/particle_background_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<Color?> _backgroundAnimation;

  double _loadingProgress = 0.0;
  String _loadingText = 'Initializing 3D Engine...';
  bool _isInitialized = false;

  final List<Map<String, dynamic>> _loadingSteps = [
    {'text': 'Initializing 3D Engine...', 'duration': 800},
    {'text': 'Loading Unity Assets...', 'duration': 600},
    {'text': 'Preparing Disaster Simulations...', 'duration': 700},
    {'text': 'Checking User Preferences...', 'duration': 500},
    {'text': 'Ready to Launch!', 'duration': 400},
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startLoadingSequence();
    _hideSystemUI();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _backgroundAnimation = ColorTween(
      begin: const Color(0xFF0A0A0A),
      end: const Color(0xFF1B365D),
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _backgroundController.forward();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  void _restoreSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
  }

  Future<void> _startLoadingSequence() async {
    double progressStep = 1.0 / _loadingSteps.length;

    for (int i = 0; i < _loadingSteps.length; i++) {
      if (mounted) {
        setState(() {
          _loadingText = _loadingSteps[i]['text'];
          _loadingProgress = (i + 1) * progressStep;
        });
      }

      await Future.delayed(
          Duration(milliseconds: _loadingSteps[i]['duration']));
    }

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });

      await Future.delayed(const Duration(milliseconds: 500));
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() {
    _restoreSystemUI();

    // Check if user is returning or new user
    final bool isReturningUser = _checkUserStatus();

    if (isReturningUser) {
      Navigator.pushReplacementNamed(context, '/main-dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/main-dashboard');
    }
  }

  bool _checkUserStatus() {
    // Mock user status check - in real app, check SharedPreferences
    return true; // Assuming returning user for demo
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _restoreSystemUI();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _backgroundAnimation.value ?? const Color(0xFF0A0A0A),
                  const Color(0xFF0A0A0A),
                  const Color(0xFF1A1A1A),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Particle background effect
                  const Positioned.fill(
                    child: ParticleBackgroundWidget(),
                  ),

                  // Main content
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),

                        // Animated logo
                        const AnimatedLogoWidget(),

                        const Spacer(flex: 1),

                        // Loading indicator
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: LoadingIndicatorWidget(
                            loadingText: _loadingText,
                            progress: _loadingProgress,
                          ),
                        ),

                        const Spacer(flex: 2),
                      ],
                    ),
                  ),

                  // Version info at bottom
                  Positioned(
                    bottom: 4.h,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          'Version 1.0.0',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 2.5.w > 11 ? 11 : 2.5.w,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '© 2025 TerraPulse - Educational Gaming',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 2.2.w > 10 ? 10 : 2.2.w,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Emergency skip button (for development/testing)
                  if (!_isInitialized)
                    Positioned(
                      top: 6.h,
                      right: 4.w,
                      child: GestureDetector(
                        onTap: _navigateToNextScreen,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Skip',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 2.8.w > 12 ? 12 : 2.8.w,
                                ),
                              ),
                              SizedBox(width: 1.w),
                              CustomIconWidget(
                                iconName: 'arrow_forward',
                                color: Colors.white.withValues(alpha: 0.8),
                                size: 3.w > 14 ? 14 : 3.w,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
