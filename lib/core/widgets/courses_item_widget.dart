import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/assets_path.dart';
import '../theme/app_typography.dart';
import 'signup_field_box.dart';

class CoursesItemWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? badge;
  final String? discount;
  final String? finalPrice;
  final String? originalPrice;
  final String? imageUrl;
  final VoidCallback? onTap;

  const CoursesItemWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.badge,
    this.discount,
    this.finalPrice,
    this.originalPrice,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: MediaQuery.widthOf(context) - 100.w,
        margin: EdgeInsets.only(right: 15.w),
        child: SignupFieldBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150.h,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl ?? '',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.pinkColor.withOpacity(0.15),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            AssetsPath.trendingCourseImg,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10.h,
                      left: 10.w,
                      right: 10.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildBadge(
                            text: badge ?? 'Best Seller',
                            //background: Colors.black.withOpacity(0.7),
                          ),
                          if ((discount ?? '').isNotEmpty)
                            _buildBadge(
                              text: discount!,
                              background: const LinearGradient(
                                colors: [Color(0xFFCF0786), Color(0xFF690444)],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                title,
                style: AppTypography.inter14SemiBold,
              ),
              if ((subtitle ?? '').isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  subtitle!,
                  style: AppTypography.inter12Regular.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
              SizedBox(height: 8.h),
              Row(
                children: [
                  if ((finalPrice ?? '').isNotEmpty)
                    Text(
                      finalPrice!,
                      style: AppTypography.inter14SemiBold.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  if ((originalPrice ?? '').isNotEmpty) ...[
                    SizedBox(width: 8.w),
                    Text(
                      originalPrice!,
                      style: AppTypography.inter12Regular.copyWith(
                        color: Colors.white.withOpacity(0.6),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge({
    required String text,
    Gradient? background,
    Color? color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.r),
        color: background == null ? color : null,
        gradient: background,
      ),
      child: Text(
        text,
        style: AppTypography.inter10SemiBold,
      ),
    );
  }
}
