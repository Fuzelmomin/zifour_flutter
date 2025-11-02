import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/challenger_zone/challenge_result_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/dialogs/reminder_complete_dialog.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../l10n/app_localizations.dart';

class ExpertChallengeScreen extends StatefulWidget {
  const ExpertChallengeScreen({super.key});

  @override
  State<ExpertChallengeScreen> createState() => _ExpertChallengeScreenState();
}

class _ExpertChallengeScreenState extends State<ExpertChallengeScreen> {

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
                  top: 0.h,
                  left: 15.w,
                  right: 5.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: '${AppLocalizations.of(context)?.expertsChallenge}',
                  )),
              // Main Content with BLoC
              Positioned(
                top: 70.h,
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
                        "Compete in faculty - Designed challenges and track your progress.",
                        style: AppTypography.inter16Regular.copyWith(
                            color: AppColors.white.withOpacity(0.6)
                        ),
                      ),
                      SizedBox(height: 25.h),

                      /// Upcoming Card
                      _challengeCard(
                        status: "UPCOMING",
                        statusColor: const Color(0xFFFFA726),
                        buttonText: "Remind Me",
                        onTap: (){
                          showDialog(
                            context: context,
                            barrierDismissible: true, // Optional tap outside close
                            builder: (_) => ReminderDialog(),
                          );
                        }
                      ),

                      SizedBox(height: 18.h),

                      /// Completed Card
                      _challengeCard(
                          status: "COMPLETED",
                          statusColor: const Color(0xFFFFA726),
                          buttonText: "View Result",
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChallengeResultScreen()),
                            );
                          }
                      ),

                      SizedBox(height: 25.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _challengeCard({
    required String status,
    required Color statusColor,
    required String buttonText,
    required Function() onTap,
  }) {
    return SignupFieldBox(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Status Badge
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 5.h),

          /// Title
          Text(
            "July NEET Mega Challenge",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 14.h),

          /// Time Row Container
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _timeItem("2:00 PM - 5:00 PM"),
                _dot(),
                _timeItem("19 JAN"),
                _dot(),
                _timeItem("180 MINS"),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          /// Syllabus Title
          Row(
            children: [
              Expanded(child: Divider(thickness: .5, color: Colors.white24)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  "SYLLABUS",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(child: Divider(thickness: .5, color: Colors.white24)),
            ],
          ),
          SizedBox(height: 14.h),

          /// Syllabus Row
          Row(
            children: [
              _syllabusBox("PHYSICS", "Electricity and\nMagnetism,"),
              SizedBox(width: 10.w),
              _syllabusBox("CHEMISTRY", "Organic"),
            ],
          ),

          SizedBox(height: 18.h),

          /// Button
          CustomGradientArrowButton(
            text: buttonText ?? '',
            onPressed: () {
              onTap();
            },
          )
        ],
      ),
    );
  }

  Widget _timeItem(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: 11.sp),
    );
  }

  Widget _dot() {
    return Text("•", style: TextStyle(color: Colors.orange, fontSize: 14.sp));
  }

  Widget _syllabusBox(String title, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
