import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/assets_path.dart';
import '../../../core/theme/app_typography.dart';
import '../model/revision_model.dart';

class RevisionItemWidget extends StatelessWidget {
  final PlannerModel planner;
  final Function()? onDelete;

  const RevisionItemWidget({
    super.key,
    required this.planner,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1B193D),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  planner.subject,
                  style: AppTypography.inter16SemiBold.copyWith(
                    color: const Color(0xFFF58D30),
                  ),
                ),
              ),
              if (onDelete != null)
                GestureDetector(
                  onTap: onDelete,
                  child: SvgPicture.asset(
                    AssetsPath.svgCloseCircle,
                    width: 22.w,
                    height: 22.h,
                    color: Colors.redAccent,
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            planner.topic,
            style: AppTypography.inter14Medium.copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            planner.chapter,
            style: AppTypography.inter12Medium.copyWith(
              color: AppColors.hintTextColor,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildMetaInfo(
                Icons.calendar_month_outlined,
                '${planner.plnrSdate} to ${planner.plnrEdate}',
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _buildBadge(planner.standard),
              _buildBadge(planner.medium),
              _buildBadge(planner.exam),
            ],
          ),
          if (planner.plnrMessage.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                planner.plnrMessage,
                style: AppTypography.inter12Medium.copyWith(
                  color: Colors.white.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetaInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: Colors.white54),
        SizedBox(width: 6.w),
        Text(
          text,
          style: AppTypography.inter12Medium.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Text(
        text,
        style: AppTypography.inter10Medium.copyWith(
          color: Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }
}
