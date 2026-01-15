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
import 'model/challenge_details_model.dart';
import 'model/chapter_model.dart';
import 'model/topic_model.dart';

class ChallengeReadyScreen extends StatefulWidget {
  ChallengeReadyScreen({
    super.key,
    required this.crtChlId,
    required this.challengeType,
    required this.from,
  });

  /// Created challenge id from previous API (create_challenge)
  final int crtChlId;
  String challengeType;
  String from;

  @override
  State<ChallengeReadyScreen> createState() => _ChallengeReadyScreenState();
}

class _ChallengeReadyScreenState extends State<ChallengeReadyScreen> {
  late final ChallengeDetailsBloc _detailsBloc;

  BehaviorSubject<bool> isEdit = BehaviorSubject<bool>.seeded(false);
  final SubjectService _subjectService = SubjectService();
  
  List<String> _selectedSubjectIds = [];
  String? _activeSubjectId; // active subject for Edit mode UI

  // Keep per-subject selections in Edit mode
  final Map<String, List<String>> _selectedChaptersBySubject = {};
  final Map<String, List<String>> _selectedTopicsBySubject = {};

  late final ChapterBloc _chapterBloc;
  late final TopicBloc _topicBloc;
  late final UpdateChallengeBloc _updateChallengeBloc;

  final BehaviorSubject<List<String>> _selectedChapters =
      BehaviorSubject<List<String>>.seeded([]);
  final BehaviorSubject<List<String>> _selectedTopics =
      BehaviorSubject<List<String>>.seeded([]);
  
  // Track which subjects have fully initialized their chapters/topics from Details
  final Set<String> _initializedSubjects = {};
  final Set<String> _initializedTopicsForSubjects = {};

  bool _isInitializingFromDetails = false;
  Timer? _topicTimer;

  void _saveActiveSelections() {
    if (_activeSubjectId == null) return;
    _selectedChaptersBySubject[_activeSubjectId!] = List.from(_selectedChapters.value);
    _selectedTopicsBySubject[_activeSubjectId!] = List.from(_selectedTopics.value);
  }

