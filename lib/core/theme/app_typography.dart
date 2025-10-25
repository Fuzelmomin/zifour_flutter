import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Centralized DM Sans text styles adjusted with ScreenUtil.
class AppTypography {
  AppTypography._();

  // 12px Regular (weight 400), line-height ~13px
  static TextStyle get dm12Regular => GoogleFonts.dmSans(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        height: 13 / 12,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      );

  // 12px Bold (weight 700), line-height ~13px
  static TextStyle get inter12Bold => GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        height: 22 / 16,
        letterSpacing: 0,
        color: AppColors.white,
      );

  static TextStyle get inter12Regular => GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 22 / 16,
    letterSpacing: 0,
    color: AppColors.white,
  );

  static TextStyle get inter14Regular => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 22 / 16,
    letterSpacing: 0,
    color: AppColors.white,
  );

  static TextStyle get inter16Regular => GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 13 / 12,
    letterSpacing: 0,
    color: AppColors.white,
  );

  static TextStyle get inter12Medium => GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    height: 13 / 12,
    letterSpacing: 0,
    color: AppColors.white,
  );

  static TextStyle get inter14Medium => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 22 / 16,
    letterSpacing: 0,
    color: AppColors.white,
  );

  static TextStyle get inter16Medium => GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    height: 22 / 16,
    letterSpacing: 0,
    color: AppColors.white,
  );

  static TextStyle get inter22Bold => GoogleFonts.inter(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    height: 22 / 16,
    letterSpacing: 0,
    color: AppColors.white,
  );

  static TextStyle get inter14SemiBold => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 14 / 16,
    letterSpacing: 0,
    color: AppColors.white,
  );

  static TextStyle get inter24Bold => GoogleFonts.inter(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    height: 22 / 16,
    letterSpacing: 0,
    color: AppColors.white,
  );

  static TextStyle get inter14Bold => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    height: 22 / 16,
    letterSpacing: 0,
    color: AppColors.white,
  );

  // 12px SemiBold (weight 600), line-height ~11.79px
  static TextStyle get dm12SemiBold => GoogleFonts.dmSans(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        height: 11.79 / 12,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      );

  // 16px Medium (weight 500), line-height ~21.57px
  static TextStyle get dm16Medium => GoogleFonts.dmSans(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        height: 22 / 16,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      );

  static TextStyle get robotoMedium => GoogleFonts.roboto(
    fontSize: 16.sp,
    height: 1.5, // line-height equivalent (14 * 1.5 = 21px)
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
}


