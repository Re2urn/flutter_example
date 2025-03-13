import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:flutter/material.dart';

enum DeviceType {
  mobile,
  tablet,
  desktop,
  web,
}

class PlatformUtil {
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  static bool get isWeb => kIsWeb;

  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (kIsWeb) return DeviceType.web;
    if (width < 600) return DeviceType.mobile;
    if (width < 900) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  static bool isMobileLayout(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTabletLayout(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 900;
  }

  static bool isDesktopLayout(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  static double getAdaptiveValue({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
    double? web,
  }) {
    if (kIsWeb && web != null) return web;

    final width = MediaQuery.of(context).size.width;
    if (width < 600) return mobile;
    if (width < 900) return tablet ?? mobile * 1.25;
    return desktop ?? mobile * 1.5;
  }
}
