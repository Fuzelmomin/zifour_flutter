import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'bloc/subject_wise_report_bloc.dart';
import 'model/subject_wise_report_model.dart';

class BiologyPerformanceAnalysisScreen extends StatefulWidget {
  final String subjectId;
  final String subjectName;

  const BiologyPerformanceAnalysisScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<BiologyPerformanceAnalysisScreen> createState() =>
      _BiologyPerformanceAnalysisScreenState();
}

class _BiologyPerformanceAnalysisScreenState
    extends State<BiologyPerformanceAnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubjectWiseReportBloc()
        ..add(FetchSubjectWiseReport(subjectId: widget.subjectId)),
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
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                      child: CustomAppBar(
                        isBack: true,
                        title: '${widget.subjectName} Performance',
                      ),
                    ),

                    // Screen Content
                    Expanded(
                      child: BlocBuilder<SubjectWiseReportBloc, SubjectWiseReportState>(
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
                                      context.read<SubjectWiseReportBloc>().add(
                                            FetchSubjectWiseReport(
                                                subjectId: widget.subjectId),
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
                                  // Subtitle
                                  Text(
                                    'Track your strengths and areas for improvement in ${widget.subjectName}!',
                                    style: AppTypography.inter14Regular.copyWith(
                                      color: AppColors.white.withOpacity(0.6),
                                    ),
                                  ),
                                  SizedBox(height: 25.h),

                                  // Overall Performance Section
                                  _buildSectionHeader(
                                      'Overall ${widget.subjectName} Performance'),
                                  SizedBox(height: 15.h),
                                  _buildOverallPerformanceCards(
                                      report.overallPerformance),
                                  SizedBox(height: 15.h),
                                  _buildAiInsightBox(report.aiInsight),
                                  SizedBox(height: 30.h),

                                  // Topic-Wise Performance Section
                                  if (report.topicWisePerformance != null &&
                                      report.topicWisePerformance!.isNotEmpty) ...[
                                    _buildSectionHeader('Topic-Wise Performance'),
                                    SizedBox(height: 15.h),
                                    _buildTopicPerformanceCards(
                                        report.topicWisePerformance!),
                                    SizedBox(height: 30.h),
                                  ],

                                  // AI Suggestion
                                  if (report.aiSuggestion != null &&
                                      report.aiSuggestion!.isNotEmpty)
                                    _buildAiSuggestionCard(report.aiSuggestion!),
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
      style: AppTypography.inter18SemiBold.copyWith(
        color: AppColors.white,
      ),
    );
  }

  Widget _buildOverallPerformanceCards(SubjectOverallPerformance? overall) {
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
                title: 'Accuracy',
                value: '${overall?.accuracy ?? 0}%',
                subtitle: 'Correct',
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
                title: 'Speed',
                value: overall?.speed ?? 'N/A',
                icon: Icons.timer,
                iconColor: AppColors.orange,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                title: 'Trend',
                value: overall?.trend ?? 'Stable',
                icon: Icons.trending_up,
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
    String? subtitle,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: AppTypography.inter10Regular.copyWith(
                      color: AppColors.white.withOpacity(0.6),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              value,
              style: AppTypography.inter20SemiBold.copyWith(
                color: AppColors.white,
              ),
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

  Widget _buildAiInsightBox(String? insightText) {
    final displayText = insightText ?? 'No AI insight available.';
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
              child: Text(
                displayText,
                style: AppTypography.inter12Regular.copyWith(
                  color: AppColors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicPerformanceCards(List<SubjectTopicPerformance> topics) {
    final limitedTopics = topics.take(20).toList();
    return Column(
      children: limitedTopics.map((topic) {
        final accuracy = double.tryParse(topic.accuracy) ?? 0;
        Color cardColor;
        String label;
        if (accuracy >= 75) {
          cardColor = AppColors.green;
          label = 'Strong';
        } else if (accuracy >= 50) {
          cardColor = AppColors.orange;
          label = 'Moderate';
        } else {
          cardColor = Colors.redAccent;
          label = 'Weak';
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _buildTopicCard(
            name: topic.topicName,
            accuracy: accuracy.toInt(),
            label: label,
            totalQuestions: topic.totalQuestions,
            correct: topic.correct,
            color: cardColor,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopicCard({
    required String name,
    required int accuracy,
    required String label,
    required String totalQuestions,
    required String correct,
    required Color color,
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
        child: Row(
          children: [
            // Icon Circle
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.3),
                    color.withOpacity(0.15),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  '$accuracy%',
                  style: AppTypography.inter12SemiBold.copyWith(
                    color: color,
                  ),
                ),
              ),
            ),
            SizedBox(width: 15.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: AppTypography.inter14SemiBold.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              color.withOpacity(0.3),
                              color.withOpacity(0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: color.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          label,
                          style: AppTypography.inter10Regular.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '$totalQuestions Questions · $correct Correct',
                    style: AppTypography.inter12Regular.copyWith(
                      color: AppColors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                    style: AppTypography.inter14SemiBold.copyWith(
                      color: suggestionColor,
                    ),
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
            _shimmerRect(width: 250.w, height: 14.h),
            SizedBox(height: 25.h),
            _shimmerRect(width: 200.w, height: 20.h), // Section header
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
            SizedBox(height: 15.h),
            _shimmerRect(height: 60.h, borderRadius: 12.r), // AI Insight
            SizedBox(height: 30.h),
            _shimmerRect(width: 180.w, height: 20.h), // Topic header
            SizedBox(height: 15.h),
            _shimmerRect(height: 80.h, borderRadius: 12.r),
            SizedBox(height: 12.h),
            _shimmerRect(height: 80.h, borderRadius: 12.r),
            SizedBox(height: 12.h),
            _shimmerRect(height: 80.h, borderRadius: 12.r),
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
