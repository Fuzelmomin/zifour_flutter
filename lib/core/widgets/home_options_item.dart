import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

class HomeOptionsItem extends StatelessWidget {
  String? imagePath;
  String? title;
  String? subTitle;
  Function()? itemClick;
  HomeOptionsItem({super.key, this.imagePath, this.title, this.subTitle, this.itemClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        itemClick!();
      },
      child: Container(
        width: double.infinity,
        height: 80.h,
        child: SignupFieldBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: SvgPicture.asset(
                  imagePath ?? AssetsPath.svgFreeTrial,
                  width: 55.h,
                  height: 55.h,
                ),
              ),
              SizedBox(width: 5.w,),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title ?? '',
                      style: AppTypography.inter14SemiBold,
                    ),
                    SizedBox(height: 5.h,),
                    Text(
                      subTitle ?? '',
                      style: AppTypography.inter12Regular,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
