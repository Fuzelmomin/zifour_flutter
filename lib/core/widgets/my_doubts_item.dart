import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';

class MyDoubtsItem extends StatelessWidget {
  String? title;
  bool? isReplied;
  Function()? itemClick;
  MyDoubtsItem({super.key, this.title, this.isReplied, this.itemClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          style: AppTypography.inter14SemiBold.copyWith(
            color: AppColors.white.withOpacity(0.6)
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isReplied == true ? Icons.check_circle_outline : Icons.query_builder,
              size: 20.0,
              color: isReplied == true ? AppColors.green : AppColors.orange,
            ),
            SizedBox(width: 5.w,),
            Text(
              isReplied == true ? 'Answered' : 'Pending',
              style: AppTypography.inter12Medium.copyWith(
                color: isReplied == true ? AppColors.green : AppColors.orange,
              ),
            )
          ],
        )
      ],
    );
  }
}


