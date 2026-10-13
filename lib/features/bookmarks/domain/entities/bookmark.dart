class Bookmark {
  final String bookId;
  final String bookTitle;
  final String author;
  final int chapterIndex;
  final int chapterNumber;
  final String chapterTitle;

  const Bookmark({
    required this.bookId,
    required this.bookTitle,
    required this.author,
    required this.chapterIndex,
    required this.chapterNumber,
    required this.chapterTitle,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      bookId: json['bookId'] as String,
      bookTitle: json['bookTitle'] as String,
      author: json['author'] as String,
      chapterIndex: json['chapterIndex'] as int,
      chapterNumber: json['chapterNumber'] as int,
      chapterTitle: json['chapterTitle'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'bookTitle': bookTitle,
      'author': author,
      'chapterIndex': chapterIndex,
      'chapterNumber': chapterNumber,
      'chapterTitle': chapterTitle,
    };
  }
}
