import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/challenge_option_box.dart';
import 'package:zifour_sourcecode/core/widgets/chapter_selection_box.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/challenger_zone/challenge_ready_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/line_label_row.dart';
import '../../l10n/app_localizations.dart';

class SelectMoreTopicsScreen extends StatefulWidget {
  const SelectMoreTopicsScreen({super.key});

  @override
  State<SelectMoreTopicsScreen> createState() => _SelectMoreTopicsScreenState();
}

class _SelectMoreTopicsScreenState extends State<SelectMoreTopicsScreen> {


  final BehaviorSubject<List<String>> _selectedTopic =
  BehaviorSubject<List<String>>.seeded(['Newton’s Laws of Motion']);
  final List<String> _topics = ['Newton’s Laws of Motion', 'Friction', 'Work, Energy & Power', 'Projectile Motion', 'Dynamics of Motion', 'Laws of Conversation'];

  @override
  void dispose() {
    _selectedTopic.close();
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
                right: 5.w,
                child: CustomAppBar(
                  isBack: true,
                  title: 'Select your topics from chapter mechanics',
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
                    Text(
                      '${AppLocalizations.of(context)?.chooseOneMoreTopics}',
                      style: AppTypography.inter16Regular.copyWith(
                          color: AppColors.white.withOpacity(0.6)
                      ),
                    ),
                    SizedBox(height: 25.h),
                    SignupFieldBox(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        spacing: 15.h,
                        children: [

                          StreamBuilder<List<String>>(
                            stream: _selectedTopic.stream,
                            builder: (context, snapshot) {
                              final selectedList = snapshot.data ?? [];
                              return Column(
                                children: _topics.map((chapter) {
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
                                      _selectedTopic.add(newList);
                                    },
                                    title: chapter,
                                    isButton: false,
                                    isSelected: isSelected,
                                    padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 7.w),
                                    bgColor: Color(0xFF1B193D),
                                    borderColor: AppColors.white.withOpacity(0.1),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 25.h),
                    Row(
                      spacing: 15.w,
                      children: [
                        Expanded(
                          child: CustomGradientButton(
                            text: '${AppLocalizations.of(context)?.cancel}',
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
                            text: '${AppLocalizations.of(context)?.confirm}',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChallengeReadyScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h,),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget stepRowContent(String title, String step) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            title,
            style: AppTypography.inter12Medium,
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            height: 1.0,
            color: AppColors.white.withOpacity(0.5),
          ),
        ),
        Flexible(
          child: Text(
            title,
            style: AppTypography.inter10Regular.copyWith(
                color: AppColors.white.withOpacity(0.5)
            ),
          ),
        )
      ],
    );
  }

  Widget subjectContainer(String title, Color color, Function() onTap) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 13.w),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(10.r))
      ),
      child: Center(
        child: Text(
          title,
          style: AppTypography.inter12SemiBold,
        ),
      ),
    );
  }

}
