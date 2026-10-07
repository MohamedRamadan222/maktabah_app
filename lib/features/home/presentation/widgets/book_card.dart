import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String rating;
  final String imageUrl;
  final double? width;
  final double? height;
  final VoidCallback? onBookmarkTap;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.rating,
    required this.imageUrl,
    this.onBookmarkTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        width: 125,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                imageUrl,
                width: width ?? 125,
                height: height ?? 178,
                fit: BoxFit.cover,
              ),
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
