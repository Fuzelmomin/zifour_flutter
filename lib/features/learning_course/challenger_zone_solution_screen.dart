import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/dialogs/create_reminder_dialog.dart';
import 'package:zifour_sourcecode/core/widgets/course_item.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/challenger_zone/challenge_result_screen.dart';
import 'package:zifour_sourcecode/features/payment/payment_status_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/challenger_score_item.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/my_course_item.dart';
import '../../l10n/app_localizations.dart';
import '../challenger_zone/bloc/challenges_list_bloc.dart';
import '../dashboard/video_player_screen.dart';

class ChallengerZoneSolutionScreen extends StatefulWidget {
  const ChallengerZoneSolutionScreen({super.key});

  @override
  State<ChallengerZoneSolutionScreen> createState() =>
      _ChallengerZoneSolutionScreenState();
}

class _ChallengerZoneSolutionScreenState
    extends State<ChallengerZoneSolutionScreen> {
  late final ChallengesListBloc _challengesListBloc;

  @override
  void initState() {
    super.initState();
    _challengesListBloc = ChallengesListBloc();
    // Load challenges from API with oe_challenge set to "0" for this screen
    _challengesListBloc.add(ChallengesListRequested(challengeType: '0'));
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
                  right: 20.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: 'Challenger Zone Solutions',
                  ),
                ),

                // Main Content with BLoC
                Positioned(
                  top: 90.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: 50.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Revisit past challenges and master the toughest MCQs.",
                        style: AppTypography.inter16Regular.copyWith(
                          color: AppColors.white.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(height: 15.h),
                    ],
                  ),
                ),

                // Challenges List
                Positioned(
                  top: 130.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: 0.h,
                  child: BlocBuilder<ChallengesListBloc, ChallengesListState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return _buildShimmerLoading();
                      }

                      if (state.status == ChallengesListStatus.failure) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Text(
                              state.errorMessage ?? 'Unable to load challenges',
                              style: AppTypography.inter14Regular.copyWith(
                                color: AppColors.white.withOpacity(0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      if (!state.hasData || state.data!.data.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Text(
                              'No challenges found',
                              style: AppTypography.inter14Regular.copyWith(
                                color: AppColors.white.withOpacity(0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      final challenges = state.data!.data;
                      return ListView.separated(
                        itemCount: challenges.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final challenge = challenges[index];
                          return ChallengerScoreItem(
                            challenge: challenge,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChallengeResultScreen(
                                    title: "Challenger Test Results 🏆",
                                    crtChlId: challenge.crtChlId,
                                    screenType: "3", // 3 = Own Challenge MCQ Type AND 2 = Expert Challenge MCQ Type
                                  ),
                                ),
                              );
                            },
                            onViewSolution: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoPlayerScreen(
                                    videoId: challenge.solutionVideo!,
                                    videoTitle: challenge.oeChaName ?? "",
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 15.h,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.white.withOpacity(0.08),
          highlightColor: Colors.white.withOpacity(0.2),
          child: Container(
            width: double.infinity,
            height: 180.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 15.h);
      },
    );
  }
}
