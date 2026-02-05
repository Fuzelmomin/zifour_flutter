import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/core/widgets/subject_header_widget.dart';
import 'package:zifour_sourcecode/features/practics_mcq/question_mcq_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/profile_option_widget.dart';
import '../challenger_zone/bloc/topic_bloc.dart';

class SelectTopicScreen extends StatefulWidget {
  final String? from;
  final String? subjectId;
  final String? subjectName;
  final String? chapterId;
  final String? chapterName;
  final String? subjectIcon;

  const SelectTopicScreen({
    super.key,
    this.from,
    this.subjectId,
    this.subjectName,
    this.chapterId,
    this.chapterName,
    this.subjectIcon,
  });

  @override
  State<SelectTopicScreen> createState() => _SelectTopicScreenState();
}

class _SelectTopicScreenState extends State<SelectTopicScreen> {
  late final TopicBloc _topicBloc;

  @override
  void initState() {
    super.initState();
    _topicBloc = TopicBloc();
    
    // Load topics from API if from is "practice" and chapterId is provided
    if (widget.from == "practice" && widget.chapterId != null && widget.chapterId!.isNotEmpty) {
      _topicBloc.add(TopicRequested(chapterIds: [widget.chapterId!]));
    }
  }

  @override
  void dispose() {
    _topicBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _topicBloc,
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
                  ),
                ),

                // Main Content with BLoC
                Positioned(
                  top: 90.h,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SubjectHeaderWidget(
                          title:
                              '${widget.subjectName ?? 'Physics'} - ${widget.chapterName ?? 'Motion'}',
                          subtitle: 'Select a Topic',
                          iconPath: AssetsPath.icPhysics,
                          iconUrl: widget.subjectIcon ?? '',
                        ),
                        SizedBox(height: 20.h),
                        
                        // Dynamic topic list for practice flow
                        if (widget.from == "practice")
                          BlocBuilder<TopicBloc, TopicState>(
                            builder: (context, state) {
                              if (state.isLoading) {
                                return _buildShimmerLoading();
                              }

                              if (state.status == TopicStatus.failure) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20.h),
                                    child: Text(
                                      state.errorMessage ?? 'No topics found',
                                      style: AppTypography.inter14Regular.copyWith(
                                        color: AppColors.white.withOpacity(0.6),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }

                              if (!state.hasData || state.data!.topicList.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20.h),
                                    child: Text(
                                      'No topics found',
                                      style: AppTypography.inter14Regular.copyWith(
                                        color: AppColors.white.withOpacity(0.6),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }

                              final topics = state.data!.topicList;
                              return Column(
                                children: topics.map((topic) {
                                  return ProfileOptionWidget(
                                    title: topic.name,
                                    itemClick: () {
                                      print('Select TopicId: ${topic.tpcId}');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QuestionMcqScreen(
                                            type: "Start Exam",
                                            mcqType: "1", // 1 = Practice MCQ Type
                                            topicId: topic.tpcId,
                                            // topicId: topic.tpcId,
                                            // topicName: topic.name,
                                            // chapterId: widget.chapterId,
                                            // chapterName: widget.chapterName,
                                            // subjectId: widget.subjectId,
                                            // subjectName: widget.subjectName,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          )
                        else
                          // Static topic list for non-practice flow
                          Column(
                            children: [
                              ProfileOptionWidget(
                                title: 'Newton\'s First Law',
                                itemClick: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuestionMcqScreen(
                                        type: "Start Exam",
                                        mcqType: "1", // 1 = Practice MCQ Type
                                        topicId: "1",
                                      ),
                                    ),
                                  );
                                },
                              ),
                              ProfileOptionWidget(
                                title: 'Newton\'s Second Law',
                                itemClick: () {},
                              ),
                              ProfileOptionWidget(
                                title: 'Newton\'s Third Law',
                                itemClick: () {},
                              ),
                              ProfileOptionWidget(
                                title: 'Friction',
                              ),
                            ],
                          ),
                      ],
                    ),
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
    return Column(
      children: List.generate(5, (index) {
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
