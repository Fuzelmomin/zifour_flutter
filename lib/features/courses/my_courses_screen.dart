import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/my_course_item.dart';
import '../../l10n/app_localizations.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> courses = [
      {
        'price': '₹ 1,999',
        'title': '11th & 12th Science - Full Syllabus',
        'start': '27 Feb, 2021',
        'end': '27 Feb, 2021',
        'image':
        'https://images.unsplash.com/photo-1581093588401-22d0a9f6f1b4?auto=format&fit=crop&w=900&q=60'
      },
      {
        'price': '₹ 1,999',
        'title': '11th & 12th Science - Full Syllabus',
        'start': '27 Feb, 2021',
        'end': '27 Feb, 2021',
        'image':
        'https://images.unsplash.com/photo-1581093588401-22d0a9f6f1b4?auto=format&fit=crop&w=900&q=60'
      },
      {
        'price': '₹ 1,999',
        'title': '11th & 12th Science - Full Syllabus',
        'start': '27 Feb, 2021',
        'end': '27 Feb, 2021',
        'image':
        'https://images.unsplash.com/photo-1581093588401-22d0a9f6f1b4?auto=format&fit=crop&w=900&q=60'
      },
    ];
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
                    title: '${AppLocalizations.of(context)?.myCourse}',
                  )),

              // Main Content with BLoC
              Positioned(
                top: 90.h,
                left: 20.w,
                right: 20.w,
                bottom: 0,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: courses.length,
                  padding: EdgeInsets.only(bottom: 20.h),
                  itemBuilder: (context, index) {
                    var item = courses[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: MyCourseItem(item: item,),
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
}
