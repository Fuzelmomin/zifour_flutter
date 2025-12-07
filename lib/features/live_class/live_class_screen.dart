import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/widgets/course_item.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/live_class/live_class_details_screen.dart';
import 'package:zifour_sourcecode/features/payment/payment_status_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/dialogs/create_reminder_dialog.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/my_course_item.dart';
import '../../l10n/app_localizations.dart';

class LiveClassScreen extends StatefulWidget {
  const LiveClassScreen({super.key});

  @override
  State<LiveClassScreen> createState() => _LiveClassScreenState();
}

class _LiveClassScreenState extends State<LiveClassScreen> {
  int selectedTab = 0;
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
                    title: 'Live Classes',
                  )),

              // Main Content with BLoC
              Positioned(
                top: 90.h,
                left: 20.w,
                right: 20.w,
                bottom: 50.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Zifour Live Classes – Learn Smarter,\nAchieve Greater.",
                      style: AppTypography.inter16Regular.copyWith(
                          color: AppColors.white.withOpacity(0.6)
                      ),
                    ),

                    SizedBox(height: 15.h),
                    /// Tabs: Today & Upcoming
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _tabButton("Today", 0),
                          _tabButton("Upcoming", 1),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),
                    /// Class Cards List
                    selectedTab == 0 ? Expanded(
                      child: ListView(
                        children: [
                          _classCard("Physics", "Laws of Motion", "11:30 AM", Icons.science, null, "Join Now!", (){}),
                          const SizedBox(height: 14),
                          _classCard("Biology", "Photosynthesis", "9:30 AM", Icons.biotech, null, "Join Now!", (){}),
                          const SizedBox(height: 14),
                          _classCard("Chemistry", "Laws of Motion", "12:30 AM", Icons.local_fire_department, null, "Join Now!", (){}),
                        ],
                      ),
                    ) : Expanded(
                      child: ListView(
                        children: [
                          _classCard("Physics", "Laws of Motion", "11:30 AM", Icons.science, "15th July 2025", "Remind Me", (){
                            showDialog(
                              context: context,
                              barrierDismissible: true, // Optional tap outside close
                              builder: (_) => const CreateReminderDialog(),
                            );
                          }),
                          const SizedBox(height: 14),
                          _classCard("Biology", "Photosynthesis", "9:30 AM", Icons.biotech, "17th July 2025", "Remind Me", (){
                            showDialog(
                              context: context,
                              barrierDismissible: true, // Optional tap outside close
                              builder: (_) => const CreateReminderDialog(),
                            );
                          }),
                          const SizedBox(height: 14),
                          _classCard("Chemistry", "Laws of Motion", "12:30 AM", Icons.local_fire_department, "20th July 2025", "Remind Me", (){
                            showDialog(
                              context: context,
                              barrierDismissible: true, // Optional tap outside close
                              builder: (_) => const CreateReminderDialog(),
                            );
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// Tab Button Widget
  Widget _tabButton(String text, int index) {
    bool active = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: active
                ? const LinearGradient(
                colors: [Color(0xFFFD2D7B), Color(0xFF6B2CF5)])
                : null,
            color: active ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: active ? Colors.white : Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// Class Card UI
  Widget _classCard(String title, String subtitle, String time, IconData icon, String? date, String btnName, Function() onTap, {Function()? itemClick}) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LiveClassDetailsScreen()),
        );
      },
      child: SignupFieldBox(

        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    width: 50.h,
                    height: 50.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white.withOpacity(0.1),
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.2),
                        width: 1.2
                      )
                    ),
                    child: Center(child: Icon(icon, color: Colors.white70, size: 28))),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(fontSize: 13, color: Colors.white54)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 15),

            Container(height: 1, color: Colors.white24),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 7.0,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 18, color: AppColors.orange),
                        const SizedBox(width: 6),
                        Text(time, style: AppTypography.inter12SemiBold.copyWith(color: AppColors.orange)),
                      ],
                    ),
                    date != null ? Row(
                      children: [
                        Icon(Icons.calendar_month_rounded, size: 18, color: AppColors.orange),
                        const SizedBox(width: 6),
                        Text(date ?? '', style: AppTypography.inter12SemiBold.copyWith(color: AppColors.orange)),
                      ],
                    ) : Container(),
                  ],
                ),

                GestureDetector(
                  onTap: (){
                    onTap();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFFFD2D7B), Color(0xFF6B2CF5)]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(btnName, style: TextStyle(color: Colors.white,fontSize: 13)),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}
