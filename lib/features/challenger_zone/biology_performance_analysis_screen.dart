import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/custom_app_bar.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/challenger_zone/genetics_performance_analysis_screen.dart';

import 'ai_performance_analysis_screen.dart';

class BiologyPerformanceAnalysisScreen extends StatefulWidget {
  const BiologyPerformanceAnalysisScreen({super.key});

  @override
  State<BiologyPerformanceAnalysisScreen> createState() =>
      _BiologyPerformanceAnalysisScreenState();
}

class _BiologyPerformanceAnalysisScreenState
    extends State<BiologyPerformanceAnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GeneticsPerformanceAnalysisScreen(),
            ),
          );
        },
        child: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: AppColors.pinkColor.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.arrow_right_alt,
              color: AppColors.white,
            ),
          ),
        ),
      ),
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
                title: 'Biology Performance Analysis',
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
                      'Track your strengths and areas for improvement in Biology!',
                      style: AppTypography.inter14Regular.copyWith(
                        color: AppColors.white.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(height: 25.h),

                    // Overall Biology Performance Section
                    _buildSectionHeader('Overall Biology Performance'),
                    SizedBox(height: 15.h),
                    _buildOverallPerformanceCards(),
                    SizedBox(height: 15.h),
                    _buildAiInsightBox(),
                    SizedBox(height: 30.h),

                    // // Topic-Wise Performance Section
                    // _buildSectionHeader('Topic-Wise Performance'),
                    // SizedBox(height: 15.h),
                    // _buildTopicWiseGraph(),
                    // SizedBox(height: 15.h),
                    _buildTopicPerformanceCards(),
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
                value: '620',
                icon: Icons.description,
                iconColor: AppColors.skyColor,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                title: 'Accuracy',
                value: '75%',
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
                value: 'Moderate',
                icon: Icons.timer,
                iconColor: AppColors.orange,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                title: 'Trend',
                value: 'Improving',
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
              child: Text(
                'Your plan is targeted to improve weaker areas. Focus on these first for maximum score.',
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

  Widget _buildTopicWiseGraph() {
    // Real data structure - can be replaced with API data
    final List<TopicPerformanceData> chartData = [
      TopicPerformanceData('Cell Structure', 92, PerformanceLevel.strong),
      TopicPerformanceData('Genetics', 88, PerformanceLevel.strong),
      TopicPerformanceData('Ecology', 82, PerformanceLevel.strong),
      TopicPerformanceData('Respiration', 48, PerformanceLevel.weak),
      TopicPerformanceData('Photosynthesis', 74, PerformanceLevel.moderate),
      TopicPerformanceData('Excretion', 52, PerformanceLevel.weak),
      TopicPerformanceData('Molecular Basis', 68, PerformanceLevel.moderate),
      TopicPerformanceData('Neural Control', 50, PerformanceLevel.weak),
      TopicPerformanceData('Human Reproduction', 91, PerformanceLevel.strong),
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
            SizedBox(
              height: 300.h,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                backgroundColor: Colors.transparent,
                margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
                primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(
                    color: AppColors.white.withOpacity(0.9),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  axisLine: const AxisLine(color: Colors.transparent),
                  majorGridLines: const MajorGridLines(width: 0),
                  labelRotation: -45,
                  labelIntersectAction: AxisLabelIntersectAction.multipleRows,
                  interval: 1,
                  labelPosition: ChartDataLabelPosition.outside,
                  maximumLabelWidth: 80.w,
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 100,
                  interval: 20,
                  labelStyle: TextStyle(
                    color: AppColors.white.withOpacity(0.8),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  axisLine: const AxisLine(color: Colors.transparent),
                  majorGridLines: MajorGridLines(
                    color: AppColors.white.withOpacity(0.25),
                    width: 1,
                    dashArray: [4, 4],
                  ),
                  minorGridLines: MinorGridLines(
                    color: AppColors.white.withOpacity(0.1),
                    width: 1,
                  ),
                  majorTickLines: const MajorTickLines(
                    color: Colors.transparent,
                  ),
                  labelFormat: '{value}%',
                ),
                series: <LineSeries<TopicPerformanceData, String>>[
                  LineSeries<TopicPerformanceData, String>(
                    dataSource: chartData,
                    xValueMapper: (TopicPerformanceData data, _) => data.topic,
                    yValueMapper: (TopicPerformanceData data, _) => data.percentage,
                    color: AppColors.pinkColor.withOpacity(0.7),
                    width: 3,
                    pointColorMapper: (TopicPerformanceData data, _) {
                      switch (data.level) {
                        case PerformanceLevel.strong:
                          return AppColors.green;
                        case PerformanceLevel.moderate:
                          return AppColors.red;
                        case PerformanceLevel.weak:
                          return AppColors.orange;
                      }
                    },
                    markerSettings: MarkerSettings(
                      isVisible: true,
                      height: 14,
                      width: 14,
                      shape: DataMarkerType.circle,
                      borderColor: AppColors.white,
                      borderWidth: 3,
                    ),
                    dataLabelSettings: DataLabelSettings(
                      isVisible: false,
                    ),
                    animationDuration: 1500,
                    animationDelay: 0,
                    enableTooltip: true,
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
                  borderColor: AppColors.white.withOpacity(0.3),
                  borderWidth: 1,
                  format: 'point.y%',
                ),
              ),
            ),
            SizedBox(height: 15.h),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendDot(AppColors.green, 'Strong'),
                SizedBox(width: 15.w),
                _buildLegendDot(AppColors.red, 'Moderate'),
                SizedBox(width: 15.w),
                _buildLegendDot(AppColors.orange, 'Weak'),
              ],
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

  Widget _buildTopicPerformanceCards() {
    final List<_TopicPerformance> topics = [
      _TopicPerformance(
        name: 'Cell Structure',
        percentage: 92,
        label: 'Strong',
        description: 'Excellent understanding of cellular organelles!',
        iconText: '50',
        color: AppColors.green,
      ),
      _TopicPerformance(
        name: 'Genetics',
        percentage: 88,
        label: 'Strong',
        description: 'Solid grasp of genetics concepts!',
        iconText: '2825',
        color: AppColors.green,
      ),
      _TopicPerformance(
        name: 'Ecology',
        percentage: 82,
        label: 'Strong',
        description: 'Consistently high performance in ecological concepts.',
        iconText: '53',
        color: AppColors.green,
      ),
      _TopicPerformance(
        name: 'Respiration',
        percentage: 48,
        label: 'Weak',
        description: 'Focus on gas exchange and cellular respiration processes.',
        iconText: '6896',
        color: AppColors.orange,
      ),
      _TopicPerformance(
        name: 'Photosynthesis',
        percentage: 74,
        label: 'Moderate',
        description: 'Medium score; review the light-dependent reactions.',
        iconText: 'B',
        color: AppColors.red,
      ),
      _TopicPerformance(
        name: 'Excretion',
        percentage: 52,
        label: 'Weak',
        description: 'Improvement needed in the function of the kidney.',
        iconText: '53',
        color: AppColors.orange,
      ),
      _TopicPerformance(
        name: 'Molecular Basis',
        percentage: 68,
        label: 'Moderate',
        description: 'Average performance on molecular genetics.',
        iconText: '3019',
        color: AppColors.red,
      ),
      _TopicPerformance(
        name: 'Neural Control',
        percentage: 50,
        label: 'Weak',
        description: 'Struggles in neural signals and synaptic transmission.',
        iconText: 'BSB',
        color: AppColors.orange,
      ),
      _TopicPerformance(
        name: 'Human Reproduction',
        percentage: 91,
        label: 'Strong',
        description: 'Strong understanding of reproductive processes.',
        iconText: '33',
        color: AppColors.green,
      ),
      _TopicPerformance(
        name: 'Evolution',
        percentage: 85,
        label: 'Strong',
        description: 'Excellent grasp on mechanisms of evolution.',
        iconText: '',
        color: AppColors.green,
      ),
    ];

    return Column(
      children: topics.map((topic) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _buildTopicCard(topic),
        );
      }).toList(),
    );
  }

  Widget _buildTopicCard(_TopicPerformance topic) {
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
            // Icon/Number Circle with gradient
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    topic.color.withOpacity(0.3),
                    topic.color.withOpacity(0.15),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: topic.color.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  topic.iconText,
                  style: AppTypography.inter12SemiBold.copyWith(
                    color: topic.color,
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
                          topic.name,
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
                              topic.color.withOpacity(0.3),
                              topic.color.withOpacity(0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: topic.color.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          topic.label,
                          style: AppTypography.inter10Regular.copyWith(
                            color: topic.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${topic.percentage}% Questions',
                    style: AppTypography.inter12Regular.copyWith(
                      color: AppColors.white.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    topic.description,
                    style: AppTypography.inter12Regular.copyWith(
                      color: AppColors.white.withOpacity(0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
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
                    'Start focusing on Respiration and Excretion to boost your score: +16 Marks Potential',
                    style: AppTypography.inter14SemiBold.copyWith(
                      color: suggestionColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    suggestionColor.withOpacity(0.3),
                    suggestionColor.withOpacity(0.15),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: suggestionColor.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  '88',
                  style: AppTypography.inter12SemiBold.copyWith(
                    color: suggestionColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data Models - Real structure for API integration
enum PerformanceLevel { strong, moderate, weak }

class TopicPerformanceData {
  final String topic;
  final double percentage;
  final PerformanceLevel level;

  TopicPerformanceData(this.topic, this.percentage, this.level);

  // Helper method to get color based on level
  Color get color {
    switch (level) {
      case PerformanceLevel.strong:
        return AppColors.green;
      case PerformanceLevel.moderate:
        return AppColors.red;
      case PerformanceLevel.weak:
        return AppColors.orange;
    }
  }

  // Helper method to get label
  String get label {
    switch (level) {
      case PerformanceLevel.strong:
        return 'Strong';
      case PerformanceLevel.moderate:
        return 'Moderate';
      case PerformanceLevel.weak:
        return 'Weak';
    }
  }

  // Factory method to create from API response
  factory TopicPerformanceData.fromJson(Map<String, dynamic> json) {
    final percentage = (json['percentage'] as num).toDouble();
    PerformanceLevel level;
    if (percentage >= 75) {
      level = PerformanceLevel.strong;
    } else if (percentage >= 60) {
      level = PerformanceLevel.moderate;
    } else {
      level = PerformanceLevel.weak;
    }

    return TopicPerformanceData(
      json['topic_name'] as String,
      percentage,
      level,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topic_name': topic,
      'percentage': percentage,
      'level': level.toString(),
    };
  }
}

class _TopicPerformance {
  final String name;
  final int percentage;
  final String label;
  final String description;
  final String iconText;
  final Color color;

  _TopicPerformance({
    required this.name,
    required this.percentage,
    required this.label,
    required this.description,
    required this.iconText,
    required this.color,
  });

  // Factory method to create from TopicPerformanceData
  factory _TopicPerformance.fromTopicData(
    TopicPerformanceData data,
    String description,
    String iconText,
  ) {
    return _TopicPerformance(
      name: data.topic,
      percentage: data.percentage.toInt(),
      label: data.label,
      description: description,
      iconText: iconText,
      color: data.color,
    );
  }
}

// Main data model for the entire screen - can be replaced with API response
class BiologyPerformanceData {
  final int totalAttempted;
  final double accuracy;
  final String speed;
  final String trend;
  final String aiInsight;
  final List<TopicPerformanceData> topics;
  final String aiSuggestion;
  final int potentialMarks;

  BiologyPerformanceData({
    required this.totalAttempted,
    required this.accuracy,
    required this.speed,
    required this.trend,
    required this.aiInsight,
    required this.topics,
    required this.aiSuggestion,
    required this.potentialMarks,
  });

  // Factory method to create from API response
  factory BiologyPerformanceData.fromJson(Map<String, dynamic> json) {
    return BiologyPerformanceData(
      totalAttempted: json['total_attempted'] as int,
      accuracy: (json['accuracy'] as num).toDouble(),
      speed: json['speed'] as String,
      trend: json['trend'] as String,
      aiInsight: json['ai_insight'] as String,
      topics: (json['topics'] as List)
          .map((t) => TopicPerformanceData.fromJson(t as Map<String, dynamic>))
          .toList(),
      aiSuggestion: json['ai_suggestion'] as String,
      potentialMarks: json['potential_marks'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_attempted': totalAttempted,
      'accuracy': accuracy,
      'speed': speed,
      'trend': trend,
      'ai_insight': aiInsight,
      'topics': topics.map((t) => t.toJson()).toList(),
      'ai_suggestion': aiSuggestion,
      'potential_marks': potentialMarks,
    };
  }
}

