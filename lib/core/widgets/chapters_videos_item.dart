import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/live_class/model/lectures_model.dart';

import '../constants/app_colors.dart';
import '../constants/assets_path.dart';

class ChaptersVideosItem extends StatelessWidget {
  final LectureItem? lecture;
  final Function()? onTap;

  const ChaptersVideosItem({
    super.key,
    this.lecture,
    this.onTap,
  });

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
            // Video Thumbnail with Play Button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CachedNetworkImage(
                    imageUrl: lecture?.thumbnailUrl ?? '',
                    width: double.infinity,
                    height: 140.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: double.infinity,
                      height: 140.h,
                      decoration: BoxDecoration(
                        color: AppColors.pinkColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.video_library,
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
              lecture?.name ?? 'Lecture Title',
              style: AppTypography.inter20SemiBold,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Row(
              spacing: 8.0,
              children: [
                Flexible(
                  child: Text(
                    lecture?.chpName ?? 'Chapter',
                    style: AppTypography.inter14Regular.copyWith(
                      color: AppColors.skyColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.circle,
                  size: 10.0,
                  color: AppColors.white.withOpacity(0.1),
                ),
                if (lecture?.videoLength != null)
                  Flexible(
                    child: Text(
                      lecture!.videoLength!,
                      style: AppTypography.inter14Regular.copyWith(
                        color: AppColors.skyColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
