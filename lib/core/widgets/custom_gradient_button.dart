import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';

class CustomGradientArrowButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final List<Color>? gradientColors;
  final Widget? icon;
  final TextStyle? textStyle;
  final bool isLoading;
  final Color? loadingColor;
  final String? assetPath;

  const CustomGradientArrowButton({
    super.key,
    required this.text,
    this.onPressed,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.gradientColors,
    this.icon,
    this.textStyle,
    this.isLoading = false,
    this.loadingColor,
    this.assetPath
  });

  // Default gradient colors (pink to purple)
  static const List<Color> defaultGradientColors = [
    Color(0xFFCF078A), // Pink
    Color(0xFF5E00D8), // Purple
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 50.h,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: gradientColors ?? defaultGradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: (gradientColors?.first ?? defaultGradientColors.first).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(12.r),
          child: Container(
            padding: padding ?? EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        loadingColor ?? Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],
                Text(
                  text,
                  style: textStyle ?? AppTypography.inter14Bold,
                ),
                Image.asset(
                  assetPath ?? AssetsPath.icRightArrowCircle,
                  width: 28.h,
                  height: 28.h,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final List<Color>? gradientColors;
  final Widget? icon;
  final TextStyle? textStyle;
  final bool isLoading;
  final Color? loadingColor;
  final String? assetPath;
  final BoxDecoration? customDecoration;

  const CustomGradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.gradientColors,
    this.icon,
    this.textStyle,
    this.isLoading = false,
    this.loadingColor,
    this.assetPath,
    this.customDecoration
  });

  // Default gradient colors (pink to purple)
  static const List<Color> defaultGradientColors = [
    Color(0xFFCF078A), // Pink
    Color(0xFF5E00D8), // Purple
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 50.h,
      margin: margin,
      decoration: customDecoration ?? BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: gradientColors ?? defaultGradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: (gradientColors?.first ?? defaultGradientColors.first).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(12.r),
          child: Container(
            padding: padding ?? EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        loadingColor ?? Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],
                Text(
                  text,
                  style: textStyle ?? AppTypography.inter14Bold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Language-specific gradient button for the language selection screen
class LanguageGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;

  const LanguageGradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomGradientButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      height: 56.h,
      borderRadius: BorderRadius.circular(12.r),
      icon: icon ?? Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
        size: 16.sp,
      ),
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
