import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/widgets/my_notes_item.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/bookmark_item.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/my_doubts_item.dart';
import '../../l10n/app_localizations.dart';

class MyDoubtsListScreen extends StatefulWidget {
  const MyDoubtsListScreen({super.key});

  @override
  State<MyDoubtsListScreen> createState() => _MyDoubtsListScreenState();
}

class _MyDoubtsListScreenState extends State<MyDoubtsListScreen> {

  String selectedFilter = "All";
  final filters = [
    "All",
    "Physics",
    "Chemistry",
    "Biology",
    "Maths"
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
                  top: 20.h,
                  left: 15.w,
                  right: 5.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: '${AppLocalizations.of(context)?.myDoubts}',
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
                top: 90.h,
                left: 20.w,
                right: 20.w,
                bottom: 10.h,
                child: SignupFieldBox(
                  padding: EdgeInsets.all(15.0),
                  child: ListView.separated(
                    itemCount: 5,
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 20),
                    itemBuilder: (context, index) => Container(
                      child: MyDoubtsItem(
                        title: 'Why does tension act upward in pulley system?',
                        isReplied: index == 2 ? false : true,
                      ),
                    ), separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      width: double.infinity,
                      height: 0.80,
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      color: AppColors.white.withOpacity(0.2),
                    );
                  },
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
