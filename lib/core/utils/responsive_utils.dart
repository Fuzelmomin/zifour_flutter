import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveUtils {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static double getResponsiveWidth(BuildContext context, double mobileWidth, {double? tabletWidth, double? desktopWidth}) {
    if (isDesktop(context) && desktopWidth != null) {
      return desktopWidth.w;
    } else if (isTablet(context) && tabletWidth != null) {
      return tabletWidth.w;
    } else {
      return mobileWidth.w;
    }
  }

  static double getResponsiveHeight(BuildContext context, double mobileHeight, {double? tabletHeight, double? desktopHeight}) {
    if (isDesktop(context) && desktopHeight != null) {
      return desktopHeight.h;
    } else if (isTablet(context) && tabletHeight != null) {
      return tabletHeight.h;
    } else {
      return mobileHeight.h;
    }
  }

  static EdgeInsets getResponsivePadding(BuildContext context, EdgeInsets mobilePadding, {EdgeInsets? tabletPadding, EdgeInsets? desktopPadding}) {
    if (isDesktop(context) && desktopPadding != null) {
      return desktopPadding;
    } else if (isTablet(context) && tabletPadding != null) {
      return tabletPadding;
    } else {
      return mobilePadding;
    }
  }

  static int getResponsiveColumns(BuildContext context, int mobileColumns, {int? tabletColumns, int? desktopColumns}) {
    if (isDesktop(context) && desktopColumns != null) {
      return desktopColumns;
    } else if (isTablet(context) && tabletColumns != null) {
      return tabletColumns;
    } else {
      return mobileColumns;
    }
  }
}
