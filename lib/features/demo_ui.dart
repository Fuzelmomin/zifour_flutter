import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';

class AskDoubtScreen extends StatelessWidget {
  AskDoubtScreen({super.key});

  // Behavior Subjects
  final BehaviorSubject<String> _subjectCtrl = BehaviorSubject<String>.seeded("Subject");
  final BehaviorSubject<String> _standardCtrl = BehaviorSubject<String>.seeded("Standard");
  final BehaviorSubject<String> _topicCtrl = BehaviorSubject<String>.seeded("Select Topic");

  final TextEditingController _doubtController = TextEditingController();

  final List<String> subjectList = ["Maths", "Science", "English"];
  final List<String> standardList = ["8th", "9th", "10th"];
  final List<String> topicList = ["Algebra", "Physics", "Grammar"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1C0F5F), Color(0xFF030617)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "Ask Your Doubts",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Past Doubts",
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 12.sp,
                        decoration: TextDecoration.underline,
                      ),
                    )
                  ],
                ),

                SizedBox(height: 20.h),

                Text(
                  "Get expert answers from mentors and toppers",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),

                SizedBox(height: 25.h),

                // Subject dropdown
                _buildDropdown(_subjectCtrl, subjectList),

                SizedBox(height: 15.h),

                // Standard dropdown
                _buildDropdown(_standardCtrl, standardList),

                SizedBox(height: 15.h),

                // Topic dropdown
                _buildDropdown(_topicCtrl, topicList),

                SizedBox(height: 15.h),

                // Doubt text input
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: TextField(
                    controller: _doubtController,
                    maxLines: 4,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type your doubt clearly",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 12.sp),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height: 15.h),

                // Upload box
                Container(
                  height: 70.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white30, style: BorderStyle.solid),
                    color: Colors.white.withOpacity(0.05),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.camera_alt_outlined, color: Colors.white70),
                        SizedBox(width: 10.w),
                        Text(
                          "Upload Your Image",
                          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                        )
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Submit Button
                Container(
                  height: 50.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFD4CBB), Color(0xFF8A4FFF)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Submit Doubt",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(BehaviorSubject<String> controller, List<String> items) {
    return StreamBuilder<String>(
      stream: controller.stream,
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () {
            // simple popup sheet
            showModalBottomSheet(
              backgroundColor: Colors.black,
              context: context,
              builder: (context) => Column(
                children: items.map((e) {
                  return ListTile(
                    title: Text(e, style: const TextStyle(color: Colors.white)),
                    onTap: () {
                      controller.add(e);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            );
          },
          child: Container(
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.white24),
              color: Colors.white.withOpacity(0.08),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  snapshot.data ?? "",
                  style: TextStyle(color: Colors.white, fontSize: 13.sp),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white70)
              ],
            ),
          ),
        );
      },
    );
  }
}
