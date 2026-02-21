import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'bloc/topic_wise_report_bloc.dart';
import 'model/topic_wise_report_model.dart';

class AiBasedPerformanceScreen extends StatefulWidget {
  final String topicId;
  final String topicName;

  const AiBasedPerformanceScreen({
    super.key,
    required this.topicId,
    required this.topicName,
  });

  @override
  State<AiBasedPerformanceScreen> createState() =>
      _AiBasedPerformanceScreenState();
}

class _AiBasedPerformanceScreenState extends State<AiBasedPerformanceScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TopicWiseReportBloc()
        ..add(FetchTopicWiseReport(topicId: widget.topicId)),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.darkBlue,
          child: Stack(
            children: [
              // Background Decoration
              Positioned.fill(
                child: Image.asset(
                  AssetsPath.signupBgImg,
                  fit: BoxFit.cover,
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    // App Bar
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 10.h),
                      child: CustomAppBar(
                        isBack: true,
                        title: 'Topic Performance',
                      ),
                    ),

                    // Screen Content
                    Expanded(
                      child: BlocBuilder<TopicWiseReportBloc,
                          TopicWiseReportState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return _buildShimmerLoading();
                          }

                          if (state.isFailure) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    state.errorMessage ?? "An error occurred",
                                    style: AppTypography.inter14Regular
                                        .copyWith(color: AppColors.white),
                                  ),
                                  SizedBox(height: 10.h),
                                  ElevatedButton(
                                    onPressed: () {
                                      context.read<TopicWiseReportBloc>().add(
                                            FetchTopicWiseReport(
                                                topicId: widget.topicId),
                                          );
                                    },
                                    child: const Text("Retry"),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (state.isSuccess && state.data != null) {
                            final report = state.data!;
                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Topic Name
                                  Text(
                                    report.topicName ?? widget.topicName,
                                    style: AppTypography.inter18SemiBold
                                        .copyWith(color: AppColors.white),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Detailed performance analysis for this topic',
                                    style:
                                        AppTypography.inter14Regular.copyWith(
                                      color:
                                          AppColors.white.withOpacity(0.6),
                                    ),
                                  ),
                                  SizedBox(height: 25.h),

                                  // Overall Performance Section
                                  _buildSectionHeader('Overall Performance'),
                                  SizedBox(height: 15.h),
                                  _buildOverallPerformanceCards(
                                      report.overallPerformance),
                                  SizedBox(height: 30.h),

                                  // AI Insight
                                  if (report.aiInsight != null &&
                                      report.aiInsight!.isNotEmpty) ...[
                                    _buildAiInsightBox(report.aiInsight!),
                                    SizedBox(height: 30.h),
                                  ],

                                  // Difficulty Breakdown
                                  if (report.difficultyBreakdown !=
                                      null) ...[
                                    _buildSectionHeader(
                                        'Difficulty Breakdown'),
                                    SizedBox(height: 15.h),
                                    _buildDifficultyBreakdown(
                                        report.difficultyBreakdown!),
                                    SizedBox(height: 30.h),
                                  ],

                                  // Common Mistakes
                                  if (report.commonMistakes != null &&
                                      report.commonMistakes!
                                          .isNotEmpty) ...[
                                    _buildSectionHeader('Common Mistakes'),
                                    SizedBox(height: 15.h),
                                    _buildCommonMistakes(
                                        report.commonMistakes!),
                                    SizedBox(height: 30.h),
                                  ],

                                  // AI Suggestion
                                  if (report.aiSuggestion != null &&
                                      report.aiSuggestion!.isNotEmpty)
                                    _buildAiSuggestionCard(
                                        report.aiSuggestion!),
                                  SizedBox(height: 50.h),
                                ],
                              ),
                            );
                          }

                          return const SizedBox.shrink();
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
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.inter18SemiBold.copyWith(color: AppColors.white),
    );
  }

  Widget _buildOverallPerformanceCards(TopicOverallPerformance? overall) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Total Attempted',
                value: '${overall?.totalAttempted ?? 0}',
                icon: Icons.description,
                iconColor: AppColors.skyColor,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                title: 'Correct',
                value: '${overall?.correct ?? 0}',
                icon: Icons.check_circle,
                iconColor: AppColors.green,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Wrong',
                value: '${overall?.wrong ?? 0}',
                icon: Icons.cancel,
                iconColor: Colors.redAccent,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                title: 'Accuracy',
                value: '${overall?.accuracy ?? 0}%',
                icon: Icons.analytics,
                iconColor: const Color(0xFF5FC1CA),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Marks',
                value: '${overall?.marks ?? 0}',
                icon: Icons.star,
                iconColor: AppColors.orange,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                title: 'Speed',
                value: overall?.speed ?? 'N/A',
                icon: Icons.timer,
                iconColor: const Color(0xFF4A90E2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    iconColor.withOpacity(0.3),
                    iconColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              value,
              style: AppTypography.inter20SemiBold
                  .copyWith(color: AppColors.white),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: AppTypography.inter12Regular.copyWith(
                color: AppColors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiInsightBox(String insightText) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.green.withOpacity(0.25),
            AppColors.green.withOpacity(0.15),
          ],
        ),
        border: Border.all(
          color: AppColors.green.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.green.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lightbulb,
                color: AppColors.green,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Insight',
                    style: AppTypography.inter10Regular.copyWith(
                      color: AppColors.green.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    insightText,
                    style: AppTypography.inter12Regular
                        .copyWith(color: AppColors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyBreakdown(DifficultyBreakdown breakdown) {
    final total = breakdown.easy + breakdown.medium + breakdown.hard;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          children: [
            _buildDifficultyRow('Easy', breakdown.easy, AppColors.green, total),
            SizedBox(height: 12.h),
            _buildDifficultyRow(
                'Medium', breakdown.medium, AppColors.orange, total),
            SizedBox(height: 12.h),
            _buildDifficultyRow(
                'Hard', breakdown.hard, Colors.redAccent, total),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyRow(
      String label, int count, Color color, int total) {
    final fraction = total > 0 ? count / total : 0.0;
    return Row(
      children: [
        SizedBox(
          width: 60.w,
          child: Text(
            label,
            style: AppTypography.inter12SemiBold.copyWith(color: color),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: fraction,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8.h,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          '$count',
          style: AppTypography.inter12SemiBold
              .copyWith(color: AppColors.white),
        ),
      ],
    );
  }

  Widget _buildCommonMistakes(List<String> mistakes) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          children: mistakes
              .map((mistake) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 5.h),
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            mistake,
                            style: AppTypography.inter12Regular
                                .copyWith(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildAiSuggestionCard(String suggestion) {
    final suggestionColor = const Color(0xFF4A90E2);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            suggestionColor.withOpacity(0.25),
            suggestionColor.withOpacity(0.15),
          ],
        ),
        border: Border.all(
          color: suggestionColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    suggestionColor.withOpacity(0.3),
                    suggestionColor.withOpacity(0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.auto_awesome,
                color: suggestionColor,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Suggestion',
                    style: AppTypography.inter10Regular.copyWith(
                      color: suggestionColor.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    suggestion,
                    style: AppTypography.inter14SemiBold
                        .copyWith(color: suggestionColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Shimmer Loading
  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.05),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            _shimmerRect(width: 200.w, height: 20.h), // Topic name
            SizedBox(height: 8.h),
            _shimmerRect(width: 280.w, height: 14.h), // Subtitle
            SizedBox(height: 25.h),
            _shimmerRect(width: 180.w, height: 20.h), // Section header
            SizedBox(height: 15.h),
            Row(
              children: [
                Expanded(child: _shimmerRect(height: 120.h)),
                SizedBox(width: 12.w),
                Expanded(child: _shimmerRect(height: 120.h)),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(child: _shimmerRect(height: 120.h)),
                SizedBox(width: 12.w),
                Expanded(child: _shimmerRect(height: 120.h)),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(child: _shimmerRect(height: 120.h)),
                SizedBox(width: 12.w),
                Expanded(child: _shimmerRect(height: 120.h)),
              ],
            ),
            SizedBox(height: 30.h),
            _shimmerRect(height: 70.h, borderRadius: 12.r), // AI Insight
            SizedBox(height: 30.h),
            _shimmerRect(width: 180.w, height: 20.h), // Difficulty header
            SizedBox(height: 15.h),
            _shimmerRect(height: 100.h, borderRadius: 12.r), // Difficulty
            SizedBox(height: 30.h),
            _shimmerRect(height: 70.h, borderRadius: 12.r), // AI Suggestion
          ],
        ),
      ),
    );
  }

  Widget _shimmerRect(
      {double? width, required double height, double? borderRadius}) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
      ),
    );
  }
}
