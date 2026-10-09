import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maktabah_app/core/error/failure.dart';
import 'package:maktabah_app/core/widgets/error_view.dart';
import 'package:maktabah_app/core/widgets/loading_view.dart';
import 'package:maktabah_app/shared/books/domain/entities/chapter.dart';
import 'package:maktabah_app/shared/books/providers/books_providers.dart';
import 'package:maktabah_app/shared/books/providers/reader_providers.dart';

import '../widgets/reader_app_bar.dart';
import '../widgets/reader_bottom_bar.dart';
import '../widgets/reader_chapter_content.dart';
import '../widgets/reader_controls.dart';

class ReadBook extends ConsumerStatefulWidget {
  final String bookId;

  const ReadBook({super.key, required this.bookId});

  @override
  ConsumerState<ReadBook> createState() => _ReadBookState();
}

class _ReadBookState extends ConsumerState<ReadBook> {
  int _chapterIndex = 0;
  int _fontSize = 18;
  final _scrollController = ScrollController(keepScrollOffset: false);
  final _readingProgress = ValueNotifier<double>(0);
  bool _hasScrolledForward = false;
  bool _chapterChangeScheduled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateReadingProgress);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _readingProgress.dispose();
    super.dispose();
  }

  void _updateReadingProgress() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    _readingProgress.value = position.maxScrollExtent > 0
        ? (position.pixels / position.maxScrollExtent).clamp(0.0, 1.0)
        : 1;
  }

  void _changeChapter(int index) {
    if (index == _chapterIndex) return;
    setState(() {
      _chapterIndex = index;
      _hasScrolledForward = false;
      _chapterChangeScheduled = false;
    });
    _readingProgress.value = 0;
  }

  bool _handleChapterScroll(ScrollNotification notification, Chapter chapter) {
    if (notification.depth != 0 || chapter.index != _chapterIndex) return false;

    if (notification is ScrollStartNotification) {
      _hasScrolledForward = false;
    } else if (notification is UserScrollNotification &&
        notification.direction != ScrollDirection.idle) {
      _hasScrolledForward = notification.direction == ScrollDirection.reverse;
    }

    final nextIndex = chapter.nextChapterIndex;
    if (notification is ScrollEndNotification &&
        _hasScrolledForward &&
        notification.metrics.extentAfter <= 1 &&
        nextIndex != null &&
        !_chapterChangeScheduled) {
      _chapterChangeScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || chapter.index != _chapterIndex) return;
        _changeChapter(nextIndex);
      });
      WidgetsBinding.instance.ensureVisualUpdate();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final key = (bookId: widget.bookId, index: _chapterIndex);
    final chapterAsync = ref.watch(chapterProvider(key));
    final chapter = chapterAsync.asData?.value;
    final details = ref.watch(bookDetailsProvider(widget.bookId)).value;
    final summaries =
        ref.watch(chapterSummariesProvider(widget.bookId)).value ?? [];
    final chapterNumber =
        chapter?.number ??
        summaries
            .where((summary) => summary.index == _chapterIndex)
            .firstOrNull
            ?.number ??
        _chapterIndex + 1;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xffFCFAF7),
        appBar: ReaderAppBar(
          title: details?.book.title ?? '',
          author: details?.book.author ?? '',
          onBackPressed: () => Navigator.pop(context),
          onBookmarkPressed: () {},
          onThemePressed: () {},
        ),
        body: Column(
          children: [
            ReaderControls(
              summaries: summaries,
              chapterIndex: _chapterIndex,
              fontSize: _fontSize,
              onChapterChanged: _changeChapter,
              onIncreaseFontSize: () {
                setState(() {
                  _fontSize = (_fontSize + 2).clamp(14, 32).toInt();
                });
              },
              onDecreaseFontSize: () {
                setState(() {
                  _fontSize = (_fontSize - 2).clamp(14, 32).toInt();
                });
              },
            ),
            Expanded(
              child: chapterAsync.when(
                data: (chapter) => NotificationListener<ScrollNotification>(
                  onNotification: (notification) =>
                      _handleChapterScroll(notification, chapter),
                  child: ReaderChapterContent(
                    key: ValueKey((widget.bookId, chapter.index)),
                    chapter: chapter,
                    fontSize: _fontSize,
                    scrollController: _scrollController,
                  ),
                ),
                loading: () => const LoadingView(),
                error: (error, stack) => ErrorView(
                  message: error is AppFailure
                      ? error.message
                      : 'تعذّر تحميل الفصل',
                  onRetry: () => ref.invalidate(chapterProvider(key)),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: ValueListenableBuilder<double>(
          valueListenable: _readingProgress,
          builder: (context, progress, child) => ReaderBottomBar(
            chapterNumber: chapterNumber,
            chapterCount: chapter?.chapterCount ?? summaries.length,
            progress: progress,
            onPreviousChapter: chapter?.previousChapterIndex == null
                ? null
                : () => _changeChapter(chapter!.previousChapterIndex!),
            onNextChapter: chapter?.nextChapterIndex == null
                ? null
                : () => _changeChapter(chapter!.nextChapterIndex!),
          ),
        ),
      ),
    );
  }
}
