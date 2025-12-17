
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/widgets/chapters_videos_item.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../dashboard/video_player_screen.dart';
import '../live_class/bloc/lectures_bloc.dart';

class LearningChapterVideosScreen extends StatefulWidget {
  final String topicId;
  final String topicName;
  final String chapterId;
  final String chapterName;
  final String subjectId;
  final String subjectName;

  const LearningChapterVideosScreen({
    super.key,
    required this.topicId,
    required this.topicName,
    required this.chapterId,
    required this.chapterName,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<LearningChapterVideosScreen> createState() => _LearningChapterVideosScreenState();
}

class _LearningChapterVideosScreenState extends State<LearningChapterVideosScreen> {
  late final LecturesBloc _lecturesBloc;

  @override
  void initState() {
    super.initState();
    _lecturesBloc = LecturesBloc();
    // Load lectures from API with parameters
    // tpc_id, chp_id, sub_id from previous screen (dynamic)
    // med_id, lec_sample, exm_id, lv_cls, lec_rept set to "0" (static)
    _lecturesBloc.add(FetchLectures(
      tpcId: widget.topicId,
      chpId: widget.chapterId,
      subId: widget.subjectId,
      medId: '0',
      lecSample: '0',
      exmId: '0',
      lvCls: '0',
      lecRept: '0',
    ));
  }

  @override
  void dispose() {
    _lecturesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _lecturesBloc,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.darkBlue,
          child: SafeArea(
            child: Stack(
              children: [
                // Background Decoration set
                Positioned.fill(
                  child: Image.asset(
                    AssetsPath.signupBgImg,
                    fit: BoxFit.cover,
                  ),
                ),

                // App Bar
                Positioned(
                  top: 20.h,
                  left: 15.w,
                  right: 20.w,
                  child: BlocBuilder<LecturesBloc, LecturesState>(
                    builder: (context, state) {
                      String title = "Chapter - ${widget.chapterName}";
                      if (state is LecturesSuccess && state.chpTitle != null) {
                        title = "Chapter - ${state.chpTitle}";
                      }
                      return CustomAppBar(
                        isBack: true,
                        title: title,
                      );
                    },
                  ),
                ),

                // Main Content with BLoC
                Positioned(
                  top: 100.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: 0,
                  child: BlocBuilder<LecturesBloc, LecturesState>(
                    builder: (context, state) {
                      if (state is LecturesLoading) {
                        return _buildShimmerLoading();
                      }

                      if (state is LecturesError) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Text(
                              state.message,
                              style: AppTypography.inter14Regular.copyWith(
                                color: AppColors.white.withOpacity(0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      if (state is LecturesSuccess) {
                        if (state.lectures.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Text(
                                'No lectures found',
                                style: AppTypography.inter14Regular.copyWith(
                                  color: AppColors.white.withOpacity(0.6),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: state.lectures.length,
                          padding: EdgeInsets.only(bottom: 20.h),
                          itemBuilder: (context, index) {
                            final lecture = state.lectures[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
                              child: ChaptersVideosItem(
                                lecture: lecture,
                                onTap: (){
                                  if (lecture.youtubeVideo != null &&
                                      lecture.youtubeVideo!.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoPlayerScreen(
                                          videoId: lecture.youtubeVideo!,
                                          videoTitle: lecture.name ?? '${widget.subjectName} Lecture',
                                          lecId: lecture.lecId,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        );
                      }

                      // Initial state
                      return SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      padding: EdgeInsets.only(bottom: 20.h),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.08),
            highlightColor: Colors.white.withOpacity(0.2),
            child: Container(
              width: double.infinity,
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        );
      },
    );
  }
}
