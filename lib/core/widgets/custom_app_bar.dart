import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';

class CustomAppBar extends StatelessWidget {
  String? title;
  bool? isBack;
  Function()? onBack;

  CustomAppBar({
    super.key,
    this.title,
    this.isBack,
    this.onBack
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isBack == true ? GestureDetector(
            onTap: (){
              onBack!();
            },
            child: SvgPicture.asset(
              AssetsPath.svgBack,
              width: 32.w,
              height: 32.h,
            ),
          ) : Container(),
          SizedBox(width: 10.w,),
          Text(
            title ?? '',
            style: AppTypography.inter16SemiBold,
          )
        ],
      ),
    );
  }
}
