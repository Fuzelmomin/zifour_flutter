import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../constants/app_colors.dart';
import '../constants/assets_path.dart';

class MentorVideosItem extends StatelessWidget {


  final String? videoName;
  final String? thumbnailUrl;
  final VoidCallback? itemClick;

  const MentorVideosItem({
    super.key,
    this.videoName,
    this.thumbnailUrl,
    this.itemClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        itemClick!();
      },
      child: SignupFieldBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Thumbnail with Play Button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CachedNetworkImage(
                    imageUrl: thumbnailUrl ?? '',
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
                // Duration Tag
                // Positioned(
                //   bottom: 8,
                //   right: 8,
                //   child: Container(
                //     padding:
                //     const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                //     decoration: BoxDecoration(
                //       color: Color(0xFF1B193D).withOpacity(0.5),
                //       borderRadius: BorderRadius.circular(6),
                //     ),
                //     child: Text(
                //       item['time'] ?? '',
                //       style: AppTypography.inter12Medium.copyWith(
                //         color: Color(0xFFF58D30)
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              videoName ?? '',
              style: AppTypography.inter14SemiBold,
            ),
            const SizedBox(height: 10),
            // Text(
            //   item['desc'] ?? '',
            //   style: AppTypography.inter12Regular.copyWith(
            //     color: AppColors.white.withOpacity(0.6)
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
