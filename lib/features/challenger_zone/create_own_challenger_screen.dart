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
import 'model/topic_model.dart';

class CreateOwnChallengerScreen extends StatefulWidget {
  const CreateOwnChallengerScreen({super.key});

  @override
  State<CreateOwnChallengerScreen> createState() =>
      _CreateOwnChallengerScreenState();
}

// Helper class to store selections per subject
class _SubjectSelection {
  List<String> selectedChapters = [];
  List<String> selectedTopics = [];
  List<ChapterModel> chapters = []; // Store chapters for this subject
}

class _CreateOwnChallengerScreenState extends State<CreateOwnChallengerScreen> {
  final SubjectService _subjectService = SubjectService();
  List<String> _selectedSubjectIds = [];
  String? _activeSubjectId; // Currently active/viewing subject
  
  // Store selections per subject: Map<subjectId, _SubjectSelection>
  final Map<String, _SubjectSelection> _subjectSelections = {};
  
  late final ChapterBloc _chapterBloc;
  late final TopicBloc _topicBloc;
  late final CreateChallengeBloc _createChallengeBloc;

  // These streams now represent ONLY the active subject's selections
  final BehaviorSubject<List<String>> _selectedChapters =
      BehaviorSubject<List<String>>.seeded([]);
  final BehaviorSubject<List<String>> _selectedTopics =
      BehaviorSubject<List<String>>.seeded([]);

  Timer? _topicTimer;

  void _pruneActiveSelectedTopicsTo(List<String> allowedTopicIds) {
    if (_activeSubjectId == null || !_subjectSelections.containsKey(_activeSubjectId)) return;
    final current = List<String>.from(_selectedTopics.value);
    current.removeWhere((id) => !allowedTopicIds.contains(id));
    if (current.length != _selectedTopics.value.length) {
      _selectedTopics.add(current);
    }
    _subjectSelections[_activeSubjectId!]!.selectedTopics = List.from(_selectedTopics.value);
  }

