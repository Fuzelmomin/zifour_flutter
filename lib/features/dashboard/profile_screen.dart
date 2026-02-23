import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/utils/user_preference.dart';
import 'package:zifour_sourcecode/core/utils/image_picker_utils.dart';
import 'package:zifour_sourcecode/core/utils/connectivity_helper.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/auth/edit_profile_screen.dart';
import 'package:zifour_sourcecode/features/auth/bloc/profile_photo_bloc.dart';
import 'package:zifour_sourcecode/features/courses/my_courses_screen.dart';
import 'package:zifour_sourcecode/features/demo_ui.dart';
import 'package:zifour_sourcecode/features/mentor/mentors_videos_list_screen.dart';
import 'package:zifour_sourcecode/features/reset_password/reset_password_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_widget.dart';
import '../../core/widgets/profile_option_widget.dart';
import '../../l10n/app_localizations.dart';
import '../mentor/mentor_list_screen.dart';
import 'dashboard_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfilePhotoBloc(),
      child: _ProfileScreenContent(),
    );
  }
}

class _ProfileScreenContent extends StatefulWidget {
  @override
  State<_ProfileScreenContent> createState() => _ProfileScreenContentState();
}

class _ProfileScreenContentState extends State<_ProfileScreenContent> {
  void _handleBackButton(BuildContext context) {
    // Check if we can pop, if not navigate to home
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      // Find DashboardScreen state and navigate to home
      final dashboardState = context.findAncestorStateOfType<DashboardScreenState>();
      if (dashboardState != null) {
        dashboardState.navigateToHome();
      }
    }
  }

  void _handleImagePicker() async {
    // Check internet connectivity before opening dialog
    final isConnected = await ConnectivityHelper.checkConnectivity();
    if (!isConnected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No internet connection. Please check your network and try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    ImagePickerUtils.showImageSourceDialog(
      context: context,
      onImageSelected: (File imageFile) {
        // Trigger bloc event to upload and update profile photo
        context.read<ProfilePhotoBloc>().add(UploadAndUpdateProfilePhoto(imageFile));
      },
      onError: (String error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfilePhotoBloc, ProfilePhotoState>(
      listener: (context, state) {
        if (state is ProfilePhotoUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is ProfilePhotoError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: _buildScreen(),
    );
  }

  Widget _buildScreen() {
    return WillPopScope(
      onWillPop: () async {
        _handleBackButton(context);
        return false; // Prevent default back behavior
      },
      child: Scaffold(
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
                top: 20.h,
                left: 15.w,
                right: 20.w,
                child: CustomAppBar(
                  isBack: true,
                  onBack: () => _handleBackButton(context),
                )
            ),

            // Main Content with BLoC
            Positioned(
              top: 90.h,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // Profile avatar + info card section
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
                        final avatarSize = isLandscape ? 85.0 : 90.w;
                        final innerAvatarSize = isLandscape ? 75.0 : 80.w;
                        final avatarOverlap = avatarSize / 2;

                        return Column(
                          children: [
                            // Avatar row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: avatarSize,
                                  height: avatarSize,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Positioned.fill(
                                        child: BlocBuilder<ProfilePhotoBloc, ProfilePhotoState>(
                                          builder: (context, photoState) {
                                            final isLoading = photoState is ProfilePhotoUploading || 
                                                             photoState is ProfilePhotoUpdating;
                                            
                                            if (isLoading) {
                                              return Shimmer.fromColors(
                                                baseColor: Colors.white.withOpacity(0.08),
                                                highlightColor: Colors.white.withOpacity(0.2),
                                                child: Container(
                                                  width: avatarSize,
                                                  height: avatarSize,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppColors.pinkColor3.withOpacity(0.2),
                                                  ),
                                                ),
                                              );
                                            }

                                            return ValueListenableBuilder(
                                              valueListenable: UserPreference.userNotifier,
                                              builder: (context, userData, child) {
                                                return Container(
                                                  width: avatarSize,
                                                  height: avatarSize,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppColors.pinkColor3.withOpacity(0.2)
                                                  ),
                                                  child: Center(
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(innerAvatarSize / 2),
                                                      child: CachedNetworkImage(
                                                        imageUrl: userData?.stuImage ?? '',
                                                        width: innerAvatarSize,
                                                        height: innerAvatarSize,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context, url) => Container(
                                                          width: innerAvatarSize,
                                                          height: innerAvatarSize,
                                                          decoration: BoxDecoration(
                                                            color: AppColors.pinkColor.withOpacity(0.3),
                                                            borderRadius: BorderRadius.circular(innerAvatarSize / 2),
                                                          ),
                                                          child: Icon(
                                                            Icons.person,
                                                            color: AppColors.pinkColor,
                                                            size: isLandscape ? 24.0 : 30.sp,
                                                          ),
                                                        ),
                                                        errorWidget: (context, url, error) => Container(
                                                          width: innerAvatarSize,
                                                          height: innerAvatarSize,
                                                          decoration: BoxDecoration(
                                                            color: AppColors.pinkColor.withOpacity(0.3),
                                                            borderRadius: BorderRadius.circular(innerAvatarSize / 2),
                                                          ),
                                                          child: Icon(
                                                            Icons.person,
                                                            color: AppColors.pinkColor,
                                                            size: isLandscape ? 24.0 : 30.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        right: -5.0,
                                        bottom: 5.0,
                                        child: BlocBuilder<ProfilePhotoBloc, ProfilePhotoState>(
                                          builder: (context, photoState) {
                                            final isLoading = photoState is ProfilePhotoUploading || 
                                                             photoState is ProfilePhotoUpdating;
                                            
                                            return GestureDetector(
                                              onTap: isLoading ? null : _handleImagePicker,
                                              child: Container(
                                                width: 30.0,
                                                height: 30.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: isLoading 
                                                      ? AppColors.pinkColor.withOpacity(0.5)
                                                      : AppColors.pinkColor
                                                ),
                                                child: Center(
                                                  child: isLoading
                                                      ? SizedBox(
                                                          width: 15.0,
                                                          height: 15.0,
                                                          child: CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                              AppColors.darkBlue,
                                                            ),
                                                          ),
                                                        )
                                                      : Icon(
                                                          Icons.edit,
                                                          color: AppColors.darkBlue,
                                                          size: 16.0,
                                                        ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            // Info card overlapping the avatar bottom
                            Transform.translate(
                              offset: Offset(0, -avatarOverlap / 1.2),
                              child: SizedBox(
                                child: SignupFieldBox(
                                  boxBgColor: AppColors.pinkColor3.withOpacity(0.1),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: avatarOverlap / 2 + 8,
                                      bottom: isLandscape ? 10 : 15.h,
                                      left: 16.w,
                                      right: 16.w,
                                    ),
                                    child: ValueListenableBuilder(
                                      valueListenable: UserPreference.userNotifier,
                                      builder: (context, userData, child) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              userData?.stuName ?? 'Guest',
                                              style: AppTypography.inter24Medium,
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: isLandscape ? 4 : 5.h),
                                            Text(
                                              userData?.stuMobile ?? '',
                                              style: AppTypography.inter14Medium.copyWith(
                                                color: AppColors.white.withOpacity(0.5)
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                width: double.infinity,
                              ),
                            ),
                          ],
                        );
                      },
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
                    // ProfileOptionWidget(
                    //   title: '${AppLocalizations.of(context)?.mentors}',
                    //   itemClick: (){
                    //     Navigator.push(
                    //       context,
                    //       //MaterialPageRoute(builder: (context) => MentorsListScreen()),
                    //       MaterialPageRoute(builder: (context) => MentorsVideosListScreen(mentorId: '', isBack: true,)),
                    //     );
                    //   },
                    // ),
                    ProfileOptionWidget(
                      title: '${AppLocalizations.of(context)?.myCourse}',
                      itemClick: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyCoursesScreen()),
                        );
                      },
                    ),
                    // ProfileOptionWidget(
                    //   title: '${AppLocalizations.of(context)?.recentActivities}',
                    // ),
                    // ProfileOptionWidget(
                    //   title: '${AppLocalizations.of(context)?.resetPassword}',
                    //   itemClick: (){
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                    //     );
                    //   },
                    // ),
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

