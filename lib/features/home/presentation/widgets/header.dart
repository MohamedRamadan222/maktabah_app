import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF0F4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDDE5EB)),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: -6,
              child: Text(
                '”',
                style: TextStyle(
                  fontSize: 172,
                  height: 1,
                  color: AppColors.primaryColor.withValues(alpha: 0.12),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.sparkles,
                      size: 14,
                      color: Color(0xFFC8923A),
                    ),
                    const Gap(6),
                    const Text(
                      'بين السطور',
                      style: TextStyle(fontSize: 10, color: Color(0xFF617286)),
                    ),
                  ],
                ),
                const Gap(14),
                const Text(
                  'بعض الكتب لا نُنهيها، بل نبدأ بها حكاية\n جديدة.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.9,
                  ),
                ),
                const Gap(12),
                const Text(
                  'من وحي مكتبة',
                  style: TextStyle(fontSize: 10, color: Color(0xFF617286)),
                ),
                Gap(5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
