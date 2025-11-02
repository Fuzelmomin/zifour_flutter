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

class ChallengeResultScreen extends StatefulWidget {
  const ChallengeResultScreen({super.key});

  @override
  State<ChallengeResultScreen> createState() => _ChallengeResultScreenState();
}

class _ChallengeResultScreenState extends State<ChallengeResultScreen> {

  String selectedFilter = "Monthly";
  List<String> filters = ["Monthly", "Weekly", "Yearly"];

  late List<ChartData> graphData;

  @override
  void initState() {
    super.initState();
    graphData = [
      ChartData("Jan", 8, 5),
      ChartData("Feb", 3, 1),
      ChartData("Mar", 6, 4),
      ChartData("Apr", 7, 3),
      ChartData("May", 5, 6),
      ChartData("Jun", 8, 6),
      ChartData("Jul", 7, 7),
    ];
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
                    title: 'Challenge Result 🏆',
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
                      Text(
                        "See how you performed in this challenge.",
                        style: AppTypography.inter16Regular.copyWith(
                            color: AppColors.white.withOpacity(0.6)
                        ),
                      ),
                      SizedBox(height: 25.h),

                      /// Score Card
                      _glassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "July NEET Mini Challenge",
                              style: AppTypography.inter16Medium,
                            ),
                            SizedBox(height: 4),
                            Text(
                              "20 July 2025",
                              style: AppTypography.inter12SemiBold.copyWith(
                                color: AppColors.orange
                              ),
                            ),
                            SizedBox(height: 16),

                            Row(
                              spacing: 15.w,
                              children: [
                                Expanded(
                                  child: InfoRow(title: "YOUR SCORE", value: "72 / 100"),
                                ),
                                Expanded(
                                  child: InfoRow(title: "ALL INDIA RANK", value: "AIR 324"),
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

                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),

                      /// Graph Card
                      _glassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Your spending",
                                  style: AppTypography.inter16Medium,
                                ),
                                DropdownButton(
                                  dropdownColor: Colors.black87,
                                  value: selectedFilter,
                                  underline: SizedBox(),
                                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                                  style: GoogleFonts.inter(color: Colors.white),
                                  items: filters.map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item, style: TextStyle(color: Colors.white)),
                                  )).toList(),
                                  onChanged: (value) {
                                    setState(() => selectedFilter = value!);
                                  },
                                ),
                              ],
                            ),

                            SizedBox(height: 12),

                            Row(
                              children: [
                                _legendDot(Colors.pinkAccent),
                                SizedBox(width: 6),
                                Text("This month", style: AppTypography.inter14Regular.copyWith(color: Color(0xFF848A9C))),
                                SizedBox(width: 16),
                                _legendDot(Colors.amberAccent),
                                SizedBox(width: 6),
                                Text("Last month", style: AppTypography.inter14Regular.copyWith(color: Color(0xFF848A9C))),
                              ],
                            ),

                            SizedBox(height: 16),

                            /// Syncfusion Bar Chart
                            SizedBox(
                              height: 240,
                              child: SfCartesianChart(
                                plotAreaBorderWidth: 0,
                                primaryXAxis: CategoryAxis(
                                  labelStyle: TextStyle(color: Colors.white70),
                                ),
                                primaryYAxis: NumericAxis(isVisible: false),
                                legend: Legend(isVisible: false),
                                series: <CartesianSeries>[
                                  ColumnSeries<ChartData, String>(
                                    color: Colors.pinkAccent,
                                    width: 0.4,
                                    dataSource: graphData,
                                    xValueMapper: (data, _) => data.month,
                                    yValueMapper: (data, _) => data.value1,
                                  ),
                                  ColumnSeries<ChartData, String>(
                                    color: Colors.amberAccent,
                                    width: 0.4,
                                    dataSource: graphData,
                                    xValueMapper: (data, _) => data.month,
                                    yValueMapper: (data, _) => data.value2,
                                  ),
                                ],
                              ),
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
                              text: 'Download PDF',
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
                              text: 'View Solutions',
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

  Widget _legendDot(Color color) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

}

class ChartData {
  ChartData(this.month, this.value1, this.value2);
  final String month;
  final double value1;
  final double value2;
}
