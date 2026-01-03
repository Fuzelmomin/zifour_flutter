import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/widgets/custom_gradient_button.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/services/subject_service.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../module_list/module_order_form_screen.dart';
import '../practics_mcq/select_chapter_screen.dart';

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({super.key});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  final SubjectService _subjectService = SubjectService();

  // Map subject names to icon paths
  String _getSubjectIcon(String subjectName) {
    final name = subjectName.toLowerCase();
    if (name.contains('physics')) return AssetsPath.icPhysics;
    if (name.contains('chemistry')) return AssetsPath.icChemistry;
    if (name.contains('biology')) return AssetsPath.icBiology;
    if (name.contains('math')) return AssetsPath.icMaths;
    return AssetsPath.icPhysics; // Default icon
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
                  title: 'Module',
                ),
              ),

              // Main Content
              Positioned(
                top: 100.h,
                left: 20.w,
                right: 20.w,
                bottom: 60.h,
                child: _subjectService.hasSubjects
                    ? SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20.h,
                    children: _subjectService.subjects.map((subject) {
                      return subjectContainer(
                        _getSubjectIcon(subject.name),
                        subject.name,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectChapterScreen(
                                from: 'module',
                                subjectId: subject.subId,
                                subjectName: subject.name,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                )
                    : Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text(
                      'No subjects found',
                      style: AppTypography.inter14Regular.copyWith(
                        color: AppColors.white.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 20.w,
                right: 20.w,
                bottom: 0,
                child: CustomGradientButton(
                  text: "Buy Modules",
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ModuleOrderFormScreen(mdlId: "1",),));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget subjectContainer(String iconPath, String title, Function() onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: Color(0xffEEF1FB).withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          border: BoxBorder.all(
            color: AppColors.white.withOpacity(0.1),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 12.w,
              children: [
                Image.asset(
                  iconPath,
                  width: 50.h,
                  height: 50.h,
                ),
                Text(
                  title,
                  style: AppTypography.inter20Medium,
                )
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_sharp,
              size: 25.0,
              color: AppColors.white.withOpacity(0.5),
            )
          ],
        ),
      ),
    );
  }
}

