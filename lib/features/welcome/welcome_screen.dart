import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/bloc/welcome_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../l10n/app_localizations.dart';
import '../auth/login_screen.dart';
import 'bloc/walkthrough_bloc.dart';
import 'model/walkthrough_model.dart';

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

    // Fetch walkthrough images from API
    context.read<WalkthroughBloc>().add(WalkthroughRequested());

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

  List<WelcomeContent> _mapWalkthroughToContent(List<WalkthroughItem> items) {
    final defaultContent = _getDefaultWelcomeContent();
    
    if (items.isEmpty) {
      return defaultContent;
    }

    return items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      
      if (index < defaultContent.length) {
        final defaultItem = defaultContent[index];
        return WelcomeContent(
          title: defaultItem.title,
          description: defaultItem.description,
          imagePath: item.wltImage.isNotEmpty ? item.wltImage : defaultItem.imagePath,
          subtitle: defaultItem.subtitle,
        );
      }
      
      return WelcomeContent(
        title: item.name,
        description: item.description,
        imagePath: item.wltImage.isNotEmpty ? item.wltImage : AssetsPath.screensBgImg,
      );
    }).toList();
  }

  List<WelcomeContent> _getDefaultWelcomeContent() {
    return [
      const WelcomeContent(
        title: "Zidd is the First Step— Success Follows",
        description: "Join thousands of determined NEET & JEE aspirants who started with just one thing: Zidd (Unstoppable Determination).",
        imagePath: "assets/images/welcome1_img.png",
      ),
      const WelcomeContent(
        title: "Live Classes & Strategy from NEET/JEE Experts",
        description: "Get guidance, clarity, and motivation from the best—every step of the way",
        imagePath: "assets/images/welcome2_img.png",
      ),
      const WelcomeContent(
        title: "Master Every Concept with Smart MCQs",
        description: "Practice chapter-wise MCQs, compete in All India challenges, test your preparation with full-length test series, and learn smart solving tricks from your mentors in live classes with a pool of more than 40,000 MCQs.",
        imagePath: "assets/images/welcome3_img.png",
      ),
      const WelcomeContent(
        title: "Track, Compete, Win!",
        description: "MCQs, test series, leaderboards that push you forward—every week",
        imagePath: "assets/images/welcome4_img.png",
      ),
      const WelcomeContent(
        title: "Beti Kafi Hai",
        subtitle: "OUR SOCIAL INITIATIVE TO EMPOWER GIRLS",
        description: "All girl students are eligible for a 50% scholarship on any course they choose. Prepare. Compete. Succeed.",
        imagePath: "assets/images/welcome5_img.png",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<WalkthroughBloc, WalkthroughState>(
        listener: (context, walkthroughState) {
          if (walkthroughState.status == WalkthroughStatus.success && walkthroughState.hasData) {
            final walkthroughItems = walkthroughState.data!.walkthroughList;
            final content = _mapWalkthroughToContent(walkthroughItems);
            context.read<WelcomeBloc>().add(LoadWelcomeContentWithData(content));
          } else if (walkthroughState.status == WalkthroughStatus.failure) {
            final defaultContent = _getDefaultWelcomeContent();
            context.read<WelcomeBloc>().add(LoadWelcomeContentWithData(defaultContent));
          }
        },
        builder: (context, walkthroughState) {
          return BlocListener<WelcomeBloc, WelcomeState>(
            listener: (context, state) {
              if (state is WelcomeChanged) {
                _imageAnimationController.reset();
                _imageAnimationController.forward();
                _contentAnimationController.reset();
                _contentAnimationController.forward();
              }
            },
            child: BlocBuilder<WelcomeBloc, WelcomeState>(
              builder: (context, state) {
                if (walkthroughState.status == WalkthroughStatus.loading ||
                    state is WelcomeInitial) {
                  return _buildShimmerLoader();
                }

                WelcomeContent currentContent;
                int currentIndex = 0;
                bool canGoNext = false;
                int totalItems = 0;

                if (state is WelcomeLoaded) {
                  currentContent = state.content[state.currentIndex];
                  currentIndex = state.currentIndex;
                  canGoNext = state.canGoNext;
                  totalItems = state.content.length;
                } else if (state is WelcomeChanged) {
                  currentContent = state.currentContent;
                  currentIndex = state.newIndex;
                  canGoNext = state.canGoNext;
                  totalItems = state.content.length;
                } else {
                  return _buildShimmerLoader();
                }

                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: AppColors.darkBlue,
                  child: SafeArea(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            AssetsPath.screensBgImg,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(height: 50.h),
                            Image.asset(
                              AssetsPath.appTitleLogo,
                              width: 122.w,
                              height: 40.h,
                            ),

                            Expanded(
                              child: AnimatedBuilder(
                                animation: _imageAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: 0.85 + (0.2 * _imageAnimation.value),
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: _buildImage(currentContent.imagePath),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Image.asset(
                            AssetsPath.bottomGradientImg,
                            width: double.infinity,
                            height: 150.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                          bottom: 15.h,
                          left: 0.w,
                          right: 0.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(totalItems, (index) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                                      width: index == currentIndex ? 24.w : 8.w,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        color: index == currentIndex
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(2.r),
                                      ),
                                    );
                                  }),
                                ),
                                SizedBox(height: 20.h),
                                CustomGradientButton(
                                  text: canGoNext
                                      ? '${AppLocalizations.of(context)?.next}'
                                      : '${AppLocalizations.of(context)?.getStarted}',
                                  onPressed: () {
                                    if (canGoNext) {
                                      context.read<WelcomeBloc>().add(NextWelcomeScreen());
                                    } else {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const LoginScreen(),
                                        ),
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
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: BoxFit.contain,
        placeholder: (context, url) => _buildImagePlaceholder(),
        errorWidget: (context, url, error) => _buildImageError(imagePath),
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 100),
      );
    } else {
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildImageError(imagePath),
      );
    }
  }

  Widget _buildImagePlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.08),
      highlightColor: Colors.white.withOpacity(0.2),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white.withOpacity(0.1),
      ),
    );
  }

  Widget _buildImageError(String imagePath) {
    final defaultContent = _getDefaultWelcomeContent();
    final fallbackIndex = defaultContent.indexWhere(
      (item) => item.imagePath == imagePath,
    );
    if (fallbackIndex >= 0) {
      return Image.asset(
        defaultContent[fallbackIndex].imagePath,
        fit: BoxFit.contain,
      );
    }
    return Image.asset(
      AssetsPath.screensBgImg,
      fit: BoxFit.contain,
    );
  }

  Widget _buildShimmerLoader() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.darkBlue,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AssetsPath.screensBgImg,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                SizedBox(height: 70.h),
                Image.asset(
                  AssetsPath.appTitleLogo,
                  width: 122.w,
                  height: 40.h,
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.white.withOpacity(0.08),
                    highlightColor: Colors.white.withOpacity(0.2),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
            Positioned(
              bottom: 15.h,
              left: 0.w,
              right: 0.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.white.withOpacity(0.08),
                          highlightColor: Colors.white.withOpacity(0.2),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            width: 8.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 20.h),
                    Shimmer.fromColors(
                      baseColor: Colors.white.withOpacity(0.08),
                      highlightColor: Colors.white.withOpacity(0.2),
                      child: Container(
                        height: 50.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
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
  }

}
