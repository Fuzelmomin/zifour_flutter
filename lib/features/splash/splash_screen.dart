import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zifour_sourcecode/core/bloc/language_bloc.dart';
import 'package:zifour_sourcecode/features/language_selection/language_selection_screen.dart';
import '../../core/constants/assets_path.dart';
import '../../core/utils/user_preference.dart';
import '../challenger_zone/challenger_zone_screen.dart';
import '../courses/all_course_list_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../mentor/mentor_list_screen.dart';
import '../welcome/welcome_screen.dart';
import '../zifour_calender/zifour_calender_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late Animation<double> _logoAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Logo animation controller (scale and rotation)
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Fade animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Logo animation (scale from 0 to 1 with bounce effect)
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Fade animation for the logo
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    // Start fade animation first
    _fadeController.forward();
    
    // Wait a bit then start logo animation
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    
    // Navigate to next screen after splash delay
    await Future.delayed(const Duration(milliseconds: 3000));
    if (!mounted) return;
    await _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    final bool isLoggedIn = await UserPreference.isLoggedIn();
    if (!mounted) return;

    final Widget destination =
        isLoggedIn ? const DashboardScreen() : LanguageSelectionScreen();
        //isLoggedIn ? const DashboardScreen() : ChallengerZoneScreen();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Background SVG
            Positioned.fill(
              child: Image.asset(
                AssetsPath.splashBgImg,
                fit: BoxFit.cover,
              ),
            ),

            // Centered content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo
                  AnimatedBuilder(
                    animation: Listenable.merge([_logoAnimation, _fadeAnimation]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoAnimation.value,
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Container(
                            width: 120.w,
                            height: 120.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: Image.asset(
                                AssetsPath.appLogo,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 30.h),


                  // // Loading indicator
                  // AnimatedBuilder(
                  //   animation: _fadeAnimation,
                  //   builder: (context, child) {
                  //     return Opacity(
                  //       opacity: _fadeAnimation.value,
                  //       child: SizedBox(
                  //         width: 30.w,
                  //         height: 30.w,
                  //         child: CircularProgressIndicator(
                  //           strokeWidth: 2.0,
                  //           valueColor: AlwaysStoppedAnimation<Color>(
                  //             Colors.white.withOpacity(0.8),
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
