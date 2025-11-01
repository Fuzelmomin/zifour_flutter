import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';

class ChallengeReadyWidget extends StatelessWidget {
  String? title;
  String? iconPath;
  String? selectedValue;
  Color? iconColor;
  ChallengeReadyWidget({
    super.key,
    this.title,
    this.iconPath,
    this.selectedValue,
    this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Color(0xFF1B193D),
        borderRadius: BorderRadius.all(Radius.circular(16.r)),
        border: BoxBorder.all(
          color: AppColors.white.withOpacity(0.1),
          width: 1.2
        )
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title ?? '',
                style: AppTypography.inter14Medium.copyWith(
                  color: AppColors.white.withOpacity(0.8)
                ),
              ),
              SvgPicture.asset(
                iconPath ?? '',
                width: 25.h,
                height: 25.h,
                color: iconColor ?? null,
              )
            ],
          ),
          SizedBox(height: 10.h,),
          Container(
            width: double.infinity,
            height: 0.80,
            color: AppColors.white.withOpacity(0.1),
          ),
          SizedBox(height: 13.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10.w,
            children: [
              Icon(
                Icons.check_circle,
                size: 25.h,
                color: AppColors.green,
              ),
              Expanded(
                child: Text(
                  selectedValue ?? '',
                  style: AppTypography.inter14Medium.copyWith(
                      color: Color(0xff9DA7F9)
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
