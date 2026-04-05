import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

class ProfileOptionWidget extends StatelessWidget {
  String? title;
  Function()? itemClick;
  String? icon;
  bool? isPractice;
  String? mcqCount;
  String? videoCount;
  String? testCount;


  ProfileOptionWidget({
    super.key,
    this.title,
    this.itemClick,
    this.icon,
    this.isPractice,
    this.mcqCount,
    this.videoCount,
    this.testCount,
  });

  bool get _hasStats =>
      isPractice == true &&
      ((mcqCount != null && mcqCount!.isNotEmpty) ||
       (videoCount != null && videoCount!.isNotEmpty) ||
       (testCount != null && testCount!.isNotEmpty));

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        itemClick!();
      },
      child: SignupFieldBox(
        margin: EdgeInsets.only(bottom: 20.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: _hasStats ? 10.h : 0),
          constraints: BoxConstraints(minHeight: 45.h),
          width: double.infinity,
          child: Row(
            crossAxisAlignment: _hasStats ? CrossAxisAlignment.center : CrossAxisAlignment.center,
            children: [
              icon != null ? Image.asset(
                 icon ?? '',
                width: 22.0,
                height: 22.0,
                color: AppColors.white.withOpacity(0.8),
              ) : Container(),
              //SizedBox(width: icon != null ? 5.0 : 0.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title ?? '',
                      style: AppTypography.inter16Medium.copyWith(
                        color: AppColors.white.withOpacity(0.8)
                      ),
                    ),
                    if (_hasStats) ...[
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          if (mcqCount != null && mcqCount!.isNotEmpty)
                            _buildStatPill(
                              Icons.bar_chart_rounded,
                              '$mcqCount MCQs',
                              const Color(0xFF2551b4),
                            ),
                          if (mcqCount != null && mcqCount!.isNotEmpty &&
                              videoCount != null && videoCount!.isNotEmpty)
                            SizedBox(width: 6.w),
                          if (videoCount != null && videoCount!.isNotEmpty)
                            _buildStatPill(
                              Icons.play_circle_filled,
                              '$videoCount Video',
                              const Color(0xFFdd6b41),
                            ),
                          if (videoCount != null && videoCount!.isNotEmpty &&
                              testCount != null && testCount!.isNotEmpty)
                            SizedBox(width: 6.w),
                          if (testCount != null && testCount!.isNotEmpty)
                            _buildStatPill(
                              Icons.description_rounded,
                              '$testCount Test',
                              const Color(0xFF78389f),
                            ),
                        ],
                      ),
                    ],
                  ],
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

  Widget _buildStatPill(IconData icon, String label, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
