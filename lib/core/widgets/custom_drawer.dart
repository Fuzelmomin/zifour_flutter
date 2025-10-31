import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/utils/dialogs_utils.dart';
import 'package:zifour_sourcecode/core/widgets/my_notes_item.dart';
import 'package:zifour_sourcecode/features/bookmarked/bookmarked_list_screen.dart';
import 'package:zifour_sourcecode/features/courses/change_courses_screen.dart';
import 'package:zifour_sourcecode/features/doubts/ask_doubts_screen.dart';
import 'package:zifour_sourcecode/features/give_feedback/give_feedback_screen.dart';
import 'package:zifour_sourcecode/features/help_support/help_support_screen.dart';
import 'package:zifour_sourcecode/features/multimedia_library/multimedia_library_screen.dart';
import 'package:zifour_sourcecode/features/my_performance/my_performance_screen.dart';
import 'package:zifour_sourcecode/features/zifour_calender/zifour_calender_screen.dart';

import '../../features/demo_ui.dart';
import '../../features/my_notes/my_notes_list_screen.dart';
import '../../l10n/app_localizations.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkBlue3, // deep blue like your image
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.r),
                    child: CachedNetworkImage(
                      imageUrl: 'https://i.pravatar.cc/150?img=3',
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
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jhone Doe",
                        style: AppTypography.inter18Medium,
                      ),
                      Text(
                        "98989852530",
                        style: AppTypography.inter14Medium,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30.h),

              // Menu Items
              Expanded(
                child: ListView(
                  children: [
                    _drawerItem(AssetsPath.svgUser, "My Profile", (){
                      Navigator.pop(context);
                    }),
                    _drawerItem(AssetsPath.svgEdit, "Change Course", (){
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChangeCourseScreen()),
                      );
                    }),
                    _drawerItem(AssetsPath.svgCalendar, "Zifour Calendar", (){
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ZifourCalenderScreen()),
                      );
                    }),
                    _drawerItem(AssetsPath.svgBookmark, "Bookmarked Question", (){
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BookmarkedListScreen()),
                      );
                    }),
                    _drawerItem(AssetsPath.svgHelpCircle, "My Doubts", (){
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AskDoubtsScreen()),
                      );
                    }),
                    _drawerItem(AssetsPath.svgNote, "My Notes", (){
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyNotesListScreen()),
                      );
                    }),
                    _drawerItem(AssetsPath.svgBarChart, "My Performance", (){
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyPerformanceScreen()),
                      );
                    }),
                    _drawerItem(AssetsPath.svgStar, "Feedback", (){
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GiveFeedbackScreen()),
                      );
                    }),
                    _drawerItem(AssetsPath.svgHelpCircle, "Help/Support", (){
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                      );
                    }),
                    _drawerItem(AssetsPath.svgRefresh, "Reset Password", (){
                      Navigator.pop(context);
                    }),
                    _drawerItem(AssetsPath.svgPlayCircle, "Multimedia Library", (){
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MultimediaLibraryScreen()),
                      );
                    }),
                    _drawerItem(AssetsPath.svgLogout, "Logout", (){
                      Navigator.pop(context);
                      DialogsUtils.confirmDialog(
                          context,
                        title: '${AppLocalizations.of(context)?.logout}?',
                        message: '${AppLocalizations.of(context)?.areYouWantLogout}',
                        negativeBtnName: '${AppLocalizations.of(context)?.no}',
                        positiveBtnName: '${AppLocalizations.of(context)?.yes}',
                        positiveClick: (){
                          Navigator.pop(context, false);
                        },
                        negativeClick: (){

                        }
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(String icon, String title, Function() itemClick) {
    return GestureDetector(
      onTap: (){

        itemClick();
      },
      child: Container(
        height: 50.h,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 20.w,
              height: 20.h,
            ),
            SizedBox(width: 15.w),
            Text(
              title,
              style: AppTypography.inter16Regular,
            ),
          ],
        ),
      ),
    );
  }
}
