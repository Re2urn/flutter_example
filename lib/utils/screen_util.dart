import 'package:flutter/material.dart';

class ScreenUtil {
  static const double mobileWidth = 600;
  static const double tabletWidth = 900;

  static EdgeInsets getSafeAdaptivePadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final viewPadding = mediaQuery.viewPadding;

    final double basePadding = width * 0.04;

    return EdgeInsets.fromLTRB(
      basePadding + viewPadding.left,
      basePadding + viewPadding.top,
      basePadding + viewPadding.right,
      basePadding + viewPadding.bottom,
    );
  }

  static EdgeInsets getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final basePadding = width * 0.04;

    return EdgeInsets.symmetric(horizontal: basePadding);
  }

  static EdgeInsets getVerticalPadding(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final basePadding = height * 0.02;

    return EdgeInsets.symmetric(vertical: basePadding);
  }

  static EdgeInsets getAllPadding(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final basePadding = size.width * 0.04;

    return EdgeInsets.all(basePadding);
  }

  static EdgeInsets getCardPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < mobileWidth) {
      return const EdgeInsets.all(12.0);
    } else if (width < tabletWidth) {
      return const EdgeInsets.all(16.0);
    } else {
      return const EdgeInsets.all(20.0);
    }
  }

  static double getSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width * 0.025;
  }

  static double getTextSize(BuildContext context, TextStyle baseStyle) {
    final width = MediaQuery.of(context).size.width;
    final scaleFactor = width / 400;

    return baseStyle.fontSize! * (scaleFactor > 0.8 ? scaleFactor : 0.8);
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileWidth;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileWidth && width < tabletWidth;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletWidth;
  }

  static int getGridCrossAxisCount(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 4;
  }

  static double getGridChildAspectRatio(BuildContext context) {
    if (isMobile(context)) return 0.8;
    if (isTablet(context)) return 0.9;
    return 1.0;
  }

  static double getAdaptiveWidth(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final width = mediaQuery.size.width;

    return isLandscape ? width * 0.5 : width * 0.9;
  }

  static double getAdaptiveFontSize(BuildContext context, double baseFontSize) {
    final width = MediaQuery.of(context).size.width;

    if (width < mobileWidth) {
      return baseFontSize;
    } else if (width < tabletWidth) {
      return baseFontSize * 1.1;
    } else {
      return baseFontSize * 1.2;
    }
  }

  static double getAdaptivePadding(BuildContext context) {
    if (isMobile(context)) return 8.0;
    if (isTablet(context)) return 16.0;
    return 24.0;
  }

  static double getVerticalSpacing(BuildContext context) {
    if (isMobile(context)) return 8.0;
    if (isTablet(context)) return 12.0;
    return 16.0;
  }

  static double getHorizontalSpacing(BuildContext context) {
    if (isMobile(context)) return 8.0;
    if (isTablet(context)) return 12.0;
    return 16.0;
  }

  static double getContentColumnWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < mobileWidth) {
      return width * 0.95;
    } else if (width < tabletWidth) {
      return width * 0.85;
    } else {
      return width * 0.7;
    }
  }
}
