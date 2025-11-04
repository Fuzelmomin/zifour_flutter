import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../constants/app_colors.dart';
import '../constants/assets_path.dart';

class ChaptersVideosItem extends StatelessWidget {

  ChaptersVideosItem({super.key,});

  @override
  Widget build(BuildContext context) {
    return SignupFieldBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Thumbnail with Play Button
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
                      Icons.no_photography_rounded,
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
              // Play Icon Centered
              const Positioned.fill(
                child: Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
              ),

            ],
          ),
          const SizedBox(height: 8),
          Text(
            'MLT Formula',
            style: AppTypography.inter20SemiBold,
          ),
          const SizedBox(height: 3),
          Row(
            spacing: 8.0,
            children: [
              Text(
                'Chapter 1',
                style: AppTypography.inter14Regular.copyWith(
                    color: AppColors.skyColor
                ),
              ),
              Icon(Icons.circle, size: 10.0, color: AppColors.white.withOpacity(0.1),),
              Text(
                'Here Topic Name',
                style: AppTypography.inter14Regular.copyWith(
                    color: AppColors.skyColor
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
