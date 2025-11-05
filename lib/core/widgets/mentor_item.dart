import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/custom_gradient_button.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../constants/app_colors.dart';
import '../constants/assets_path.dart';

class MentorItem extends StatelessWidget {
  Map<String, String> item;
  Function() onTap;
  MentorItem({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SignupFieldBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Thumbnail with Play Button
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedNetworkImage(
              imageUrl: item['img'] ?? '',
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
                  Icons.hide_image_outlined,
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
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? '',
                    style: AppTypography.inter14SemiBold,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item['desc'] ?? '',
                    style: AppTypography.inter12Regular.copyWith(
                        color: AppColors.white.withOpacity(0.6)
                    ),
                  ),
                ],
              ),
              CustomGradientArrowButton(
                width: 100.w,
                height: 45.h,
                text: 'VIEW',
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                icon: Image.asset(
                  AssetsPath.icPlayCircle,
                  width: 35.h,
                  height: 35.h,
                ),
                onPressed: (){
                  onTap();
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
