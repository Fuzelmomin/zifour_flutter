import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';
import '../constants/assets_path.dart';
import '../theme/app_typography.dart';

class ModuleItem extends StatelessWidget {

  String? title;
  String? author;

  Function() itemClick;


  ModuleItem({
    super.key,
    this.title,
    this.author,
    required this.itemClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        itemClick();
      },
      child: AnimatedContainer(
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
                ],
              ),
              SizedBox(height: 7.h,),
              Text(
                'Author:',
                style: AppTypography.inter10Medium.copyWith(
                    color: const Color(0xFFF58D30)
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width - 100.0,
                child: Text(
                  author ?? '',
                  style: AppTypography.inter14Medium,
                ),
              ),
              /*SizedBox(height: 7.h,),
              Text(
                'Notes:',
                style: AppTypography.inter10Medium.copyWith(
                    color: const Color(0xFFF58D30)
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      notesDes ?? '',
                      style: AppTypography.inter10Medium.copyWith(
                          color: AppColors.skyColor
                      ),
                    ),
                  ),
                ],
              )*/
            ],
          )
      ),
    );
  }
}
