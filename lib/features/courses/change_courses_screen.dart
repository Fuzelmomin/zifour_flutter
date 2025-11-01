import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar_plus/flutter_rating_bar_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/chapter_selection_box.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/my_course_item.dart';
import '../../core/widgets/signup_field_box.dart';
import '../../core/widgets/text_field_container.dart';
import '../../l10n/app_localizations.dart';

class ChangeCourseScreen extends StatefulWidget {
  const ChangeCourseScreen({super.key});

  @override
  State<ChangeCourseScreen> createState() => _ChangeCourseScreenState();
}

class _ChangeCourseScreenState extends State<ChangeCourseScreen> {

  // BehaviorSubjects for reactive state management
  final BehaviorSubject<String> _selectedClass =
  BehaviorSubject<String>.seeded('Class 12');
  final BehaviorSubject<String> _selectedExam =
  BehaviorSubject<String>.seeded('NEET');
  final BehaviorSubject<List<String>> _selectedChapters =
  BehaviorSubject<List<String>>.seeded(['Physics']);

  final List<String> _classes = ['Class 11', 'Class 12', 'Dropper'];
  final List<String> _chapters = ['Physics', 'Chemistry', 'Maths'];

  @override
  void dispose() {
    _selectedClass.close();
    _selectedExam.close();
    _selectedChapters.close();
    super.dispose();
  }

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
                  title: '${AppLocalizations.of(context)?.changeCourse}',
                )),

            // Main Content with BLoC
            Positioned(
              top: 110.h,
              left: 20.w,
              right: 20.w,
              bottom: 0,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: SignupFieldBox(
                        child: Column(
                          children: [
                            // Class Dropdown
                            StreamBuilder<String>(
                              stream: _selectedClass.stream,
                              builder: (context, snapshot) {
                                return Container(
                                  width: double.infinity,
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.2)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      dropdownColor: const Color(0xFF2A2663),
                                      value: snapshot.data,
                                      icon: const Icon(Icons.keyboard_arrow_down,
                                          color: Colors.white),
                                      style: const TextStyle(color: Colors.white),
                                      items: _classes
                                          .map((cls) => DropdownMenuItem(
                                        value: cls,
                                        child: Text(cls),
                                      ))
                                          .toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          _selectedClass.add(val);
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 20),

                            // Exam Options (Neet / Jee)
                            StreamBuilder<String>(
                              stream: _selectedExam.stream,
                              builder: (context, snapshot) {
                                final selectedExam = snapshot.data ?? 'NEET';
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _examButton('NEET', selectedExam == 'NEET'),
                                    _examButton('JEE', selectedExam == 'JEE'),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h,),


                    SignupFieldBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section Title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "SELECT CHAPTERS",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "STEP 1",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          StreamBuilder<List<String>>(
                            stream: _selectedChapters.stream,
                            builder: (context, snapshot) {
                              final selectedList = snapshot.data ?? [];
                              return Column(
                                children: _chapters.map((chapter) {
                                  final isSelected =
                                  selectedList.contains(chapter);
                                  return ChapterSelectionBox(
                                    onTap: (){
                                      final newList =
                                      List<String>.from(
                                          selectedList);
                                      if (isSelected) {
                                        newList.remove(chapter);
                                      } else {
                                        newList.add(chapter);
                                      }
                                      _selectedChapters.add(newList);
                                    },
                                    title: chapter,
                                    isButton: true,
                                    isSelected: isSelected,
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h,),
                    CustomGradientButton(
                      text: '${AppLocalizations.of(context)?.saveChanges}',
                      onPressed: () {
                        // TODO: Implement login logic
                        // if (_oldPasswordController.text.isEmpty || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
                        //   AlertShow.alertShowSnackBar(context, '${AppLocalizations.of(context)?.pleaseFillAllFields}', Colors.red);
                        //   return;
                        // }

                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _examButton(String text, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectedExam.add(text),
        child: Container(
          height: 45,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.pinkColor2
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.3),
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: AppTypography.inter14Medium,
              ),
              Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? Colors.white : AppColors.white.withOpacity(0.5), size: 22.0),
            ],
          ),
        ),
      ),
    );
  }

}
