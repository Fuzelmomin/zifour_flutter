import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/dialogs/create_reminder_dialog.dart';
import 'package:zifour_sourcecode/core/widgets/course_item.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/payment/payment_status_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/my_course_item.dart';
import '../../l10n/app_localizations.dart';

class LiveClassDetailsScreen extends StatefulWidget {
  const LiveClassDetailsScreen({super.key});

  @override
  State<LiveClassDetailsScreen> createState() => _LiveClassDetailsScreenState();
}

class _LiveClassDetailsScreenState extends State<LiveClassDetailsScreen> {
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
                    title: 'Biology',
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
                      "Explore Biology Concepts Live – Grow Smarter With Zifour.",
                      style: AppTypography.inter16Regular.copyWith(
                          color: AppColors.white.withOpacity(0.6)
                      ),
                    ),

                    SizedBox(height: 15.h),
                    /// Class Card

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        /// Live Tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          margin: EdgeInsets.only(right: 25.w),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(6.r), topRight: Radius.circular(6.r)),
                          ),
                          child: const Text(
                            "LIVE",
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(0),  // top-right = 0
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(height: 6),

                          const Text(
                            "Human Physiology",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),

                          const Text(
                            "April 24   |   10:00 AM - 1:00 PM",
                            style: TextStyle(color: Colors.orange, fontSize: 13),
                          ),

                          const SizedBox(height: 12),
                          Container(height: 1, color: Colors.white24),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              /// Profile image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  "https://i.pravatar.cc/150?img=15",
                                  height: 42,
                                  width: 42,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),

                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pankaj Sharma",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    "Expert of Biology",
                                    style:
                                    TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              )
                            ],
                          ),

                          const SizedBox(height: 18),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              /// Remind Me
                              GestureDetector(
                                onTap: (){
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true, // Optional tap outside close
                                    builder: (_) => const CreateReminderDialog(),
                                  );
                                },
                                child: Text(
                                  "Remind Me",
                                  style: AppTypography.inter14Bold.copyWith(
                                    color: AppColors.pinkColor,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.pinkColor
                                  ),
                                ),

                              ),

                              /// Join Now Button
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFD2D7B), Color(0xFF6B2CF5)],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Join Class Now!",
                                      style: AppTypography.inter14Bold,
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.play_arrow,
                                        color: Colors.white, size: 18),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
