import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../../l10n/app_localizations.dart';
import 'custom_gradient_button.dart';

class ChallengeOptionBox extends StatelessWidget {
  String? iconPath;
  String? title;
  String? subtitle;
  String? buttonText;
  Function()? onTap;
  ChallengeOptionBox({super.key, this.iconPath, this.title, this.subtitle, this.buttonText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SignupFieldBox(
      padding: EdgeInsets.all(18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                iconPath ?? '',
                width: 50.h,
                height: 50.h,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            subtitle ?? '',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13.sp,
              height: 1.4,
            ),
          ),
          SizedBox(height: 15.h),

          CustomGradientArrowButton(
            text: buttonText ?? '',
            onPressed: () {
              onTap!();
            },
          )
        ],
      ),
    );
  }
}
