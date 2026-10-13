import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:maktabah_app/core/theme/app_colors.dart';
import 'package:maktabah_app/features/reader/presentation/views/reader.dart';

import '../../domain/entities/bookmark.dart';
import '../providers/bookmarks_providers.dart';
import 'show_bookmark_snackbar.dart';

class BookmarkTile extends ConsumerStatefulWidget {
  final Bookmark bookmark;

  const BookmarkTile({super.key, required this.bookmark});

  @override
  ConsumerState<BookmarkTile> createState() => _BookmarkTileState();
}

class _BookmarkTileState extends ConsumerState<BookmarkTile> {
  bool _isDeleting = false;

  Future<void> _deleteBookmark() async {
    if (_isDeleting) return;
    setState(() => _isDeleting = true);
    try {
      await ref.read(bookmarksProvider.notifier).unsave(widget.bookmark.bookId);
      if (!mounted) return;
      showBookmarkSnackBar(context, message: 'أُزيلت العلامة');
    } catch (_) {
      if (!mounted) return;
      showBookmarkSnackBar(
        context,
        message: 'تعذّر حذف العلامة، حاول مرة أخرى',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmark = widget.bookmark;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.borderColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const Icon(
          LucideIcons.bookmark,
          color: AppColors.primaryColor,
          size: 24,
        ),
        title: Text(
          bookmark.bookTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(4),
            Text(
              bookmark.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: AppColors.mutedColor),
            ),
            const Gap(6),
            Text(
              'الفصل ${bookmark.chapterNumber}: ${bookmark.chapterTitle}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: AppColors.goldColor),
            ),
          ],
        ),
        trailing: IconButton(
          tooltip: 'حذف العلامة',
          onPressed: _isDeleting ? null : _deleteBookmark,
          icon: const Icon(Icons.delete_outline, color: AppColors.mutedColor),
        ),
        onTap: _isDeleting
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReadBook(
                      bookId: bookmark.bookId,
                      initialChapterIndex: bookmark.chapterIndex,
                    ),
                  ),
                );
              },
      ),
    );
  }
}
