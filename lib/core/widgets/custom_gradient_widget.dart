import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomGradientWidget extends StatelessWidget {
  final Widget child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final List<Color>? colors;
  final List<double>? stops;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;

  const CustomGradientWidget({
    super.key,
    required this.child,
    this.alignment,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.fit,
    this.colors,
    this.stops,
    this.begin,
    this.end,
  });

  // Default gradient colors based on your image
  static const List<Color> defaultColors = [
    AppColors.transparentBlue, // Transparent dark blue at top
    AppColors.darkBlue,  // Opaque dark blue at bottom
  ];

  static const List<double> defaultStops = [0.0, 1.0];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin ?? Alignment.topCenter,
          end: end ?? Alignment.bottomCenter,
          colors: colors ?? defaultColors,
          stops: stops ?? defaultStops,
        ),
      ),
      child: child,
    );
  }
}

// Specific gradient variants for different use cases
class SplashGradientWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const SplashGradientWidget({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return CustomGradientWidget(
      padding: padding,
      margin: margin,
      width: double.infinity,
      height: double.infinity,
      child: child,
    );
  }
}

class CardGradientWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const CardGradientWidget({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: CustomGradientWidget.defaultColors,
          stops: CustomGradientWidget.defaultStops,
        ),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class ButtonGradientWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ButtonGradientWidget({
    super.key,
    required this.child,
    this.onPressed,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: CustomGradientWidget.defaultColors,
          stops: CustomGradientWidget.defaultStops,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0C0B33).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

// Horizontal gradient variant
class HorizontalGradientWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const HorizontalGradientWidget({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CustomGradientWidget(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      child: child,
    );
  }
}

// Diagonal gradient variant
class DiagonalGradientWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const DiagonalGradientWidget({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CustomGradientWidget(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      child: child,
    );
  }
}

BoxDecoration boxGradientDecoration() {
  return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          AppColors.selectedBoxColor, // Deep blue bottom-left
          Color(0xFF0c0a2e), // Cyan middle
          Color(0xFF0c0a2e), // Light purple top-right
          Color(0xFF0c0a2e), // Light purple top-right
          Color(0xFF0c0a2e), // Light purple top-right
          AppColors.selectedBoxColor,
        ],

      )
  );

}
