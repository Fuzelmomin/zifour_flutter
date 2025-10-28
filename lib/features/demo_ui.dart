import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0E0E6E), Color(0xFF1C1C8C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔙 AppBar
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "My Courses",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // 📚 Course List
                Expanded(
                  child: ListView.builder(
                    itemCount: courses.length,
                    padding: EdgeInsets.only(bottom: 20.h),
                    itemBuilder: (context, index) {
                      var item = courses[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF262678),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🖼 Course Image
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16.r),
                                      topRight: Radius.circular(16.r),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: item['image']!,
                                      height: 140.h,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2E2E8E),
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Text(
                                        item['price']!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 10.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title']!,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      children: [
                                        _dateBox("Start Date", item['start']!),
                                        SizedBox(width: 10.w),
                                        _dateBox("End Date", item['end']!),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateBox(String label, String date) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              date,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
