import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/challenge_option_box.dart';
import 'package:zifour_sourcecode/core/widgets/challenge_ready_widget.dart';
import 'package:zifour_sourcecode/core/widgets/chapter_selection_box.dart';
import 'package:zifour_sourcecode/core/widgets/custom_loading_widget.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/practics_mcq/question_mcq_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/challenges_item_widget.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/line_label_row.dart';
import '../../l10n/app_localizations.dart';
import 'bloc/challenges_list_bloc.dart';
import 'challenge_result_screen.dart';

class ChallengesListScreen extends StatefulWidget {
  String challengeType;
  ChallengesListScreen({
    super.key,
    required this.challengeType
  });

  @override
  State<ChallengesListScreen> createState() => _ChallengesListScreenState();
}

class _ChallengesListScreenState extends State<ChallengesListScreen> {
  late final ChallengesListBloc _challengesListBloc;

  @override
  void initState() {
    super.initState();
    _challengesListBloc = ChallengesListBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _challengesListBloc.add(ChallengesListRequested(challengeType: widget.challengeType));
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
      child: BlocBuilder<ChallengesListBloc, ChallengesListState>(
        builder: (context, state) {
          return CustomLoadingOverlay(
            isLoading: state.isLoading,
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
                      right: 5.w,
                      child: CustomAppBar(
                        isBack: true,
                        title: '${AppLocalizations.of(context)?.challengesList}',
                      ),
                    ),

                    // Main Content with BLoC
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
          );
        },
      ),
    );
  }

  Widget _buildContent(ChallengesListState state) {
    if (state.status == ChallengesListStatus.failure) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            state.errorMessage ?? 'Unable to load challenges.',
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
          'No challenges found.',
          style: AppTypography.inter14Regular.copyWith(
            color: AppColors.white.withOpacity(0.6),
          ),
        ),
      );
    }

    final challenges = state.data!.data;
    return ListView.separated(
      itemCount: challenges.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return ChallengesItemWidget(
          challenge: challenge,
          btnName: challenge.erFlag == "2" ? "View Results" : "Start Exam",
          onTap: () {

            if(challenge.erFlag == "2"){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChallengeResultScreen(
                    title: 'Challenge Result 🏆',
                    crtChlId: challenge.crtChlId,
                  ),
                ),
              ).then((value){
                _challengesListBloc.add(ChallengesListRequested(
                  challengeType: widget.challengeType
                ));
              });
            }else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionMcqScreen(
                    type: 'Start Exam',
                    crtChlId: challenge.crtChlId,
                  ),
                ),
              ).then((value){
                _challengesListBloc.add(ChallengesListRequested(
                  challengeType: widget.challengeType
                ));
              });
            }

          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 15.h);
      },
    );
  }

  Widget stepRowContent(String title, String step) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            title,
            style: AppTypography.inter12Medium,
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            height: 1.0,
            color: AppColors.white.withOpacity(0.5),
          ),
        ),
        Flexible(
          child: Text(
            title,
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
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 13.w),
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
