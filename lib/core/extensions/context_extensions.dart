import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // Theme
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Media Query
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => MediaQuery.of(this).size;

  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  EdgeInsets get padding => MediaQuery.of(this).padding;

  // Navigation
  NavigatorState get navigator => Navigator.of(this);

  // Snackbar
  void showSnackBar(
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showErrorSnackBar(String message) =>
      showSnackBar(message, isError: true);

  void showSuccessSnackBar(String message) =>
      showSnackBar(message, isError: false);
}
