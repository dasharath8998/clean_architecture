import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';

class ResponsiveHelper {
  ResponsiveHelper._();

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < AppSizes.mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppSizes.mobileBreakpoint &&
        width < AppSizes.desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppSizes.desktopBreakpoint;

  static double contentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > AppSizes.mobileBreakpoint) {
      return AppSizes.maxContentWidth;
    }
    return width;
  }
}

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth = AppSizes.maxContentWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
