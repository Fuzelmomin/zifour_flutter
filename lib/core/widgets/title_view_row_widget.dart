import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';

class TitleViewRowWidget extends StatelessWidget {
  String? title;
  String? subTitle;
  Function()? itemClick;

  TitleViewRowWidget({
    super.key,
    this.title,
    this.subTitle,
    this.itemClick
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title ?? '',
            style: AppTypography.inter18SemiBold,
          ),

          GestureDetector(
            onTap: (){
              itemClick!();
            },
            child: Text(
              subTitle ?? '',
              style: AppTypography.inter14Bold.copyWith(color: AppColors.pinkColor),
            ),
          )
        ],
      ),
    );
  }
}
