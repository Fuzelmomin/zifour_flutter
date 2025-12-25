import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/challenger_zone/challenge_result_screen.dart';
import 'package:zifour_sourcecode/features/practics_mcq/question_mcq_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/dialogs/reminder_complete_dialog.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../l10n/app_localizations.dart';
import 'bloc/challenges_list_bloc.dart';
import 'model/challenges_list_model.dart';

class ExpertChallengeScreen extends StatefulWidget {
  const ExpertChallengeScreen({super.key});

  @override
  State<ExpertChallengeScreen> createState() => _ExpertChallengeScreenState();
}

class _ExpertChallengeScreenState extends State<ExpertChallengeScreen> {
  late final ChallengesListBloc _challengesListBloc;

  @override
  void initState() {
    super.initState();
    _challengesListBloc = ChallengesListBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _challengesListBloc.add(ChallengesListRequested(challengeType: '2'));
    });
  }

  @override
  void dispose() {
    _challengesListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _challengesListBloc,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.darkBlue,
          child: SafeArea(
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
                  right: 5.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: '${AppLocalizations.of(context)?.expertsChallenge}',
                  ),
                ),

                // Main Content with BLoC
                Positioned(
                  top: 90.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Compete in faculty - Designed challenges and track your progress.",
                        style: AppTypography.inter16Regular.copyWith(
                          color: AppColors.white.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Expanded(
                        child: BlocBuilder<ChallengesListBloc, ChallengesListState>(
                          builder: (context, state) {
                            switch (state.status) {
                              case ChallengesListStatus.loading:
                              case ChallengesListStatus.initial:
                                return _buildShimmerLoader();
                              case ChallengesListStatus.failure:
                                return _buildError(
                                  message: state.errorMessage ?? 'Unable to load challenges.',
                                  onRetry: () {
                                    _challengesListBloc.add(
                                      ChallengesListRequested(challengeType: '2'),
                                    );
                                  },
                                );
                              case ChallengesListStatus.success:
                                if (!state.hasData || state.data!.data.isEmpty) {
                                  return _buildEmpty();
                                }
                                return _buildChallengesList(state);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, __) => SizedBox(height: 18.h),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.08),
        highlightColor: Colors.white.withOpacity(0.2),
        child: Container(
          height: 200.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
    );
  }

  Widget _buildError({required String message, required VoidCallback onRetry}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.orange,
            size: 60.sp,
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.inter16Regular.copyWith(
                color: AppColors.white.withOpacity(0.8),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          CustomGradientButton(
            text: 'Retry',
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text(
        'No expert challenges found.',
        style: AppTypography.inter16Regular.copyWith(
          color: AppColors.white.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildChallengesList(ChallengesListState state) {
    final challenges = state.data!.data;
    
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: challenges.length,
      separatorBuilder: (_, __) => SizedBox(height: 18.h),
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        
        // Determine status and button based on erFlag
        String status = challenge.erFlag == "2" ? "COMPLETED" : "UPCOMING";
        Color statusColor = challenge.erFlag == "2" 
            ? const Color(0xFF4CAF50) 
            : const Color(0xFFFFA726);
        String buttonText = challenge.erFlag == "2" ? "View Result" : "Start Exam";
        
        return _challengeCard(
          challenge: challenge,
          status: status,
          statusColor: statusColor,
          buttonText: buttonText,
          onTap: () {
            if (challenge.erFlag == "2") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChallengeResultScreen(
                    title: "Challenge Result 🏆",
                    crtChlId: challenge.crtChlId,
                    solution: challenge.solutionVideo,
                    screenType: "2", // 3 = Own Challenge MCQ Type AND 2 = Expert Challenge MCQ Type
                  ),
                ),
              ).then((value) {
                _challengesListBloc.add(
                  ChallengesListRequested(challengeType: '2'),
                );
              });
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionMcqScreen(
                    type: 'Start Exam',
                    crtChlId: challenge.crtChlId,
                    mcqType: "2", // 3 = Own Challenge MCQ Type AND 2 = Expert Challenge MCQ Type
                  ),
                ),
              ).then((value) {
                _challengesListBloc.add(
                  ChallengesListRequested(challengeType: '2'),
                );
              });
            }
          },
        );
      },
    );
  }

  Widget _challengeCard({
    required ChallengeListItem challenge,
    required String status,
    required Color statusColor,
    required String buttonText,
    required Function() onTap,
  }) {
    return SignupFieldBox(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Status Badge
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 5.h),

          /// Title
          Text(
            challenge.challengeName ?? "Challenge",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 14.h),

          /// Time Row Container
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _timeItem(_formatDate(challenge.createdAt)),
                //_dot(),
                //_timeItem(challenge.subjects ?? "Subject"),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          /// Syllabus Title
          Row(
            children: [
              Expanded(child: Divider(thickness: .5, color: Colors.white24)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  "SYLLABUS",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(child: Divider(thickness: .5, color: Colors.white24)),
            ],
          ),
          SizedBox(height: 14.h),

          /// Syllabus Row
          Row(
            children: [
              if (challenge.subjects != null && challenge.subjects.isNotEmpty)
                _syllabusBox("SUBJECT", challenge.subjects),

              if (challenge.subjects != null && challenge.subjects.isNotEmpty &&
                  challenge.chapters != null && challenge.chapters.isNotEmpty)
                SizedBox(width: 10.w),

              if (challenge.chapters != null && challenge.chapters.isNotEmpty)
                _syllabusBox("CHAPTERS", challenge.chapters),
            ],
          ),
          SizedBox(height: 10.h),
          if (challenge.topics != null && challenge.topics.isNotEmpty)
            Row(
              children: [
                _syllabusBox("TOPICS", challenge.topics),
              ],
            ),

          SizedBox(height: 18.h),

          /// Button
          CustomGradientArrowButton(
            text: buttonText,
            onPressed: () {
              onTap();
            },
          )
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Date';
    }
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Widget _timeItem(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: 11.sp),
    );
  }

  Widget _dot() {
    return Text("•", style: TextStyle(color: Colors.orange, fontSize: 14.sp));
  }

  Widget _syllabusBox(String title, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
