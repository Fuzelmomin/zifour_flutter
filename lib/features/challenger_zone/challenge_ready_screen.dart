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
import 'package:zifour_sourcecode/core/widgets/challenge_ready_widget.dart';
import 'package:zifour_sourcecode/core/widgets/chapter_selection_box.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/challenger_zone/challenges_list_screen.dart';

import '../../core/api_models/subject_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/services/subject_service.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/custom_loading_widget.dart';
import '../../core/widgets/line_label_row.dart';
import '../../core/utils/connectivity_helper.dart';
import '../../l10n/app_localizations.dart';
import 'bloc/challenge_details_bloc.dart';
import 'bloc/chapter_bloc.dart';
import 'bloc/topic_bloc.dart';
import 'bloc/update_challenge_bloc.dart';

class ChallengeReadyScreen extends StatefulWidget {
  ChallengeReadyScreen({
    super.key,
    required this.crtChlId,
    required this.challengeType,
  });

  /// Created challenge id from previous API (create_challenge)
  final int crtChlId;
  String challengeType;

  @override
  State<ChallengeReadyScreen> createState() => _ChallengeReadyScreenState();
}

class _ChallengeReadyScreenState extends State<ChallengeReadyScreen> {
  late final ChallengeDetailsBloc _detailsBloc;

  BehaviorSubject<bool> isEdit = BehaviorSubject<bool>.seeded(false);
  final SubjectService _subjectService = SubjectService();
  String? _selectedSubjectId;
  late final ChapterBloc _chapterBloc;
  late final TopicBloc _topicBloc;
  late final UpdateChallengeBloc _updateChallengeBloc;

  final BehaviorSubject<List<String>> _selectedChapters =
      BehaviorSubject<List<String>>.seeded([]);
  final BehaviorSubject<List<String>> _selectedTopics =
      BehaviorSubject<List<String>>.seeded([]);
  
  Timer? _topicTimer;

