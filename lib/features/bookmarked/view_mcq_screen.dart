import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/signup_field_box.dart';
import 'model/mcq_bookmark_list_model.dart';

class ViewMcqScreen extends StatelessWidget {
  final McqBookmarkListItem bookmark;

  const ViewMcqScreen({super.key, required this.bookmark});

  @override
  Widget build(BuildContext context) {
    final optionLabels = ['A', 'B', 'C', 'D'];
    final options = bookmark.options;
    final correctIndex = int.tryParse(bookmark.mcAnswer) ?? 0;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.darkBlue,
        child: SafeArea(
          child: Stack(
            children: [
              // Background
              Positioned.fill(
                child: Image.asset(
                  AssetsPath.signupBgImg,
                  fit: BoxFit.cover,
                ),
              ),

              // App Bar
              Positioned(
                top: 15.h,
                left: 15.w,
                right: 5.w,
                child: CustomAppBar(
                  isBack: true,
                  title: 'View MCQ',
                  actionClick: () {},
                ),
              ),

              // Content
              Positioned(
                top: 85.h,
                left: 20.w,
                right: 20.w,
                bottom: 0,
                child: SignupFieldBox(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 30.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Chapter & Topic info
                        if (bookmark.chpName.isNotEmpty ||
                            bookmark.tpcName.isNotEmpty) ...[
                          Row(
                            children: [
                              if (bookmark.chpName.isNotEmpty)
                                Expanded(
                                  child: _infoTag(
                                    title: 'Chapter',
                                    value: bookmark.chpName,
                                  ),
                                ),
                              if (bookmark.chpName.isNotEmpty &&
                                  bookmark.tpcName.isNotEmpty)
                                SizedBox(width: 10.w),
                              if (bookmark.tpcName.isNotEmpty)
                                Expanded(
                                  child: _infoTag(
                                    title: 'Topic',
                                    value: bookmark.tpcName,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                        ],

                        // Type badge
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.h, horizontal: 10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFCF078A).withOpacity(0.2),
                                const Color(0xFF5E00D8).withOpacity(0.2),
                              ],
                            ),
                            border: Border.all(
                              color: const Color(0xFFCF078A).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            bookmark.type,
                            style: AppTypography.inter10Medium.copyWith(
                              color: const Color(0xFFF58D30),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Question
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.pinkColor3.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Html(
                            data: bookmark.mcQuestion.trim(),
                            style: {
                              "body": Style(
                                color: Colors.white,
                                fontSize:
                                    FontSize(isLandscape ? 15.0 : 15.sp),
                                fontWeight: FontWeight.w700,
                                lineHeight: LineHeight(1.5),
                                margin: Margins.zero,
                                padding: HtmlPaddings.zero,
                              ),
                            },
                          ),
                        ),

                        // Description
                        if (bookmark.mcDescription.trim().isNotEmpty) ...[
                          SizedBox(height: 12.h),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Html(
                              data: bookmark.mcDescription.trim(),
                              style: {
                                "body": Style(
                                  color: Colors.white70,
                                  fontSize: FontSize(13.sp),
                                  lineHeight: LineHeight(1.4),
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                ),
                              },
                            ),
                          ),
                        ],

                        SizedBox(height: 20.h),

                        // Options
                        ...List.generate(options.length, (index) {
                          final isCorrect =
                              correctIndex > 0 && (index + 1) == correctIndex;
                          return _optionTile(
                            label: optionLabels[index],
                            text: options[index].trim(),
                            isCorrect: isCorrect,
                            isLandscape: isLandscape,
                          );
                        }),

                        // Solution
                        if (bookmark.mcSolution.trim().isNotEmpty) ...[
                          SizedBox(height: 20.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(14.w),
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFF5E00D8).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: const Color(0xFF5E00D8)
                                    .withOpacity(0.25),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline,
                                      color: const Color(0xFF8B8FFF),
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      'Solution',
                                      style: AppTypography.inter14SemiBold
                                          .copyWith(
                                        color: const Color(0xFF8B8FFF),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Html(
                                  data: bookmark.mcSolution.trim(),
                                  style: {
                                    "body": Style(
                                      color:
                                          Colors.white.withOpacity(0.85),
                                      fontSize: FontSize(13.sp),
                                      lineHeight: LineHeight(1.5),
                                      margin: Margins.zero,
                                      padding: HtmlPaddings.zero,
                                    ),
                                    "strong": Style(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],

                        SizedBox(height: 30.h),
                      ],
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

  Widget _optionTile({
    required String label,
    required String text,
    required bool isCorrect,
    required bool isLandscape,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isCorrect ? 0.18 : 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCorrect ? AppColors.success : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 26.w,
            height: 26.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCorrect
                  ? AppColors.success.withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isCorrect ? AppColors.success : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Html(
              data: text,
              style: {
                "body": Style(
                  color: isCorrect ? AppColors.success : Colors.white,
                  fontSize: FontSize(isLandscape ? 14.0 : 14.sp),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
              },
            ),
          ),
          if (isCorrect)
            Icon(Icons.check_circle, color: AppColors.success, size: 20.sp),
        ],
      ),
    );
  }

  Widget _infoTag({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
