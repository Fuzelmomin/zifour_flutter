import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'signup_field_box.dart';

class SubjectHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final String iconUrl;

  const SubjectHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        // Background Box (Non-positioned to determine height)
        Padding(
          padding: EdgeInsets.only(top: 35.h),
          child: SignupFieldBox(
            boxBgColor: AppColors.pinkColor3.withOpacity(0.1),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 40.h,
                bottom: 20.h,
                left: 15.w,
                right: 15.w,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTypography.inter24Medium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    subtitle,
                    style: AppTypography.inter14Medium.copyWith(
                      color: const Color(0xffC55492),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Overlapping Icon
        Positioned(
          top: 0.0,
          child: Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.pinkColor3.withOpacity(0.2),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: iconUrl.isNotEmpty ?
                Image.network(
                  iconUrl,
                  width: 60.w,
                  height: 60.w,
                  fit: BoxFit.contain,
                ) : Image.asset(
                  iconPath,
                  width: 60.w,
                  height: 60.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
