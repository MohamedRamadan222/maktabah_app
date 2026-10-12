import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:maktabah_app/core/theme/app_colors.dart';
import 'package:maktabah_app/core/widgets/loading_view.dart';
import 'package:maktabah_app/features/library/presentation/widgets/reading_book_card.dart';
import 'package:maktabah_app/shared/books/providers/books_providers.dart';

class SavedBookTile extends ConsumerWidget {
  final String bookId;

  const SavedBookTile({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(bookDetailsProvider(bookId));
    return detailsAsync.when(
      data: (details) {
        final book = details.book;
        return ReadingBookCard(
          title: book.title,
          author: book.author,
          category: book.categoryName,
          rating: book.rating.toStringAsFixed(1),
          imageUrl: book.coverUrl,
          progress: book.chapterCount.toDouble(),
          bookId: bookId,
        );
      },
      loading: () => const LoadingView(),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.bookX,
              size: 28,
              color: AppColors.mutedColor,
            ),
            const Gap(8),
            const Text(
              'تعذّر تحميل الكتاب',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: AppColors.mutedColor),
            ),
            TextButton(
              onPressed: () => ref.invalidate(bookDetailsProvider(bookId)),
              child: const Text(
                'إعادة المحاولة',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
