import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/info_row.dart';
import '../../l10n/app_localizations.dart';

class TestAnalysisScreen extends StatefulWidget {
  const TestAnalysisScreen({super.key});

  @override
  State<TestAnalysisScreen> createState() => _TestAnalysisScreenState();
}

class _TestAnalysisScreenState extends State<TestAnalysisScreen> {

  final List<_ChartData> chartData = [
    _ChartData('Physics', 200),
    _ChartData('Chemistry', 160),
    _ChartData('Biology', 180),
    _ChartData('', 0),
    _ChartData('', 0),
  ];

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  top: 0.h,
                  left: 15.w,
                  right: 5.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: 'Test Analysis',
                  )),
              // Main Content with BLoC
              Positioned(
                top: 70.h,
                left: 20.w,
                right: 20.w,
                bottom: 0,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),

                      /// Score Card
                      _glassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Full Syllabus Neet Test 01",
                              style: AppTypography.inter16Medium,
                            ),
                            SizedBox(height: 4),
                            Text(
                              "15th September | 3 Hours",
                              style: AppTypography.inter12SemiBold.copyWith(
                                  color: AppColors.orange
                              ),
                            ),
                            SizedBox(height: 16),

                            Row(
                              spacing: 15.w,
                              children: [
                                Expanded(
                                  child: InfoRow(title: "TOTAL SCORE", value: "504 / 720"),
                                ),
                                Expanded(
                                  child: InfoRow(title: "ALL INDIA RANK", value: "1200"),
                                )
                              ],
                            ),

                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              spacing: 15.w,
                              children: [
                                Expanded(
                                  child: InfoRow(title: "PERCENTILE", value: "89%"),
                                ),
                                Expanded(
                                  child: InfoRow(title: "ACCURACY", value: "76%"),
                                )
                              ],
                            ),
                            SizedBox(height: 10.h,),
                            Container(
                                width: double.infinity,
                                child: InfoRow(title: "Average Time (Per Question)".toUpperCase(), value: "1Minutes 20S")),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      // Chart card
                      SignupFieldBox(

                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Performance",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              height: 200,
                              child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(
                                  labelStyle: const TextStyle(color: Colors.white70),
                                  axisLine: const AxisLine(color: Colors.transparent),
                                  majorGridLines: MajorGridLines(width: 0),
                                ),
                                primaryYAxis: NumericAxis(
                                  minimum: 0,
                                  maximum: 220,
                                  interval: 40,
                                  labelStyle: const TextStyle(color: Colors.white70),
                                  axisLine: const AxisLine(color: Colors.transparent),
                                  majorGridLines: const MajorGridLines(color: Colors.white24),
                                ),
                                series: <ColumnSeries<_ChartData, String>>[
                                  ColumnSeries<_ChartData, String>(
                                    dataSource: chartData,
                                    xValueMapper: (_ChartData data, _) => data.subject,
                                    yValueMapper: (_ChartData data, _) => data.value,
                                    pointColorMapper: (_ChartData data, _) {
                                      switch (data.subject) {
                                        case 'Physics':
                                          return Colors.orangeAccent;
                                        case 'Chemistry':
                                          return Colors.pinkAccent;
                                        case 'Biology':
                                          return Colors.greenAccent;
                                        default:
                                          return Colors.blue;
                                      }
                                    },
                                    dataLabelSettings: const DataLabelSettings(
                                      isVisible: true,
                                      textStyle: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                                plotAreaBorderWidth: 0,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Stats cards
                      Row(
                        children: [
                          Expanded(
                            child: _statsCard(
                              title: "Physics",
                              correct: 25,
                              incorrect: 14,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statsCard(
                              title: "Chemistry",
                              correct: 28,
                              incorrect: 10,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _statsCard(
                        title: "Biology",
                        correct: 25,
                        incorrect: 12,
                        color: Colors.green,
                      ),

                      SizedBox(height: 20.h,),
                      Row(
                        spacing: 15.w,
                        children: [
                          Expanded(
                            child: CustomGradientButton(
                              text: 'Download Report',
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
                              text: 'GO to Solutions',
                              onPressed: () {

                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 70.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white12),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _statsCard({
    required String title,
    required int correct,
    required int incorrect,
    required Color color,
  }) {
    return SignupFieldBox(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
            const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _statRow("Correct - $correct", AppColors.green),
          _statRow("Incorrect - $incorrect", AppColors.red),
          _statRow("Unattempted", AppColors.orange),
        ],
      ),
    );
  }
  Widget _statRow(String text, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.circle, size: 10, color: dotColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: dotColor, fontSize: 14),
          ),
        ],
      ),
    );
  }


}

class _ChartData {
  final String subject;
  final double value;
  _ChartData(this.subject, this.value);
}
