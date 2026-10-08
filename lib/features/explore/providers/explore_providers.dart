import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maktabah_app/shared/books/domain/entities/book.dart';
import 'package:maktabah_app/shared/books/providers/books_providers.dart';

class ExploreQuery {
  final String q;
  final String category;
  final String sort;
  final int limit;

  const ExploreQuery({
    this.q = '',
    this.category = 'all',
    this.sort = 'catalog',
    this.limit = 6,
  });

  ExploreQuery copyWith({
    String? q,
    String? category,
    String? sort,
    int? limit,
  }) {
    return ExploreQuery(
      q: q ?? this.q,
      category: category ?? this.category,
      sort: sort ?? this.sort,
      limit: limit ?? this.limit,
    );
  }
}

class ExploreFeed {
  final List<Book> books;
  final int total;
  final int page;
  final bool hasNextPage;
  final bool isLoadingMore;

  const ExploreFeed({
    required this.books,
    required this.total,
    required this.page,
    required this.hasNextPage,
    this.isLoadingMore = false,
  });

  ExploreFeed copyWith({
    List<Book>? books,
    int? total,
    int? page,
    bool? hasNextPage,
    bool? isLoadingMore,
  }) {
    return ExploreFeed(
      books: books ?? this.books,
      total: total ?? this.total,
      page: page ?? this.page,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ExploreFeedNotifier extends AsyncNotifier<ExploreFeed> {
  @override
  Future<ExploreFeed> build() async {
    final query = ref.watch(exploreQueryProvider);
    final repository = ref.watch(booksRepositoryProvider);

    final result = await repository.getBooks(
      q: query.q,
      category: query.category,
      sort: query.sort,
      page: 1,
      limit: query.limit,
    );

    return ExploreFeed(
      books: result.books,
      total: result.total,
      page: 1,
      hasNextPage: result.hasNextPage,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasNextPage) {
      return;
    }

    final query = ref.read(exploreQueryProvider);
    final repository = ref.read(booksRepositoryProvider);
    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final result = await repository.getBooks(
        q: query.q,
        category: query.category,
        sort: query.sort,
        page: current.page + 1,
        limit: query.limit,
      );

      if (!identical(ref.read(exploreQueryProvider), query)) return;

      state = AsyncData(
        current.copyWith(
          books: [...current.books, ...result.books],
          page: current.page + 1,
          total: result.total,
          hasNextPage: result.hasNextPage,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      if (!identical(ref.read(exploreQueryProvider), query)) return;
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }
}

final exploreFeedProvider =
    AsyncNotifierProvider<ExploreFeedNotifier, ExploreFeed>(
      ExploreFeedNotifier.new,
    );

class ExploreQueryNotifier extends Notifier<ExploreQuery> {
  @override
  ExploreQuery build() => const ExploreQuery();

  void setQuery(String q) {
    state = state.copyWith(q: q);
  }

  void setCategory(String category) {
    state = state.copyWith(category: category);
  }

  void setSort(String sort) {
    state = state.copyWith(sort: sort);
  }
}

final exploreQueryProvider =
    NotifierProvider<ExploreQueryNotifier, ExploreQuery>(
      ExploreQueryNotifier.new,
    );
