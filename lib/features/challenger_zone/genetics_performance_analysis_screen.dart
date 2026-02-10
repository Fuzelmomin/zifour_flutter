import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/custom_app_bar.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

class GeneticsPerformanceAnalysisScreen extends StatefulWidget {
  const GeneticsPerformanceAnalysisScreen({super.key});

  @override
  State<GeneticsPerformanceAnalysisScreen> createState() =>
      _GeneticsPerformanceAnalysisScreenState();
}

class _GeneticsPerformanceAnalysisScreenState
    extends State<GeneticsPerformanceAnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            // App Bar
            Positioned(
              top: 20.h,
              left: 15.w,
              right: 5.w,
              child: CustomAppBar(
                isBack: true,
                title: 'Genetics Performance Analysis',
              ),
            ),

            // Main Content
            Positioned(
              top: 90.h,
              left: 20.w,
              right: 20.w,
              bottom: 0,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subtitle
                    Text(
                      'Your progress in Genetics chapter, analyzed and improved!',
                      style: AppTypography.inter14Regular.copyWith(
                        color: AppColors.white.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(height: 25.h),

                    // Overall Genetics Performance Section
                    _buildSectionHeader('Overall Genetics Performance'),
                    SizedBox(height: 15.h),
                    _buildOverallPerformanceCards(),
                    SizedBox(height: 15.h),
                    _buildAiInsightBox(),
                    SizedBox(height: 30.h),

                    // Accuracy Progress Section
                    // _buildSectionHeader('Your Genetics Accuracy Progress'),
                    // SizedBox(height: 15.h),
                    // _buildAccuracyProgressGraph(),
                    // SizedBox(height: 30.h),

                    // Question Difficulty Breakdown
                    _buildSectionHeader('Question Difficulty Breakdown'),
                    SizedBox(height: 15.h),
                    _buildDifficultyBreakdown(),
                    SizedBox(height: 30.h),

                    // Common Mistakes Section
                    _buildSectionHeader('Common Mistakes'),
                    SizedBox(height: 15.h),
                    _buildCommonMistakesList(),
                    SizedBox(height: 30.h),

                    // AI Suggestion
                    _buildAiSuggestionCard(),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
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

  Widget _buildOverallPerformanceCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Total Attempted',
                value: '56',
                icon: Icons.description,
                iconColor: AppColors.skyColor,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                title: 'Accuracy',
                value: '88%',
                subtitle: 'Correct',
                icon: Icons.check_circle,
                iconColor: AppColors.green,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildStatCard(
          title: 'Speed',
          value: 'Moderate',
          icon: Icons.timer,
          iconColor: AppColors.orange,
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
        child: Row(
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
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: AppTypography.inter20SemiBold.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTypography.inter12Regular.copyWith(
                          color: AppColors.white.withOpacity(0.6),
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(width: 4.w),
                        Text(
                          subtitle,
                          style: AppTypography.inter10Regular.copyWith(
                            color: AppColors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiInsightBox() {
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
                    style: AppTypography.inter12SemiBold.copyWith(
                      color: AppColors.green,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Great work! Your grasp of genetics concepts is solid. Focus on practicing tougher questions for perfection.',
                    style: AppTypography.inter12Regular.copyWith(
                      color: AppColors.green,
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

  Widget _buildAccuracyProgressGraph() {
    final List<_ProgressData> progressData = [
      _ProgressData('Apr 5', 5, 45),
      _ProgressData('Apr 12', 8, 58),
      _ProgressData('Apr 20', 12, 68),
      _ProgressData('Apr 24', 7, 88),
    ];

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
                Text(
                  'Your Genetics Accuracy Progress',
                  style: AppTypography.inter16SemiBold.copyWith(
                    color: AppColors.white,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.green.withOpacity(0.3),
                        AppColors.green.withOpacity(0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.green.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '88%',
                    style: AppTypography.inter14SemiBold.copyWith(
                      color: AppColors.green,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 200.h,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                backgroundColor: Colors.transparent,
                margin: EdgeInsets.zero,
                primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(
                    color: AppColors.white.withOpacity(0.8),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  axisLine: const AxisLine(color: Colors.transparent),
                  majorGridLines: const MajorGridLines(width: 0),
                  labelIntersectAction: AxisLabelIntersectAction.multipleRows,
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 100,
                  interval: 20,
                  labelStyle: TextStyle(
                    color: AppColors.white.withOpacity(0.7),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  axisLine: const AxisLine(color: Colors.transparent),
                  majorGridLines: MajorGridLines(
                    color: AppColors.white.withOpacity(0.2),
                    width: 1,
                    dashArray: [4, 4],
                  ),
                  labelFormat: '{value}%',
                ),
                series: <LineSeries<_ProgressData, String>>[
                  LineSeries<_ProgressData, String>(
                    dataSource: progressData,
                    xValueMapper: (_ProgressData data, _) =>
                        '${data.date}\n${data.questions} Qs',
                    yValueMapper: (_ProgressData data, _) => data.accuracy,
                    color: AppColors.green,
                    width: 3,
                    markerSettings: MarkerSettings(
                      isVisible: true,
                      height: 12,
                      width: 12,
                      shape: DataMarkerType.circle,
                      color: AppColors.green,
                      borderColor: AppColors.white,
                      borderWidth: 2.5,
                    ),
                    dataLabelSettings: DataLabelSettings(
                      isVisible: false,
                    ),
                    animationDuration: 1500,
                  ),
                ],
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: AppColors.darkBlue.withOpacity(0.95),
                  textStyle: TextStyle(
                    color: AppColors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  format: 'point.y%',
                ),
              ),
            ),
            SizedBox(height: 15.h),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendDot(AppColors.green, 'Accuracy'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyBreakdown() {
    final int total = 56;
    final int easy = 22;
    final int medium = 24;
    final int hard = 10;

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
            Text(
              'Total $total',
              style: AppTypography.inter14SemiBold.copyWith(
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 15.h),
            // Horizontal Bar Chart
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.white.withOpacity(0.05),
              ),
              child: Row(
                children: [
                  // Easy
                  if (easy > 0)
                    Flexible(
                      flex: easy,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.green.withOpacity(0.9),
                              AppColors.green.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.r),
                            bottomLeft: Radius.circular(8.r),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$easy Easy',
                            style: AppTypography.inter12SemiBold.copyWith(
                              color: AppColors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  // Medium
                  if (medium > 0)
                    Flexible(
                      flex: medium,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF4CAF50).withOpacity(0.9),
                              const Color(0xFF4CAF50).withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$medium Medium',
                            style: AppTypography.inter12SemiBold.copyWith(
                              color: AppColors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  // Hard
                  if (hard > 0)
                    Flexible(
                      flex: hard,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.darkBlue4.withOpacity(0.9),
                              AppColors.darkBlue4.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8.r),
                            bottomRight: Radius.circular(8.r),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$hard Hard',
                            style: AppTypography.inter12SemiBold.copyWith(
                              color: AppColors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
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

  Widget _buildCommonMistakesList() {
    final List<_MistakeItem> mistakes = [
      _MistakeItem(
        title: 'Gene Interaction',
        description: 'Missed 5 out of 16 Questions on Epistasis & Complementation',
        icon: Icons.warning,
        iconColor: AppColors.orange,
        easyPercent: 95,
        mediumPercent: 87,
        hardPercent: 70,
      ),
      _MistakeItem(
        title: 'Linkage & Crossing Over',
        description: 'Struggled with Linkage Maps: 6/10 Wrong Answers',
        icon: Icons.warning,
        iconColor: AppColors.orange,
        easyPercent: 95,
        mediumPercent: 87,
        hardPercent: 70,
      ),
      _MistakeItem(
        title: 'Pedigree Analysis',
        description: 'Errors in analyzing Pedigree Charts: 3/8 Missed',
        icon: Icons.info,
        iconColor: const Color(0xFF4A90E2),
        easyPercent: 95,
        mediumPercent: 87,
        hardPercent: 70,
      ),
    ];

    return Column(
      children: mistakes.map((mistake) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _buildMistakeCard(mistake),
        );
      }).toList(),
    );
  }

  Widget _buildMistakeCard(_MistakeItem mistake) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    mistake.iconColor.withOpacity(0.3),
                    mistake.iconColor.withOpacity(0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                mistake.icon,
                color: mistake.iconColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mistake.title,
                    style: AppTypography.inter14SemiBold.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    mistake.description,
                    style: AppTypography.inter12Regular.copyWith(
                      color: AppColors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      _buildDifficultyBadge('Easy', mistake.easyPercent, AppColors.green),
                      SizedBox(width: 8.w),
                      _buildDifficultyBadge('Medium', mistake.mediumPercent, const Color(0xFF4CAF50)),
                      SizedBox(width: 8.w),
                      _buildDifficultyBadge('Hard', mistake.hardPercent, AppColors.orange),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(String label, int percent, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
        '$percent% $label',
        style: AppTypography.inter10Regular.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAiSuggestionCard() {
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
                Icons.cloud,
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
                    'AI Suggestion:',
                    style: AppTypography.inter12SemiBold.copyWith(
                      color: suggestionColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Practice more difficult genetics questions to master advanced concepts.',
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

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: AppTypography.inter10Regular.copyWith(
            color: AppColors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

// Data Models
class _ProgressData {
  final String date;
  final int questions;
  final double accuracy;

  _ProgressData(this.date, this.questions, this.accuracy);
}

class _MistakeItem {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final int easyPercent;
  final int mediumPercent;
  final int hardPercent;

  _MistakeItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.easyPercent,
    required this.mediumPercent,
    required this.hardPercent,
  });
}

