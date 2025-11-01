import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/challenge_option_box.dart';
import 'package:zifour_sourcecode/core/widgets/challenge_ready_widget.dart';
import 'package:zifour_sourcecode/core/widgets/chapter_selection_box.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/challenger_zone/challenges_list_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/line_label_row.dart';
import '../../l10n/app_localizations.dart';

class ChallengeReadyScreen extends StatefulWidget {
  const ChallengeReadyScreen({super.key});

  @override
  State<ChallengeReadyScreen> createState() => _ChallengeReadyScreenState();
}

class _ChallengeReadyScreenState extends State<ChallengeReadyScreen> {

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
                top: 40.h,
                left: 15.w,
                right: 15.w,
                child: CustomAppBar(
                  isBack: true,
                  title: '${AppLocalizations.of(context)?.challengeReady}',
                  isActionWidget: true,
                  actionWidget: Text(
                    '${AppLocalizations.of(context)?.edit}',
                    style: AppTypography.inter14Bold.copyWith(
                        color: AppColors.pinkColor,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.pinkColor
                    ),
                  ),
                  actionClick: (){

                  },
                )),

            // Main Content with BLoC
            Positioned(
              top: 110.h,
              left: 20.w,
              right: 20.w,
              bottom: 0,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)?.reviewYourSelections}',
                      style: AppTypography.inter16Regular.copyWith(
                          color: AppColors.white.withOpacity(0.6)
                      ),
                    ),
                    SizedBox(height: 25.h),
                    SignupFieldBox(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        spacing: 15.h,
                        children: [
                          ChallengeReadyWidget(
                            title: '${AppLocalizations.of(context)?.subjectsSelected}',
                            iconPath: AssetsPath.svgBook,
                            selectedValue: 'Physics, Chemistry',
                          ),
                          ChallengeReadyWidget(
                            title: '${AppLocalizations.of(context)?.chapterSelected}',
                            iconPath: AssetsPath.svgBook,
                            iconColor: Color(0xFFF58D30),
                            selectedValue: 'Mechanics, Kinematics, Thermodynamics',
                          ),
                          ChallengeReadyWidget(
                            title: '${AppLocalizations.of(context)?.topicsIncluded}',
                            iconPath: AssetsPath.svgBook2,
                            selectedValue: 'Newton’s Laws, Friction, Carnot cycle',
                          ),
                          ChallengeReadyWidget(
                            title: '${AppLocalizations.of(context)?.totalQuestions}',
                            iconPath: AssetsPath.svgHelpCircle,
                            iconColor: Color(0xFFFACC15),
                            selectedValue: '25 MCQS',
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomGradientArrowButton(
                      text: '${AppLocalizations.of(context)?.startChallenge}',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChallengesListScreen()),
                        );
                      },
                    ),
                    SizedBox(height: 20.h,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget stepRowContent(String title, String step) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            title,
            style: AppTypography.inter12Medium,
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            height: 1.0,
            color: AppColors.white.withOpacity(0.5),
          ),
        ),
        Flexible(
          child: Text(
            title,
            style: AppTypography.inter10Regular.copyWith(
                color: AppColors.white.withOpacity(0.5)
            ),
          ),
        )
      ],
    );
  }

  Widget subjectContainer(String title, Color color, Function() onTap) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 13.w),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(10.r))
      ),
      child: Center(
        child: Text(
          title,
          style: AppTypography.inter12SemiBold,
        ),
      ),
    );
  }

}
