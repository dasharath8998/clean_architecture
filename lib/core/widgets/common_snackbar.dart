import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class CommonSnackbar {
  CommonSnackbar._();

  static void showError(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline_rounded,
    );
  }

  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.info,
      icon: Icons.info_outline_rounded,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSizes.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: AppSizes.iconMd),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
