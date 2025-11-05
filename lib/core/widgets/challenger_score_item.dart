import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../constants/app_colors.dart' show AppColors;
import '../theme/app_typography.dart';
import 'custom_gradient_button.dart';
import 'info_row.dart';

class ChallengerScoreItem extends StatelessWidget {
  final Function() onTap;
  const ChallengerScoreItem({super.key, required this.onTap});

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
                Column(
                  children: [
                    Text(
                      "Challenger Zone #5",
                      style: AppTypography.inter16Medium,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Held on 1st June 2025",
                      style: AppTypography.inter12SemiBold.copyWith(
                          color: AppColors.orange
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  AssetsPath.icCup,
                  width: 60.h,
                  height: 60.h,
                  fit: BoxFit.fill,
                )
              ],
            ),
            SizedBox(height: 16),
            Row(
              spacing: 5.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InfoRow(title: "Physics", value: "Motion, Laws of Motion", subTitleStyle: AppTypography.inter12SemiBold,),
                ),
                Expanded(
                  child: InfoRow(title: "Biology", value: "Cell, Enzymes", subTitleStyle: AppTypography.inter12SemiBold),
                )
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            SizedBox(width: double.infinity, child: InfoRow(title: "Chemistry", value: "Chemical Bonding, Periodic Table", subTitleStyle: AppTypography.inter12SemiBold)),
            SizedBox(
              height: 8.h,
            ),
            Row(
              spacing: 15.w,
              children: [
                Expanded(
                  child: CustomGradientButton(
                    text: 'My Performance',
                    onPressed: onTap,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    customDecoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                        color: Color(0xFF464375)
                    ),
                  ),
                ),

                Expanded(
                  child: CustomGradientButton(
                    text: 'View Solutions',
                    onPressed: () {

                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
