import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/custom_app_bar.dart';

import 'biology_performance_analysis_screen.dart';
import 'genetics_performance_analysis_screen.dart';

class AiPerformanceAnalysisScreen extends StatefulWidget {
  const AiPerformanceAnalysisScreen({super.key});

  @override
  State<AiPerformanceAnalysisScreen> createState() => _AiPerformanceAnalysisScreenState();
}

class _AiPerformanceAnalysisScreenState extends State<AiPerformanceAnalysisScreen> {
  String selectedTab = "This Week";
  final List<String> tabs = ["Today", "This Week", "This Month"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      floatingActionButton: InkWell(
        onTap: (){
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
                  child: SingleChildScrollView(
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
                        
                        // Tab Selector & Date Range
                        _buildTabSelector(),
                        SizedBox(height: 25.h),
                        
                        // Overall Performance Section
                        _buildSectionHeader("Overall Performance"),
                        SizedBox(height: 15.h),
                        _buildOverallPerformanceCards(),
                        SizedBox(height: 15.h),
                        _buildAiInsightBox(),
                        SizedBox(height: 30.h),
                        
                        // Subject-Wise Analysis Section
                        _buildSectionHeader("Subject-Wise Analysis"),
                        SizedBox(height: 15.h),
                        _buildSubjectAnalysisCard(
                          title: "Biology",
                          questions: 420,
                          accuracy: 78,
                          strongAreas: "Genetics, Ecology",
                          color: Colors.greenAccent,
                        ),
                        SizedBox(height: 15.h),
                        _buildSubjectAnalysisCard(
                          title: "Chemistry",
                          questions: 180,
                          accuracy: 67,
                          strongAreas: "Organic, Thermodynamics",
                          color: Colors.orangeAccent,
                        ),
                        SizedBox(height: 15.h),
                        _buildSubjectAnalysisCard(
                          title: "Physics",
                          questions: 140,
                          accuracy: 75,
                          strongAreas: "Optics, Modern Physics",
                          color: Colors.blueAccent,
                        ),
                        SizedBox(height: 30.h),
                        
                        // Performance Overview Graph
                        // _buildPerformanceOverview(),
                        // SizedBox(height: 30.h),
                        
                        // Chapter Performance Section
                        _buildSectionHeader("Chapter Performance"),
                        SizedBox(height: 15.h),
                        _buildChapterPerformanceList(),
                        SizedBox(height: 30.h),
                        
                        // Weak Topic Insights
                        _buildSectionHeader("Weak Topic Insights"),
                        SizedBox(height: 15.h),
                        _buildWeakTopicInsights(),
                        
                        SizedBox(height: 50.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildOverallPerformanceCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            "Total Attempted",
            "1,200",
            Icons.edit_note,
            const Color(0xFF4A90E2).withOpacity(0.2),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            "Accuracy",
            "81%",
            Icons.analytics,
            const Color(0xFF5FC1CA).withOpacity(0.2),
            subtitle: "Correct",
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            "Trend",
            "Improving",
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

  Widget _buildAiInsightBox() {
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
              "Your performance shows strong consistency, but your Biology speed needs improvement.",
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

  Widget _buildChapterPerformanceList() {
    return Column(
      children: [
        _buildChapterItem("Genetics", 88, Colors.green),
        SizedBox(height: 10.h),
        _buildChapterItem("Human Physiology", 56, Colors.red),
        SizedBox(height: 10.h),
        _buildChapterItem("Thermodynamics", 64, Colors.orange),
      ],
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

  Widget _buildWeakTopicInsights() {
    return _glassCard(
      padding: EdgeInsets.all(15.w),
      child: Column(
        children: [
          _buildWeakTopicRow("Respiration", 42, 48),
          Divider(color: Colors.white10, height: 20.h),
          _buildWeakTopicRow("Excretion", 35, 25),
          Divider(color: Colors.white10, height: 20.h),
          _buildWeakTopicRow("Neural Control", 28, 50),
          Divider(color: Colors.white10, height: 20.h),
          _buildWeakTopicRow("Marks Potential", 0, 0, isPotential: true),
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
}

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final double y;
}
