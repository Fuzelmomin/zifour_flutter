import 'package:flutter/material.dart';

class TestSeriesScreen extends StatelessWidget {
  const TestSeriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B0D35),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff0B0D35), Color(0xff1A1F54)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.arrow_back, color: Colors.white),
                  const SizedBox(width: 10),
                  const Text(
                    "All India Test Series",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: [
                    testCard(
                      title: "Full Syllabus Neet Test 01",
                      status: "Available on 15th September",
                      statusColor: Colors.purpleAccent,
                      icon: Icons.check_circle,
                      iconColor: Colors.purpleAccent,
                      date: "15th September",
                      duration: "3 Hours",
                    ),
                    testCard(
                      title: "Full Syllabus Neet Test 01",
                      status: "Attempt Now",
                      statusColor: Colors.orange,
                      icon: Icons.error,
                      iconColor: Colors.orange,
                      date: "21st September",
                      duration: "4 Hours",
                    ),
                    testCard(
                      title: "Full Syllabus Neet Test 03",
                      status: "Completed on 24th September",
                      statusColor: Colors.greenAccent,
                      icon: Icons.verified,
                      iconColor: Colors.greenAccent,
                      date: "21st September",
                      duration: "4 Hours",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Bottom Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xffFF00C6), Color(0xff7C4DFF)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  "View Past Test Result",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget testCard({
    required String title,
    required String status,
    required Color statusColor,
    required IconData icon,
    required Color iconColor,
    required String date,
    required String duration,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),

          // Status Row
          Row(
            children: [
              Icon(icon, color: iconColor, size: 16),
              const SizedBox(width: 6),
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Date + Time Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.22),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "•",
                  style: TextStyle(color: Colors.white54),
                ),
                const SizedBox(width: 8),
                Text(
                  duration,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
