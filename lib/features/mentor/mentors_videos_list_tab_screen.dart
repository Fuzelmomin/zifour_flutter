import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/mentors_item_widget.dart';
import 'package:zifour_sourcecode/features/dashboard/video_player_screen.dart';
import 'package:zifour_sourcecode/features/mentor/bloc/get_mentor_videos_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/mentors_videos_item.dart';
import '../../l10n/app_localizations.dart';
import '../../core/services/mentor_category_service.dart';
import '../../core/widgets/signup_field_box.dart';
import '../dashboard/dashboard_screen.dart';
import 'model/mentor_videos_model.dart';

class MentorsVideosListTabScreen extends StatefulWidget {
  final String mentorId;
  final String? mentorName;
  final bool? isBack;

  MentorsVideosListTabScreen({
    super.key,
    required this.mentorId,
    this.mentorName,
    this.isBack,
  });

  @override
  State<MentorsVideosListTabScreen> createState() =>
      _MentorsVideosListTabScreenState();
}

class _MentorsVideosListTabScreenState extends State<MentorsVideosListTabScreen> {
  bool _videosLoaded = false;
  late GetMentorVideosBloc _videosBloc;
  final MentorCategoryService _categoryService = MentorCategoryService();
  String selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    _videosBloc = GetMentorVideosBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVideos();
    });
  }

  @override
  void dispose() {
    _videosBloc.close();
    super.dispose();
  }

  Future<void> _loadVideos() async {
    if (_videosLoaded) return;
    _videosLoaded = true;

    if (mounted) {
      //_videosBloc.add(FetchMentorVideos(mentorId: widget.mentorId));
      _videosBloc.add(FetchMentorVideos(mentorId: ""));
    }
  }

  void _handleBackButton(BuildContext context) {
    // Check if we can pop, if not navigate to home
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      // Find DashboardScreen state and navigate to home
      final dashboardState = context.findAncestorStateOfType<DashboardScreenState>();
      if (dashboardState != null) {
        dashboardState.navigateToHome();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _videosBloc,
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: AppColors.darkBlue,
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        AssetsPath.signupBgImg,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 20.h,
                      left: 15.w,
                      right: 20.w,
                      child: CustomAppBar(
                        isBack: widget.isBack,
                        title: widget.mentorName ??
                            '${AppLocalizations.of(context)?.mentors}',
                        onBack: () => _handleBackButton(context),

                      ),
                    ),

                    Positioned(
                      top: 80.h,
                      left: 15.w,
                      right: 15.w,
                      child: Text(
                        "From Doubt To Direction",
                        style: AppTypography.inter14Medium.copyWith(
                          color: AppColors.hintTextColor
                        ),
                      ),
                    ),

                    // Horizontal Category Tabs
                    Positioned(
                      top: 140.h,
                      left: 0,
                      right: 0,
                      height: 50.h,
                      child: _buildCategoryTabs(),
                    ),

                    Positioned(
                      top: 200.h,
                      left: 20.w,
                      right: 20.w,
                      bottom: 0,
                      child: BlocBuilder<GetMentorVideosBloc,
                          GetMentorVideosState>(
                        builder: (context, state) {
                          if (state is GetMentorVideosLoading) {
                            return _buildShimmerLoading();
                          }

                          if (state is GetMentorVideosError) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    state.message,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  ElevatedButton(
                                    onPressed: () {
                                      _videosLoaded = false;
                                      _loadVideos();
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (state is GetMentorVideosSuccess) {
                            final videos = state.videos;
                            final filteredVideos = videos.where((video) {
                              if (selectedFilter == "All") return true;
                              return video.category?.toLowerCase() == selectedFilter.toLowerCase();
                            }).toList();

                            if (filteredVideos.isEmpty) {
                              return Center(
                                child: Text(
                                  'No videos available for "$selectedFilter"',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }

                            return ListView.separated(
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              itemCount: filteredVideos.length,
                              padding: EdgeInsets.only(bottom: 30.h),
                              itemBuilder: (context, index) {
                                final video = filteredVideos[index];
                                return _buildRedesignedVideoItem(video);
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 15.h);
                              },
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = _categoryService.mentorCategories;
    List<String> tabNames = ["All"];
    tabNames.addAll(categories.map((e) => e.name).toList());

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: EdgeInsets.symmetric(horizontal: 15.w), // Balanced padding
      itemCount: tabNames.length,
      itemBuilder: (context, index) {
        final name = tabNames[index];
        final isSelected = selectedFilter == name;

        return GestureDetector(
          onTap: () => setState(() => selectedFilter = name),
          child: Container(
            margin: EdgeInsets.only(right: 2.w), // Small gap between items
            padding: EdgeInsets.symmetric(horizontal: 24.w), // Generous horizontal padding
            decoration: BoxDecoration(
              color: isSelected ? AppColors.pinkColor3 : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15.r), // Uniform radius for all tabs looks better and is safer
              border: isSelected 
                  ? Border.all(color: Colors.white.withOpacity(0.1), width: 1)
                  : Border.all(color: Colors.transparent, width: 1),
            ),
            alignment: Alignment.center,
            child: Text(
              name,
              softWrap: false,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRedesignedVideoItem(MentorVideoItem video) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(
              videoId: video.youtubeCode ?? '',
              videoTitle: video.name ?? '',
            ),
          ),
        );
      },
      child: SignupFieldBox(
        padding: EdgeInsets.all(18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withAlpha(50), width: 1),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: "https://api.dicebear.com/7.x/avataaars/png?seed=${video.mentor ?? 'mentor'}",
                      width: 44.w,
                      height: 44.h,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.white.withOpacity(0.05),
                        child: const Icon(Icons.person, color: Colors.white54, size: 20),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.white.withOpacity(0.05),
                        child: const Icon(Icons.person, color: Colors.white54, size: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.name ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              'Posted By ${video.mentor}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Let's Watch Video",
                    style: TextStyle(
                      color: const Color(0xFFF7444E),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(
                    'assets/icons/youtube_red.png', // Assuming there's a youtube icon, if not fallback to Icon
                    width: 24.w,
                    height: 18.h,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.play_circle_fill,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.white.withOpacity(0.08),
          highlightColor: Colors.white.withOpacity(0.2),
          child: Container(
            height: 140.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 15.h);
      },
    );
  }
}

