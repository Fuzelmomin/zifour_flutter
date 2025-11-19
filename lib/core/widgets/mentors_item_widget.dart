import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../constants/app_colors.dart';
import '../constants/assets_path.dart';
import '../theme/app_typography.dart';

class MentorsItemWidget extends StatelessWidget {
  final String? videoName;
  final String? thumbnailUrl;
  final VoidCallback? itemClick;

  const MentorsItemWidget({
    super.key,
    this.videoName,
    this.thumbnailUrl,
    this.itemClick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: itemClick,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
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
                          imageUrl: thumbnailUrl ?? '',
                          width: double.infinity,
                          height: 150.h,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: double.infinity,
                            height: 150.h,
                            decoration: BoxDecoration(
                              color: AppColors.pinkColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(),
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
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_circle_fill_rounded,
                          size: 40.sp,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                videoName ?? 'Mentor Video',
                style: AppTypography.inter14SemiBold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}
