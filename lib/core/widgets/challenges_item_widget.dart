import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/custom_gradient_button.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../../l10n/app_localizations.dart';

class ChallengesItemWidget extends StatelessWidget {
  String? btnName;
  ChallengesItemWidget({super.key, this.btnName});

  @override
  Widget build(BuildContext context) {
    return SignupFieldBox(
      padding: EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'July NEET Mini Challenge',
            style: AppTypography.inter16Medium,
          ),
          SizedBox(height: 7.h,),
          Text(
            '20 July 2025',
            style: AppTypography.inter12SemiBold.copyWith(
              color: AppColors.orange
            ),
          ),
          SizedBox(height: 10.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12.w,
            children: [
              Expanded(
                flex: 3,
                child: _customContainer(
                    '${AppLocalizations.of(context)?.subject}', 'Physics'
                ),
              ),

              Expanded(
                flex: 3,
                child: _customContainer(
                    '${AppLocalizations.of(context)?.chapter}', 'Mechanics'
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h,),
          _customContainer(
              '${AppLocalizations.of(context)?.topic}', 'Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search '
          ),
          SizedBox(height: 12.h,),
          CustomGradientArrowButton(
            text: btnName ?? '',
            onPressed: () {

            },
          ),
        ],
      ),
    );
  }
}

Widget _customContainer(String title, String subTitle) {
  return Container(
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Color(0xFF0D0B2F).withOpacity(0.4),
      borderRadius: BorderRadius.all(Radius.circular(10.r)),
      border: BoxBorder.all(
        color: AppColors.white.withOpacity(0.1),
        width: 1.0
      ),
    ),

    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 7.h,
      children: [
        Text(
          title,
          style: AppTypography.inter12Regular.copyWith(
            color: AppColors.white.withOpacity(0.5)
          ),
        ),

        Text(
          subTitle,
          style: AppTypography.inter14Medium,
        ),
      ],
    ),
  );
}
