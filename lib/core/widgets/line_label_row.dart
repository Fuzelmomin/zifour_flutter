import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../l10n/app_localizations.dart';
import '../constants/app_colors.dart';
import '../theme/app_typography.dart';

class LineLabelRow extends StatelessWidget {
  String? label;
  double? line1Width;
  double? line2Width;
  double? textWidth;

  LineLabelRow({super.key, this.label, this.line1Width, this.line2Width, this.textWidth});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: line1Width ?? 70.w,
          height: 1.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  // Deep blue bottom-left
                  Color(0xFF4F1B4E), // Cyan middle
                  AppColors.white,
                ],
              )),
        ),
        Center(
          child: SizedBox(
            width: textWidth ?? null,
            child: Text(
                    label ?? '',
              textAlign: TextAlign.center,
              style: AppTypography.inter12Regular.copyWith(
                color: AppColors.white.withOpacity(0.7),
              ),
            ),
          ),
        ),
        Container(
          width: line2Width ?? 70.w,
          height: 1.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  // Deep blue bottom-left
                  AppColors.white,
                  Color(0xFF4F1B4E), // Cyan middle
                ],
              )),
        ),
      ],
    );
  }
}