  @override
  void initState() {
    super.initState();
    _detailsBloc = ChallengeDetailsBloc();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _detailsBloc
          .add(ChallengeDetailsRequested(crtChlId: widget.crtChlId));
    });
    _chapterBloc = ChapterBloc();
    _topicBloc = TopicBloc();
    _updateChallengeBloc = UpdateChallengeBloc();
    
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
    _detailsBloc.close();
    _selectedChapters.close();
    _selectedTopics.close();
    _chapterBloc.close();
    _topicBloc.close();
    _updateChallengeBloc.close();
    super.dispose();
  }

  Future<void> _handleUpdateChallenge() async {
    // Validation: Check if subject, chapters, and topics are selected
    if (_selectedSubjectId == null || _selectedSubjectId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)?.pleaseSelectSubject ?? "Please select a subject"}'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedChapters.value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)?.pleaseSelectChapter ?? "Please select at least one chapter"}'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedTopics.value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)?.pleaseSelectTopic ?? "Please select at least one topic"}'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Check internet connectivity
    final isConnected = await ConnectivityHelper.checkConnectivity();
    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No internet connection. Please check your network.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Trigger update challenge API
    _updateChallengeBloc.add(UpdateChallengeRequested(
      crtChlId: widget.crtChlId,
      chapterIds: _selectedChapters.value,
      topicIds: _selectedTopics.value,
      subId: _selectedSubjectId!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _detailsBloc),
        BlocProvider.value(value: _chapterBloc),
        BlocProvider.value(value: _topicBloc),
        BlocProvider.value(value: _updateChallengeBloc),
      ],
      child: BlocListener<UpdateChallengeBloc, UpdateChallengeState>(
        listener: (context, state) {
          if (state.status == UpdateChallengeStatus.success) {
            isEdit.add(false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.data?.message ?? 'Challenge updated successfully'),
                backgroundColor: AppColors.success,
              ),
            );
            // Refresh challenge details
            _detailsBloc.add(ChallengeDetailsRequested(crtChlId: widget.crtChlId));
          } else if (state.status == UpdateChallengeStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Unable to update challenge'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<UpdateChallengeBloc, UpdateChallengeState>(
          builder: (context, updateState) {
            return CustomLoadingOverlay(
              isLoading: updateState.isLoading,
              child: Scaffold(
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
                top: 20.h,
                left: 15.w,
                right: 15.w,
                child: StreamBuilder(
                  stream: isEdit,
                  builder: (context, asyncSnapshot) {
                    return CustomAppBar(
                      isBack: true,
                      title: '${AppLocalizations.of(context)?.challengeReady}',
                      isActionWidget: true,
                      actionWidget: asyncSnapshot.data == true ? Container() : Text(
                        '${AppLocalizations.of(context)?.edit}',
                        style: AppTypography.inter14Bold.copyWith(
                            color: AppColors.pinkColor,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.pinkColor
                        ),
                      ),
                      actionClick: (){
                        if(isEdit.value){
                          isEdit.add(false);
                        }else {
                          isEdit.add(true);
                        }
                      },
                    );
                  }
                )
            ),

            // Main Content with BLoC
            Positioned(
              top: 90.h,
              left: 20.w,
              right: 20.w,
              bottom: 0,
              child: StreamBuilder<bool>(
                stream: isEdit,
                builder: (context, asyncSnapshot) {
                  return asyncSnapshot.data == true ?
                      Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
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
                                              padding:
                                              EdgeInsets.symmetric(vertical: 20.h),
                                              child: Text(
                                                state.errorMessage ?? 'No topics found',
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
                                                _selectedChapters.value.isEmpty
                                                    ? 'Please select chapters first'
                                                    : 'No topics found',
                                                style:
                                                AppTypography.inter12Regular.copyWith(
                                                  color: AppColors.white.withOpacity(0.6),
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
                                            final selectedList = snapshot.data ?? [];
                                            return Column(
                                              children: topics.map((topic) {
                                                final isSelected =
                                                selectedList.contains(topic.tpcId);
                                                return ChapterSelectionBox(
                                                  onTap: () {
                                                    final newList =
                                                    List<String>.from(selectedList);
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
                              SizedBox(height: 20.h),
                              Row(
                                spacing: 15.w,
                                children: [
                                  Expanded(
                                    child: CustomGradientButton(
                                      text: '${AppLocalizations.of(context)?.cancel}',
                                      onPressed: () {
                                        isEdit.add(false);
                                      },
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
                                      text: '${AppLocalizations.of(context)?.update}',
                                      onPressed: _handleUpdateChallenge,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                      : Container(
                    child: BlocBuilder<ChallengeDetailsBloc, ChallengeDetailsState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return _buildShimmerContent();
                        }

                        if (state.status == ChallengeDetailsStatus.failure) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Text(
                                state.errorMessage ??
                                    'Unable to load challenge details.',
                                style: AppTypography.inter14Regular.copyWith(
                                  color: AppColors.white.withOpacity(0.8),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }

                        if (!state.hasData) {
                          return const SizedBox.shrink();
                        }

                        final details = state.data!.challenge;
                        final subjectNames =
                            details.subjects.map((e) => e.name).join(', ');
                        final chapterNames =
                            details.chapters.map((e) => e.name).join(', ');
                        final topicNames =
                            details.topics.map((e) => e.name).join(', ');

                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)?.reviewYourSelections}',
                                style: AppTypography.inter16Regular.copyWith(
                                  color: AppColors.white.withOpacity(0.6),
                                ),
                              ),
                              SizedBox(height: 25.h),
                              SignupFieldBox(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  spacing: 15.h,
                                  children: [
                                    ChallengeReadyWidget(
                                      title:
                                          '${AppLocalizations.of(context)?.subjectsSelected}',
                                      iconPath: AssetsPath.svgBook,
                                      selectedValue:
                                          subjectNames.isEmpty ? '-' : subjectNames,
                                    ),
                                    ChallengeReadyWidget(
                                      title:
                                          '${AppLocalizations.of(context)?.chapterSelected}',
                                      iconPath: AssetsPath.svgBook,
                                      iconColor: const Color(0xFFF58D30),
                                      selectedValue: chapterNames,
                                    ),
                                    ChallengeReadyWidget(
                                      title:
                                          '${AppLocalizations.of(context)?.topicsIncluded}',
                                      iconPath: AssetsPath.svgBook2,
                                      selectedValue: topicNames,
                                    ),
                                    ChallengeReadyWidget(
                                      title:
                                          '${AppLocalizations.of(context)?.totalQuestions}',
                                      iconPath: AssetsPath.svgHelpCircle,
                                      iconColor: const Color(0xFFFACC15),
                                      selectedValue: '${details.totalMcq} MCQS',
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              CustomGradientArrowButton(
                                text:
                                    '${AppLocalizations.of(context)?.startChallenge}',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChallengesListScreen(
                                        challengeType: widget.challengeType,
                                        from: "ready",

                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget stepRowContent(String title, String step) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.inter12Medium,
        ),
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

  Widget _buildShimmerContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200.w,
            height: 16.h,
            margin: EdgeInsets.only(top: 4.h, bottom: 25.h),
            child: Shimmer.fromColors(
              baseColor: Colors.white.withOpacity(0.1),
              highlightColor: Colors.white.withOpacity(0.3),
              child: Container(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ),
          SignupFieldBox(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              spacing: 15.h,
              children: List.generate(4, (index) {
                return Shimmer.fromColors(
                  baseColor: Colors.white.withOpacity(0.1),
                  highlightColor: Colors.white.withOpacity(0.3),
                  child: Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
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

}
