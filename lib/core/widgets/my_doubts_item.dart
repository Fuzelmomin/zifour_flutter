import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';

class MyDoubtsItem extends StatelessWidget {
  String? title;
  String? imageUrl;
  bool? isReplied;
  Function()? itemClick;
  MyDoubtsItem({super.key, this.title, this.isReplied, this.itemClick, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (imageUrl != null && imageUrl!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CachedNetworkImage(
              imageUrl: imageUrl!,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: const Icon(Icons.broken_image, color: Colors.white38, size: 40),
              ),
            ),
          ),
        Text(
          title ?? '',
          style: AppTypography.inter14SemiBold.copyWith(
            color: AppColors.white.withOpacity(0.6)
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isReplied == true ? Icons.check_circle_outline : Icons.query_builder,
              size: 20.0,
              color: isReplied == true ? AppColors.green : AppColors.orange,
            ),
            SizedBox(width: 5.w,),
            Text(
              isReplied == true ? 'Answered' : 'Pending',
              style: AppTypography.inter12Medium.copyWith(
                color: isReplied == true ? AppColors.green : AppColors.orange,
              ),
            )
          ],
        )
      ],
    );
  }
}


