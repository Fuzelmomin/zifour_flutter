import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../constants/app_colors.dart';
import '../constants/assets_path.dart';
import '../theme/app_typography.dart';

class MentorsItemWidget extends StatelessWidget {
  String? mentorName;
  Function()? itemClick;
  MentorsItemWidget({super.key, this.mentorName, this.itemClick});

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
                        imageUrl: 'https://www.istockphoto.com/photo/schoolgirls-gm539812344-96261695?utm_source=unsplash&utm_medium=affiliate&utm_campaign=srp_photos_bottom&utm_content=https%3A%2F%2Funsplash.com%2Fs%2Fphotos%2Fsyllabus&utm_term=syllabus%3A%3Alayout-below-fold-units-2%3Aexperiment',
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
                  Center(
                    child: Icon(
                      Icons.play_circle_fill_rounded,
                      size: 40.0,
                      color: Colors.black.withOpacity(0.7),
                    )
                  )
                ],
              ),
            ),

            SizedBox(height: 10.h,),
            Text(
              mentorName ?? 'Jhone Deo',
              style: AppTypography.inter14SemiBold,
            )
          ],
        ),
      ),
    );
  }
}
