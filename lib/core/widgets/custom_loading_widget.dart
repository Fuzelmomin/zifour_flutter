import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constants/app_colors.dart';

/// Custom loading widget that can be used across all screens
/// Supports different loading styles and placements
class CustomLoadingWidget extends StatelessWidget {
  /// The type of loading indicator to show
  final LoadingType type;
  
  /// Color of the loading indicator
  final Color? color;
  
  /// Size of the loading indicator
  final double? size;
  
  /// Background color (for full screen and overlay types)
  final Color? backgroundColor;
  
  /// Message to display below the loading indicator
  final String? message;
  
  /// Custom message style
  final TextStyle? messageStyle;
  
  /// Whether to show as full screen overlay
  final bool fullScreen;
  
  const CustomLoadingWidget({
    super.key,
    this.type = LoadingType.circle,
    this.color,
    this.size,
    this.backgroundColor,
    this.message,
    this.messageStyle,
    this.fullScreen = false,
  });

  /// Default full-screen loading widget
  const CustomLoadingWidget.fullScreen({
    super.key,
    this.type = LoadingType.circle,
    this.color,
    this.size,
    this.backgroundColor,
    this.message,
    this.messageStyle,
    this.fullScreen = true,
  });

  /// Inline loading widget (without background)
  const CustomLoadingWidget.inline({
    super.key,
    this.type = LoadingType.circle,
    this.color,
    this.size,
    this.backgroundColor,
    this.message,
    this.messageStyle,
    this.fullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final loadingColor = color ?? AppColors.pinkColor;
    final loadingSize = size ?? 50.0.sp;
    final bgColor = backgroundColor ?? AppColors.darkBlue.withOpacity(0.9);
    
    Widget loadingIndicator = _buildLoadingIndicator(type, loadingColor, loadingSize);
    
    if (message != null) {
      loadingIndicator = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loadingIndicator,
          SizedBox(height: 24.h),
          Text(
            message!,
            style: messageStyle ?? TextStyle(
              color: AppColors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
    
    if (fullScreen) {
      return Builder(
        builder: (context) {
          final size = MediaQuery.of(context).size;
          return Container(
            width: size.width,
            height: size.height,
            color: bgColor,
            child: Center(
              child: loadingIndicator,
            ),
          );
        },
      );
    }
    
    return Center(
      child: loadingIndicator,
    );
  }

  Widget _buildLoadingIndicator(LoadingType type, Color color, double size) {
    switch (type) {
      case LoadingType.circle:
        return SpinKitCircle(
          color: color,
          size: size,
        );
      case LoadingType.threeBounce:
        return SpinKitThreeBounce(
          color: color,
          size: size * 0.8,
        );
      case LoadingType.chasingDots:
        return SpinKitChasingDots(
          color: color,
          size: size,
        );
      case LoadingType.wave:
        return SpinKitWave(
          color: color,
          size: size * 0.8,
        );
      case LoadingType.wanderingCubes:
        return SpinKitWanderingCubes(
          color: color,
          size: size,
        );
      case LoadingType.pulse:
        return SpinKitPulse(
          color: color,
          size: size,
        );
      case LoadingType.fadingCircle:
        return SpinKitFadingCircle(
          color: color,
          size: size,
        );
      case LoadingType.rotatingCircle:
        return SpinKitRotatingCircle(
          color: color,
          size: size,
        );
      case LoadingType.foldingCube:
        return SpinKitFoldingCube(
          color: color,
          size: size,
        );
      case LoadingType.doubleBounce:
        return SpinKitDoubleBounce(
          color: color,
          size: size,
        );
      case LoadingType.spinningCircle:
        return SpinKitSpinningCircle(
          color: color,
          size: size,
        );
    }
  }
}

/// Different types of loading indicators available
enum LoadingType {
  /// Classic circular loading indicator
  circle,
  
  /// Three bouncing dots
  threeBounce,
  
  /// Chasing dots animation
  chasingDots,
  
  /// Wave animation
  wave,
  
  /// Wandering cubes animation
  wanderingCubes,
  
  /// Pulsing circle
  pulse,
  
  /// Fading circle
  fadingCircle,
  
  /// Rotating circle
  rotatingCircle,
  
  /// Folding cube
  foldingCube,
  
  /// Double bounce
  doubleBounce,
  
  /// Spinning circle
  spinningCircle,
}

/// Loading overlay widget that can be used as a dialog/overlay
class CustomLoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final LoadingType loadingType;
  final Color? loadingColor;
  final double? loadingSize;
  final Color? overlayColor;
  final String? message;

  const CustomLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingType = LoadingType.circle,
    this.loadingColor,
    this.loadingSize,
    this.overlayColor,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          CustomLoadingWidget.fullScreen(
            type: loadingType,
            color: loadingColor,
            size: loadingSize,
            backgroundColor: overlayColor,
            message: message,
          ),
      ],
    );
  }
}

