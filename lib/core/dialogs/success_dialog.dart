import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../constants/app_colors.dart';
import '../constants/assets_path.dart';
import '../theme/app_typography.dart';
import '../widgets/custom_gradient_button.dart';

class SuccessDialog {


  static void showSuccessDialog({required BuildContext context, String? message, Function()? btnClick}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.darkBlue,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.pinkColor, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                AssetsPath.successJson,
                width: 180.h,
                height: 180.h,
              ),
              SizedBox(height: 20.h),
              Text(
                'Success!',
                style: AppTypography.inter24Bold.copyWith(color: Colors.white),
              ),
              SizedBox(height: 10.h),
              Text(
                message ?? '',
                textAlign: TextAlign.center,
                style: AppTypography.inter14Medium.copyWith(color: Colors.white70),
              ),
              SizedBox(height: 30.h),
              CustomGradientButton(
                text: 'OK',
                onPressed: btnClick,
              ),
            ],
          ),
        ),
      ),
    );
  }

}