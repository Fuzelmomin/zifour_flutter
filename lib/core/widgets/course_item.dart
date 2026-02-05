import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_colors.dart';
import '../constants/assets_path.dart';
import '../theme/app_typography.dart';
import '../widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/courses/models/course_package.dart';

class CourseItem extends StatelessWidget {
  const CourseItem({
    super.key,
    this.package,
    this.onTap,
  });

  final CoursePackage? package;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final label = package?.label.isNotEmpty == true ? package!.label : 'Best Selling';
    final title = package?.name ?? '11th & 12th Science - Full Syllabus';
    final testsText = '${package?.totalTests ?? 0} Tests';
    final videosText = '${package?.totalVideo ?? 0} Videos';
    final finalPrice = package?.finalPrice ?? '₹ 0';
    final oldPrice = package?.oldPrice;
    final imageUrl = package?.imageUrl ?? '';

    return GestureDetector(
      onTap: onTap,
      child: SignupFieldBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: _CourseImage(imageUrl: imageUrl),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFCF078A),
                          Color(0xFF5E00D8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFCF078A).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      label,
                      style: AppTypography.inter12SemiBold,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 10.h),
                  // Row(
                  //   spacing: 10.w,
                  //   children: [
                  //     _iconLabelWidget(AssetsPath.svgFileText, testsText),
                  //     _iconLabelWidget(AssetsPath.svgPlayCircle, videosText),
                  //   ],
                  // ),
                  SizedBox(height: 10.h),
                  Text(
                    title,
                    style: AppTypography.inter14SemiBold,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    spacing: 5.w,
                    children: [
                      Text(
                        finalPrice,
                        style: AppTypography.inter18SemiBold,
                      ),
                      if (oldPrice != null && oldPrice.isNotEmpty)
                        Text(
                          oldPrice,
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
}

Widget _iconLabelWidget(String iconPath, String title) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
    decoration: BoxDecoration(
      color: const Color(0xFF4C4993),
      borderRadius: BorderRadius.all(Radius.circular(6.r)),
    ),
    child: Row(
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
        ),
      ],
    ),
  );
}

class _CourseImage extends StatelessWidget {
  const _CourseImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Image.asset(
        AssetsPath.trendingCourseImg,
        width: double.infinity,
        height: 140.h,
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
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
    );
  }
}
