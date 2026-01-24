import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/widgets/mentors_item_widget.dart';
import 'package:zifour_sourcecode/features/dashboard/video_player_screen.dart';
import 'package:zifour_sourcecode/features/solution_videos/bloc/solution_video_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/mentors_videos_item.dart';
import '../../l10n/app_localizations.dart';
import '../../core/widgets/signup_field_box.dart';

class SolutionVideosListScreen extends StatefulWidget {
  final String? paperId;
  final String? chalId;
  final String? subId;
  final String from;

  SolutionVideosListScreen({
    super.key,
    this.paperId,
    this.chalId,
    required this.from,
    this.subId,
  });

  @override
  State<SolutionVideosListScreen> createState() =>
      _SolutionVideosListScreenState();
}

class _SolutionVideosListScreenState extends State<SolutionVideosListScreen> {
  late SolutionVideoBloc _solutionVideoBloc;

  @override
  void initState() {
    super.initState();
    _solutionVideoBloc = SolutionVideoBloc();
    _fetchData();
  }

  void _fetchData() {
    if (widget.paperId != null && widget.subId != null) {
      if (widget.from == "expert") {
        _solutionVideoBloc.add(
          FetchExpertSolutionVideos(
            challengeId: widget.chalId!,
            subId: widget.subId!,
          ),
        );
      } else {
        _solutionVideoBloc.add(
          FetchSolutionVideos(
            paperId: widget.paperId!,
            subId: widget.subId!,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _solutionVideoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  title: 'Solution Videos',
                ),
              ),
              Positioned(
                top: 90.h,
                left: 20.w,
                right: 20.w,
                bottom: 20.h,
                child: SignupFieldBox(
                  child: BlocProvider.value(
                    value: _solutionVideoBloc,
                    child: BlocBuilder<SolutionVideoBloc, SolutionVideoState>(
                      builder: (context, state) {
                        if (state is SolutionVideoLoading) {
                          return _buildShimmerLoading();
                        } else if (state is SolutionVideoSuccess) {
                          if (state.solutionVideos.isEmpty) {
                            return const Center(
                              child: Text(
                                'No solution videos found.',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                          return ListView.separated(
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.solutionVideos.length,
                            itemBuilder: (context, index) {
                              final video = state.solutionVideos[index];
                              return MentorVideosItem(
                                videoName: "Solution Video ${index + 1}",
                                thumbnailUrl: "https://img.youtube.com/vi/${video.solutionVideo}/0.jpg",
                                itemClick: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoPlayerScreen(
                                        videoId: video.solutionVideo,
                                        videoTitle: "Solution Video ${index + 1}",
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 20.h);
                            },
                          );
                        } else if (state is SolutionVideoError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.message,
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10.h),
                                ElevatedButton(
                                  onPressed: _fetchData,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.white.withOpacity(0.08),
          highlightColor: Colors.white.withOpacity(0.2),
          child: Container(
            width: double.infinity,
            height: 185.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 20.h);
      },
    );
  }
}
