import 'dart:async';
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

import '../../core/api_models/subject_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/services/subject_service.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/custom_loading_widget.dart';
import '../../core/widgets/line_label_row.dart';
import '../../l10n/app_localizations.dart';
import 'bloc/chapter_bloc.dart';
import 'bloc/topic_bloc.dart';
import 'bloc/create_challenge_bloc.dart';
import 'challenge_ready_screen.dart';
import 'model/chapter_model.dart';

class CreateOwnChallengerScreen extends StatefulWidget {
  const CreateOwnChallengerScreen({super.key});

  @override
  State<CreateOwnChallengerScreen> createState() =>
      _CreateOwnChallengerScreenState();
}

class _CreateOwnChallengerScreenState extends State<CreateOwnChallengerScreen> {
  final SubjectService _subjectService = SubjectService();
  List<String> _selectedSubjectIds = [];
  late final ChapterBloc _chapterBloc;
  late final TopicBloc _topicBloc;
  late final CreateChallengeBloc _createChallengeBloc;

  final BehaviorSubject<List<String>> _selectedChapters =
      BehaviorSubject<List<String>>.seeded([]);
  final BehaviorSubject<List<String>> _selectedTopics =
      BehaviorSubject<List<String>>.seeded([]);

  Timer? _topicTimer;

