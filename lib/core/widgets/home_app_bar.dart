import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';

import '../constants/app_colors.dart';

class HomeAppBar extends StatelessWidget {
  String? profileImg;
  Function()? profileClick;
  Function()? notificationClick;

  HomeAppBar({
    super.key,
    this.profileImg,
    this.profileClick,
    this.notificationClick
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
          ClipRRect(
            borderRadius: BorderRadius.circular(30.r),
            child: CachedNetworkImage(
              imageUrl: profileImg ?? '',
              width: 50.w,
              height: 50.h,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.pinkColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.pinkColor,
                  size: 30.sp,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.pinkColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.pinkColor,
                  size: 30.sp,
                ),
              ),
            ),
          ),
          Image.asset(
              AssetsPath.appTitleLogo,
            width: 88.w,
            height: 30.h,
          ),
          SvgPicture.asset(
              AssetsPath.svgNotification,
            width: 50.w,
            height: 50.h,
          )
        ],
      ),
    );
  }
}
