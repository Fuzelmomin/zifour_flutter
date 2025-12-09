import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/dialogs/add_note_dialog.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/utils/connectivity_helper.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/custom_loading_widget.dart';
import '../challenger_zone/challenge_result_screen.dart';
import 'bloc/challenge_mcq_list_bloc.dart';
import 'bloc/submit_mcq_answer_bloc.dart';
import 'bloc/mcq_bookmark_bloc.dart';
import 'model/challenge_mcq_list_model.dart';

class QuestionMcqScreen extends StatefulWidget {
  final String type;
  final String? crtChlId;

  const QuestionMcqScreen({
    super.key,
    required this.type,
    this.crtChlId,
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


  String selectedFilter = "";
  final options = [
    "Add Note",
    "Mark as Bookmark",
    "Feedback"
  ];

  @override
  void initState() {
    super.initState();
    _mcqListBloc = ChallengeMcqListBloc();
    _submitMcqAnswerBloc = SubmitMcqAnswerBloc();
    _mcqBookmarkBloc = McqBookmarkBloc();
    if (widget.crtChlId != null && widget.crtChlId!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mcqListBloc.add(
          ChallengeMcqListRequested(crtChlId: widget.crtChlId!),
        );
      });
    }
  }

  @override
  void dispose() {
    selectedOption.close();
    _mcqListBloc.close();
    _submitMcqAnswerBloc.close();
    _mcqBookmarkBloc.close();
    super.dispose();
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
    if (currentSelected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an answer before proceeding.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    // Save current answer
    _allAnswers[currentMcq.mcId] = currentSelected;
    
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
        _currentQuestionIndex = nextIndex;
      });
      
      // Restore saved answer for next question if exists
      selectedOption.add(savedAnswer);
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
      
      final previousIndex = _currentQuestionIndex - 1;
      final previousMcq = mcqList[previousIndex];
      final savedAnswer = _allAnswers[previousMcq.mcId];
      
      setState(() {
        _currentQuestionIndex = previousIndex;
      });
      
      // Restore saved answer for previous question
      selectedOption.add(savedAnswer);
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
          builder: (_) => AddNoteDialog(mcqId: currentMcq.mcId),
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
        McqBookmarkRequested(mcqId: currentMcq.mcId),
      );
    }
  }
  
  Future<void> _submitAnswers() async {
    if (!_mcqListBloc.state.hasData || widget.crtChlId == null) return;
    
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
        'mc_answer_stu': studentAnswerIndex >= 0 ? (studentAnswerIndex+1).toString() : '1',
        'mc_answer': mcq.mcAnswer,
      });
    }
    
    // Call API
    _submitMcqAnswerBloc.add(
      SubmitMcqAnswerRequested(
        crtChlId: int.parse(widget.crtChlId!),
        mcqList: mcqListForApi,
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
      child: BlocListener<McqBookmarkBloc, McqBookmarkState>(
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
        child: BlocListener<SubmitMcqAnswerBloc, SubmitMcqAnswerState>(
        listener: (context, state) {
          if (state.status == SubmitMcqAnswerStatus.success) {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ChallengeResultScreen(
            //       title: 'Challenge Results',
            //       crtChlId: "",
            //     ),
            //   ),
            // );
            Navigator.pop(context);
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

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
          const SizedBox(height: 14),

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
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     color: Colors.white.withOpacity(0.15),
              //   ),
              //   child: const Row(
              //     children: [
              //       Icon(Icons.timer, color: Colors.orange, size: 16),
              //       SizedBox(width: 5),
              //       Text("00:53",
              //           style: TextStyle(color: Colors.white, fontSize: 13)),
              //     ],
              //   ),
              // )
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

          Row(
            spacing: 10.0,
            children: [
              Expanded(
                child: CustomGradientButton(
                  text: 'Video Solution',
                  onPressed: () {},
                  customDecoration: widget.type == "Start Exam"
                      ? BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.2),
                      ),
                      color: Colors.grey.withOpacity(0.3))
                      : null,
                  textStyle: widget.type == "Start Exam"
                      ? AppTypography.inter14Bold
                      .copyWith(color: Colors.white.withOpacity(0.2))
                      : null,
                ),
              ),
              Expanded(
                child: CustomGradientButton(
                  text: 'Text Solution',
                  onPressed: () {
                    _showSolutionDialog(currentMcq);
                  },
                  customDecoration: widget.type == "Start Exam"
                      ? BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.2),
                      ),
                      color: Colors.grey.withOpacity(0.3))
                      : null,
                  textStyle: widget.type == "Start Exam"
                      ? AppTypography.inter14Bold
                      .copyWith(color: Colors.white.withOpacity(0.2))
                      : null,
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

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

          SizedBox(height: 50.h),
        ],
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

  void _showSolutionDialog(McqItem mcq) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkBlue,
        title: const Text(
          'Solution',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Text(
            mcq.mcSolution.replaceAll(RegExp(r'\r\n&nbsp;'), ' '),
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
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