  @override
  void initState() {
    super.initState();
    if (widget.from == "edit") {
      isEdit.add(true);
    }
    _detailsBloc = ChallengeDetailsBloc();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _detailsBloc.add(ChallengeDetailsRequested(crtChlId: widget.crtChlId));
    });
    _chapterBloc = ChapterBloc();
    _topicBloc = TopicBloc();
    _updateChallengeBloc = UpdateChallengeBloc();

    // Listen to chapter selection changes to sync with per-subject map
    _selectedChapters.listen((chapters) {
      if (_isInitializingFromDetails || _activeSubjectId == null) {
        return;
      }
      
      _topicTimer?.cancel();
      
      // Update the per-subject map with current chapters
      _selectedChaptersBySubject[_activeSubjectId!] = List.from(chapters);
      
      // We don't clear topics here anymore; it's handled in the manual onTap of ChapterSelectionBox
    });
    
    // Corrected Listener Logic:
    // We shouldn't use this listener to manage state restoration logic to avoid conflicts.
    // Instead, we'll trigger topic loading manually or via specific events.
    // Re-implementing simplified listeners purely for API triggering:
    
    _selectedChapters.stream
        .debounceTime(const Duration(seconds: 3))
        .listen((chapters) {
           if (mounted && chapters.isNotEmpty && _activeSubjectId != null) {
             // Only trigger if we really need to fetch topics (e.g. they changed)
             // For now, adhering to existing pattern: just fetch.
             _topicBloc.add(TopicRequested(chapterIds: chapters));
           }
    });
  }

  // Helper to init selections from details (called once usually, or when edit starts)
  void _prefillSelectionsFromDetails(ChallengeDetails details) {
    if (_isInitializingFromDetails) return;
    _isInitializingFromDetails = true;

    // Prefill subjects
    if (details.subjects.isNotEmpty) {
      final subIds = details.subjects.map((e) => e.id).toList();
      setState(() {
        _selectedSubjectIds = subIds;
        // Start with the first subject active if none set
        _activeSubjectId ??= subIds.first;
      });
      
      for (final id in subIds) {
        _selectedChaptersBySubject.putIfAbsent(id, () => []);
        _selectedTopicsBySubject.putIfAbsent(id, () => []);
      }
      
      // Request chapters for the ACTIVE subject immediately to kickstart the chain
      // We treat other subjects as "pending initialization" until clicked.
      if (_activeSubjectId != null) {
        _chapterBloc.add(ChapterRequested(subId: _activeSubjectId!));
      }
    }
    _isInitializingFromDetails = false;
  }

  Future<void> _handleUpdateChallenge() async {
    // Save active subject selection snapshot
    _saveActiveSelections();

    // Validation: Check if subject, chapters, and topics are selected
    if (_selectedSubjectIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)?.pleaseSelectSubject ?? "Please select a subject"}'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Combine selections from all subjects (Edit mode)
    final allSelectedChapterIds = <String>[];
    final allSelectedTopicIds = <String>[];
    final usedSubjectIds = <String>{};
    for (final subId in _selectedSubjectIds) {
      final ch = _selectedChaptersBySubject[subId] ?? const [];
      final tp = _selectedTopicsBySubject[subId] ?? const [];
      if (ch.isEmpty) {
        // If a subject has no chapters selected, treat it as unselected
        continue;
      }
      usedSubjectIds.add(subId);
      allSelectedChapterIds.addAll(ch);
      allSelectedTopicIds.addAll(tp);
    }

    // De-duplicate (API should not receive duplicates)
    final uniqueChapterIds = allSelectedChapterIds.toSet().toList();
    final uniqueTopicIds = allSelectedTopicIds.toSet().toList();

    if (uniqueChapterIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)?.pleaseSelectChapter ?? "Please select at least one chapter"}'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (uniqueTopicIds.isEmpty) {
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
      chapterIds: uniqueChapterIds,
      topicIds: uniqueTopicIds,
      subIds: usedSubjectIds.toList(),
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
      child: MultiBlocListener(
        listeners: [
          BlocListener<UpdateChallengeBloc, UpdateChallengeState>(
            listener: (context, state) {
              if (state.status == UpdateChallengeStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.data?.message ?? 'Challenge updated successfully'),
                    backgroundColor: AppColors.success,
                  ),
                );
                if(widget.from == "edit"){
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) =>
                          ChallengesListScreen(
                            from: "",
                            challengeType: widget.challengeType,
                          )));
                } else{
                  isEdit.add(false);
                  // Refresh challenge details
                  _detailsBloc.add(ChallengeDetailsRequested(crtChlId: widget.crtChlId));
                }

              } else if (state.status == UpdateChallengeStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ?? 'Unable to update challenge'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
          ),
          // Prefill Subject/Chapters/Topics from challenge details when available
          BlocListener<ChallengeDetailsBloc, ChallengeDetailsState>(
            listenWhen: (previous, current) =>
                current.status == ChallengeDetailsStatus.success && current.hasData,
            listener: (context, state) {
              if ((widget.from == "edit" || isEdit.value) &&
                  _selectedSubjectIds.isEmpty &&
                  _selectedChapters.value.isEmpty &&
                  _selectedTopics.value.isEmpty) {
                _prefillSelectionsFromDetails(state.data!.challenge);
              }
            },
          ),
          
          // --- CHAPTER MATCHING LOGIC ---
          // When chapters load, if the active subject has not been initialized yet,
          // matched chapters from details against the loaded list to pre-select them.
          BlocListener<ChapterBloc, ChapterState>(
            listenWhen: (previous, current) => 
               current.status == ChapterStatus.success && current.hasData,
            listener: (context, state) {
              final activeSub = _activeSubjectId;
              if (activeSub != null && 
                  _selectedSubjectIds.contains(activeSub) && 
                  !_initializedSubjects.contains(activeSub) && 
                  _detailsBloc.state.hasData) {
                  
                final details = _detailsBloc.state.data!.challenge;
                final allLoadedChapters = state.data!.chapterList;
                
                // Get chapters from Details that match the loaded chapters (by ID)
                // This implicitely filters chapters belonging to this subject
                final loadedChapterIds = allLoadedChapters.map((c) => c.chpId).toSet();
                final matchingChapterIds = details.chapters
                    .map((c) => c.id)
                    .where((id) => loadedChapterIds.contains(id))
                    .toList();
                
                if (matchingChapterIds.isNotEmpty) {
                  // Update selections
                  _selectedChapters.add(matchingChapterIds);
                  _selectedChaptersBySubject[activeSub] = List.from(matchingChapterIds);
                  
                  // Mark this subject as having its chapters initialized
                  _initializedSubjects.add(activeSub);
                  
                  // Now trigger Topic fetch for these chapters
                  _topicBloc.add(TopicRequested(chapterIds: matchingChapterIds));
                }
              }
            },
          ),

          // --- TOPIC MATCHING LOGIC ---
          // When topics load, if the active subject topics haven't been initialized,
          // match them against details.
          BlocListener<TopicBloc, TopicState>(
            listenWhen: (previous, current) =>
                !current.isLoading && current.hasData,
            listener: (context, state) {
               final activeSub = _activeSubjectId;
              // Only auto-fill when coming from edit mode and user hasn't changed topics yet
              if ((widget.from == "edit" || isEdit.value) &&
                  activeSub != null &&
                  !_initializedTopicsForSubjects.contains(activeSub) &&
                  _detailsBloc.state.hasData) {
                  
                final details = _detailsBloc.state.data!.challenge;
                final availableTopicIds =
                    state.data!.topicList.map((e) => e.tpcId).toSet();
                
                // Find topics from details that exist in the loaded topic list
                final prefilledTopicIds = details.topics
                    .map((e) => e.id)
                    .where((id) => availableTopicIds.contains(id))
                    .toList();
                
                if (prefilledTopicIds.isNotEmpty) {
                   // Update selections
                  _selectedTopics.add(prefilledTopicIds);
                   _selectedTopicsBySubject[activeSub] = List.from(prefilledTopicIds);
                   
                   // Mark as initialized so future manual changes aren't overwritten
                   _initializedTopicsForSubjects.add(activeSub);
                }
              }
            },
          ),
        ],
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
                          if (isEdit.value) {
                            isEdit.add(false);
                          } else {
                            isEdit.add(true);
                            final state = _detailsBloc.state;
                            if (state.hasData &&
                                _selectedSubjectIds.isEmpty &&
                                _selectedChapters.value.isEmpty &&
                                _selectedTopics.value.isEmpty) {
                            _prefillSelectionsFromDetails(state.data!.challenge);
                          }
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
                  // Ensure initial selections are prefilled when entering edit view
                  if (asyncSnapshot.data == true &&
                      _selectedSubjectIds.isEmpty &&
                      _selectedChapters.value.isEmpty &&
                      _selectedTopics.value.isEmpty &&
                      _detailsBloc.state.hasData) {
                    _prefillSelectionsFromDetails(_detailsBloc.state.data!.challenge);
                  }

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
                                          final subject =
                                              _subjectService.subjects[index];
                                          final isSelected = _selectedSubjectIds
                                              .contains(subject.subId);
                                      return Padding(
                                        padding: EdgeInsets.only(right: 10.w),
                                        child: subjectContainer(
                                          subject: subject,
                                          isSelected: isSelected,
                                          isActive: _activeSubjectId == subject.subId,
                                          onTap: () {
                                            setState(() {
                                              if (isSelected) {
                                                // If already selected, switch active subject (toggle view)
                                                _saveActiveSelections();
                                                _activeSubjectId = subject.subId;

                                                // Restore this subject's selections (or empty)
                                                _selectedChapters.add(List.from(_selectedChaptersBySubject[subject.subId] ?? const []));
                                                
                                                // If we had topics saved, restore them. else empty.
                                                _selectedTopics.add(List.from(_selectedTopicsBySubject[subject.subId] ?? const []));

                                                // CRITICAL LOGIC: If this subject is selected BUT not initialized (meaning we never fetched/matched its chapters),
                                                // we must trigger the fetch now. This happens if we pre-filled 3 subjects but only fetched for the 1st one.
                                                if (!_initializedSubjects.contains(subject.subId)) {
                                                   // This trigger will cause ChapterBloc to load.
                                                   // The BlocListener we added will catch the success, match details, and auto-select values.
                                                   _chapterBloc.add(ChapterRequested(subId: subject.subId, replace: true));
                                                } else {
                                                   // Already initialized. If we have chapters, we might need to refresh topics 
                                                   // if they are missing for some reason, but typically restoration above is enough.
                                                   // Just in case we need to "view" the chapters again (since we use different BLoC instance or state might have changed?)
                                                   // Actually, if we switch subjects, we want the ChapterBloc to show THIS subject's chapters.
                                                   // Since ChapterBloc state holds ALL loaded chapters (append) or just one (replace)? 
                                                   // CreateOwnChallenger used specific filtering. Here standard ChapterBloc uses append by default unless replace=true.
                                                   // Let's safe-guard by requesting chapters (checking cache/repo handled by Bloc mostly, or just re-fetch).
                                                   // Better: `replace: true` ensures the UI finds them easily.
                                                   _chapterBloc.add(ChapterRequested(subId: subject.subId, replace: true));
                                                   
                                                   // Also restore topics if chapters exist
                                                   final ch = _selectedChaptersBySubject[subject.subId] ?? const [];
                                                    if (ch.isNotEmpty) {
                                                      _topicBloc.add(TopicRequested(chapterIds: ch));
                                                    }
                                                }
                                                
                                              } else {
                                                // New subject selection
                                                _saveActiveSelections(); // save previous
                                                _selectedSubjectIds.add(subject.subId);
                                                _activeSubjectId = subject.subId;
                                                _selectedChaptersBySubject.putIfAbsent(subject.subId, () => []);
                                                _selectedTopicsBySubject.putIfAbsent(subject.subId, () => []);
                                                _selectedChapters.add([]);
                                                _selectedTopics.add([]);
                                                
                                                // Fetch chapters for this new subject
                                                _chapterBloc.add(ChapterRequested(subId: subject.subId, replace: true));
                                                // It's a new manual selection, so no "Initialization" from details needed.
                                                // We mark it as initialized effectively (since empty is valid start) 
                                                // to prevent accidental overwrite if Details had this subject (unlikely if user just clicked it fresh).
                                                _initializedSubjects.add(subject.subId);
                                                _initializedTopicsForSubjects.add(subject.subId);
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
                                                _selectedSubjectIds.isEmpty
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

                                        // Show ONLY active subject chapters in Edit mode
                                        final allChapters = state.data!.chapterList;
                                        final chapters = _activeSubjectId == null
                                            ? <ChapterModel>[]
                                            : allChapters.where((c) => c.subId == _activeSubjectId).toList();
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
                                                      
                                                      // If user manually changes chapters, clear topics for this subject 
                                                      // as the topics might not be valid anymore.
                                                      // (Or we could keep them and let the server/next fetch filter them)
                                                      // Typical flow: change chapter -> reset topics.
                                                      _selectedTopics.add([]);
                                                      _selectedTopicsBySubject[_activeSubjectId!] = [];
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

                                        // Filter topics by selected chapter NAMES (API returns chapter name)
                                        final allTopics = state.data!.topicList;
                                        final allChapters = _chapterBloc.state.data?.chapterList ?? [];
                                        final selectedChapterIds = _selectedChapters.value;
                                        final selectedChapterNames = allChapters
                                            .where((c) => selectedChapterIds.contains(c.chpId))
                                            .map((c) => c.name)
                                            .toList();

                                        final topics = selectedChapterNames.isNotEmpty
                                            ? allTopics.where((t) => selectedChapterNames.contains(t.chapter)).toList()
                                            : <TopicModel>[];
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
              color: isActive 
                  ? AppColors.green // Distinct yellow border for active sub
                  : (isSelected == false 
                      ? Colors.white.withOpacity(0.3) 
                      : Colors.transparent),
              width: isActive ? 2.0 : 1.0,
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
