import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../l10n/app_localizations.dart';
import '../constants/app_colors.dart';
import '../constants/assets_path.dart';
import '../theme/app_typography.dart';

class UploadDocBoxWidget extends StatelessWidget {
  String? title;
  Function()? itemClick;
  File? imageFile;
  
  UploadDocBoxWidget({
    super.key, 
    this.title, 
    this.itemClick,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        itemClick?.call();
      },
      child: DottedBorder(
        options: RectDottedBorderOptions(
            dashPattern: [5, 2],
            strokeWidth: 1,
            padding: EdgeInsets.all(12),
            color: AppColors.white.withOpacity(0.3)),
        child: imageFile != null
            ? Row(
                spacing: 10.w,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.file(
                      imageFile!,
                      width: 60.h,
                      height: 60.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title ?? 'Image Selected',
                          style: AppTypography.inter12Regular.copyWith(
                            color: Colors.white.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Tap to change',
                          style: AppTypography.inter10Regular.copyWith(
                            color: AppColors.pinkColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 24.sp,
                  ),
                ],
              )
            : Row(
                spacing: 10.w,
                children: [
                  SvgPicture.asset(
                    AssetsPath.svgUploadDoc,
                    width: 40.h,
                    height: 40.h,
                  ),
                  Expanded(
                    child: Text(
                      title ?? '',
                      style: AppTypography.inter12Regular.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
