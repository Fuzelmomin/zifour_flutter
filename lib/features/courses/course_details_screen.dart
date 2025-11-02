import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/widgets/course_item.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/courses/order_summery_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/my_course_item.dart';
import '../../l10n/app_localizations.dart';

class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen({super.key});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
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
                  title: 'Course',
                )),

            // Main Content with BLoC
            Positioned(
              top: 110.h,
              left: 0.w,
              right: 0.w,
              bottom: 0.h,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: CourseItem(),
                    ),
                    SizedBox(height: 15.h,),
                    /// Bullet Points
                    ...List.generate(4, (i) => _bulletPoint()),

                    const SizedBox(height: 20),

                    /// Includes Details Box
                    SignupFieldBox(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("THIS COURSE INCLUDES",
                            style: TextStyle(
                              color: Colors.white.withOpacity(.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 18),

                          _infoRow("Video", "10"),
                          _infoRow("Test", "15"),
                          _infoRow("Chapter", "10"),
                          _infoRow("Validity", "10 Months"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    CustomGradientButton(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      text: 'Buy Mow',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OrderSummeryScreen()),
                        );
                      },
                    ),
                    SizedBox(height: 70.h,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bulletPoint() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Icon(Icons.circle, color: Color(0xffA259FF), size: 10),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model.",
              style: TextStyle(color: Colors.white70, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Color(0xFF1B193D),
        borderRadius: BorderRadius.all(Radius.circular(16.r)),
        border: BoxBorder.all(
          color: AppColors.white.withOpacity(0.1),
          width: 1.0
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white60, fontSize: 14)),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
