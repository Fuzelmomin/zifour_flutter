import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/dialogs/add_note_dialog.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/features/dashboard/dashboard_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/utils/connectivity_helper.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/custom_loading_widget.dart';
import '../../core/widgets/info_row.dart';
import '../challenger_zone/challenge_result_screen.dart';
import '../dashboard/video_player_screen.dart';
import 'bloc/challenge_mcq_list_bloc.dart';
import 'bloc/submit_mcq_answer_bloc.dart';
import 'bloc/mcq_bookmark_bloc.dart';
import 'model/challenge_mcq_list_model.dart';

class QuestionMcqScreen extends StatefulWidget {
  final String type;
  final String mcqType;
  final String? crtChlId;
  final String? topicId;
  final String? pkId;
  final String? paperId;
  final String? paperSolution;

  const QuestionMcqScreen({
    super.key,
    required this.type,
    required this.mcqType,
    this.crtChlId,
    this.topicId,
    this.pkId,
    this.paperId,
    this.paperSolution,
  });

  @override
  State<QuestionMcqScreen> createState() => _QuestionMcqScreenState();
}

class _QuestionMcqScreenState extends State<QuestionMcqScreen> {
  late final ChallengeMcqListBloc _mcqListBloc;
  late final SubmitMcqAnswerBloc _submitMcqAnswerBloc;
  late final McqBookmarkBloc _mcqBookmarkBloc;
  final BehaviorSubject<String?> selectedOption =
      BehaviorSubject<String?>.seeded(null);
  int _currentQuestionIndex = 0;
  
  // Store all answers: key = mcId, value = selected option (A, B, C, D)
  final Map<String, String> _allAnswers = {};

  // Track slide direction: true = forward (right to left), false = backward (left to right)
  bool _isMovingForward = true;

  String selectedFilter = "";
  final options = [
    "Add Note",
    "Mark as Bookmark"
  ];

  final BehaviorSubject<String> takeTime =
  BehaviorSubject<String>.seeded("00:00");
  
  Timer? _timer;
  int _currentQuestionSeconds = 0;
  // Map to store cumulative time spent on each question (mcId -> total seconds)
  final Map<String, int> _questionTimeMap = {};