  @override
  void initState() {
    super.initState();
    _chapterBloc = ChapterBloc();
    _topicBloc = TopicBloc();
    _createChallengeBloc = CreateChallengeBloc();

    // Listen to chapter selection changes and trigger topic API after 3 seconds
    _selectedChapters.listen((chapters) {
      _topicTimer?.cancel();
      // Clear selected topics when chapters change
      _selectedTopics.add([]);
      if (chapters.isNotEmpty) {
        _topicTimer = Timer(const Duration(seconds: 3), () {
          if (mounted && chapters.isNotEmpty) {
            _topicBloc.add(TopicRequested(chapterIds: chapters));
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _topicTimer?.cancel();
    _selectedChapters.close();
    _selectedTopics.close();
    _chapterBloc.close();
    _topicBloc.close();
    _createChallengeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _chapterBloc),
        BlocProvider.value(value: _topicBloc),
        BlocProvider.value(value: _createChallengeBloc),
      ],
      child: BlocConsumer<CreateChallengeBloc, CreateChallengeState>(
        listener: (context, state) {
          if (state.status == CreateChallengeStatus.success &&
              state.data != null &&
              state.data!.topicList.isNotEmpty) {
            final created = state.data!.topicList.first;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChallengeReadyScreen(
                  crtChlId: created.crtChlId,
                  challengeType: "1",
                  from: "create_own",
                ),
              ),
            );
          } else if (state.status == CreateChallengeStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return CustomLoadingOverlay(
            isLoading: state.isLoading,
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
                      top: 20.h,
                      left: 15.w,
                      right: 5.w,
                      child: CustomAppBar(
                        isBack: true,
                        title:
                            '${AppLocalizations.of(context)?.createOwnChallenge}',
                      )),

                  // Main Content with BLoC
                  Positioned(
                    top: 90.h,
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
                                color: AppColors.white.withOpacity(0.6)),
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
                                      final subject =
                                          _subjectService.subjects[index];
                                      final isSelected =
                                          _selectedSubjectIds.contains(subject.subId);
                                      return Padding(
                                        padding: EdgeInsets.only(right: 10.w),
                                        child: subjectContainer(
                                          subject: subject,
                                          isSelected: isSelected,
                                          onTap: () {
                                            setState(() {
                                              if (isSelected) {
                                                _selectedSubjectIds.remove(subject.subId);
                                                
                                                // Remove chapters of this subject from selection
                                                final chaptersOfSubject = _chapterBloc.state.data?.chapterList
                                                    .where((c) => c.subId == subject.subId)
                                                    .map((c) => c.chpId)
                                                    .toList() ?? [];
                                                
                                                final currentChapters = List<String>.from(_selectedChapters.value);
                                                currentChapters.removeWhere((id) => chaptersOfSubject.contains(id));
                                                _selectedChapters.add(currentChapters);

                                                // Update topics selection too
                                                _selectedTopics.add([]);
                                                
                                                _chapterBloc.add(ChapterRemoveRequested(subId: subject.subId));
                                              } else {
                                                _selectedSubjectIds.add(subject.subId);
                                                _chapterBloc.add(ChapterRequested(subId: subject.subId));
                                              }
                                            });
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
                                    '${AppLocalizations.of(context)?.selectChapter.toUpperCase()}',
                                    "STEP 2"),
                                BlocBuilder<ChapterBloc, ChapterState>(
                                  builder: (context, state) {
                                    if (state.isLoading) {
                                      return _buildShimmerLoading();
                                    }

                                    if (state.status == ChapterStatus.failure) {
                                      return Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20.h),
                                          child: Text(
                                            state.errorMessage ??
                                                'No chapters found',
                                            style: AppTypography.inter12Regular
                                                .copyWith(
                                              color: AppColors.white
                                                  .withOpacity(0.6),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    }

                                    if (!state.hasData) {
                                      return Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20.h),
                                          child: Text(
                                            _selectedSubjectIds.isEmpty
                                                ? 'Please select a subject first'
                                                : 'No chapters found',
                                            style: AppTypography.inter12Regular
                                                .copyWith(
                                              color: AppColors.white
                                                  .withOpacity(0.6),
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
                                        final selectedList =
                                            snapshot.data ?? [];
                                        return Column(
                                          children: chapters.map((chapter) {
                                            final isSelected = selectedList
                                                .contains(chapter.chpId);
                                            return ChapterSelectionBox(
                                              onTap: () {
                                                final newList =
                                                    List<String>.from(
                                                        selectedList);
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
                                                  vertical: 7.h,
                                                  horizontal: 7.w),
                                              bgColor: Color(0xFF1B193D),
                                              borderColor: AppColors.white
                                                  .withOpacity(0.1),
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
                          SizedBox(height: 15.h),
                          SignupFieldBox(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              spacing: 15.h,
                              children: [
                                stepRowContent(
                                    '${AppLocalizations.of(context)?.selectTopic.toUpperCase()}',
                                    "STEP 3"),
                                BlocBuilder<TopicBloc, TopicState>(
                                  builder: (context, state) {
                                    if (state.isLoading) {
                                      return _buildShimmerLoading();
                                    }

                                    if (state.status == TopicStatus.failure) {
                                      return Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20.h),
                                          child: Text(
                                            state.errorMessage ??
                                                'No topics found',
                                            style: AppTypography.inter12Regular
                                                .copyWith(
                                              color: AppColors.white
                                                  .withOpacity(0.6),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    }

                                    if (!state.hasData) {
                                      return Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20.h),
                                          child: Text(
                                            _selectedChapters.value.isEmpty
                                                ? 'Please select chapters first'
                                                : 'No topics found',
                                            style: AppTypography.inter12Regular
                                                .copyWith(
                                              color: AppColors.white
                                                  .withOpacity(0.6),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    }

                                    final topics = state.data!.topicList;
                                    return StreamBuilder<List<String>>(
                                      stream: _selectedTopics.stream,
                                      builder: (context, snapshot) {
                                        final selectedList =
                                            snapshot.data ?? [];
                                        return Column(
                                          children: topics.map((topic) {
                                            final isSelected = selectedList
                                                .contains(topic.tpcId);
                                            return ChapterSelectionBox(
                                              onTap: () {
                                                final newList =
                                                    List<String>.from(
                                                        selectedList);
                                                if (isSelected) {
                                                  newList.remove(topic.tpcId);
                                                } else {
                                                  newList.add(topic.tpcId);
                                                }
                                                _selectedTopics.add(newList);
                                              },
                                              title: topic.name,
                                              isButton: true,
                                              isSelected: isSelected,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 7.h,
                                                  horizontal: 7.w),
                                              bgColor: Color(0xFF1B193D),
                                              borderColor: AppColors.white
                                                  .withOpacity(0.1),
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
                              if (_selectedSubjectIds.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please select at least one subject.'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                                return;
                              }

                              if (_selectedChapters.value.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Please select at least one chapter.'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                                return;
                              }

                              if (_selectedTopics.value.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Please select at least one topic.'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                                return;
                              }

                              // Filter subject IDs: only include those whose chapters are selected
                              final List<ChapterModel> allChaptersInState = _chapterBloc.state.data?.chapterList ?? [];
                              final List<String> selectedChapterIds = _selectedChapters.value;
                              
                              final Set<String> filteredSubIds = {};
                              for (var chapterId in selectedChapterIds) {
                                try {
                                  final chapter = allChaptersInState.firstWhere((c) => c.chpId == chapterId);
                                  if (chapter.subId != null) {
                                    filteredSubIds.add(chapter.subId!);
                                  }
                                } catch (_) {
                                  // Chapter not found in state or subId missing, skip filtering for this one
                                }
                              }

                              // Call create challenge API
                              _createChallengeBloc.add(
                                CreateChallengeRequested(
                                  chapterIds: _selectedChapters.value,
                                  topicIds: _selectedTopics.value,
                                  subIds: filteredSubIds.toList(),
                                  challengeType: "1",
                                ),
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
        },
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
            color: isSelected == false ? Colors.white.withOpacity(0.1) : null,
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFCF078A), // Pink
                      Color(0xFF5E00D8),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            border: Border.all(
              color: isSelected == false
                  ? Colors.white.withOpacity(0.3)
                  : Colors.transparent,
              width: 1.0,
            )),
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
