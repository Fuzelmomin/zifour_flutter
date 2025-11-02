import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/india_test_series/test_analysis_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';

class AllIndiaTestSeriesScreen extends StatefulWidget {
  const AllIndiaTestSeriesScreen({super.key});

  @override
  State<AllIndiaTestSeriesScreen> createState() => _AllIndiaTestSeriesScreenState();
}

class _AllIndiaTestSeriesScreenState extends State<AllIndiaTestSeriesScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
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
                  right: 5.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: 'All India Test Series',
                  )),
              // Main Content with BLoC
              Positioned(
                top: 70.h,
                left: 20.w,
                right: 20.w,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          testCard(
                            title: "Full Syllabus Neet Test 01",
                            status: "Available on 15th September",
                            statusColor: Colors.purpleAccent,
                            icon: Icons.check_circle,
                            iconColor: Colors.purpleAccent,
                            date: "15th September",
                            duration: "3 Hours",
                          ),
                          testCard(
                            title: "Full Syllabus Neet Test 01",
                            status: "Attempt Now",
                            statusColor: Colors.orange,
                            icon: Icons.error,
                            iconColor: Colors.orange,
                            date: "21st September",
                            duration: "4 Hours",
                          ),
                          testCard(
                            title: "Full Syllabus Neet Test 03",
                            status: "Completed on 24th September",
                            statusColor: Colors.greenAccent,
                            icon: Icons.verified,
                            iconColor: Colors.greenAccent,
                            date: "21st September",
                            duration: "4 Hours",
                          ),

                        ],
                      ),
                    ),

                    CustomGradientButton(
                      text: 'View Past Test Result',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TestAnalysisScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget testCard({
    required String title,
    required String status,
    required Color statusColor,
    required IconData icon,
    required Color iconColor,
    required String date,
    required String duration,
  }) {
    return SignupFieldBox(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),

          // Status Row
          Row(
            children: [
              Icon(icon, color: iconColor, size: 16),
              const SizedBox(width: 6),
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Date + Time Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: Color(0xff0D0B2F).withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "•",
                  style: TextStyle(color: Colors.white54),
                ),
                const SizedBox(width: 8),
                Text(
                  duration,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}

