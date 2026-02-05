import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/widgets/custom_gradient_button.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/services/subject_service.dart';
import '../practics_mcq/select_chapter_screen.dart';

class LearningCourseListScreen extends StatefulWidget {
  const LearningCourseListScreen({super.key});

  @override
  State<LearningCourseListScreen> createState() => _LearningCourseListScreenState();
}

class _LearningCourseListScreenState extends State<LearningCourseListScreen> {
  final SubjectService _subjectService = SubjectService();

  @override
  void dispose() {

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
                  right: 5.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: 'My Courses',
                  )),
              // Main Content with BLoC
              Positioned(
                top: 90.h,
                left: 20.w,
                right: 20.w,
                bottom: 0,
                child: ListView.builder(
                  itemCount: _subjectService.subjects.length,
                  itemBuilder: (context, index) {
                    final subject = _subjectService.subjects[index];
                    return _CourseCard(
                      title: subject.name,
                      progress: 65, // Static for now as API doesn't provide this
                      chapters: subject.totalChapter ?? "", // Static for now as API doesn't provide this
                      lectures: subject.totalLectures ?? "", // Static for now as API doesn't provide this
                      //iconUrl: "https://cdn-icons-png.flaticon.com/512/4149/4149678.png", // Static icon
                      iconUrl: subject.icon, // Static icon
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectChapterScreen(
                              from: "course",
                              subjectId: subject.subId,
                              subjectName: subject.name,
                              subjectIcon: subject.icon,
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
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final String title;
  final int progress;
  final String chapters;
  final String lectures;
  final String iconUrl;
  final Function() onTap;

  const _CourseCard({
    required this.title,
    required this.progress,
    required this.chapters,
    required this.lectures,
    required this.iconUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SignupFieldBox(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Row: Icon + Text
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white.withOpacity(0.1),
                child: CachedNetworkImage(
                  imageUrl: iconUrl,
                  height: 28,
                  color: Colors.white,
                  errorWidget: (_, __, ___) => Icon(Icons.book, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.inter20Medium,
                  ),
                  // const SizedBox(height: 4),
                  // Row(
                  //   children: [
                  //     Text(
                  //       "Progress: ",
                  //       style: TextStyle(
                  //         fontSize: 13,
                  //         color: Colors.white.withOpacity(0.8),
                  //       ),
                  //     ),
                  //     Text(
                  //       "$progress%",
                  //       style: AppTypography.inter14SemiBold.copyWith(
                  //           color: AppColors.white
                  //       ),
                  //     ),
                  //     SizedBox(width: 5.0,),
                  //     Text(
                  //       "Completed: ",
                  //       style: TextStyle(
                  //         fontSize: 13,
                  //         color: Colors.white.withOpacity(0.8),
                  //       ),
                  //     ),
                  //     Icon(
                  //       Icons.check_circle,
                  //       color: AppColors.green,
                  //       size: 18.0,
                  //     )
                  //   ],
                  // ),
                  const SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: BoxBorder.all(
                        color: AppColors.white.withOpacity(0.1),
                        width: 1.1
                      )
                    ),
                    child: Row(
                    children: [
                      Text(
                        "Chapter : ",
                        style: AppTypography.inter14Medium.copyWith(
                          color: AppColors.skyColor
                        ),
                      ),
                      Text(
                        "$chapters",
                        style: AppTypography.inter16SemiBold.copyWith(
                            color: AppColors.skyColor
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      Icon(Icons.circle, size: 8.0, color: AppColors.white.withOpacity(0.1),),
                      SizedBox(width: 10.0,),
                      Text(
                        "Lecture : ",
                        style: AppTypography.inter14Medium.copyWith(
                            color: AppColors.skyColor
                        ),
                      ),
                      Text(
                        "$lectures",
                        style: AppTypography.inter16SemiBold.copyWith(
                            color: AppColors.skyColor
                        ),
                      ),
                    ],
                  ),
                  )
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Button
          CustomGradientArrowButton(
            text: 'Continue Learning',
            onPressed: (){
              onTap();
            },
          )

        ],
      ),
    );
  }
}

