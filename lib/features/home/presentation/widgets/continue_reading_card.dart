import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

class ContinueReadingCard extends StatefulWidget {
  const ContinueReadingCard({super.key});

  @override
  State<ContinueReadingCard> createState() => _ContinueReadingCardState();
}

class _ContinueReadingCardState extends State<ContinueReadingCard> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8ECF1)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                'https://maktabah-demo-api.ashahin.workers.dev/images/light.png',
                width: 53,
                height: 75,
                fit: BoxFit.cover,
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'أثر الضوء',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const Text(
                    'ليلى مراد',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const Gap(10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 0.67,
                      minHeight: 4,
                      backgroundColor: Color(0xFFE8ECF1),
                      color: Color(0xFF7A9AA5),
                    ),
                  ),
                  const Gap(6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'مقتطف القراءة',
                        style: TextStyle(fontSize: 9, color: Colors.grey),
                      ),
                      Text(
                        '٦٧٪ مكتمل',
                        style: TextStyle(fontSize: 9, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(12),
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF0F6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.arrowLeft,
                size: 16,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
