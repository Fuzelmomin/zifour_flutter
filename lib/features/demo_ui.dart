import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyPerformanceScreen extends StatelessWidget {
  const MyPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1444),
              Color(0xFF0A0E29),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header Row
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "My Performance",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                /// Chart Card
                _glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Performance",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),

                      /// Bar Chart
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            barTouchData: BarTouchData(enabled: true),
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (double value, TitleMeta meta) {
                                    switch (value.toInt()) {
                                      case 0:
                                        return const Text("Physics", style: TextStyle(color: Colors.orangeAccent, fontSize: 12));
                                      case 1:
                                        return const Text("Chemistry", style: TextStyle(color: Colors.pinkAccent, fontSize: 12));
                                      case 2:
                                        return const Text("Biology", style: TextStyle(color: Colors.greenAccent, fontSize: 12));
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(),
                              topTitles: AxisTitles(),
                            ),
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [BarChartRodData(toY: 200, width: 24, color: Colors.orangeAccent)],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [BarChartRodData(toY: 160, width: 24, color: Colors.pinkAccent)],
                              ),
                              BarChartGroupData(
                                x: 2,
                                barRods: [BarChartRodData(toY: 180, width: 24, color: Colors.greenAccent)],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: _subjectCard("Physics", 25, 14, 0, Colors.green)),
                    const SizedBox(width: 12),
                    Expanded(child: _subjectCard("Chemistry", 28, 10, 0, Colors.green)),
                  ],
                ),

                const SizedBox(height: 12),
                _subjectCard("Biology", 25, 12, 0, Colors.green),

                const SizedBox(height: 25),

                Row(
                  children: [
                    Expanded(child: _normalBtn("Download Report")),
                    const SizedBox(width: 10),
                    Expanded(child: _gradientBtn("Go to Solutions")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: child,
    );
  }

  Widget _subjectCard(String subject, int correct, int incorrect, int unattempted, Color color) {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subject,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _stat("Correct - $correct", Colors.green),
          _stat("Incorrect - $incorrect", Colors.redAccent),
          _stat("Unattempted", Colors.orangeAccent)
        ],
      ),
    );
  }

  Widget _stat(String text, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(Icons.circle, color: dotColor, size: 10),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _normalBtn(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Center(
        child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _gradientBtn(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFB00FF), Color(0xFF694AFF)]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
