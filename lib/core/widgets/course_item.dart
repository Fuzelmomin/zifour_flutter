import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../constants/assets_path.dart';

class CourseItem extends StatelessWidget {
  Map<String, dynamic>? item;
  Function()? onTap;
  CourseItem({super.key, this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap!();
      },
      child: SignupFieldBox(
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFFCF078A), // Pink
                          Color(0xFF5E00D8)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFCF078A).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      'Best Selling',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 10.w,
                    children: [
                      _iconLabelWidget(AssetsPath.svgFileText, 'Include 12 Tests'),
                      _iconLabelWidget(AssetsPath.svgPlayCircle, '10 Videos')
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    '11th & 12th Science - Full Syllabus',
                    style: AppTypography.inter14SemiBold,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    spacing: 5.w,
                    children: [
                      Text(
                        '₹ 1,999',
                        style: AppTypography.inter18SemiBold,
                      ),
                      Text(
                        "₹ 3,999",
                        style: AppTypography.inter12Medium.copyWith(
                          color: AppColors.white.withOpacity(0.5),
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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

Widget _iconLabelWidget(String iconPath, String title) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
    decoration: BoxDecoration(
      color: Color(0xFF4C4993),
      borderRadius: BorderRadius.all(Radius.circular(6.r))
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 7.w,
      children: [
        SvgPicture.asset(
          iconPath,
          width: 15.h,
          height: 15.h,
        ),
        Text(
          title,
          style: AppTypography.inter12SemiBold,
        )
      ],
    ),
  );
}
