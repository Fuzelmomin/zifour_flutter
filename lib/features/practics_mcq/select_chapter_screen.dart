import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/auth/edit_profile_screen.dart';
import 'package:zifour_sourcecode/features/courses/my_courses_screen.dart';
import 'package:zifour_sourcecode/features/demo_ui.dart';
import 'package:zifour_sourcecode/features/learning_course/learning_chapter_videos_screen.dart';
import 'package:zifour_sourcecode/features/learning_course/select_course_topic_screen.dart';
import 'package:zifour_sourcecode/features/mentor/mentors_videos_list_screen.dart';
import 'package:zifour_sourcecode/features/module_list/module_list_screen.dart';
import 'package:zifour_sourcecode/features/practics_mcq/select_topic_screen.dart';
import 'package:zifour_sourcecode/features/reset_password/reset_password_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_widget.dart';
import '../../core/widgets/profile_option_widget.dart';
import '../../l10n/app_localizations.dart';
import '../challenger_zone/bloc/chapter_bloc.dart';


class SelectChapterScreen extends StatefulWidget {
  final String? from;
  final String? subjectId;
  final String? subjectName;
  
  SelectChapterScreen({
    super.key, 
    this.from,
    this.subjectId,
    this.subjectName,
  });

  @override
  State<SelectChapterScreen> createState() => _SelectChapterScreenState();
}

class _SelectChapterScreenState extends State<SelectChapterScreen> {
  late final ChapterBloc _chapterBloc;

  List<String> chapterOptions = [
    "Motion",
    "Laws of Motions",
    "Gravitation",
    "Work, Energy & Power",
  ];


  @override
  void initState() {
    super.initState();
    _chapterBloc = ChapterBloc();
    
    if(widget.from == "course" || widget.from == "practice" || widget.from == "module"){
      // Load chapters from API if subjectId is provided
      if (widget.subjectId != null && widget.subjectId!.isNotEmpty) {
        _chapterBloc.add(ChapterRequested(subId: widget.subjectId!));
      }
    } else {
      // Keep static data for non-course/practice flow
      chapterOptions = [
        "Motion",
        "Laws of Motions",
        "Gravitation",
        "Work, Energy & Power",
      ];
    }
  }

  @override
  void dispose() {
    _chapterBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chapterBloc,
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
                    child: CustomAppBar(
                      isBack: true,
                    )
                ),

                // Main Content with BLoC
                Positioned(
                  top: 90.h,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 15.h,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 160.h,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 40.h,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  height: 110.h,
                                  width: double.infinity,
                                  child: SignupFieldBox(
                                    boxBgColor: AppColors.pinkColor3.withOpacity(0.1),
                                    child: Container(
                                      margin: EdgeInsets.only(top: 15.h),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          Text(
                                            widget.subjectName ?? 'Physics',
                                            style: AppTypography.inter24Medium,
                                          ),
                                          SizedBox(height: 5.h,),
                                          Text(
                                            'Select a Chapter',
                                            style: AppTypography.inter14Medium.copyWith(
                                                color: Color(0xffC55492)
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Positioned(
                              top: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70.w,
                                    height: 70.w,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.pinkColor3.withOpacity(0.2)
                                    ),
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30.r),
                                        child: Image.asset(
                                          AssetsPath.icPhysics,
                                          width: 60.0,
                                          height: 60.0,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                        // Dynamic chapter list based on from parameter
                        if (widget.from == "course" || widget.from == "practice" || widget.from == "module")
                          BlocBuilder<ChapterBloc, ChapterState>(
                            builder: (context, state) {
                              if (state.isLoading) {
                                return _buildShimmerLoading();
                              }

                              if (state.status == ChapterStatus.failure) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20.h),
                                    child: Text(
                                      state.errorMessage ?? 'No chapters found',
                                      style: AppTypography.inter14Regular.copyWith(
                                        color: AppColors.white.withOpacity(0.6),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }

                              if (!state.hasData || state.data!.chapterList.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20.h),
                                    child: Text(
                                      'No chapters found',
                                      style: AppTypography.inter14Regular.copyWith(
                                        color: AppColors.white.withOpacity(0.6),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }

                              final chapters = state.data!.chapterList;
                              return Column(
                                children: chapters.map((chapter) {
                                  return ProfileOptionWidget(
                                    title: chapter.name,
                                    itemClick: () {
                                      if (widget.from == "course") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SelectCourseTopicScreen(
                                              subjectId: widget.subjectId ?? '',
                                              subjectName: widget.subjectName ?? '',
                                              chapterId: chapter.chpId,
                                              chapterName: chapter.name,
                                            ),
                                          ),
                                        );
                                      } else if (widget.from == "practice") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SelectTopicScreen(
                                              from: 'practice',
                                              subjectId: widget.subjectId ?? '',
                                              subjectName: widget.subjectName ?? '',
                                              chapterId: chapter.chpId,
                                              chapterName: chapter.name,
                                            ),
                                          ),
                                        );
                                      } else if(widget.from == "module"){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ModuleListScreen(
                                              subId: widget.subjectId ?? '',
                                              chapterId: chapter.chpId,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          )
                        else
                          Column(
                            children: chapterOptions.map((title) {
                              return ProfileOptionWidget(
                                title: title,
                                itemClick: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SelectTopicScreen()),
                                  );
                                },
                              );
                            }).toList(),
                          )

                    ],
                  ),
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
    return Column(
      children: List.generate(5, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.08),
            highlightColor: Colors.white.withOpacity(0.2),
            child: Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        );
      }),
    );
  }
}

