import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../constants/app_colors.dart';

class CoursesItemWidget extends StatelessWidget {
  String? courseType;
  String? courseName;
  String? courseDiscount;
  CoursesItemWidget({
    super.key,
    this.courseType,
    this.courseName,
    this.courseDiscount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.widthOf(context) - 100.w,
      margin: EdgeInsets.only(right: 15.w),
      height: 185.h,
      child: SignupFieldBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 150.h,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CachedNetworkImage(
                        imageUrl: '',
                        width: double.infinity,
                        height: 150.h,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: double.infinity,
                          height: 150.h,
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
                          height: 150.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    right: 10.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100.r)),
                            color: Colors.black.withOpacity(0.8)
                          ),
                          child: Text(
                            courseType ?? 'Most Popular',
                            style: AppTypography.inter10SemiBold,
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(100.r)),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFFCF0786), // Cyan middle
                                  Color(0xFFCF0786), // Light purple top-right
                                  Color(0xFF690444), // Light purple top-right
                                ],

                              )
                          ),
                          child: Text(
                            courseDiscount ?? '20%',
                            style: AppTypography.inter10SemiBold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 10.h,),
            Text(
              courseName ?? '11th & 12th Science - Full Syllabus',
              style: AppTypography.inter14SemiBold,
            )
          ],
        ),
      ),
    );
  }
}
