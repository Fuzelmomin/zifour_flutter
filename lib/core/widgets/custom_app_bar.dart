import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';

class CustomAppBar extends StatelessWidget {
  String? title;
  bool? isBack;
  Function()? onBack;
  bool? isActionWidget;
  Widget? actionWidget;
  Function()? actionClick;
  bool? isLongText;

  CustomAppBar({
    super.key,
    this.title,
    this.isBack,
    this.onBack,
    this.isActionWidget,
    this.actionWidget,
    this.actionClick,
    this.isLongText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              isBack == true ? GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                  onBack!();
                },
                child: SvgPicture.asset(
                  AssetsPath.svgBack,
                  width: 32.w,
                  height: 32.h,
                ),
              ) : Container(),
              SizedBox(width: 10.w,),
              // isLongText == true ? SizedBox(
              //   width: MediaQuery.widthOf(context) * 0.4,
              //   child: Text(
              //     title ?? '',
              //     style: AppTypography.inter16SemiBold,
              //   ),
              // ) :
            Text(
                title ?? '',
                style: AppTypography.inter16SemiBold,
              ),
            ],
          ),

          isActionWidget == true ? GestureDetector(
            onTap: (){
              actionClick!();
            },
              child: actionWidget!
          ) : Container()
        ],
      ),
    );
  }
}