  @override
  void initState() {
    super.initState();
    _chapterBloc = ChapterBloc();
    _topicBloc = TopicBloc();
    _createChallengeBloc = CreateChallengeBloc();

    // Listen to chapter selection changes and trigger topic API after 3 seconds
    _selectedChapters.listen((chapters) {
      _topicTimer?.cancel();
      if (chapters.isNotEmpty && _activeSubjectId != null) {
        // Save chapters selection for active subject
        if (_subjectSelections.containsKey(_activeSubjectId)) {
          _subjectSelections[_activeSubjectId]!.selectedChapters = List.from(chapters);
        }
        
        _topicTimer = Timer(const Duration(seconds: 3), () {
          if (mounted && chapters.isNotEmpty && _activeSubjectId != null) {
            _topicBloc.add(TopicRequested(chapterIds: chapters));
          }
        });
      } else if (chapters.isEmpty && _activeSubjectId != null) {
        // Clear topics when no chapters selected
        _selectedTopics.add([]);
        if (_subjectSelections.containsKey(_activeSubjectId)) {
          _subjectSelections[_activeSubjectId]!.selectedTopics = [];
        }
      }
    });
    
    // Listen to topic selection changes and save for active subject
    _selectedTopics.listen((topics) {
      if (_activeSubjectId != null && _subjectSelections.containsKey(_activeSubjectId)) {
        _subjectSelections[_activeSubjectId]!.selectedTopics = List.from(topics);
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
                                      final isActive = _activeSubjectId == subject.subId;
                                      return Padding(
                                        padding: EdgeInsets.only(right: 10.w),
                                        child: subjectContainer(
                                          subject: subject,
                                          isSelected: isSelected,
                                          isActive: isActive,
                                          onTap: () {
                                            setState(() {
                                              if (isSelected) {
                                                // Subject already selected
                                                if (_activeSubjectId == subject.subId) {
                                                  // If clicking on already active subject, do nothing (or could deselect if needed)
                                                  // For now, we'll keep it selected but allow switching
                                                  return;
                                                } else {
                                                  // Switch to this subject (make it active)
                                                  // Save current active subject's selections before switching
                                                  if (_activeSubjectId != null && _subjectSelections.containsKey(_activeSubjectId)) {
                                                    _subjectSelections[_activeSubjectId]!.selectedChapters = List.from(_selectedChapters.value);
                                                    _subjectSelections[_activeSubjectId]!.selectedTopics = List.from(_selectedTopics.value);
                                                  }
                                                  
                                                  // Switch to this subject
                                                  _activeSubjectId = subject.subId;
                                                  
                                                  // Load this subject's chapters (replace, not append)
                                                  final subjectChapters = _chapterBloc.state.data?.chapterList
                                                      .where((c) => c.subId == subject.subId)
                                                      .toList() ?? [];
                                                  
                                                  // Update BLoC state to show only this subject's chapters
                                                  if (subjectChapters.isNotEmpty) {
                                                    _chapterBloc.add(ChapterReplaceRequested(
                                                      chapters: subjectChapters,
                                                      subId: subject.subId,
                                                    ));
                                                  } else {
                                                    // Fetch chapters if not in state
                                                    _chapterBloc.add(ChapterRequested(subId: subject.subId, replace: true));
                                                  }
                                                  
                                                  // Restore this subject's selections
                                                  if (_subjectSelections.containsKey(subject.subId)) {
                                                    _selectedChapters.add(List.from(_subjectSelections[subject.subId]!.selectedChapters));
                                                    _selectedTopics.add(List.from(_subjectSelections[subject.subId]!.selectedTopics));
                                                    
                                                    // Load topics if chapters are selected
                                                    if (_subjectSelections[subject.subId]!.selectedChapters.isNotEmpty) {
                                                      _topicBloc.add(TopicRequested(chapterIds: _subjectSelections[subject.subId]!.selectedChapters));
                                                    } else {
                                                      _selectedTopics.add([]);
                                                    }
                                                  } else {
                                                    _selectedChapters.add([]);
                                                    _selectedTopics.add([]);
                                                  }
                                                }
                                              } else {
                                                // New subject selected - add it and make it active
                                                _selectedSubjectIds.add(subject.subId);
                                                
                                                // Save current active subject's selections before switching
                                                if (_activeSubjectId != null && _subjectSelections.containsKey(_activeSubjectId)) {
                                                  _subjectSelections[_activeSubjectId]!.selectedChapters = List.from(_selectedChapters.value);
                                                  _subjectSelections[_activeSubjectId]!.selectedTopics = List.from(_selectedTopics.value);
                                                }
                                                
                                                // Make this subject active
                                                _activeSubjectId = subject.subId;
                                                
                                                // Initialize selection for this subject
                                                _subjectSelections[subject.subId] = _SubjectSelection();
                                                
                                                // Fetch chapters for this subject (replace, not append)
                                                _chapterBloc.add(ChapterRequested(subId: subject.subId, replace: true));
                                                
                                                // Clear current selections (will be populated when chapters load)
                                                _selectedChapters.add([]);
                                                _selectedTopics.add([]);
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
                                    // Store chapters when loaded for active subject
                                    if (state.hasData && _activeSubjectId != null) {
                                      final subjectChapters = state.data!.chapterList
                                          .where((c) => c.subId == _activeSubjectId)
                                          .toList();
                                      if (_subjectSelections.containsKey(_activeSubjectId)) {
                                        _subjectSelections[_activeSubjectId]!.chapters = subjectChapters;
                                      }
                                    }
                                    
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
                                            _activeSubjectId == null
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

                                    // Show ONLY active subject's chapters
                                    final allChapters = state.data!.chapterList;
                                    final chapters = _activeSubjectId != null
                                        ? allChapters.where((c) => c.subId == _activeSubjectId).toList()
                                        : [];
                                    
                                    if (chapters.isEmpty && _activeSubjectId != null) {
                                      return Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20.h),
                                          child: Text(
                                            'No chapters found for this subject',
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
                                            _selectedChapters.value.isEmpty || _activeSubjectId == null
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

                                    // Filter topics using selected chapter NAMES (API returns chapter name, not id)
                                    final allTopics = state.data!.topicList;
                                    final activeSelection = _activeSubjectId != null
                                        ? _subjectSelections[_activeSubjectId!]
                                        : null;
                                    final selectedChapterIds = _selectedChapters.value;
                                    final selectedChapterNames = activeSelection == null
                                        ? <String>[]
                                        : activeSelection.chapters
                                            .where((c) => selectedChapterIds.contains(c.chpId))
                                            .map((c) => c.name)
                                            .toList();

                                    final topics = selectedChapterNames.isNotEmpty
                                        ? allTopics.where((t) => selectedChapterNames.contains(t.chapter)).toList()
                                        : <TopicModel>[];

                                    if (topics.isEmpty && selectedChapterNames.isNotEmpty) {
                                      return Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20.h),
                                          child: Text(
                                            'No topics found for selected chapters',
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

                                    // Keep active subject's selected topics valid against returned topic list.
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      _pruneActiveSelectedTopicsTo(topics.map((t) => t.tpcId ?? '').toList());
                                    });
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
                                                  newList.add(topic.tpcId ?? '');
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
                              // Save current active subject's selections before generating
                              if (_activeSubjectId != null && _subjectSelections.containsKey(_activeSubjectId)) {
                                _subjectSelections[_activeSubjectId]!.selectedChapters = List.from(_selectedChapters.value);
                                _subjectSelections[_activeSubjectId]!.selectedTopics = List.from(_selectedTopics.value);
                              }
                              
                              if (_selectedSubjectIds.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please select at least one subject.'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                                return;
                              }

                              // Collect ALL selections from ALL subjects
                              final List<String> allSelectedChapterIds = [];
                              final List<String> allSelectedTopicIds = [];
                              final Set<String> allSubjectIds = {};
                              
                              // Get all chapters from BLoC state
                              final List<ChapterModel> allChaptersInState = _chapterBloc.state.data?.chapterList ?? [];
                              
                              // Collect selections from all subjects
                              for (var entry in _subjectSelections.entries) {
                                final subjectId = entry.key;
                                final selection = entry.value;
                                
                                if (selection.selectedChapters.isNotEmpty) {
                                  allSubjectIds.add(subjectId);
                                  allSelectedChapterIds.addAll(selection.selectedChapters);
                                  allSelectedTopicIds.addAll(selection.selectedTopics);
                                }
                              }
                              
                              // Validate that we have selections
                              if (allSelectedChapterIds.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please select at least one chapter from any subject.'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                                return;
                              }
                              
                              if (allSelectedTopicIds.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please select at least one topic from any subject.'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                                return;
                              }

                              // Call create challenge API with ALL selections
                              _createChallengeBloc.add(
                                CreateChallengeRequested(
                                  chapterIds: allSelectedChapterIds,
                                  topicIds: allSelectedTopicIds,
                                  subIds: allSubjectIds.toList(),
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
    required bool isActive,
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
              color: isActive && isSelected
                  ? Colors.yellow.withOpacity(0.8) // Highlight active subject
                  : isSelected == false
                      ? Colors.white.withOpacity(0.3)
                      : Colors.transparent,
              width: isActive && isSelected ? 2.0 : 1.0,
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
