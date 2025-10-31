import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/all_mentors_item.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/my_course_item.dart';
import '../../l10n/app_localizations.dart';

class MyPerformanceScreen extends StatefulWidget {

  MyPerformanceScreen({
    super.key
  });

  @override
  State<MyPerformanceScreen> createState() => _MyPerformanceScreenState();
}

class _MyPerformanceScreenState extends State<MyPerformanceScreen> {

  final List<_ChartData> chartData = [
    _ChartData('Physics', 200),
    _ChartData('Chemistry', 160),
    _ChartData('Biology', 180),
    _ChartData('', 0),
    _ChartData('', 0),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                top: 40.h,
                left: 15.w,
                right: 20.w,
                child: CustomAppBar(
                  isBack: true,
                  title: '${AppLocalizations.of(context)?.myPerformance}',
                )),


            // Main Content with BLoC
            Positioned(
              top: 120.h,
              left: 20.w,
              right: 20.w,
              bottom: 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
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

                    const SizedBox(height: 24),

                    // Buttons row
                    Row(
                      children: [
                        Expanded(
                          child: _normalButton("Download Report"),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomGradientButton(
                              text: "Go to Solutions",
                            height: 48.0,

                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
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

  Widget _normalButton(String title) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

}

class _ChartData {
  final String subject;
  final double value;
  _ChartData(this.subject, this.value);
}