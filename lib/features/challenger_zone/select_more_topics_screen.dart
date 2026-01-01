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
import 'package:zifour_sourcecode/features/challenger_zone/challenge_ready_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/custom_loading_widget.dart';
import '../../core/widgets/line_label_row.dart';
import '../../l10n/app_localizations.dart';
import 'bloc/create_challenge_bloc.dart';
import 'bloc/topic_bloc.dart';

class SelectMoreTopicsScreen extends StatefulWidget {
  const SelectMoreTopicsScreen({
    super.key,
    required this.subId,
    required this.chapterIds,
    required this.challengeType,
    this.topicIds = const [],
  });

  /// Selected subject id (sub_id) from previous screen
  final String subId;
  final String challengeType;

  /// Selected chapter ids (chp_id) from previous screen
  final List<String> chapterIds;

  /// Pre-selected topic ids from previous screen
  final List<String> topicIds;

  @override
  State<SelectMoreTopicsScreen> createState() => _SelectMoreTopicsScreenState();
}

class _SelectMoreTopicsScreenState extends State<SelectMoreTopicsScreen> {
  late final TopicBloc _topicBloc;
  late final CreateChallengeBloc _createChallengeBloc;

  /// Selected topic ids which will be passed to create-challenge API
  final BehaviorSubject<List<String>> _selectedTopicIds =
      BehaviorSubject<List<String>>.seeded([]);

  @override
  void initState() {
    super.initState();
    _topicBloc = TopicBloc();
    _createChallengeBloc = CreateChallengeBloc();

    // Pre-select topics if provided
    if (widget.topicIds.isNotEmpty) {
      _selectedTopicIds.add(widget.topicIds);
    }

    // Fetch topics for selected chapters when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.chapterIds.isNotEmpty) {
        _topicBloc.add(TopicRequested(chapterIds: widget.chapterIds));
      }
    });
  }

  @override
  void dispose() {
    _selectedTopicIds.close();
    _topicBloc.close();
    _createChallengeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
                  challengeType: widget.challengeType,
                  from: "select_topic"
                ),
              ),
            );
          } else if (state.status == CreateChallengeStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          final isCreating = state.isLoading;
          return CustomLoadingOverlay(
            isLoading: isCreating,
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
                  title: 'Select your topics from chapter mechanics',
                  isLongText: true,
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
                      '${AppLocalizations.of(context)?.chooseOneMoreTopics}',
                      style: AppTypography.inter16Regular.copyWith(
                          color: AppColors.white.withOpacity(0.6)
                      ),
                    ),
                    SizedBox(height: 25.h),
                    SignupFieldBox(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        spacing: 15.h,
                        children: [
                          BlocBuilder<TopicBloc, TopicState>(
                            builder: (context, state) {
                              if (state.isLoading) {
                                return _buildTopicsShimmer();
                              }

                              if (state.status == TopicStatus.failure) {
                                return Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.h),
                                    child: Text(
                                      state.errorMessage ??
                                          'Unable to load topics.',
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
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.h),
                                    child: Text(
                                      'No topics found for selected chapters.',
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
                                stream: _selectedTopicIds.stream,
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
                                          _selectedTopicIds.add(newList);
                                        },
                                        title: topic.name,
                                        isButton: false,
                                        isSelected: isSelected,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 7.h, horizontal: 7.w),
                                        bgColor: const Color(0xFF1B193D),
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
                    Row(
                      spacing: 15.w,
                      children: [
                        Expanded(
                          child: CustomGradientButton(
                            text: '${AppLocalizations.of(context)?.cancel}',
                            onPressed: () {},
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
                            text: '${AppLocalizations.of(context)?.confirm}',
                            onPressed: _onConfirmPressed,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h,),

                  ],
                ),
              ),
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

  void _onConfirmPressed() {
    final selectedTopics = _selectedTopicIds.value;

    if (selectedTopics.isEmpty) {
      print('Please select at least one topic.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one topic.')),
      );
      return;
    }

    if (widget.chapterIds.isEmpty || widget.subId.isEmpty) {
      print('Missing chapters or subject.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing chapters or subject.')),
      );
      return;
    }

    print('CreateChallengeBloc: \n${widget.chapterIds} \n $selectedTopics \n ${widget.subId} ');

    // Use the bloc instance directly instead of context.read
    // _createChallengeBloc.add(
    //   CreateChallengeRequested(
    //     chapterIds: widget.chapterIds,
    //     topicIds: selectedTopics,
    //     subId: widget.subId,
    //     challengeType: widget.challengeType,
    //   ),
    // );
  }

  Widget _buildTopicsShimmer() {
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
