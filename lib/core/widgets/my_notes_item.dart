import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';
import '../constants/assets_path.dart';
import '../theme/app_typography.dart';

class MyNotesItem extends StatelessWidget {

  String? title;
  String? noteType;
  String? notesDes;
  Function()? deleteClick;


  MyNotesItem({
    super.key,
    this.title,
    this.noteType,
    this.notesDes,
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
            SizedBox(height: 7.h,),
            Text(
              'Notes:',
              style: AppTypography.inter10Medium.copyWith(
                  color: const Color(0xFFF58D30)
              ),
            ),
            Expanded(
              child: Text(
                'Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search ',
                style: AppTypography.inter10Medium.copyWith(
                    color: AppColors.skyColor
                ),
              ),
            )
          ],
        )
    );
  }
}
