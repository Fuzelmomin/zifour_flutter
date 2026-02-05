import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/challenger_zone/model/challenges_list_model.dart';

import '../constants/app_colors.dart' show AppColors;
import '../theme/app_typography.dart';
import 'custom_gradient_button.dart';
import 'info_row.dart';

class ChallengerScoreItem extends StatelessWidget {
  final ChallengeListItem? challenge;
  final Function() onTap;
  final Function()? onViewSolution;

  const ChallengerScoreItem({
    super.key,
    this.challenge,
    required this.onTap,
    this.onViewSolution,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SignupFieldBox(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge?.challengeName ?? "Challenger Zone",
                        style: AppTypography.inter16Medium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      // Text(
                      //   challenge?.oeChaName ?? "Challenge Type",
                      //   style: AppTypography.inter12SemiBold.copyWith(
                      //     color: AppColors.orange,
                      //   ),
                      //   maxLines: 1,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Image.asset(
                  AssetsPath.icCup,
                  width: 60.h,
                  height: 60.h,
                  fit: BoxFit.fill,
                ),
              ],
            ),
            SizedBox(height: 16),
            if (challenge?.subjects != null && challenge!.subjects.isNotEmpty)
              Column(
                children: [
                  InfoRow(
                    title: "Subject",
                    value: challenge!.subjects,
                    subTitleStyle: AppTypography.inter12SemiBold,
                  ),
                  SizedBox(height: 5.h),
                ],
              ),
            if (challenge?.chapters != null && challenge!.chapters.isNotEmpty)
              Column(
                children: [
                  InfoRow(
                    title: "Chapter",
                    value: challenge!.chapters,
                    subTitleStyle: AppTypography.inter12SemiBold,
                  ),
                  SizedBox(height: 5.h),
                ],
              ),
            if (challenge?.topics != null && challenge!.topics.isNotEmpty)
              InfoRow(
                title: "Topic",
                value: challenge!.topics,
                subTitleStyle: AppTypography.inter12SemiBold,
              ),
            SizedBox(height: 8.h),
            Row(
              spacing: 15.w,
              children: [
                Expanded(
                  child: CustomGradientButton(
                    text: 'My Performance',
                    onPressed: onTap,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    customDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                      color: Color(0xFF464375),
                    ),
                  ),
                ),
                Expanded(
                  // child: CustomGradientButton(
                  //   text: 'View Solutions',
                  //   onPressed: onViewSolution ?? () {},
                  // ),
                  child: Container(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
