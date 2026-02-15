import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/custom_app_bar.dart';
import '../challenger_zone/genetics_performance_analysis_screen.dart';
import 'biology_performance_analysis_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/overall_report_bloc.dart';
import 'repository/overall_report_repository.dart';
import 'model/overall_report_model.dart';
import '../../core/utils/user_preference.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

class AiPerformanceAnalysisScreen extends StatefulWidget {
  const AiPerformanceAnalysisScreen({super.key});

  @override
  State<AiPerformanceAnalysisScreen> createState() => _AiPerformanceAnalysisScreenState();
}

class _AiPerformanceAnalysisScreenState extends State<AiPerformanceAnalysisScreen> {
  String selectedTab = "This Week";
  final List<String> tabs = ["Today", "This Week", "This Month"];

  @override
  void initState() {
    super.initState();
    // Fetch user data and trigger report fetch if needed
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OverallReportBloc()..add(const FetchOverallReport()),
      child: Scaffold(
        backgroundColor: AppColors.darkBlue,
        floatingActionButton: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BiologyPerformanceAnalysisScreen(),
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
        body: Stack(
          children: [
            // Background Image
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
                      title: "AI Performance Analysis",
                    ),
                  ),

                  // Screen Content
                  Expanded(
                    child: BlocBuilder<OverallReportBloc, OverallReportState>(
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
                                  style: AppTypography.inter14Regular.copyWith(color: AppColors.white),
                                ),
                                SizedBox(height: 10.h),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<OverallReportBloc>().add(const FetchOverallReport());
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
                                TweenAnimationBuilder(
                                  tween: Tween<double>(begin: 0, end: 1),
                                  duration: const Duration(milliseconds: 800),
                                  builder: (context, value, child) {
                                    return Opacity(
                                      opacity: value,
                                      child: Transform.translate(
                                        offset: Offset(0, 20 * (1 - value)),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Your path to success in NEET begins here!",
                                    style: AppTypography.inter14Regular.copyWith(
                                      color: AppColors.white.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),

                                // Overall Performance Section
                                _buildSectionHeader("Overall Performance"),
                                SizedBox(height: 15.h),
                                _buildOverallPerformanceCards(report.overall),
                                SizedBox(height: 15.h),
                                _buildAiInsightBox(report.overall?.trend),
                                SizedBox(height: 30.h),

                                // Subject-Wise Analysis Section
                                if (report.subjects != null && report.subjects!.isNotEmpty) ...[
                                  _buildSectionHeader("Subject-Wise Analysis"),
                                  SizedBox(height: 15.h),
                                  ...report.subjects!.map((subj) => Column(
                                        children: [
                                          _buildSubjectAnalysisCard(
                                            title: subj.subjectName,
                                            questions: int.tryParse(subj.totalQuestions) ?? 0,
                                            accuracy: (double.tryParse(subj.accuracy) ?? 0).toInt(),
                                            strongAreas: "Analysis based on ${subj.correct} correct answers", // Placeholder for actual strong areas if not in API
                                            color: subj.subjectName.toLowerCase().contains("bio")
                                                ? Colors.greenAccent
                                                : subj.subjectName.toLowerCase().contains("chem")
                                                    ? Colors.orangeAccent
                                                    : Colors.blueAccent,
                                          ),
                                          SizedBox(height: 15.h),
                                        ],
                                      )),
                                  SizedBox(height: 15.h),
                                ],

                                // Chapter Performance Section
                                if (report.chapters != null && report.chapters!.isNotEmpty) ...[
                                  _buildSectionHeader("Chapter Performance"),
                                  SizedBox(height: 15.h),
                                  _buildChapterPerformanceList(report.chapters!),
                                  SizedBox(height: 30.h),
                                ],

                                // Weak Topic Insights
                                if (report.topics != null && report.topics!.isNotEmpty) ...[
                                  _buildSectionHeader("Weak Topic Insights"),
                                  SizedBox(height: 15.h),
                                  _buildWeakTopicInsights(report.topics!),
                                ],

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
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.inter18SemiBold.copyWith(color: AppColors.white),
    );
  }

  Widget _buildTabSelector() {
    return Column(
      children: [
        Container(
          height: 48.h,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: tabs.map((tab) {
              final isSelected = selectedTab == tab;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedTab = tab),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [
                                Color(0xFFCF078A), // Pink
                                Color(0xFF5E00D8), // Purple
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFFCF078A).withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      tab,
                      style: AppTypography.inter14SemiBold.copyWith(
                        color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 10.h),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today, size: 14.sp, color: Colors.white60),
                SizedBox(width: 8.w),
                Text(
                  "Apr 18, 2024 - Apr 24, 2024",
                  style: AppTypography.inter12Regular.copyWith(color: Colors.white60),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.white60),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverallPerformanceCards(OverallStats? overall) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            "Total Attempted",
            "${overall?.totalQuestions ?? 0}",
            Icons.edit_note,
            const Color(0xFF4A90E2).withOpacity(0.2),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            "Accuracy",
            "${overall?.accuracy ?? 0}%",
            Icons.analytics,
            const Color(0xFF5FC1CA).withOpacity(0.2),
            subtitle: "Correct",
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            "Trend",
            overall?.trend ?? "Stable",
            Icons.trending_up,
            const Color(0xFFF58D30).withOpacity(0.2),
            isTrend: true,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color bgColor, {String? subtitle, bool isTrend = false}) {
    return _glassCard(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: Colors.white, size: 20.sp),
              ),
              if (isTrend)
                Icon(Icons.arrow_outward, color: Colors.greenAccent, size: 16.sp),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: AppTypography.inter10Regular.copyWith(color: Colors.white54),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: AppTypography.inter16SemiBold.copyWith(color: Colors.white),
          ),
          if (subtitle != null)
            Text(
              subtitle,
              style: AppTypography.inter10Regular.copyWith(color: Colors.greenAccent),
            ),
        ],
      ),
    );
  }

  Widget _buildAiInsightBox(String? trend) {
    String insightText = trend == "Improving" 
      ? "Your performance shows positive growth. Keep up the consistent effort!"
      : "Maintain your practice schedule to see more consistent results across all subjects.";
    
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Text(
              "AI Insight",
              style: AppTypography.inter10Medium.copyWith(color: Colors.greenAccent),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              insightText,
              style: AppTypography.inter12Regular.copyWith(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectAnalysisCard({
    required String title,
    required int questions,
    required int accuracy,
    required String strongAreas,
    required Color color,
  }) {
    return _glassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.2),
                  color.withOpacity(0.05),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.r),
                topRight: Radius.circular(18.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4.w,
                      height: 18.h,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      title,
                      style: AppTypography.inter16SemiBold.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                Icon(
                  title == "Biology" ? Icons.science : title == "Chemistry" ? Icons.biotech : Icons.psychology,
                  color: color,
                  size: 20.sp,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSubStat("Questions", "$questions"),
                    _buildSubStat("Accuracy", "$accuracy%"),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Text(
                      "Strong Areas: ",
                      style: AppTypography.inter12SemiBold.copyWith(color: Colors.white54),
                    ),
                    Expanded(
                      child: Text(
                        strongAreas,
                        style: AppTypography.inter12Regular.copyWith(color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.inter10Regular.copyWith(color: Colors.white38),
        ),
        Text(
          value,
          style: AppTypography.inter18Medium.copyWith(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildPerformanceOverview() {
    final List<_ChartData> chartData = [
      _ChartData(0, 40),
      _ChartData(1, 80),
      _ChartData(2, 60),
      _ChartData(3, 55),
      _ChartData(4, 45),
      _ChartData(5, 50),
    ];

    return _glassCard(
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Accuracy Trend",
            style: AppTypography.inter16Medium.copyWith(color: Colors.white),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 150.h,
            child: SfCartesianChart(
              margin: EdgeInsets.zero,
              plotAreaBorderWidth: 0,
              primaryXAxis: const NumericAxis(isVisible: false),
              primaryYAxis: const NumericAxis(isVisible: false),
              series: <CartesianSeries<_ChartData, int>>[
                AreaSeries<_ChartData, int>(
                  dataSource: chartData,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4A90E2).withOpacity(0.3),
                      const Color(0xFF4A90E2).withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendDot(Colors.greenAccent, "High"),
              _buildLegendDot(Colors.redAccent, "Low"),
              _buildLegendDot(Colors.blueAccent, "Strong"),
              _buildLegendDot(Colors.orangeAccent, "Moderate"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: AppTypography.inter10Regular.copyWith(color: Colors.white60),
        ),
      ],
    );
  }

  Widget _buildChapterPerformanceList(List<ChapterAnalysis> chapters) {
    return Column(
      children: chapters.map((chapter) => Column(
        children: [
          _buildChapterItem(
            chapter.chapterName, 
            (double.tryParse(chapter.accuracy) ?? 0).toInt(),
            chapter.level.toLowerCase() == "strong" ? Colors.green : Colors.red
          ),
          SizedBox(height: 10.h),
        ],
      )).toList(),
    );
  }

  Widget _buildChapterItem(String name, int accuracy, Color color) {
    return _glassCard(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.inter14Medium.copyWith(color: Colors.white),
                ),
                SizedBox(height: 4.h),
                Text(
                  "$accuracy% Accuracy",
                  style: AppTypography.inter10Regular.copyWith(color: Colors.white54),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              "$accuracy%",
              style: AppTypography.inter12Bold.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeakTopicInsights(List<TopicAnalysis> topics) {
    return _glassCard(
      padding: EdgeInsets.all(15.w),
      child: Column(
        children: [
          ...topics.map((topic) => Column(
            children: [
              _buildWeakTopicRow(topic.topicName, 0, 0), // Q/Acc not available for specific topics in JSON
              Divider(color: Colors.white10, height: 20.h),
            ],
          )),
          _buildWeakTopicRow("Performance Review", 0, 0, isPotential: true),
        ],
      ),
    );
  }

  Widget _buildWeakTopicRow(String title, int q, int acc, {bool isPotential = false}) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: isPotential ? const Color(0xFF4A90E2) : Colors.blueAccent,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isPotential ? "22 Marks Potential" : title,
                style: AppTypography.inter14Regular.copyWith(
                  color: isPotential ? const Color(0xFF4A90E2) : Colors.white70,
                  fontWeight: isPotential ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (!isPotential)
                Text(
                  "$q Questions, $acc% Accuracy",
                  style: AppTypography.inter10Regular.copyWith(color: Colors.white38),
                ),
            ],
          ),
        ),
        if (!isPotential) Icon(Icons.arrow_forward_ios, size: 12.sp, color: Colors.white24),
      ],
    );
  }

  Widget _glassCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding ?? EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.white10),
          ),
          child: child,
        ),
      ),
    );
  }

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
            SizedBox(height: 20.h),
            _shimmerRect(width: 200.w, height: 14.h), // Path to success text
            SizedBox(height: 30.h),
            _shimmerRect(width: 150.w, height: 20.h), // Overall Performance header
            SizedBox(height: 15.h),
            Row(
              children: [
                Expanded(child: _shimmerRect(height: 100.h)),
                SizedBox(width: 12.w),
                Expanded(child: _shimmerRect(height: 100.h)),
                SizedBox(width: 12.w),
                Expanded(child: _shimmerRect(height: 100.h)),
              ],
            ),
            SizedBox(height: 15.h),
            _shimmerRect(height: 60.h, borderRadius: 12.r), // AI Insight box
            SizedBox(height: 30.h),
            _shimmerRect(width: 150.w, height: 20.h), // Subject-Wise header
            SizedBox(height: 15.h),
            _shimmerRect(height: 120.h, borderRadius: 18.r),
            SizedBox(height: 15.h),
            _shimmerRect(height: 120.h, borderRadius: 18.r),
            SizedBox(height: 30.h),
            _shimmerRect(width: 150.w, height: 20.h), // Chapter Performance header
            SizedBox(height: 15.h),
            _shimmerRect(height: 70.h, borderRadius: 18.r),
            SizedBox(height: 10.h),
            _shimmerRect(height: 70.h, borderRadius: 18.r),
          ],
        ),
      ),
    );
  }

  Widget _shimmerRect({double? width, required double height, double? borderRadius}) {
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

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final double y;
}
