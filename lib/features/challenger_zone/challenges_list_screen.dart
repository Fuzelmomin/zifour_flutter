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

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/challenges_item_widget.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/line_label_row.dart';
import '../../l10n/app_localizations.dart';

class ChallengesListScreen extends StatefulWidget {
  const ChallengesListScreen({super.key});

  @override
  State<ChallengesListScreen> createState() => _ChallengesListScreenState();
}

class _ChallengesListScreenState extends State<ChallengesListScreen> {

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
                right: 5.w,
                child: CustomAppBar(
                  isBack: true,
                  title: '${AppLocalizations.of(context)?.challengesList}',
                )),

            // Main Content with BLoC
            Positioned(
              top: 110.h,
              left: 20.w,
              right: 20.w,
              bottom: 0,
              child: ListView.separated(
                itemCount: 5,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    child: ChallengesItemWidget(
                      btnName: index == 1 || index == 5 ? 'View Results' : 'Start Exam',
                    ),
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
