import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

class ProfileOptionWidget extends StatelessWidget {
  String? title;
  Function()? itemClick;

  ProfileOptionWidget({super.key, this.title, this.itemClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        itemClick!();
      },
      child: SignupFieldBox(
        child: Container(
          height: 45.h,
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title ?? '',
                style: AppTypography.inter16Medium.copyWith(
                  color: AppColors.white.withOpacity(0.8)
                ),
              ),

              Icon(
                Icons.arrow_forward_ios_sharp,
                size: 20.0,
                color: AppColors.white.withOpacity(0.4),
              )
            ],
          ),
        ),
      ),
    );
  }
}
