import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/challenge_option_box.dart';
import 'package:zifour_sourcecode/core/widgets/chapter_selection_box.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/challenger_zone/select_more_topics_screen.dart';

import '../../core/api_models/subject_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/services/subject_service.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/line_label_row.dart';
import '../../l10n/app_localizations.dart';
import 'bloc/chapter_bloc.dart';
import 'model/chapter_model.dart';

class CreateOwnChallengerScreen extends StatefulWidget {
  const CreateOwnChallengerScreen({super.key});

  @override
  State<CreateOwnChallengerScreen> createState() =>
      _CreateOwnChallengerScreenState();
}

class _CreateOwnChallengerScreenState extends State<CreateOwnChallengerScreen> {
  final SubjectService _subjectService = SubjectService();
  String? _selectedSubjectId;
  late final ChapterBloc _chapterBloc;

  final BehaviorSubject<List<String>> _selectedChapters =
      BehaviorSubject<List<String>>.seeded([]);

  @override
  void initState() {
    super.initState();
    _chapterBloc = ChapterBloc();
  }

  @override
  void dispose() {
    _selectedChapters.close();
    _chapterBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chapterBloc,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.darkBlue,
          child: Stack(children: [
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
                      style: AppTypography.inter16Regular
                          .copyWith(color: AppColors.white.withOpacity(0.6)),
                    ),
                    SizedBox(height: 25.h),
                    SignupFieldBox(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        spacing: 15.h,
                        children: [
                          stepRowContent(
                              '${AppLocalizations.of(context)?.selectSubject.toUpperCase()}',
                              "STEP 1 "),
                          SizedBox(
                            height: 50.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _subjectService.subjects.length,
                              itemBuilder: (context, index) {
                                final subject = _subjectService.subjects[index];
                                final isSelected =
                                    _selectedSubjectId == subject.subId;
                                return Padding(
                                  padding: EdgeInsets.only(right: 10.w),
                                  child: subjectContainer(
                                    subject: subject,
                                    isSelected: isSelected,
                                    onTap: () {
                                      setState(() {
                                        _selectedSubjectId =
                                            isSelected ? null : subject.subId;
                                      });

                                      // Trigger API call when subject is selected
                                      if (!isSelected &&
                                          subject.subId.isNotEmpty) {
                                        _chapterBloc.add(ChapterRequested(
                                            subId: subject.subId));
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
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
                          stepRowContent(
                              '${AppLocalizations.of(context)?.selectTopic.toUpperCase()}',
                              "STEP 2"),
                          BlocBuilder<ChapterBloc, ChapterState>(
                            builder: (context, state) {
                              if (state.isLoading) {
                                return _buildShimmerLoading();
                              }

                              if (state.status == ChapterStatus.failure) {
                                return Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.h),
                                    child: Text(
                                      state.errorMessage ?? 'No chapters found',
                                      style:
                                          AppTypography.inter12Regular.copyWith(
                                        color: AppColors.white.withOpacity(0.6),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }

                              if (!state.hasData) {
                                return Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.h),
                                    child: Text(
                                      _selectedSubjectId == null
                                          ? 'Please select a subject first'
                                          : 'No chapters found',
                                      style:
                                          AppTypography.inter12Regular.copyWith(
                                        color: AppColors.white.withOpacity(0.6),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }

                              final chapters = state.data!.chapterList;
                              return StreamBuilder<List<String>>(
                                stream: _selectedChapters.stream,
                                builder: (context, snapshot) {
                                  final selectedList = snapshot.data ?? [];
                                  return Column(
                                    children: chapters.map((chapter) {
                                      final isSelected =
                                          selectedList.contains(chapter.chpId);
                                      return ChapterSelectionBox(
                                        onTap: () {
                                          final newList =
                                              List<String>.from(selectedList);
                                          if (isSelected) {
                                            newList.remove(chapter.chpId);
                                          } else {
                                            newList.add(chapter.chpId);
                                          }
                                          _selectedChapters.add(newList);
                                        },
                                        title: chapter.name,
                                        isButton: true,
                                        isSelected: isSelected,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 7.h, horizontal: 7.w),
                                        bgColor: Color(0xFF1B193D),
                                        borderColor:
                                            AppColors.white.withOpacity(0.1),
                                      );
                                    }).toList(),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.h),
                    CustomGradientArrowButton(
                      text:
                          '${AppLocalizations.of(context)?.generateMyChallenge}',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectMoreTopicsScreen(
                                subId: _selectedSubjectId ?? '',
                                chapterIds: _selectedChapters.value,
                              )),
                        );
                      },
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    LineLabelRow(
                        label:
                            '${AppLocalizations.of(context)?.youCanSaveChallenge}',
                        line1Width: 70.w,
                        line2Width: 70.w,
                        textWidth: MediaQuery.widthOf(context) * 0.5),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Column(
      children: List.generate(3, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.08),
            highlightColor: Colors.white.withOpacity(0.2),
            child: Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        );
      }),
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
            style: AppTypography.inter10Regular
                .copyWith(color: AppColors.white.withOpacity(0.5)),
          ),
        )
      ],
    );
  }

  Widget subjectContainer({
    required SubjectModel subject,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 18.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
        child: Center(
          child: Text(
            subject.name,
            style: AppTypography.inter12SemiBold,
          ),
        ),
      ),
    );
  }
}
