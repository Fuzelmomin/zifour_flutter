import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';
import '../constants/assets_path.dart';
import '../theme/app_typography.dart';

class BookmarkItem extends StatelessWidget {

  String? title;
  String? description;
  String? bookmarkType;
  Function()? deleteClick;


  BookmarkItem({
    super.key,
    this.title,
    this.description,
    this.bookmarkType,
    this.deleteClick,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 2500),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
            color: Color(0xFF1B193D),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
                color: AppColors.white.withOpacity(0.1),
                width: 1.0
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Text(
                    title ?? '',
                    style: AppTypography.inter14Medium,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: (){
                      deleteClick!();
                    },
                    child: SvgPicture.asset(
                      AssetsPath.svgCloseCircle,
                      width: 20.w,
                      height: 20.h,
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 5.h,),
            Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Text(
                    description ?? '',
                    style: AppTypography.inter12Medium.copyWith(color: AppColors.hintTextColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 7.h,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16.r)),
                color: Colors.transparent,
                border: BoxBorder.all(
                  color: AppColors.white.withOpacity(0.1),
                  width: 1.0
                )
              ),
              child: Text(
                bookmarkType ?? '',
                style: AppTypography.inter10Medium.copyWith(
                    color: const Color(0xFFF58D30)
                ),
              ),
            ),
          ],
        )
    );
  }
}
