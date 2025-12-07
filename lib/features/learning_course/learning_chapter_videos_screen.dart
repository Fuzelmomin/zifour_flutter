
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/widgets/chapters_videos_item.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';

class LearningChapterVideosScreen extends StatefulWidget {
  LearningChapterVideosScreen({
    super.key,
  });

  @override
  State<LearningChapterVideosScreen> createState() => _LearningChapterVideosScreenState();
}

class _LearningChapterVideosScreenState extends State<LearningChapterVideosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.darkBlue,
        child: SafeArea(
          child: Stack(
            children: [
              // Background Decoration set

              Positioned.fill(
                child: Image.asset(
                  AssetsPath.signupBgImg,
                  fit: BoxFit.cover,
                ),
              ),

              // App Bar
              Positioned(
                  top: 20.h,
                  left: 15.w,
                  right: 20.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: "Chapter - units and measurement",
                  )),

              // Main Content with BLoC
              Positioned(
                top: 100.h,
                left: 20.w,
                right: 20.w,
                bottom: 0,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: 5,
                  padding: EdgeInsets.only(bottom: 20.h),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: ChaptersVideosItem(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
