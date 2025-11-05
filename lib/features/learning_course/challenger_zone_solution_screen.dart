import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/dialogs/create_reminder_dialog.dart';
import 'package:zifour_sourcecode/core/widgets/course_item.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/challenger_zone/challenge_result_screen.dart';
import 'package:zifour_sourcecode/features/payment/payment_status_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/challenger_score_item.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/my_course_item.dart';
import '../../l10n/app_localizations.dart';

class ChallengerZoneSolutionScreen extends StatefulWidget {
  const ChallengerZoneSolutionScreen({super.key});

  @override
  State<ChallengerZoneSolutionScreen> createState() => _ChallengerZoneSolutionScreenState();
}

class _ChallengerZoneSolutionScreenState extends State<ChallengerZoneSolutionScreen> {
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
                  right: 20.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: 'Challenger Zone Solutions',
                  )),

              // Main Content with BLoC
              Positioned(
                top: 60.h,
                left: 20.w,
                right: 20.w,
                bottom: 50.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Revisit past challenges and master the toughest MCQs.",
                      style: AppTypography.inter16Regular.copyWith(
                          color: AppColors.white.withOpacity(0.6)
                      ),
                    ),

                    SizedBox(height: 15.h),
                    /// Class Card

                  ],
                ),
              ),
              Positioned(
                top: 110.h,
                left: 20.w,
                right: 20.w,
                bottom: 0.h,
                child: ListView.separated(
                  itemCount: 5,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChallengerScoreItem(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChallengeResultScreen(
                            title: "Challenger Test Results 🏆",
                          )),
                        );
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 15.h,
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
