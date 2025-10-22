import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/widgets/custom_gradient_widget.dart';

class GradientDemoScreen extends StatelessWidget {
  const GradientDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gradient Widget Demo'),
        backgroundColor: const Color(0xFF0C0B33),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Full Screen Gradient
            Container(
              height: 200.h,
              margin: EdgeInsets.only(bottom: 16.h),
              child: SplashGradientWidget(
                child: Center(
                  child: Text(
                    'Full Screen Gradient',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Card Gradient
            CardGradientWidget(
              height: 100.h,
              margin: EdgeInsets.only(bottom: 16.h),
              child: Text(
                'Card Gradient Widget',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Button Gradient
            ButtonGradientWidget(
              height: 50.h,
              margin: EdgeInsets.only(bottom: 16.h),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gradient Button Pressed!')),
                );
              },
              child: Text(
                'Gradient Button',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Horizontal Gradient
            Container(
              height: 80.h,
              margin: EdgeInsets.only(bottom: 16.h),
              child: HorizontalGradientWidget(
                child: Center(
                  child: Text(
                    'Horizontal Gradient',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Diagonal Gradient
            Container(
              height: 80.h,
              margin: EdgeInsets.only(bottom: 16.h),
              child: DiagonalGradientWidget(
                child: Center(
                  child: Text(
                    'Diagonal Gradient',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Custom Gradient with different colors
            Container(
              height: 100.h,
              margin: EdgeInsets.only(bottom: 16.h),
              child: CustomGradientWidget(
                colors: const [
                  Color(0x000C0B33), // Transparent
                  Color(0xFF0C0B33),  // Dark blue
                  Color(0xFF1A1A4A),  // Lighter blue
                ],
                stops: const [0.0, 0.5, 1.0],
                child: Center(
                  child: Text(
                    'Custom 3-Color Gradient',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Usage examples
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Usage Examples:',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '• SplashGradientWidget - Full screen gradient\n'
                    '• CardGradientWidget - Card with gradient background\n'
                    '• ButtonGradientWidget - Gradient button with tap effect\n'
                    '• HorizontalGradientWidget - Left to right gradient\n'
                    '• DiagonalGradientWidget - Top-left to bottom-right\n'
                    '• CustomGradientWidget - Fully customizable',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
