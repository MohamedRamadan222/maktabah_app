class Chapter {
  final int index;
  final int number;
  final int chapterCount;
  final int? previousChapterIndex;
  final int? nextChapterIndex;
  final String bookId;
  final String title;
  final List<String> paragraphs;

  const Chapter({
    required this.index,
    required this.number,
    required this.chapterCount,
    required this.bookId,
    required this.title,
    required this.paragraphs,
    required this.previousChapterIndex,
    required this.nextChapterIndex,
  });
}
