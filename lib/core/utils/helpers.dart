import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme/app_pallete.dart';

enum SnackType { normal, success, error }

class Helpers {
  Helpers._();

  static void showSnackBar(
      BuildContext context,
      String message, {
        SnackType type = SnackType.normal,
      }) {
    final theme = Theme.of(context);

    final Color backgroundColor;
    switch (type) {
      case SnackType.success:
        backgroundColor = Pallete.successColor;
        break;
      case SnackType.error:
        backgroundColor = Pallete.errorColor;
        break;
      case SnackType.normal:
        backgroundColor = theme.colorScheme.primary;
    }

    Flushbar(
      message: message,
      messageSize: 15,
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(14),
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 450),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      icon: _iconForType(type),
      boxShadows: [
        BoxShadow(
          color: backgroundColor.withValues(alpha: 0.35),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ).show(context);
  }

  static Future<void> makePhoneCall(
      BuildContext context,
      String phoneNumber,
      ) async {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final uri = Uri(scheme: 'tel', path: cleaned);

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('Phone call error: $e');
      if (context.mounted) {
        showSnackBar(
          context,
          'Could not make call. Please try again.',
          type: SnackType.error,
        );
      }
    }
  }

  static Icon _iconForType(SnackType type) {
    switch (type) {
      case SnackType.success:
        return const Icon(Icons.check_circle_outline, color: Colors.white);
      case SnackType.error:
        return const Icon(Icons.error_outline, color: Colors.white);
      case SnackType.normal:
        return const Icon(Icons.info_outline, color: Colors.white);
    }
  }
}