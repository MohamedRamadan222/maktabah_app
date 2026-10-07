import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void showSimpleSnackBar(BuildContext context, {required bool isAdded}) {
  final messenger = ScaffoldMessenger.of(context);

  final message = isAdded
      ? 'أُضيف الكتاب إلى المحفوظة'
      : 'أُزيل الكتاب من المحفوظة';
  final icon = isAdded ? LucideIcons.check : LucideIcons.bookmark;

  messenger
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1B2F4B),
        elevation: 0,
        duration: const Duration(seconds: 3),
        width: 245,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white70, size: 18),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
}
