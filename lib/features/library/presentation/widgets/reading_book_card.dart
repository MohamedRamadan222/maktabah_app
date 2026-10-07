import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/widgets/book_detailes_sheet.dart';

class ReadingBookCard extends StatelessWidget {
  final String title;
  final String author;
  final String category;
  final String rating;
  final String imageUrl;
  final double progress; // 0..1
  final VoidCallback? onBookmarkTap;

  const ReadingBookCard({
    super.key,
    required this.title,
    required this.author,
    required this.category,
    required this.rating,
    required this.imageUrl,
    required this.progress,
    this.onBookmarkTap,
  });

  String _toArabic(String s) {
    const en = '0123456789';
    const ar = '٠١٢٣٤٥٦٧٨٩';
    return s.split('').map((c) {
      final i = en.indexOf(c);
      return i == -1 ? c : ar[i];
    }).join();
  }

  @override
  Widget build(BuildContext context) {
    final percent = _toArabic('${(progress * 100).round()}');

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            constraints: const BoxConstraints(maxWidth: 480),
            clipBehavior: Clip.antiAlias,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (_) => const ScaffoldMessenger(
              child: BookDetailsSheet(),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onBookmarkTap,
                  child: Icon(
                    LucideIcons.bookmark,
                    size: 16,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const Gap(2),
            Text(
              author,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const Gap(6),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 14,
                  color: Color(0xFFC8923A),
                ),
                const Gap(4),
                Text(
                  rating,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const Gap(6),
                const Text(
                  '•',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const Gap(6),
                Text(
                  category,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
            const Gap(10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: Colors.black12,
                color: AppColors.primaryColor,
              ),
            ),
            const Gap(6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'تقدم القراءة',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Text(
                  '$percent٪',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
