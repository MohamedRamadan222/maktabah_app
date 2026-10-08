class Book {
  final String id;
  final String title;
  final String author;
  final String categoryId;
  final String categoryName;
  final String language;
  final String description;
  final String tagline;
  final String coverUrl;
  final String coverBackgroundColor;
  final String direction;
  final String contentType;
  final double rating;
  final int pageCount;
  final int coverWidth;
  final int coverHeight;
  final int chapterCount;
  final bool isFictional;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.categoryId,
    required this.categoryName,
    required this.language,
    required this.description,
    required this.tagline,
    required this.coverUrl,
    required this.coverBackgroundColor,
    required this.direction,
    required this.contentType,
    required this.rating,
    required this.pageCount,
    required this.coverWidth,
    required this.coverHeight,
    required this.chapterCount,
    required this.isFictional,
  });
}
