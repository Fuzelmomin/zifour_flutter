import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/dialogs/create_reminder_dialog.dart';
import 'package:zifour_sourcecode/core/utils/connectivity_helper.dart';
import 'package:zifour_sourcecode/features/dashboard/video_player_screen.dart';
import 'package:zifour_sourcecode/features/live_class/bloc/lectures_bloc.dart';
import 'package:zifour_sourcecode/features/live_class/model/lectures_model.dart';
import 'package:zifour_sourcecode/features/live_class/repository/lectures_repository.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../l10n/app_localizations.dart';

class LiveClassDetailsScreen extends StatefulWidget {
  final String? subjectName;
  final String? subId;
  final String? chpId;
  final String? tpcId;
  final String? lvCls;

  const LiveClassDetailsScreen({
    super.key,
    this.subjectName,
    this.subId,
    this.chpId,
    this.tpcId,
    this.lvCls,
  });

  @override
  State<LiveClassDetailsScreen> createState() => _LiveClassDetailsScreenState();
}

class _LiveClassDetailsScreenState extends State<LiveClassDetailsScreen> {
  bool _hasInitialized = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LecturesBloc(repository: LecturesRepository()),
      child: Builder(
        builder: (blocContext) {
          // Trigger API call after the widget is built (only once)
          if (!_hasInitialized) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _hasInitialized = true;
                _checkConnectivityAndLoad(blocContext);
              }
            });
          }
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: SafeArea(
              child: Stack(
                children: [
                  // Background Decoration set
                  /*Positioned.fill(
                  child: Image.asset(
                    AssetsPath.signupBgImg,
                    fit: BoxFit.cover,
                  ),
                ),*/

                  // App Bar
                  /*Positioned(
                  top: 20.h,
                  left: 15.w,
                  right: 20.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: widget.subjectName ?? 'Live Classes',
                  ),
                ),*/

                  // Main Content with BLoC
                  Positioned(
                    // top: 10.h,
                    // left: 20.w,
                    // right: 20.w,
                    // bottom: 20.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*Text(
                        "Explore ${widget.subjectName ?? 'Live'} Concepts Live – Grow Smarter With Zifour.",
                        style: AppTypography.inter16Regular.copyWith(
                          color: AppColors.white.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(height: 15.h),*/
                        Expanded(
                          child: BlocBuilder<LecturesBloc, LecturesState>(
                            builder: (blocContext, state) {
                              if (state is LecturesLoading) {
                                return _buildShimmerLoading();
                              }

                              if (state is LecturesError) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        state.message,
                                        textAlign: TextAlign.center,
                                        style: AppTypography.inter14Regular.copyWith(
                                          color: AppColors.white.withOpacity(0.6),
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      ElevatedButton(
                                        onPressed: () {
                                          _checkConnectivityAndLoad(blocContext);
                                        },
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              if (state is LecturesSuccess) {
                                final lectures = state.lectures;
                                if (lectures.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'No live lectures available',
                                      style: AppTypography.inter14Regular.copyWith(
                                        color: AppColors.white.withOpacity(0.6),
                                      ),
                                    ),
                                  );
                                }

                                return ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: lectures.length,
                                  itemBuilder: (context, index) {
                                    final lecture = lectures[index];
                                    return _buildLectureCard(lecture);
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _checkConnectivityAndLoad(BuildContext blocContext) async {
    final isConnected = await ConnectivityHelper.checkConnectivity();
    if (isConnected) {
      blocContext.read<LecturesBloc>().add(
            FetchLectures(
              chpId: widget.chpId ?? '0',
              tpcId: widget.tpcId ?? '0',
              subId: widget.subId,
              lvCls: widget.lvCls,
              lecSample: '0',
              lecRept: '0',
            ),
          );
    } else {
      ConnectivityHelper.checkAndShowNoInternetScreen(blocContext);
    }
  }

  Widget _buildLectureCard(LectureItem lecture) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Live Tag
        _buildLiveTag(lecture.lecStart),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            color: Colors.white.withOpacity(0.1),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                lecture.name ?? 'Lecture',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                "${lecture.standard ?? ''}ˢᵗ  ●  ${lecture.exam ?? ''}  ●  ${lecture.subject}",
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "${lecture.lecDate ?? ''}   |   ${lecture.lecTime ?? ''}",
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),
              Container(height: 1, color: Colors.white24),
              const SizedBox(height: 12),
              Row(
                children: [
                  // Profile image placeholder
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      height: 42,
                      width: 42,
                      color: AppColors.pinkColor.withOpacity(0.3),
                      child: Icon(
                        Icons.person,
                        color: AppColors.pinkColor,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lecture.teacherName ?? 'Teacher',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Expert of ${lecture.subject ?? ''}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Remind Me
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) => CreateReminderDialog(
                          lecture: lecture,
                        ),
                      );
                    },
                    child: Text(
                      "Remind Me",
                      style: AppTypography.inter14Bold.copyWith(
                        color: AppColors.pinkColor,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.pinkColor,
                      ),
                    ),
                  ),
                  // Join Now Button
                  GestureDetector(
                    onTap: () {
                      if (lecture.youtubeVideo != null &&
                          lecture.youtubeVideo!.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(
                              videoId: lecture.youtubeVideo!,
                              videoTitle: lecture.name ?? 'Live Lecture',
                              isLive: true,
                              lecId: lecture.lecId,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFD2D7B), Color(0xFF6B2CF5)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Join Class Now!",
                            style: AppTypography.inter14Bold,
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLiveTag(String? lecStartStr) {
    if (lecStartStr == null || lecStartStr.isEmpty) return const SizedBox.shrink();

    try {
      final lecStart = DateTime.parse(lecStartStr);
      final now = DateTime.now();
      final oneHourAfter = lecStart.add(const Duration(hours: 1));

      String tagText = '';
      Color tagColor = Colors.transparent;
      bool isVisible = false;

      if (now.isBefore(lecStart)) {
        tagText = "UPCOMING";
        tagColor = Colors.orange;
        isVisible = true;
      } else if ((now.isAtSameMomentAs(lecStart) || now.isAfter(lecStart)) &&
          now.isBefore(oneHourAfter)) {
        tagText = "LIVE";
        tagColor = Colors.redAccent;
        isVisible = true;
      }

      if (!isVisible) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        margin: EdgeInsets.only(right: 25.w),
        decoration: BoxDecoration(
          color: tagColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.r),
            topRight: Radius.circular(6.r),
          ),
        ),
        child: Text(
          tagText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildShimmerLoading() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.white.withOpacity(0.08),
          highlightColor: Colors.white.withOpacity(0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 60.w,
                height: 25.h,
                margin: EdgeInsets.only(right: 25.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6.r),
                    topRight: Radius.circular(6.r),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  color: Colors.white.withOpacity(0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20.h,
                      width: 200.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      height: 15.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Container(
                      height: 1,
                      color: Colors.white24,
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 15.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              height: 12.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 15.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        Container(
                          height: 35.h,
                          width: 140.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 15.h);
      },
    );
  }
}
