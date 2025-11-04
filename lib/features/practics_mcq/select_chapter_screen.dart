import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/auth/edit_profile_screen.dart';
import 'package:zifour_sourcecode/features/courses/my_courses_screen.dart';
import 'package:zifour_sourcecode/features/demo_ui.dart';
import 'package:zifour_sourcecode/features/learning_course/learning_chapter_videos_screen.dart';
import 'package:zifour_sourcecode/features/mentor/mentors_list_screen.dart';
import 'package:zifour_sourcecode/features/practics_mcq/select_topic_screen.dart';
import 'package:zifour_sourcecode/features/reset_password/reset_password_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_widget.dart';
import '../../core/widgets/profile_option_widget.dart';
import '../../l10n/app_localizations.dart';

class SelectChapterScreen extends StatefulWidget {
  final String? from;
  SelectChapterScreen({super.key, this.from});

  @override
  State<SelectChapterScreen> createState() => _SelectChapterScreenState();
}

class _SelectChapterScreenState extends State<SelectChapterScreen> {

  List<String> chapterOptions = [
    "Motion",
    "Laws of Motions",
    "Gravitation",
    "Work, Energy & Power",
  ];


  @override
  void initState() {
    if(widget.from == "course"){
      chapterOptions = [
        "Units and Measurements",
        "Motion in a Straight Line",
        "Motion in a plane",
        "Motion in a Straight Liner",
        "Motion in a plane",
        "Units and Measurements"
      ];
    }
    super.initState();
  }

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
                  top: 0.h,
                  left: 15.w,
                  right: 20.w,
                  child: CustomAppBar(
                    isBack: true,
                  )
              ),

              // Main Content with BLoC
              Positioned(
                top: 70.h,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 15.h,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 160.h,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 40.h,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                height: 110.h,
                                width: double.infinity,
                                child: SignupFieldBox(
                                  boxBgColor: AppColors.pinkColor3.withOpacity(0.1),
                                  child: Container(
                                    margin: EdgeInsets.only(top: 15.h),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [

                                        Text(
                                          'Physics',
                                          style: AppTypography.inter24Medium,
                                        ),
                                        SizedBox(height: 5.h,),
                                        Text(
                                          'Select a Chapter',
                                          style: AppTypography.inter14Medium.copyWith(
                                              color: Color(0xffC55492)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70.w,
                                    height: 70.w,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.pinkColor3.withOpacity(0.2)
                                    ),
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30.r),
                                        child: Image.asset(
                                          AssetsPath.icPhysics,
                                          width: 60.0,
                                          height: 60.0,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Column(
                        children: chapterOptions.map((title) {
                          return ProfileOptionWidget(
                            title: title,
                            itemClick: () {
                              if(widget.from == "course"){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LearningChapterVideosScreen()),
                                );
                              }else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SelectTopicScreen()),
                                );
                              }

                            },
                          );
                        }).toList(),
                      )

                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

