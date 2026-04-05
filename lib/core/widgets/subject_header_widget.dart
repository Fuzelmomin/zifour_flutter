import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'signup_field_box.dart';

class SubjectHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final String iconUrl;
  final bool isPractice;
  final String? mcqCount;
  final String? videoCount;
  final String? testCount;

  const SubjectHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.iconUrl,
    required this.isPractice,
    this.mcqCount,
    this.videoCount,
    this.testCount,
  });

  bool get _hasStats =>
      (mcqCount != null && mcqCount!.isNotEmpty) ||
      (videoCount != null && videoCount!.isNotEmpty) ||
      (testCount != null && testCount!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final iconOuterSize = isLandscape ? 65.0 : 70.w;
    final iconInnerSize = isLandscape ? 50.0 : 60.w;

    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        // Background Box (Non-positioned to determine height)
        Padding(
          padding: EdgeInsets.only(top: isLandscape ? 25 : 35.h),
          child: SignupFieldBox(
            boxBgColor: AppColors.pinkColor3.withOpacity(0.1),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: isLandscape ? 30 : 40.h,
                bottom: isLandscape ? 12 : 10.h,
                left: 15.w,
                right: 15.w,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTypography.inter24Medium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isLandscape ? 4 : 8.h),
                  Text(
                    subtitle,
                    style: AppTypography.inter14Medium.copyWith(
                      color: const Color(0xffC55492),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_hasStats) ...[
                    SizedBox(height: isLandscape ? 8 : 12.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 5.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (mcqCount != null && mcqCount!.isNotEmpty)
                            _buildStatItem(Icons.quiz_outlined, mcqCount!, 'MCQs', const Color(0xFF4FC3F7)),
                          if (mcqCount != null && mcqCount!.isNotEmpty &&
                              videoCount != null && videoCount!.isNotEmpty)
                            _buildDivider(),
                          if (videoCount != null && videoCount!.isNotEmpty)
                            _buildStatItem(Icons.play_circle_outline, videoCount!, 'Video', const Color(0xFFFF8A65)),
                          if (videoCount != null && videoCount!.isNotEmpty &&
                              testCount != null && testCount!.isNotEmpty)
                            _buildDivider(),
                          if (testCount != null && testCount!.isNotEmpty)
                            _buildStatItem(Icons.description_outlined, testCount!, 'Test', const Color(0xFFA5D6A7)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),

        // Overlapping Icon
        Positioned(
          top: 0.0,
          child: Container(
            width: iconOuterSize,
            height: iconOuterSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.pinkColor3.withOpacity(0.2),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(iconInnerSize / 2),
                child: iconUrl.isNotEmpty ?
                Image.network(
                  iconUrl,
                  width: iconInnerSize,
                  height: iconInnerSize,
                  fit: BoxFit.contain,
                ) : Image.asset(
                  iconPath,
                  width: iconInnerSize,
                  height: iconInnerSize,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String count, String label, Color iconColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 18.0),
        SizedBox(width: 5.w),
        Text(
          count,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 20.h,
      color: Colors.white.withOpacity(0.15),
    );
  }
}
