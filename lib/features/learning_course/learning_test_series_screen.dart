import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/india_test_series/test_analysis_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';

class LearningTestSeriesScreen extends StatefulWidget {
  const LearningTestSeriesScreen({super.key});

  @override
  State<LearningTestSeriesScreen> createState() => _LearningTestSeriesScreenState();
}

class _LearningTestSeriesScreenState extends State<LearningTestSeriesScreen> {

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
                    title: 'Test Series',
                  )),
              // Main Content with BLoC
              Positioned(
                top: 70.h,
                left: 20.w,
                right: 20.w,
                bottom: 0,
                child: ListView.separated(
                  itemCount: 5,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return testCard();
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 15.h,
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

  Widget testCard() {
    return SignupFieldBox(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Test Series #05",
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
              Text(
                "Completed",
                style: AppTypography.inter12Regular.copyWith(
                  color: AppColors.white.withOpacity(0.6)
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.check_circle, color: AppColors.green, size: 16),

            ],
          ),

          const SizedBox(height: 15),

          // Date + Time Box
          SignupFieldBox(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Row(
              children: [
                Text(
                  "Physics",
                  style: const TextStyle(
                    color: AppColors.skyColor,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.circle, color: AppColors.white.withOpacity(0.4), size: 10),
                const SizedBox(width: 8),
                Text(
                  "Chemistry",
                  style: const TextStyle(
                    color: AppColors.skyColor,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.circle, color: AppColors.white.withOpacity(0.4), size: 10),
                Text(
                  "Maths",
                  style: const TextStyle(
                    color: AppColors.skyColor,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0,),
          SizedBox(
            height: 8.h,
          ),
          Row(
            spacing: 15.w,
            children: [
              Expanded(
                child: CustomGradientButton(
                  text: 'My Performance',
                  onPressed: () {},
                  customDecoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                      color: Color(0xFF464375)
                  ),
                ),
              ),

              Expanded(
                child: CustomGradientButton(
                  text: 'View Solutions',
                  onPressed: () {

                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

