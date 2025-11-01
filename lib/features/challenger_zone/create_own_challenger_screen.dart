import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/challenge_option_box.dart';
import 'package:zifour_sourcecode/core/widgets/chapter_selection_box.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/challenger_zone/select_more_topics_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/line_label_row.dart';
import '../../l10n/app_localizations.dart';

class CreateOwnChallengerScreen extends StatefulWidget {
  const CreateOwnChallengerScreen({super.key});

  @override
  State<CreateOwnChallengerScreen> createState() => _CreateOwnChallengerScreenState();
}

class _CreateOwnChallengerScreenState extends State<CreateOwnChallengerScreen> {


  final BehaviorSubject<List<String>> _selectedChapters =
  BehaviorSubject<List<String>>.seeded(['Mechanics']);
  final List<String> _chapters = ['Mechanics', 'Thermodynamics', 'Kinematics'];

  @override
  void dispose() {
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
                right: 5.w,
                child: CustomAppBar(
                  isBack: true,
                  title: '${AppLocalizations.of(context)?.createOwnChallenge}',
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
                      '${AppLocalizations.of(context)?.selectAnySubject}',
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
                          stepRowContent('${AppLocalizations.of(context)?.selectChapter.toUpperCase()}', "STEP 1 "),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              subjectContainer('Physics', Color(0xFF3D50DF), (){}),
                              subjectContainer('Chemistry', Color(0xFF2AA939), (){}),
                              subjectContainer('Maths', Color(0xFFDF3DA1), (){}),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    SignupFieldBox(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        spacing: 15.h,
                        children: [
                          stepRowContent('${AppLocalizations.of(context)?.selectTopic.toUpperCase()}', "STEP 2"),
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
                    CustomGradientArrowButton(
                      text: '${AppLocalizations.of(context)?.generateMyChallenge}',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SelectMoreTopicsScreen()),
                        );
                      },
                    ),
                    SizedBox(height: 25.h,),
                    LineLabelRow(
                      label: '${AppLocalizations.of(context)?.youCanSaveChallenge}',
                      line1Width: 70.w,
                      line2Width: 70.w,
                       textWidth: MediaQuery.widthOf(context) * 0.5
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

  Widget stepRowContent(String title, String step) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 15.w,
      children: [
        Flexible(

          child: Text(
            title,
            style: AppTypography.inter12Medium,
          ),
        ),
        // Expanded(
        //   flex: 15,
        //   child: Container(
        //     width: double.infinity,
        //     height: 1.0,
        //     color: AppColors.white.withOpacity(0.5),
        //   ),
        // ),
        Flexible(

          child: Text(
            step,
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
      padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 18.w),
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
