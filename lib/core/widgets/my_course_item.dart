import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../constants/assets_path.dart';

class MyCourseItem extends StatelessWidget {
  Map<String, dynamic>? item;
  MyCourseItem({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return SignupFieldBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼 Course Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CachedNetworkImage(
                  imageUrl: '',
                  width: double.infinity,
                  height: 140.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: double.infinity,
                    height: 140.h,
                    decoration: BoxDecoration(
                      color: AppColors.pinkColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.pinkColor,
                      size: 40.sp,
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    AssetsPath.trendingCourseImg,
                    width: double.infinity,
                    height: 140.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Text(
                    item!['price']!,
                    style: AppTypography.inter12SemiBold,
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(
                 vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text(
                  item!['title']!,
                  style: AppTypography.inter14SemiBold,
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    _dateBox("Start Date", item!['start']!),
                    SizedBox(width: 10.w),
                    _dateBox("End Date", item!['end']!),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateBox(String label, String date) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: AppColors.darkBlue4,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: AppTypography.inter10Regular.copyWith(
                color: AppColors.white.withOpacity(0.5)
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              date,
              style: AppTypography.inter12SemiBold,
            ),
          ],
        ),
      ),
    );
  }
}
