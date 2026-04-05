import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';
import '../constants/assets_path.dart';
import '../theme/app_typography.dart';

class BookmarkItem extends StatefulWidget {
  final String? title;
  final String? description;
  final String? bookmarkType;
  final String? mcOption1;
  final String? mcOption2;
  final String? mcOption3;
  final String? mcOption4;
  final String? mcAnswer;
  final String? mcSolution;
  final String? chpName;
  final String? tpcName;
  final Function()? deleteClick;
  final Function()? onViewMcq;

  const BookmarkItem({
    super.key,
    this.title,
    this.description,
    this.bookmarkType,
    this.mcOption1,
    this.mcOption2,
    this.mcOption3,
    this.mcOption4,
    this.mcAnswer,
    this.mcSolution,
    this.chpName,
    this.tpcName,
    this.deleteClick,
    this.onViewMcq,
  });

  @override
  State<BookmarkItem> createState() => _BookmarkItemState();
}

class _BookmarkItemState extends State<BookmarkItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1B193D),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.white.withOpacity(0.1),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question title + delete button
          Row(
            children: [
              Expanded(
                flex: 9,
                child: Html(
                  data: widget.title?.trim() ?? '',
                  style: {
                    "body": Style(
                      color: Colors.white,
                      fontSize: FontSize(14.sp),
                      lineHeight: LineHeight(1.5),
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                    ),
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    widget.deleteClick!();
                  },
                  child: SvgPicture.asset(
                    AssetsPath.svgCloseCircle,
                    width: 20.w,
                    height: 20.h,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),

          // Description
          if (widget.description != null &&
              widget.description!.trim().isNotEmpty) ...[
            SizedBox(height: 5.h),
            Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Html(
                    data: widget.description?.trim() ?? '',
                    style: {
                      "body": Style(
                        color: AppColors.hintTextColor,
                        fontSize: FontSize(12.sp),
                        lineHeight: LineHeight(1.5),
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                    },
                  ),
                ),
              ],
            ),
          ],

          SizedBox(height: 7.h),

          // Type badge + Show More/Less + View MCQ row
          Row(
            children: [
              // Type badge
              Container(
                padding:
                    EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16.r)),
                  color: Colors.transparent,
                  border: BoxBorder.all(
                    color: AppColors.white.withOpacity(0.1),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  widget.bookmarkType ?? '',
                  style: AppTypography.inter10Medium
                      .copyWith(color: const Color(0xFFF58D30)),
                ),
              ),

              const SizedBox(width: 8),

              // Show More / Show Less toggle
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded ? 'Show Less' : 'Show More',
                      style: AppTypography.inter10Medium.copyWith(
                        color: const Color(0xFF8B8FFF),
                      ),
                    ),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: const Color(0xFF8B8FFF),
                      size: 16,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // View MCQ link
              GestureDetector(
                onTap: widget.onViewMcq,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View MCQ',
                      style: AppTypography.inter10Medium.copyWith(
                        color: const Color(0xFFCF078A),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: const Color(0xFFCF078A),
                      size: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Expandable section
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedContent(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    final optionLabels = ['A', 'B', 'C', 'D'];
    final options = [
      widget.mcOption1 ?? '',
      widget.mcOption2 ?? '',
      widget.mcOption3 ?? '',
      widget.mcOption4 ?? '',
    ];
    final correctIndex = int.tryParse(widget.mcAnswer ?? '') ?? 0;

    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Divider
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.08),
          ),
          SizedBox(height: 10.h),

          // Chapter & Topic
          if ((widget.chpName ?? '').isNotEmpty ||
              (widget.tpcName ?? '').isNotEmpty) ...[
            Row(
              children: [
                if ((widget.chpName ?? '').isNotEmpty)
                  Expanded(
                    child: _infoChip(
                      icon: Icons.menu_book,
                      label: widget.chpName!,
                    ),
                  ),
                if ((widget.chpName ?? '').isNotEmpty &&
                    (widget.tpcName ?? '').isNotEmpty)
                  SizedBox(width: 8.w),
                if ((widget.tpcName ?? '').isNotEmpty)
                  Expanded(
                    child: _infoChip(
                      icon: Icons.topic,
                      label: widget.tpcName!,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10.h),
          ],

          // Options
          ...List.generate(options.length, (index) {
            final isCorrect = correctIndex > 0 && (index + 1) == correctIndex;
            return Container(
              margin: EdgeInsets.only(bottom: 6.h),
              padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isCorrect
                    ? AppColors.success.withOpacity(0.15)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: isCorrect
                      ? AppColors.success.withOpacity(0.5)
                      : Colors.white.withOpacity(0.06),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 22.w,
                    height: 22.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCorrect
                          ? AppColors.success.withOpacity(0.3)
                          : Colors.white.withOpacity(0.1),
                    ),
                    child: Text(
                      optionLabels[index],
                      style: TextStyle(
                        color: isCorrect ? AppColors.success : Colors.white70,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Html(
                      data: options[index].trim(),
                      style: {
                        "body": Style(
                          color: isCorrect ? AppColors.success : Colors.white70,
                          fontSize: FontSize(12.sp),
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                        ),
                      },
                    ),
                  ),
                  if (isCorrect)
                    Icon(Icons.check_circle,
                        color: AppColors.success, size: 16.sp),
                ],
              ),
            );
          }),

          // Solution
          if ((widget.mcSolution ?? '').isNotEmpty) ...[
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xFF5E00D8).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: const Color(0xFF5E00D8).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Solution',
                    style: AppTypography.inter10Medium.copyWith(
                      color: const Color(0xFF8B8FFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Html(
                    data: widget.mcSolution ?? '',
                    style: {
                      "body": Style(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: FontSize(11.sp),
                        lineHeight: LineHeight(1.4),
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoChip({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white38, size: 12.sp),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              label,
              style: AppTypography.inter10Medium.copyWith(
                color: Colors.white60,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
