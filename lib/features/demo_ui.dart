import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChallengerZoneScreen extends StatelessWidget {
  const ChallengerZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.white, size: 22.sp),
        ),
        title: Text(
          "Challenger Zone",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A148C), // purple shade like screenshot top
              Color(0xFF0D1B3E), // deep navy
              Color(0xFF000000), // dark gradient bottom
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose how you want to challenge\nyourself today.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 25.h),

                /// Create Own Challenge Card
                _challengeCard(
                  icon: Icons.all_inclusive,
                  title: "Create your own challenge",
                  subtitle:
                  "Select your subjects, Chapters, Topics and take\ncontrol of your practice.",
                  buttonText: "Create Own Challenge",
                  onTap: () {},
                ),
                SizedBox(height: 20.h),

                /// Expert Challenge Card
                _challengeCard(
                  icon: Icons.person_outline,
                  title: "Expert’s Challenge",
                  subtitle:
                  "Complete in faculty-designed challenges held\ntwice a month with fixed syllabus.",
                  buttonText: "Expert Challenge",
                  onTap: () {},
                ),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _challengeCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white.withOpacity(0.09),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 36.h,
                width: 36.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
                child: Icon(icon, color: Colors.white, size: 20.sp),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12.sp,
              height: 1.4,
            ),
          ),
          SizedBox(height: 15.h),

          /// Button
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 42.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFE3C80),
                    Color(0xFF8F00FF),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 18.sp),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
