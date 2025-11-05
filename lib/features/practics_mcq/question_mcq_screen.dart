import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';

class QuestionMcqScreen extends StatefulWidget {
  String type;
  QuestionMcqScreen({super.key, required this.type});

  @override
  State<QuestionMcqScreen> createState() => _QuestionMcqScreenState();
}

class _QuestionMcqScreenState extends State<QuestionMcqScreen> {

  final BehaviorSubject<String?> selectedOption = BehaviorSubject<String?>.seeded(null);


  String selectedFilter = "";
  final options = [
    "Add Note",
    "Mark as Bookmark",
    "Feedback"
  ];

  @override
  void dispose() {
    selectedOption.close();
    super.dispose();
  }

  void onOptionSelect(String option) {
    selectedOption.sink.add(option);
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
                  right: 15.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: 'Law of Motion',
                    isActionWidget: true,
                    actionWidget: PopupMenuButton<String>(
                      onSelected: (value) => setState(() => selectedFilter = value),
                      itemBuilder: (context) {
                        return options
                            .map((e) => PopupMenuItem(value: e, child: Text(e)))
                            .toList();
                      },
                      child: Image.asset(
                        AssetsPath.icMenuBox,
                        width: 30.w,
                        height: 30.h,
                      ),
                    ),
                    actionClick: (){

                    },

                  )),

              // Main Content with BLoC
              Positioned(
                top: 70.h,
                left: 20.w,
                right: 20.w,
                bottom: 0,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Chapter + Topic
                      Row(
                        children: [
                          _infoTag(title: "CHAPTER", value: "Physics Motion"),
                          const SizedBox(width: 10),
                          _infoTag(title: "TOPIC", value: "Newton's First Law"),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Difficulty + Timer
                      Row(
                        children: [
                          const Text(
                            "Difficulty : ",
                            style: TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                          const Text(
                            "Easy",
                            style: TextStyle(color: Colors.pinkAccent, fontSize: 14),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(0.15),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.timer, color: Colors.orange, size: 16),
                                SizedBox(width: 5),
                                Text("00:53",
                                    style: TextStyle(color: Colors.white, fontSize: 13)),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Question Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.pinkColor3.withOpacity(0.1),

                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          "A body is falling freely under the action of gravity alone in vacuum. "
                              "Which one of the following remains constant during the fall?",
                          style: TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Options Stream
                      StreamBuilder<String?>(
                        stream: selectedOption.stream,
                        builder: (context, snapshot) {
                          final selected = snapshot.data;

                          return Column(
                            children: [
                              _optionTile("A", "Newton’s First Law", selected),
                              _optionTile("B", "Potential Energy", selected),
                              _optionTile("C", "Kinetic Energy", selected),
                              _optionTile("D", "Acceleration", selected),
                            ],
                          );
                        },
                      ),

                      SizedBox(height: 50.h),

                      Row(
                        spacing: 15.w,
                        children: [
                          Expanded(
                            child: CustomGradientButton(
                              text: 'Video Solution',
                              onPressed: () {},
                              customDecoration: widget.type == "Start Exam" ? BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                  color: Colors.grey.withOpacity(0.3)
                              ) : null,
                              textStyle: widget.type == "Start Exam" ? AppTypography.inter14Bold.copyWith(
                                  color: Colors.white.withOpacity(0.2)
                              ) : null,
                            ),
                          ),

                          Expanded(
                            child: CustomGradientButton(
                              text: 'Text Solution',
                              onPressed: () {},
                              customDecoration: widget.type == "Start Exam" ? BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                  color: Colors.grey.withOpacity(0.3)
                              ) : null,
                              textStyle: widget.type == "Start Exam" ? AppTypography.inter14Bold.copyWith(
                                color: Colors.white.withOpacity(0.2)
                              ) : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // Prev & Next Buttons
                      Row(
                        spacing: 15.w,
                        children: [
                          Expanded(
                            child: CustomGradientButton(
                              text: 'Previous',
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
                              text: 'Next',
                              onPressed: () {

                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _infoTag({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: Colors.white60,
                  fontSize: 11,
                  letterSpacing: 1)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _optionTile(String label, String text, String? selected) {
    final bool isSelected = selected == label;

    return GestureDetector(
      onTap: () => onOptionSelect(label),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(isSelected ? 0.18 : 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.purpleAccent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(label,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(text,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

}
