import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/bloc/welcome_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../l10n/app_localizations.dart';
import '../auth/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _imageAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _imageAnimation;
  late Animation<double> _contentAnimation;

  @override
  void initState() {
    super.initState();

    // Image transition animation
    _imageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Content animation
    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _imageAnimation = CurvedAnimation(
      parent: _imageAnimationController,
      curve: Curves.easeInOut,
    );

    _contentAnimation = CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeInOut,
    );

    // Load welcome content
    context.read<WelcomeBloc>().add(LoadWelcomeContent());

    // Start both animations
    _contentAnimationController.forward();
    _imageAnimationController.forward();
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<WelcomeBloc, WelcomeState>(
        listener: (context, state) {
          if (state is WelcomeChanged) {
            // Trigger image transition animation
            _imageAnimationController.reset();
            _imageAnimationController.forward();

            // Reset and restart content animation
            _contentAnimationController.reset();
            _contentAnimationController.forward();
          }
        },
        child: BlocConsumer<WelcomeBloc, WelcomeState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is WelcomeInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            WelcomeContent currentContent;
            int currentIndex = 0;
            bool canGoNext = false;

            if (state is WelcomeLoaded) {
              currentContent = state.content[state.currentIndex];
              currentIndex = state.currentIndex;
              canGoNext = state.canGoNext;
            } else if (state is WelcomeChanged) {
              currentContent = state.currentContent;
              currentIndex = state.newIndex;
              canGoNext = state.canGoNext;
            } else {
              return const Center(child: CircularProgressIndicator());
            }

            return Container(
              width: double.infinity,
              height: double.infinity,
              color: AppColors.darkBlue,
              child: Stack(
                children: [
                  // Background gradient
                  Positioned.fill(
                    child: Image.asset(
                      AssetsPath.screensBgImg,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),

                  // Main content
                  Column(
                    children: [
                      // Status bar spacing
                      SizedBox(height: 70.h),

                      // App logo
                      Image.asset(
                        AssetsPath.appTitleLogo,
                        width: 122.w,
                        height: 40.h,
                      ),

                      SizedBox(height: 10.h),

                      // Main image with transition animation - Full screen
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _imageAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 0.8 + (0.2 * _imageAnimation.value),
                              child: Opacity(
                                opacity: _imageAnimation.value,
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Image.asset(
                                    currentContent.imagePath,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  // Bottom Gradient View
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Image.asset(
                      AssetsPath.bottomGradientImg,
                      width: double.infinity,
                      height: 330.h,
                      fit: BoxFit.fill,
                    ),
                  ),

                  // Bottom section with indicators and button
                  Positioned(
                    bottom: 15.h,
                    left: 0.w,
                    right: 0.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Page indicators
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                width: index == currentIndex ? 24.w : 8.w,
                                height: 4.h,
                                decoration: BoxDecoration(
                                  color: index == currentIndex ? Colors.white : Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                              );
                            }),
                          ),

                          SizedBox(height: 20.h),

                          // Next button
                          CustomGradientButton(
                            text: canGoNext ? '${AppLocalizations.of(context)?.next}' : '${AppLocalizations.of(context)?.getStarted}',
                            onPressed: () {
                              if (canGoNext) {
                                context.read<WelcomeBloc>().add(NextWelcomeScreen());
                              } else {
                                // Navigate to login screen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
