import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';

import '../theme/app_typography.dart';

class InfoRow extends StatelessWidget {
  String title;
  String value;
  InfoRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Color(0xFF0D0B2F).withOpacity(0.4),
        border: Border.all(color: AppColors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              title,
              style: AppTypography.inter12Regular.copyWith(
                  color: AppColors.white.withOpacity(0.5)
              )
          ),
          Text(value,
              style: AppTypography.inter16SemiBold
          ),
        ],
      ),
    );
  }
}