  @override
  void initState() {
    super.initState();
    _mcqListBloc = ChallengeMcqListBloc();
    _submitMcqAnswerBloc = SubmitMcqAnswerBloc();
    _mcqBookmarkBloc = McqBookmarkBloc();

    // if widget.mcqType = "1", Practice MCQ
    // if widget.mcqType = "2", Expert Challenge MCQ Type
    // if widget.mcqType = "3", Own Challenge MCQ Type
    // if widget.mcqType = "4", All India Series Test

    if(widget.mcqType == "1"){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mcqListBloc.add(
          ChallengeMcqListRequested(crtChlId: "", apiType: widget.mcqType, sampleTest: "0", topicId: widget.topicId),
        );
      });
    }else if(widget.mcqType == "4"){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mcqListBloc.add(
          ChallengeMcqListRequested(crtChlId: "", apiType: widget.mcqType, sampleTest: "2", pkId: widget.pkId, paperId: widget.paperId),
        );
      });
    } else {
      if (widget.crtChlId != null && widget.crtChlId!.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mcqListBloc.add(
            ChallengeMcqListRequested(crtChlId: widget.crtChlId!, apiType: widget.mcqType, sampleTest: "0", topicId: widget.topicId),
          );
        });
      }
    }


  }

  @override
  void dispose() {
    _stopTimer();
    selectedOption.close();
    _mcqListBloc.close();
    _submitMcqAnswerBloc.close();
    _mcqBookmarkBloc.close();
    takeTime.close();
    super.dispose();
  }

  void _startTimer() {
    _stopTimer();
    _currentQuestionSeconds = 0;
    takeTime.add("00:00");
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentQuestionSeconds++;
      final minutes = (_currentQuestionSeconds ~/ 60).toString().padLeft(2, '0');
      final seconds = (_currentQuestionSeconds % 60).toString().padLeft(2, '0');
      takeTime.add("$minutes:$seconds");
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _saveCurrentTime() {
    if (_mcqListBloc.state.hasData) {
      final mcqList = _mcqListBloc.state.data!.mcqList;
      if (_currentQuestionIndex < mcqList.length) {
        final currentMcq = mcqList[_currentQuestionIndex];
        _questionTimeMap[currentMcq.mcId] = 
            (_questionTimeMap[currentMcq.mcId] ?? 0) + _currentQuestionSeconds;
      }
    }
  }

  void _goToNextQuestion() async {
    print('_goToNextQuestion');
    if (!_mcqListBloc.state.hasData) return;
    print('_goToNextQuestion 111');
    final mcqList = _mcqListBloc.state.data!.mcqList;
    final totalQuestions = mcqList.length;
    final currentMcq = mcqList[_currentQuestionIndex];
    
    // Validation: Check if answer is selected
    final currentSelected = selectedOption.value;
    
    // Save current answer
    _allAnswers[currentMcq.mcId] = currentSelected ?? "";

    // Save time spent on this question before moving
    _saveCurrentTime();
    
    // Check if this is the last question
    if (_currentQuestionIndex == totalQuestions - 1) {
      // Last question - submit answers via API
      await _submitAnswers();
    } else {
      // Move to next question
      final nextIndex = _currentQuestionIndex + 1;
      final nextMcq = mcqList[nextIndex];
      final savedAnswer = _allAnswers[nextMcq.mcId];
      
      setState(() {
        _isMovingForward = true;
        _currentQuestionIndex = nextIndex;
      });
      
      // Restore saved answer for next question if exists
      selectedOption.add(savedAnswer);

      // Reset timer for next question
      _startTimer();
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0 && _mcqListBloc.state.hasData) {
      final mcqList = _mcqListBloc.state.data!.mcqList;
      final currentMcq = mcqList[_currentQuestionIndex];
      
      // Save current answer before moving
      final currentSelected = selectedOption.value;
      if (currentSelected != null) {
        _allAnswers[currentMcq.mcId] = currentSelected;
      }

      // Save time spent on this question before moving
      _saveCurrentTime();
      
      final previousIndex = _currentQuestionIndex - 1;
      final previousMcq = mcqList[previousIndex];
      final savedAnswer = _allAnswers[previousMcq.mcId];
      
      setState(() {
        _isMovingForward = false;
        _currentQuestionIndex = previousIndex;
      });
      
      // Restore saved answer for previous question
      selectedOption.add(savedAnswer);

      // Reset timer for previous question
      _startTimer();
    }
  }

  void onOptionSelect(String option) {
    selectedOption.sink.add(option);
    // Save answer immediately when selected
    if (_mcqListBloc.state.hasData) {
      final mcqList = _mcqListBloc.state.data!.mcqList;
      if (_currentQuestionIndex < mcqList.length) {
        final currentMcq = mcqList[_currentQuestionIndex];
        _allAnswers[currentMcq.mcId] = option;
      }
    }
  }

  void _handleMenuSelection(String value) {
    if (value == "Mark as Bookmark") {
      _addBookmark();
    } else if(value == "Add Note"){
      if (!_mcqListBloc.state.hasData) return;
      
      final mcqList = _mcqListBloc.state.data!.mcqList;
      if (_currentQuestionIndex < mcqList.length) {
        final currentMcq = mcqList[_currentQuestionIndex];
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => AddNoteDialog(mcqId: currentMcq.mcId, mcqType: widget.mcqType,),
        );
      }
    }
    else {
      setState(() => selectedFilter = value);
    }
  }

  void _addBookmark() {
    if (!_mcqListBloc.state.hasData) return;
    
    final mcqList = _mcqListBloc.state.data!.mcqList;
    if (_currentQuestionIndex < mcqList.length) {
      final currentMcq = mcqList[_currentQuestionIndex];
      _mcqBookmarkBloc.add(
        McqBookmarkRequested(mcqId: currentMcq.mcId, mcqType: widget.mcqType),
      );
    }
  }
  
  Future<void> _submitAnswers() async {
    //if (!_mcqListBloc.state.hasData || widget.crtChlId == null) return;
    
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
    
    // Save time for the current question before submission
    _saveCurrentTime();
    
    final mcqList = _mcqListBloc.state.data!.mcqList;
    final optionLabels = ['A', 'B', 'C', 'D'];
    
    // Prepare mcq_list for API
    final List<Map<String, String>> mcqListForApi = [];

    for (final mcq in mcqList) {
      final selectedOption = _allAnswers[mcq.mcId] ?? '';
      // Convert option label (A, B, C, D) to index (1, 2, 3, 4)
      final studentAnswerIndex = optionLabels.indexOf(selectedOption);
      
      mcqListForApi.add({
        'mc_id': mcq.mcId,
        'mc_answer_stu': selectedOption == "" ? "" : studentAnswerIndex >= 0 ? (studentAnswerIndex+1).toString() : '1',
        'mc_answer': mcq.mcAnswer,
        'mc_timer': (_questionTimeMap[mcq.mcId] ?? 0).toString(),
      });
    }

    print("QuestionAnswer: ${mcqListForApi}");

    // if widget.mcqType = "1", Practice MCQ
    // if widget.mcqType = "2", Expert Challenge MCQ Type
    // if widget.mcqType = "3", Own Challenge MCQ Type
    // if widget.mcqType = "4",
    // Call API
    _submitMcqAnswerBloc.add(
      SubmitMcqAnswerRequested(
        crtChlId: widget.mcqType == "1" || widget.mcqType == "4" ? 0 : int.parse(widget.crtChlId!),
        mcqList: mcqListForApi,
        apiType: widget.mcqType,
        tpcId: widget.topicId,
        paperId: widget.paperId,
        pkId: widget.pkId
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _mcqListBloc),
        BlocProvider.value(value: _submitMcqAnswerBloc),
        BlocProvider.value(value: _mcqBookmarkBloc),
      ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<ChallengeMcqListBloc, ChallengeMcqListState>(
              listener: (context, state) {
                if (state.status == ChallengeMcqListStatus.success && _timer == null) {
                  _startTimer();
                }
              },
            ),
            BlocListener<McqBookmarkBloc, McqBookmarkState>(
              listener: (context, bookmarkState) {
                if (bookmarkState.status == McqBookmarkStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        bookmarkState.data?.message ?? 'Bookmark added successfully.',
                      ),
                      backgroundColor: AppColors.success,
                    ),
                  );
                } else if (bookmarkState.status == McqBookmarkStatus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        bookmarkState.errorMessage ?? 'Unable to add bookmark.',
                      ),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
            ),
          ],
          child: BlocListener<SubmitMcqAnswerBloc, SubmitMcqAnswerState>(
            listener: (context, state) {
              if (state.status == SubmitMcqAnswerStatus.success) {
                _stopTimer();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.data?.message ?? 'Submit answers.'),
                backgroundColor: AppColors.success,
              ),
            );
            if(widget.mcqType == "1" || widget.mcqType == "4"){
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(),
                ),
                    (route) => false,
              );
              print('Paper MCQ Test Id PKID: ${widget.pkId}');
              print('Paper MCQ Test Id PaperId: ${widget.paperId}');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChallengeResultScreen(
                  title: "Test Series Results 🏆",
                  crtChlId: "",
                  screenType: "1", // 1 = Test Series, 3 = Own Challenge MCQ Type AND 2 = Expert Challenge MCQ Type
                  pkId: widget.pkId,
                  paperId: widget.paperId,
                  solution: widget.paperSolution,
                )),
              );
            } /*else if(widget.mcqType == "4"){
              int count = 0;
              Navigator.popUntil(context, (route) => count++ == 1);
            }*/
            else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(),
                ),
                (route) => false,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChallengeResultScreen(
                    title: 'Challenge Results',
                    crtChlId: widget.crtChlId ?? "",
                    screenType: widget.mcqType, // 3 = Own Challenge MCQ Type AND 2 = Expert Challenge MCQ Type
                  ),
                ),
              );
            }
          } else if (state.status == SubmitMcqAnswerStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Unable to submit answers.'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<SubmitMcqAnswerBloc, SubmitMcqAnswerState>(
          builder: (context, submitState) {
            return BlocBuilder<McqBookmarkBloc, McqBookmarkState>(
              builder: (context, bookmarkState) {
                return BlocBuilder<ChallengeMcqListBloc, ChallengeMcqListState>(
                  builder: (context, state) {
                    return CustomLoadingOverlay(
                      isLoading: submitState.isLoading || bookmarkState.isLoading,
                      child: Scaffold(
                        body: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: AppColors.darkBlue,
                      child: SafeArea(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                AssetsPath.signupBgImg,
                                fit: BoxFit.cover,
                              ),
                            ),

                            Positioned(
                              top: 20.h,
                              left: 15.w,
                              right: 15.w,
                              child: CustomAppBar(
                                isBack: true,
                                title: state.hasData
                                    ? 'Question ${_currentQuestionIndex + 1}/${state.data!.mcqList.length}'
                                    : 'MCQ Challenge',
                                isActionWidget: true,
                                actionWidget: PopupMenuButton<String>(
                                  onSelected: _handleMenuSelection,
                                  itemBuilder: (context) {
                                    return options
                                        .map(
                                          (e) => PopupMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                        .toList();
                                  },
                                  child: Image.asset(
                                    AssetsPath.icMenuBox,
                                    width: 30.w,
                                    height: 30.h,
                                  ),
                                ),
                                actionClick: () {},
                              ),
                            ),

                            Positioned(
                              top: 90.h,
                              left: 20.w,
                              right: 20.w,
                              bottom: 0,
                              child: _buildContent(state),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                  },
                );
              },
            );
          },
        ),
      ),
    ),
    );
  }

  Widget _buildContent(ChallengeMcqListState state) {
    if (state.isLoading) {
      return _buildShimmerLoading();
    }

    if (state.status == ChallengeMcqListStatus.failure) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            state.errorMessage ?? 'Unable to load questions.',
            style: AppTypography.inter14Regular.copyWith(
              color: AppColors.white.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (!state.hasData) {
      return Center(
        child: Text(
          'No questions found.',
          style: AppTypography.inter14Regular.copyWith(
            color: AppColors.white.withOpacity(0.6),
          ),
        ),
      );
    }

    final mcqList = state.data!.mcqList;

    if (_currentQuestionIndex >= mcqList.length) {
      _currentQuestionIndex = 0;
    }

    final currentMcq = mcqList[_currentQuestionIndex];
    final totalQuestions = mcqList.length;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        // Only animate the NEW incoming widget, not the old outgoing one
        final isNewWidget = child.key == ValueKey<int>(_currentQuestionIndex);
        
        if (!isNewWidget) {
          // Old widget - just hide it instantly (no animation)
          return const SizedBox.shrink();
        }
        
        // New widget - slide animation
        final offsetAnimation = Tween<Offset>(
          begin: Offset(_isMovingForward ? 1.0 : -1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      child: SingleChildScrollView(
        key: ValueKey<int>(_currentQuestionIndex),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            widget.mcqType == "1" ? Row(
              spacing: 15.w,
              children: [
                Expanded(
                  child: InfoRow(
                    title: "Chapter",
                    value: state.data?.chpName ?? "",
                  ),
                ),
                Expanded(
                  child: InfoRow(
                    title: "Topic",
                    value: state.data?.tpcName ?? "",
                  ),
                ),
              ],
            ) : Container(),
            SizedBox(height: widget.mcqType == "1" ? 10.h : 0.0),

            /*Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Question ${_currentQuestionIndex + 1} of $totalQuestions',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 14),*/

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
                    children: [
                      Icon(Icons.timer, color: Colors.orange, size: 16),
                      SizedBox(width: 5),
                      StreamBuilder<String>(
                        stream: takeTime,
                        builder: (context, asyncSnapshot) {
                          return Text(asyncSnapshot.data ?? "00:00",
                              style: TextStyle(color: Colors.white, fontSize: 13));
                        }
                      ),
                    ],
                  ),
                )

              ],
            ),
            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.pinkColor3.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                currentMcq.mcQuestion.replaceAll(RegExp(r'\r\n&nbsp;'), ' '),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),

            if (currentMcq.mcDescription.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  currentMcq.mcDescription.replaceAll(RegExp(r'\r\n&nbsp;'), ' '),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            StreamBuilder<String?>(
              stream: selectedOption.stream,
              builder: (context, snapshot) {
                final selected = snapshot.data;
                final options = currentMcq.options;
                final optionLabels = ['A', 'B', 'C', 'D'];

                return Column(
                  children: List.generate(
                    options.length,
                        (index) => _optionTile(
                      optionLabels[index],
                      options[index].replaceAll(RegExp(r'\r\n&nbsp;'), ' '),
                      selected,
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 50.h),

            //
            // SizedBox(height: 20.h),

            Row(
              spacing: 10.0,
              children: [
                Expanded(
                  child: CustomGradientButton(
                    text: 'Previous',
                    onPressed:
                    _currentQuestionIndex > 0 ? _goToPreviousQuestion : null,
                    customDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                      color: const Color(0xFF464375),
                    ),
                  ),
                ),
                Expanded(
                  child: CustomGradientButton(
                    text: _currentQuestionIndex < totalQuestions - 1
                        ? 'Next'
                        : 'Submit',
                    onPressed: _goToNextQuestion,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h,),

            widget.mcqType == "1" ? Row(
              spacing: 10.0,
              children: [
                Expanded(
                  child: Container(),
                ),
                Expanded(
                  child: CustomGradientButton(
                    text: 'Solution',
                    onPressed: (){
                      if (_currentQuestionIndex >= 0 && _mcqListBloc.state.hasData) {
                        final mcqList = _mcqListBloc.state.data!.mcqList;
                        final currentMcq = mcqList[_currentQuestionIndex];
                        if(currentMcq.textSolution != null && currentMcq.textSolution.isNotEmpty){
                          _showSolutionDialog(currentMcq.textSolution);
                        }else if(currentMcq.videoSolution != null && currentMcq.videoSolution.isNotEmpty){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                videoId: currentMcq.videoSolution,
                                videoTitle: "",
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ) : Container(),

            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.08),
            highlightColor: Colors.white.withOpacity(0.2),
            child: Container(
              height: 30.h,
              width: 150.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.08),
            highlightColor: Colors.white.withOpacity(0.2),
            child: Container(
              height: 20.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.08),
            highlightColor: Colors.white.withOpacity(0.2),
            child: Container(
              height: 100.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          ...List.generate(4, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Shimmer.fromColors(
                baseColor: Colors.white.withOpacity(0.08),
                highlightColor: Colors.white.withOpacity(0.2),
                child: Container(
                  height: 60.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showSolutionDialog(String solution) {
    showDialog(
      context: context,

      builder: (context) => AlertDialog(
        backgroundColor: AppColors.hintTextColor,
        // 🔥 makes dialog wider
        insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24).copyWith(left: 0.0),

        // 🔥 removes default padding around content
        contentPadding: EdgeInsets.zero,
        title: const Text(
          'Solution',
          style: TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Html(
              data: solution,

              style: {
                "strong": Style(
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize(16),
                  color: Colors.white
                ),
                "body": Style(
                  color: Colors.white,
                  fontSize: FontSize(16),
                ),
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: AppTypography.inter14Medium.copyWith(color: AppColors.darkBlue),),
          ),
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
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
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

  // Widget _optionTile(String label, String text, String? selected) {
  //   final bool isSelected = selected == label;
  //
  //   return GestureDetector(
  //     onTap: () => onOptionSelect(label),
  //     child: Container(
  //       margin: const EdgeInsets.only(bottom: 12),
  //       padding: const EdgeInsets.all(14),
  //       decoration: BoxDecoration(
  //         color: Colors.white.withOpacity(isSelected ? 0.18 : 0.08),
  //         borderRadius: BorderRadius.circular(14),
  //         border: Border.all(
  //           color: isSelected ? Colors.purpleAccent : Colors.transparent,
  //           width: 2,
  //         ),
  //       ),
  //       child: Row(
  //         children: [
  //           Text(label,
  //               style: const TextStyle(
  //                   color: Colors.white, fontWeight: FontWeight.w600)),
  //           const SizedBox(width: 14),
  //           Expanded(
  //             child: Text(text,
  //                 style: const TextStyle(
  //                     color: Colors.white, fontSize: 14)),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

}
