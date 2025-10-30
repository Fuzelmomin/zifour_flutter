import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/auth/edit_profile_screen.dart';
import 'package:zifour_sourcecode/features/courses/my_courses_screen.dart';
import 'package:zifour_sourcecode/features/demo_ui.dart';
import 'package:zifour_sourcecode/features/mentor/mentors_list_screen.dart';
import 'package:zifour_sourcecode/features/reset_password/reset_password_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_widget.dart';
import '../../core/widgets/profile_option_widget.dart';
import '../../l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.darkBlue,
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
                top: 40.h,
                left: 15.w,
                right: 20.w,
                child: CustomAppBar(
                  isBack: true,
                )
            ),

            // Main Content with BLoC
            Positioned(
              top: 120.h,
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
                                        'Jhone Deo',
                                        style: AppTypography.inter24Medium,
                                      ),
                                      SizedBox(height: 5.h,),
                                      Text(
                                        '1234566789',
                                        style: AppTypography.inter14Medium.copyWith(
                                          color: AppColors.white.withOpacity(0.5)
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
                                      child: CachedNetworkImage(
                                        imageUrl: 'https://i.pravatar.cc/150?img=3',
                                        width: 60.w,
                                        height: 60.h,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          width: 60.w,
                                          height: 60.h,
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
                                          width: 60.w,
                                          height: 60.h,
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
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ProfileOptionWidget(
                      title: '${AppLocalizations.of(context)?.studentInfo}',
                      itemClick: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                        );
                      },
                    ),
                    ProfileOptionWidget(
                      title: '${AppLocalizations.of(context)?.mentors}',
                      itemClick: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MentorsListScreen()),
                        );
                      },
                    ),
                    ProfileOptionWidget(
                      title: '${AppLocalizations.of(context)?.myCourse}',
                      itemClick: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyCoursesScreen()),
                        );
                      },
                    ),
                    ProfileOptionWidget(
                      title: '${AppLocalizations.of(context)?.recentActivities}',
                    ),
                    ProfileOptionWidget(
                      title: '${AppLocalizations.of(context)?.resetPassword}',
                      itemClick: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

