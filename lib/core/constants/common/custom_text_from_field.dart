import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../theme/app_colors.dart';

class CustomTextFromField extends StatelessWidget {
  const CustomTextFromField({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffE3E8EF)),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 20, color: Colors.grey),
            const Gap(10),
            const Expanded(
              child: TextField(
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  hintText: 'ابحث عن كتابك القادم...',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryColor,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            Container(width: 1, height: 24, color: const Color(0xffE3E8EF)),
            const Gap(12),
            Icon(
              Icons.menu_book_outlined,
              size: 20,
              color: AppColors.primaryColor.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
