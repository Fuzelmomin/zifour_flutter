import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_gradient_button.dart';
import '../constants/app_colors.dart';

class SubscriptionDialogs {
  static void showSubscriptionPlanDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) => Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 320.w,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6857F9).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      color: const Color(0xFF6857F9),
                      size: 40.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Premium Subscription',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Get unlimited access to all courses, live classes, and practice tests.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildPlanItem(
                    title: 'Monthly Plan',
                    price: '₹999/mo',
                    description: 'Flexible access to all content',
                  ),
                  SizedBox(height: 12.h),
                  _buildPlanItem(
                    title: 'Yearly Plan',
                    price: '₹7,999/yr',
                    description: 'Best value - Save 33%',
                    isPopular: true,
                  ),
                  SizedBox(height: 24.h),
                  CustomGradientButton(
                    text: 'Choose a Plan',
                    height: 50.h,
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(height: 12.h),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Maybe Later',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void showTrialExpiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) => Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 300.w,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_clock_rounded,
                      color: AppColors.error,
                      size: 40.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Trial Period Finished',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Your trial period has ended. To continue using this module and access all premium features, please subscribe to a plan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  CustomGradientButton(
                    text: 'View Subscription Plans',
                    height: 50.h,
                    onPressed: () {
                      Navigator.pop(context);
                      showSubscriptionPlanDialog(context);
                    },
                  ),
                  SizedBox(height: 12.h),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Dismiss',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildPlanItem({
    required String title,
    required String price,
    required String description,
    bool isPopular = false,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isPopular ? const Color(0xFF6857F9) : Colors.white.withOpacity(0.1),
          width: isPopular ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              if (isPopular)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6857F9),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'POPULAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            price,
            style: TextStyle(
              color: isPopular ? const Color(0xFF6857F9) : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}
