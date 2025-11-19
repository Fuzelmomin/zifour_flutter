import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/be_ziddi_item_widget.dart';
import '../../core/widgets/courses_item_widget.dart';
import '../../core/widgets/custom_drawer.dart';
import '../../core/widgets/home_app_bar.dart';
import '../../core/widgets/home_options_item.dart';
import '../../core/widgets/mentors_item_widget.dart';
import '../../core/widgets/title_view_row_widget.dart';
import '../../l10n/app_localizations.dart';
import '../al_based_performance/al_based_performanc_screen.dart';
import '../challenger_zone/challenger_zone_screen.dart';
import '../courses/all_course_list_screen.dart';
import '../doubts/ask_doubts_screen.dart';
import '../india_test_series/all_india_test_series_screen.dart';
import '../learning_course/learning_course_screen.dart';
import '../live_class/live_class_screen.dart';
import '../mentor/mentor_list_screen.dart';
import '../practics_mcq/practice_subject_screen.dart';
import 'bloc/home_bloc.dart';
import 'models/home_model.dart';
import 'video_player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  final BehaviorSubject<int> _bannerIndex = BehaviorSubject<int>.seeded(0);
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<HomeBloc>();
      if (bloc.state.status == HomeStatus.initial) {
        bloc.add(const HomeRequested());
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels == 0) {
      final state = context.read<HomeBloc>().state;
      if (state.status == HomeStatus.success) {
        context.read<HomeBloc>().add(const HomeRequested(forceRefresh: true));
      }
    }
  }

  void _startBannerAutoScroll(List<HomeSlider> sliders) {
    _bannerTimer?.cancel();
    if (sliders.isEmpty || !mounted) return;

    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || sliders.isEmpty) {
        timer.cancel();
        return;
      }
      final currentIndex = _bannerIndex.value;
      final nextIndex = (currentIndex + 1) % sliders.length;
      _bannerIndex.add(nextIndex);
      if (_bannerController.hasClients) {
        _bannerController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _bannerIndex.close();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    final completer = Completer<void>();
    context.read<HomeBloc>().add(HomeRequested(forceRefresh: true, completer: completer));
    try {
      await completer.future;
    } catch (e) {
      // Error handled by bloc
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.status == HomeStatus.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
              ),
            );
          }
          if (state.status == HomeStatus.success && state.data != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _startBannerAutoScroll(state.data!.sliders);
            });
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const CustomDrawer(),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.darkBlue,
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: AppColors.pinkColor,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            AssetsPath.homeImgBg,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        state.showSkeleton
                            ? Shimmer.fromColors(
                                baseColor: AppColors.selectedBoxColor,
                                highlightColor: Colors.white.withOpacity(0.1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.h,
                                        horizontal: 15.w,
                                      ).copyWith(top: 20.h),
                                      child: HomeAppBar(
                                        profileImg: '',
                                        profileClick: () {
                                          _scaffoldKey.currentState?.openDrawer();
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    _buildBannerSection(state),
                                    SizedBox(height: 15.h),
                                    _buildTrendingCoursesSection(state),
                                    SizedBox(height: 20.h),
                                    _buildMentorsSection(state),
                                    SizedBox(height: 25.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [BeZiddiItemWidget()],
                                    ),
                                    SizedBox(height: 20.h),
                                    _buildHomeOptionSection(),
                                    SizedBox(height: 20.h),
                                  ],
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                      horizontal: 15.w,
                                    ).copyWith(top: 20.h),
                                    child: HomeAppBar(
                                      profileImg: '',
                                      profileClick: () {
                                        _scaffoldKey.currentState?.openDrawer();
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  if (state.data?.sliders.isNotEmpty ?? false)
                                    _buildBannerSection(state),
                                  if (state.data?.sliders.isNotEmpty ?? false)
                                    SizedBox(height: 15.h),
                                  if (state.data?.packages.isNotEmpty ?? false)
                                    _buildTrendingCoursesSection(state),
                                  if (state.data?.packages.isNotEmpty ?? false)
                                    SizedBox(height: 20.h),
                                  if (state.data?.mentorVideos.isNotEmpty ?? false)
                                    _buildMentorsSection(state),
                                  if (state.data?.mentorVideos.isNotEmpty ?? false)
                                    SizedBox(height: 25.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [BeZiddiItemWidget()],
                                  ),
                                  SizedBox(height: 20.h),
                                  _buildHomeOptionSection(),
                                  SizedBox(height: 20.h),
                                ],
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
    );
  }

  Widget _buildBannerSection(HomeState state) {
    final sliders = state.data?.sliders ?? [];
    
    if (state.showSkeleton) {
      return Column(
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.selectedBoxColor,
            highlightColor: Colors.white.withOpacity(0.2),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              height: 200.h,
              decoration: BoxDecoration(
                color: AppColors.selectedBoxColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) => Shimmer.fromColors(
              baseColor: Colors.white.withOpacity(0.3),
              highlightColor: Colors.white.withOpacity(0.5),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            )),
          ),
        ],
      );
    }

    if (sliders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 200.h,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: sliders.length,
            onPageChanged: (index) {
              _bannerIndex.add(index);
            },
            itemBuilder: (context, index) {
              final slider = sliders[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: CachedNetworkImage(
                    imageUrl: slider.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.selectedBoxColor,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      AssetsPath.BannerImg,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        _buildBannerIndicators(sliders.length),
      ],
    );
  }

  Widget _buildBannerIndicators(int count) {
    return StreamBuilder<int>(
      stream: _bannerIndex.stream,
      initialData: 0,
      builder: (context, snapshot) {
        final currentIndex = snapshot.data ?? 0;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            count,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: currentIndex == index ? 24.w : 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? AppColors.white
                    : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendingCoursesSection(HomeState state) {
    final packages = state.data?.packages ?? [];

    if (!state.showSkeleton && packages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleViewRowWidget(
            title: '${AppLocalizations.of(context)?.trendingCourse}',
            subTitle: '${AppLocalizations.of(context)?.viewAll}',
            itemClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllCoursesScreen()),
              );
            },
          ),
          SizedBox(height: 10.h),
          if (state.showSkeleton)
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: AppColors.selectedBoxColor,
                    highlightColor: Colors.white.withOpacity(0.2),
                    child: CoursesItemWidget(
                      title: 'Loading...',
                    ),
                  );
                },
              ),
            )
          else
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: packages.length,
                itemBuilder: (context, index) {
                  final package = packages[index];
                  return CoursesItemWidget(
                    title: package.name,
                    badge: package.label,
                    discount: package.discount,
                    finalPrice: package.finalPrice,
                    originalPrice: package.oldPrice,
                    imageUrl: package.imageUrl,
                    onTap: () {
                      // Navigate to package details if needed
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMentorsSection(HomeState state) {
    final videos = state.data?.mentorVideos ?? [];

    if (!state.showSkeleton && videos.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleViewRowWidget(
            title: 'Z Mentors',
            subTitle: '${AppLocalizations.of(context)?.viewAll}',
            itemClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MentorsListScreen()),
              );
            },
          ),
          SizedBox(height: 10.h),
          if (state.showSkeleton)
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: AppColors.selectedBoxColor,
                    highlightColor: Colors.white.withOpacity(0.2),
                    child: MentorsItemWidget(),
                  );
                },
              ),
            )
          else
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return MentorsItemWidget(
                    videoName: video.name,
                    thumbnailUrl: video.thumbnailUrl,
                    itemClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(
                            videoId: video.youtubeCode,
                            videoTitle: video.name,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHomeOptionSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15.h,
        children: [
          HomeOptionsItem(
            title: 'Start your free trial',
            subTitle: 'Free 7-Day Access to Excellence',
            imagePath: AssetsPath.svgFreeTrial,
          ),
          HomeOptionsItem(
            title: 'Live Classes',
            subTitle: 'Learn Live With Experts',
            imagePath: AssetsPath.svgLiveClass,
            itemClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LiveClassScreen()),
              );
            },
          ),
          HomeOptionsItem(
            title: 'My Courses',
            subTitle: 'Live Classes Learn Live with mentors',
            imagePath: AssetsPath.svgMyCourse,
            itemClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LearningCourseScreen()),
              );
            },
          ),
          HomeOptionsItem(
            title: 'Practice MCQS',
            subTitle: 'Master Every Concept',
            imagePath: AssetsPath.svgPractice,
            itemClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PracticeSubjectScreen()),
              );
            },
          ),
          HomeOptionsItem(
            title: 'All india Challenger Zone',
            subTitle: 'Compete Across India',
            imagePath: AssetsPath.svgChallenger,
            itemClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChallengerZoneScreen()),
              );
            },
          ),
          HomeOptionsItem(
            title: 'Test Series',
            subTitle: 'Full Syllabus Mock Test',
            imagePath: AssetsPath.svgTestSeries,
            itemClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AllIndiaTestSeriesScreen()),
              );
            },
          ),
          HomeOptionsItem(
            title: 'AI Based Performance Analysis',
            subTitle: 'Know Your Complete Progress',
            imagePath: AssetsPath.svgAIBase,
            itemClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AiBasedPerformanceScreen()),
              );
            },
          ),
          HomeOptionsItem(
            title: 'Ask Your Doubts',
            subTitle: 'Get Expert Solutions',
            imagePath: AssetsPath.svgAskDoubts,
            itemClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AskDoubtsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
