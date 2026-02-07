import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../challenger_zone/expert_challenge_screen.dart';
import '../india_test_series/all_india_test_series_screen.dart';
import 'challenger_zone_solution_screen.dart';
import 'learning_course_list_screen.dart';
import 'learning_test_series_screen.dart';

class LearningCourseScreen extends StatefulWidget {
  String? pkId;
  LearningCourseScreen({
    super.key,
    this.pkId
  });

  @override
  State<LearningCourseScreen> createState() => _LearningCourseScreenState();
}

class _LearningCourseScreenState extends State<LearningCourseScreen> {

  final List<_LearningCard> cardList = [
    _LearningCard(
      title: "Subject Expert's Lectures",
      subtitle: "Full Syllabus lectures by top mentors",
      buttonText: "View Lecture",
      iconPath: AssetsPath.svgExpertLecture,
      iconBg: Color(0xFFFF408B),
      iconBg2: Color(0xFFFD5F60),
    ),
    _LearningCard(
      title: "Challenger Zone solutions",
      subtitle: "Video solutions of all challenger zone MCQs",
      buttonText: "View Lecture",
      iconPath: AssetsPath.svgChallengerSolution,
      iconBg: Color(0xFFFF9F00),
      iconBg2: Color(0xFFFFC267),
    ),
    _LearningCard(
      title: "Test Series Solutions",
      subtitle: "Detailed video solutions for mock tests",
      buttonText: "View Lecture",
      iconPath: AssetsPath.svgTestSolution,
      iconBg: Color(0xFFFF4D6D),
      iconBg2: Color(0xFFFF7E62),
    ),
  ];

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
                    title: 'Choose How You Learn',
                  )),
              // Main Content with BLoC
              Positioned(
                top: 90.h,
                left: 20.w,
                right: 20.w,
                bottom: 0,
                child: ListView.builder(
                  //padding: const EdgeInsets.all(16),
                  itemCount: cardList.length,
                  itemBuilder: (context, index) {
                    return _LearningItem(
                        card: cardList[index],
                      onTap: (){
                          if(index == 0){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LearningCourseListScreen()),
                            );
                          }else if(index == 1){
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => ChallengerZoneSolutionScreen()),
                            // );
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ExpertChallengeScreen(from: "course",)),
                            );
                          }else {
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LearningTestSeriesScreen()),
                            );*/

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AllIndiaTestSeriesScreen(
                                pkId: widget.pkId,
                              )),
                            );

                          }
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

class _LearningCard {
  final String title;
  final String subtitle;
  final String buttonText;
  final String iconPath;
  final Color iconBg;
  final Color iconBg2;

  _LearningCard({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.iconPath,
    required this.iconBg,
    required this.iconBg2,
  });
}

class _LearningItem extends StatelessWidget {
  final _LearningCard card;
  final Function() onTap;
  const _LearningItem({required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SignupFieldBox(
        margin: const EdgeInsets.only(bottom: 18.0),
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Icon Circle
            SvgPicture.asset(
              card.iconPath,
              height: 55.h,
              width: 55.h,
            ),

            const SizedBox(width: 16),

            /// Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.title,
                    style: AppTypography.inter20Medium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card.subtitle,
                    style: AppTypography.inter12Medium.copyWith(
                      color: AppColors.white.withOpacity(0.6)
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    card.buttonText,
                    style: AppTypography.inter12Medium.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.pinkColor,
                      decorationColor: AppColors.pinkColor,
                      decoration: TextDecoration.underline
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
