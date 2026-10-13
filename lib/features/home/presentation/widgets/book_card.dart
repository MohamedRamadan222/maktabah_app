import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maktabah_app/core/constants/common/show_simple_snackbar.dart';

import '../../../../shared/books/providers/saved_books_provider.dart';
import '../../../../core/theme/app_colors.dart';
import 'book_details_sheet.dart';

class BookCard extends ConsumerWidget {
  final String title;
  final String author;
  final String rating;
  final String imageUrl;
  final double? width;
  final double? height;
  final String bookId;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.rating,
    required this.imageUrl,
    this.width,
    this.height,
    required this.bookId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = ref.watch(savedBooksProvider).contains(bookId);
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
            builder: (_) =>
                ScaffoldMessenger(child: BookDetailsSheet(bookId: bookId)),
          );
        },
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
                    onTap: () {
                      final saved = ref.read(savedBooksProvider.notifier);
                      if (isSaved) {
                        saved.unsave(bookId);
                      } else {
                        saved.save(bookId);
                      }
                      showSimpleSnackBar(context, isAdded: !isSaved);
                    },
                    child: Icon(
                      isSaved
                          ? LucideIcons.bookmarkCheck
                          : LucideIcons.bookmark,
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
      ),
    );
  }
}
