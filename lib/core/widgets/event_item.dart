import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';

import '../constants/app_colors.dart';

class EventItem extends StatelessWidget {
  String? time;
  String? date;
  String? eventName;
  String? eventDescription;
  Function()? deleteClick;


  EventItem({
    super.key,
    this.time,
    this.date,
    this.eventName,
    this.eventDescription,
    this.deleteClick,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
            color: Color(0xFF1B193D),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
                color: AppColors.white.withOpacity(0.1),
                width: 1.0
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    iconLabel(Icons.access_time_outlined, time ?? ''),
                    SizedBox(width: 10.w,),
                    iconLabel(Icons.calendar_month_rounded, date ?? ''),
                  ],
                ),

                GestureDetector(
                  onTap: (){

                  },
                  child: SvgPicture.asset(
                    AssetsPath.svgCloseCircle,
                    width: 20.w,
                    height: 20.h,
                    color: Colors.red,
                  ),
                )
              ],
            ),
            SizedBox(height: 7.h,),
            Text(
              eventName ?? '',
              style: AppTypography.inter12Medium,
            ),
            SizedBox(height: 4.h,),
            Text(
              eventDescription ?? '',
              style: AppTypography.inter12Regular.copyWith(
                color: const Color(0xFF8F9BB3)
              ),
            )
          ],
        )
    );
  }

  Widget iconLabel(IconData icon, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 15.0,
          color: const Color(0xFF90A2F8),
        ),
        SizedBox(width: 5.w,),
        Text(
          label,
          style: AppTypography.inter10SemiBold.copyWith(
            color: const Color(0xFF90A2F8),
          ),
        )
      ],
    );
  }
}
