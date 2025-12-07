import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/widgets/mentors_item_widget.dart';
import 'package:zifour_sourcecode/features/dashboard/video_player_screen.dart';
import 'package:zifour_sourcecode/features/mentor/bloc/get_mentor_videos_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/mentors_videos_item.dart';
import '../../l10n/app_localizations.dart';

class MentorsVideosListScreen extends StatefulWidget {
  final String mentorId;
  final String? mentorName;

  MentorsVideosListScreen({
    super.key,
    required this.mentorId,
    this.mentorName,
  });

  @override
  State<MentorsVideosListScreen> createState() =>
      _MentorsVideosListScreenState();
}

class _MentorsVideosListScreenState extends State<MentorsVideosListScreen> {
  bool _videosLoaded = false;
  late GetMentorVideosBloc _videosBloc;

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
      _videosBloc.add(FetchMentorVideos(mentorId: widget.mentorId));
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
                        isBack: true,
                        title: widget.mentorName ??
                            '${AppLocalizations.of(context)?.mentors}',
                      ),
                    ),
                    Positioned(
                      top: 90.h,
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
                            if (videos.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No videos available',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }

                            return SizedBox(
                              height: 200.h,
                              child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                itemCount: videos.length,
                                itemBuilder: (context, index) {
                                  final video = videos[index];
                                  return MentorVideosItem(
                                    videoName: video.name,
                                    thumbnailUrl: video.thumbnailUrl,
                                    itemClick: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VideoPlayerScreen(
                                            videoId: video.youtubeCode ?? '',
                                            videoTitle: video.name ?? '',
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                separatorBuilder: (context, index){
                                  return SizedBox(height: 10.h,);
                                },
                              ),
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

  Widget _buildShimmerLoading() {
    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.08),
            highlightColor: Colors.white.withOpacity(0.2),
            child: Container(
              width: MediaQuery.of(context).size.width - 100.w,
              margin: EdgeInsets.only(right: 15.w),
              height: 185.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          );
        },
      ),
    );
  }
}
