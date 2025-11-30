import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final List<Map<String, dynamic>> menuItems = [
    {
      "title": "Start Your Free Trial",
      "subtitle": "",
      "icon": Icons.bolt,
      "color": const Color(0xFF6857F9),
    },
    {
      "title": "Live Classes",
      "subtitle": "",
      "icon": Icons.play_circle_fill,
      "color": const Color(0xFF7C2C6A),
    },
    {
      "title": "My Courses",
      "subtitle": "Live Classes\nLearn Live\nWith Mentors",
      "icon": Icons.school,
      "color": const Color(0xFF2DA63A),
    },
    {
      "title": "Practice MCQS",
      "subtitle": "Master Every\nConcept",
      "icon": Icons.menu_book,
      "color": const Color(0xFFCA7A18),
    },
    {
      "title": "All India\nChallenger Zone",
      "subtitle": "Compete\nAcross India",
      "icon": Icons.flag_circle_rounded,
      "color": const Color(0xFF1FB2B2),
    },
    {
      "title": "Test Series",
      "subtitle": "Full Syllabus\nMock Test",
      "icon": Icons.assignment,
      "color": const Color(0xFFB11818),
    },
    {
      "title": "Ask Your\nDoubts",
      "subtitle": "Get Expert\nSolutions",
      "icon": Icons.support_agent_rounded,
      "color": const Color(0xFF8E8E8E),
    },
    {
      "title": "AI Based\nPerformance",
      "subtitle": "Know Your\nComplete Progress",
      "icon": Icons.auto_graph,
      "color": const Color(0xFF1F87F3),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0B2A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "🔥 Be Ziddi. Be a Topper.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),

              /// ---------------- GridView ----------------
              Expanded(
                child: GridView.builder(
                  itemCount: menuItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: size.width > 500 ? 3 : 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.88,
                  ),
                  itemBuilder: (context, index) {
                    final item = menuItems[index];

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            item['color'].withOpacity(0.85),
                            item['color'].withOpacity(0.55),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Icon(
                              item['icon'],
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            item['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (item["subtitle"] != "")
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                item["subtitle"],
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 13,
                                ),
                              ),
                            )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
