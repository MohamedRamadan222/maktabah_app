import 'package:maktabah_app/shared/books/data/models/book_model.dart';
import 'package:maktabah_app/shared/books/domain/entities/book_page.dart';

class BookPageModel {
  final List<BookModel> books;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const BookPageModel({
    required this.books,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory BookPageModel.fromEnvelope(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>;
    final pagination =
        (json['meta'] as Map<String, dynamic>)['pagination']
            as Map<String, dynamic>;

    return BookPageModel(
      books: dataList
          .map((item) => BookModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      page: pagination['page'] as int,
      limit: pagination['limit'] as int,
      total: pagination['total'] as int,
      totalPages: pagination['totalPages'] as int,
      hasNextPage: pagination['hasNextPage'] as bool,
      hasPreviousPage: pagination['hasPreviousPage'] as bool,
    );
  }

  BookPage toEntity() {
    return BookPage(
      books: books.map((bookModel) => bookModel.toEntity()).toList(),
      page: page,
      limit: limit,
      total: total,
      totalPages: totalPages,
      hasNextPage: hasNextPage,
      hasPreviousPage: hasPreviousPage,
    );
  }
}
