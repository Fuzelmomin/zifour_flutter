import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/widgets/my_notes_item.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/bookmark_item.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../l10n/app_localizations.dart';

class MyNotesListScreen extends StatefulWidget {
  const MyNotesListScreen({super.key});

  @override
  State<MyNotesListScreen> createState() => _MyNotesListScreenState();
}

class _MyNotesListScreenState extends State<MyNotesListScreen> {

  String selectedFilter = "Practice MCQ";
  final filters = [
    "Practice MCQ",
    "All India Test Series",
    "Create Own Challenges",
    "Expert Challenge"
  ];

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
                    title: '${AppLocalizations.of(context)?.myNotes}',
                    isActionWidget: true,
                    actionWidget: PopupMenuButton<String>(
                      onSelected: (value) => setState(() => selectedFilter = value),
                      itemBuilder: (context) {
                        return filters
                            .map((e) => PopupMenuItem(value: e, child: Text(e)))
                            .toList();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFFCF078A), // Pink
                              Color(0xFF5E00D8)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFCF078A).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              selectedFilter,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    actionClick: (){
          
                    },
                  )),
          
              // Main Content with BLoC
              Positioned(
                top: 70.h,
                left: 20.w,
                right: 20.w,
                bottom: 0,
                child: SignupFieldBox(
                  child: ListView.builder(
                    itemCount: 8,
                    padding: const EdgeInsets.only(bottom: 20),
                    itemBuilder: (context, index) => Container(
                      child: MyNotesItem(
                        title: 'Why does tension act upward in pulley system?',
                        noteType: 'Practice MCQ',
                        notesDes: 'Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search ',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
