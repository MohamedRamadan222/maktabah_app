# Maktabah app implementation roadmap

Start at Step 1 and carry out the tasks in order. Each numbered step tells you exactly which file to open and what to write or change. Finish the working result at the end of each section before moving on.

The existing visual layouts are your starting point. First connect Explore to the real API; then complete the other features around that working catalog.

**The order is:** real catalog → search and categories → book details → reader → local initialization → saved books → reading progress → bookmarks → Library → Home → preferences → installed build.

API response shapes and verified examples are in [API reference](API_RESEARCH.md). The signatures and local rules below are the implementation choices for this app.

## First put real books on the Explore screen

### Step 1 Add the three packages

[pubspec.yaml](../pubspec.yaml)

- [ ] Run `flutter pub add dio flutter_riverpod shared_preferences` in the project root. Keep the existing icon, spacing, and font configuration.

### Step 2 Write the API constants

[lib/core/network/api_constants.dart](../lib/core/network/api_constants.dart)

- [ ] Create `ApiConstants` with `baseUrl = 'https://maktabah-demo-api.ashahin.workers.dev'` and `apiPrefix = '/api/v1'`. Use this origin with paths such as `/api/v1/books`.

### Step 3 Write the failure type

[lib/core/error/failure.dart](../lib/core/error/failure.dart)

- [ ] Create `AppFailure` implementing `Exception`, with a required `message` and optional `code` and `statusCode`. Use it for failed requests and invalid response data.

### Step 4 Create the shared HTTP client

[lib/core/network/dio_provider.dart](../lib/core/network/dio_provider.dart)

- [ ] Create `dioProvider` returning one Dio instance. Set `baseUrl` from `ApiConstants` and connect/receive timeouts to 15 seconds. Do not create a new client inside a screen.

### Step 5 Create the three result widgets

[lib/core/widgets/loading_view.dart](../lib/core/widgets/loading_view.dart)  
[lib/core/widgets/error_view.dart](../lib/core/widgets/error_view.dart)  
[lib/core/widgets/empty_view.dart](../lib/core/widgets/empty_view.dart)

- [ ] Write `LoadingView` with a progress indicator, `ErrorView` with `message` and `onRetry`, and `EmptyView` with a message. The screens will use these whenever an asynchronous result is loading, failed, or empty.

### Step 6 Write the Book entity

[lib/shared/books/domain/entities/book.dart](../lib/shared/books/domain/entities/book.dart)

- [ ] Create an immutable `Book` with the exact fields in the Book fields table below. Use `double` for rating, `int` for counts/dimensions, and a normal string for the absolute cover URL.

### Step 7 Write the Book JSON model

[lib/shared/books/data/models/book_model.dart](../lib/shared/books/data/models/book_model.dart)

- [ ] Create `BookModel.fromJson(Map<String, dynamic>)` for one book object and `toEntity()` returning `Book`. Convert rating through `num.toDouble()`. Preserve the API ID; do not generate an ID from the title.

### Step 8 Write the paginated books result

`lib/shared/books/domain/entities/book_page.dart` **create this file**  
`lib/shared/books/data/models/book_page_model.dart` **create this file**

- [ ] Create these two new files. `BookPage` contains `List<Book> books`, `page`, `limit`, `total`, `totalPages`, `hasNextPage`, and `hasPreviousPage`.
- [ ] Create `BookPageModel.fromEnvelope(Map<String, dynamic>)`. Read books from `data` and page fields from `meta.pagination`; convert to `BookPage`. An empty `data` list is a valid result.

### Step 9 Implement the first API method

[lib/shared/books/data/sources/books_api.dart](../lib/shared/books/data/sources/books_api.dart)

- [ ] Create `BooksApi(Dio dio)`. Add `fetchBooks({String q = '', String category = 'all', int page = 1, int limit = 12, String sort = 'catalog'})` returning `Future<BookPageModel>`.
- [ ] Send GET `/api/v1/books` with those five names in `queryParameters`. Parse the complete response envelope with `BookPageModel.fromEnvelope`.

### Step 10 Write the first repository contract

[lib/shared/books/domain/repositories/books_repository.dart](../lib/shared/books/domain/repositories/books_repository.dart)

- [ ] Declare an abstract `BooksRepository` with `getBooks` taking the same five parameters and returning `Future<BookPage>`. Add further operations to this same interface in later steps.

### Step 11 Implement the books repository

[lib/shared/books/data/repositories/books_repository_impl.dart](../lib/shared/books/data/repositories/books_repository_impl.dart)

- [ ] Create `BooksRepositoryImpl(BooksApi api)` implementing `BooksRepository`. Its `getBooks` calls `fetchBooks` and returns `model.toEntity()`.
- [ ] Translate Dio failures into `AppFailure`: preserve `error.message` and `error.code` when the response supplies them, and give timeouts or malformed JSON a usable message.

### Step 12 Connect the books dependencies

[lib/shared/books/providers/books_providers.dart](../lib/shared/books/providers/books_providers.dart)

- [ ] Create `booksApiProvider` from `dioProvider`, then `booksRepositoryProvider` from `booksApiProvider`.
- [ ] Create `catalogProvider` as a `FutureProvider<BookPage>` calling `getBooks(limit: 12)`.

### Step 13 Put ProviderScope around the app

[lib/main.dart](../lib/main.dart)

- [ ] Change `main()` to run `ProviderScope(child: MyApp())`. Keep the existing `MaterialApp` and navigation.

### Step 14 Replace the Explore mock grid

[lib/features/explore/presentation/views/explore_screen.dart](../lib/features/explore/presentation/views/explore_screen.dart)

- [ ] Convert the screen to a Riverpod consumer and watch `catalogProvider`. Use the three result widgets for loading/error/empty states. Retry by invalidating `catalogProvider`.
- [ ] Set grid `itemCount` to the returned books length. Pass each book's title, author, formatted rating, and `coverUrl` into the existing `BookCard`. Replace the fixed result count with `page.total`. Do not connect the other screens yet.

**Working result:** Explore shows the real catalog. Stop here until different books show different titles and covers.

## Then finish Explore categories search and pagination

### Step 15 Write the category entity and model

[lib/shared/books/domain/entities/category.dart](../lib/shared/books/domain/entities/category.dart)  
[lib/shared/books/data/models/category_model.dart](../lib/shared/books/data/models/category_model.dart)

- [ ] Create `Category(id, name, icon, bookCount)`. `icon` is the API's string identifier.
- [ ] Create `CategoryModel.fromJson` and `toEntity()`.

### Step 16 Add category loading to the books layer

[lib/shared/books/data/sources/books_api.dart](../lib/shared/books/data/sources/books_api.dart)  
[lib/shared/books/domain/repositories/books_repository.dart](../lib/shared/books/domain/repositories/books_repository.dart)  
[lib/shared/books/data/repositories/books_repository_impl.dart](../lib/shared/books/data/repositories/books_repository_impl.dart)  
[lib/shared/books/providers/books_providers.dart](../lib/shared/books/providers/books_providers.dart)

- [ ] Add `fetchCategories()` returning models from GET `/api/v1/categories` → `data`. Add `getCategories()` returning `Future<List<Category>>` to the interface and implementation.
- [ ] Expose the result as `categoriesProvider`. Do not send query parameters to this endpoint.

### Step 17 Make CategoryChips controlled by its screen

[lib/features/home/presentation/widgets/categores_items.dart](../lib/features/home/presentation/widgets/categories_items.dart)

- [ ] Keep `CategoryItem` for display and add a required `selectedId` to `CategoryChips`. Determine selection by comparing IDs, and send the tapped item through `onSelected`. Remove its independent `_selected` index.
- [ ] Map API icon strings to local icons: `feather`, `sprout`, `history`, and `science`. Include a fallback icon. Prepend an All item with ID `all` when preparing a screen's items.
- [ ] Update the existing Home and Explore call sites for the new selected-ID parameter.

### Step 18 Make the search widget send its text

[lib/core/constants/common/custom_text_from_field.dart](../lib/core/constants/common/custom_text_from_field.dart)

- [ ] Add a required `ValueChanged<String> onSubmitted` parameter and pass it to the inner TextField. Remove `const` from the TextField where necessary.
- [ ] Update every existing `CustomTextFromField()` call site to supply a callback. Connect Explore in the next step; connect Home when its screen is finished.

### Step 19 Create the Explore query state

[lib/features/explore/providers/explore_providers.dart](../lib/features/explore/providers/explore_providers.dart)

- [ ] In this file create `ExploreQuery` with `q`, `category`, `sort`, `page`, and `limit`, plus `copyWith`. Defaults: empty query, `all`, `catalog`, page `1`, limit `4`.
- [ ] Create `ExploreQueryNotifier` and `exploreQueryProvider`. Add `setQuery`, `setCategory`, `setSort`, `nextPage`, and `previousPage`. The first three always reset page to `1`; previous page cannot go below `1`.
- [ ] Create `exploreResultsProvider` as a FutureProvider that watches the query state and calls `booksRepositoryProvider.getBooks` with it. This provider must depend on the complete query so an old request cannot replace a newer query's result.

### Step 20 Wire Explore to that state

[lib/features/explore/presentation/views/explore_screen.dart](../lib/features/explore/presentation/views/explore_screen.dart)

- [ ] Replace `catalogProvider` with `exploreResultsProvider`. Watch `categoriesProvider` and `exploreQueryProvider` for the category row and selected values.
- [ ] Submit search to `setQuery`, category taps to `setCategory`, and sort selection to `setSort`. Offer only `catalog`, `title`, and `rating`. Reject a query longer than 200 code units before requesting it.
- [ ] Add Previous and Next buttons using `hasPreviousPage` and `hasNextPage`, and display the current page. Keep the selected filters visible while results load.

**Working result:** Explore can search, filter, sort, and visit every catalog page.

## Then make each card open its own book details

### Step 21 Write the details entity

[lib/shared/books/domain/entities/book_details.dart](../lib/shared/books/domain/entities/book_details.dart)

- [ ] Create `ChapterSummary` with `index`, `number`, `title`, and `paragraphCount`.
- [ ] Create `BookDetails` with `Book book`, `List<ChapterSummary> chapters`, and `String notice`.

### Step 22 Write the details model

[lib/shared/books/data/models/book_details_model.dart](../lib/shared/books/data/models/book_details_model.dart)

- [ ] Create `BookDetailsModel.fromJson` for the single object in response `data`. Its book fields are at that object's top level; the API does not nest them under a `book` key.
- [ ] Reuse `BookModel` for the book portion, parse the `chapters` summaries, and return a `BookDetails` from `toEntity()`.

### Step 23 Add details loading

[lib/shared/books/data/sources/books_api.dart](../lib/shared/books/data/sources/books_api.dart)  
[lib/shared/books/domain/repositories/books_repository.dart](../lib/shared/books/domain/repositories/books_repository.dart)  
[lib/shared/books/data/repositories/books_repository_impl.dart](../lib/shared/books/data/repositories/books_repository_impl.dart)

- [ ] Add `fetchBookDetails(String bookId)` using GET `/api/v1/books/$bookId` with no query parameters. Return `BookDetailsModel`.
- [ ] Add `getBookDetails(String bookId)` returning `Future<BookDetails>` to the repository interface and implementation.

### Step 24 Create the details provider

[lib/shared/books/providers/book_details_provider.dart](../lib/shared/books/providers/book_details_provider.dart)

- [ ] Create `bookDetailsProvider` as a `FutureProvider.family<BookDetails, String>` keyed by book ID and backed by `getBookDetails`.

### Step 25 Pass the ID and render those details

[lib/features/home/presentation/widgets/book_card.dart](../lib/features/home/presentation/widgets/book_card.dart)  
[lib/features/library/presentation/widgets/reading_book_card.dart](../lib/features/library/presentation/widgets/reading_book_card.dart)  
[lib/features/home/presentation/widgets/book_detailes_sheet.dart](../lib/features/home/presentation/widgets/book_details_sheet.dart)  
[lib/features/explore/presentation/views/explore_screen.dart](../lib/features/explore/presentation/views/explore_screen.dart)  
[lib/features/home/presentation/views/home_screen.dart](../lib/features/home/presentation/views/home_screen.dart)  
[lib/features/library/presentation/views/library_screen.dart](../lib/features/library/presentation/views/library_screen.dart)

- [ ] Add a required `bookId` to both card constructors and to `BookDetailsSheet`. Each card passes its ID into the sheet it opens.
- [ ] Supply real IDs in Explore. Until their mock lists are replaced, use `slow` for Home's existing على مهل sample and `sea` for Library's existing رسائل إلى البحر sample so all call sites compile.
- [ ] Make the sheet a consumer of `bookDetailsProvider(bookId)`. Replace the fixed cover, title, author, rating, category, description, page count, language, chapter count, and notice with returned values.
- [ ] Retain close/loading/error/retry actions. Keep the existing save button for later connection. Connect the reading button after the reader accepts a book ID.

**Working result:** Two different cards open two different sets of book details.

## Then build reading and chapter navigation

### Step 26 Write the chapter entity

[lib/features/reader/domain/entities/chapter.dart](../lib/features/reader/domain/entities/chapter.dart)

- [ ] Create `Chapter` with `bookId`, `index`, `number`, `title`, `List<String> paragraphs`, `chapterCount`, nullable `previousChapterIndex`, and nullable `nextChapterIndex`.

### Step 27 Write the chapter model

[lib/features/reader/data/models/chapter_model.dart](../lib/features/reader/data/models/chapter_model.dart)

- [ ] Create `ChapterModel.fromJson` for the full chapter's `data` object and `toEntity()`. Leave missing navigation targets as null; do not turn them into index `0`.

### Step 28 Implement ReaderApi

[lib/features/reader/data/sources/reader_api.dart](../lib/features/reader/data/sources/reader_api.dart)

- [ ] Create `ReaderApi(Dio dio)`. Add `fetchChapter(String bookId, int index)` using GET `/api/v1/books/$bookId/chapters/$index`.
- [ ] Add `fetchChapterSummaries(String bookId)` using GET `/api/v1/books/$bookId/chapters`, parsing the summaries already defined with book details. Both requests have no query parameters.

### Step 29 Write the reader repository

[lib/features/reader/domain/repositories/reader_repository.dart](../lib/features/reader/domain/repositories/reader_repository.dart)  
[lib/features/reader/data/repositories/reader_repository_impl.dart](../lib/features/reader/data/repositories/reader_repository_impl.dart)

- [ ] Declare `getChapter(String bookId, int index)` returning `Future<Chapter>` and `getChapterSummaries(String bookId)` returning `Future<List<ChapterSummary>>`.
- [ ] Implement these in `ReaderRepositoryImpl` using ReaderApi and the same failure conversion used for books. Local progress operations are added after storage exists.

### Step 30 Create the reader providers

[lib/features/reader/presentation/providers/reader_providers.dart](../lib/features/reader/presentation/providers/reader_providers.dart)

- [ ] Create `readerApiProvider` and `readerRepositoryProvider`.
- [ ] Create a `chapterProvider` family whose key is a record containing both book ID and chapter index, for example `({String bookId, int index})`. Create `chapterSummariesProvider` keyed by book ID.

### Step 31 Replace the empty reader screen

[lib/features/reader/presentation/views/reader.dart](../lib/features/reader/presentation/views/reader.dart)  
[lib/features/home/presentation/widgets/book_detailes_sheet.dart](../lib/features/home/presentation/widgets/book_details_sheet.dart)

- [ ] Make `ReadBook` a ConsumerStatefulWidget accepting required `bookId`, `initialChapterIndex` defaulting to `0`, and `initialScroll` defaulting to `0.0`. Keep the current chapter index in its state.
- [ ] Watch `chapterProvider((bookId: widget.bookId, index: currentIndex))`. Render its title and paragraphs in an RTL SingleChildScrollView with a ScrollController.
- [ ] Use loading/error/retry states. Change the sheet's reading action to push `ReadBook(bookId: widget.bookId)`.

### Step 32 Connect chapter selection and next previous actions

[lib/features/reader/presentation/views/reader.dart](../lib/features/reader/presentation/views/reader.dart)

- [ ] Use `chapterSummariesProvider(bookId)` for a chapter picker. Selecting a summary sets the current index to `summary.index`. Display `summary.number` to the reader.
- [ ] Wire Previous and Next to the returned nullable navigation indexes; disable each action when its target is null.
- [ ] When the index changes, reset the scroll position after the new chapter is laid out. Ignore the old chapter's scroll events while replacing content.

**Working result:** The selected book opens real chapter text, and the reader can visit all of its sample chapters.

## Then create local storage and initialize it once

### Step 33 Write reading position and history types

[lib/features/reader/domain/entities/reading_progress.dart](../lib/features/reader/domain/entities/reading_progress.dart)

- [ ] Create `ReadingProgress` with `int chapter`, `double scroll`, and `int updatedAt`. Add an `overallFraction(int chapterCount)` calculation clamped to `0..1`: `(chapter + scroll) / chapterCount`.
- [ ] In the same file create `ReadingHistory` with `Map<String, ReadingProgress> positions` and nullable `String lastRead`. Sources will load/update these two fields together.

### Step 34 Write the bookmark entity

[lib/features/bookmarks/domain/entities/bookmark.dart](../lib/features/bookmarks/domain/entities/bookmark.dart)

- [ ] Create `Bookmark` with `String bookId`, `int chapter`, and `double scroll`.
- [ ] Give it a stable identity derived from book ID, chapter, and scroll rounded to three decimal places. Use the same identity for duplicate prevention and deletion. A bookmark identifies a reading location, separately from a saved whole book.

### Step 35 Write the preferences entity

`lib/features/reader/domain/entities/reader_preferences.dart` **create this file**

- [ ] Create this new file with `ReaderPreferences(double fontSize, String theme)`. Use defaults `21` and `light`; support theme values `light` and `dark`.

### Step 36 Implement the local store

[lib/core/storage/_store.dart](../lib/core/storage/_store.dart)

- [ ] Create `LocalStore(SharedPreferencesAsync preferences)` with `readState()` and `updateState(transform)`. Store one JSON document under `maktabah.state.v1`.
- [ ] Serialize all update operations. Each transform receives the latest complete document and changes only its own fields. Complete each operation after the write succeeds; a failed operation must not prevent later operations from running.
- [ ] Use the local document shape below. Missing storage means first launch; unreadable stored JSON is a recovery error and must not be replaced silently.

### Step 37 Expose one store instance

[lib/core/storage/local](../lib/core/storage/local)

- [ ] Rename this empty extensionless file to `lib/core/storage/local_store_provider.dart`. Create `localStoreProvider` exposing the LocalStore shared by every feature source.

### Step 38 Write the demo state model

`lib/features/library/data/models/demo_state_model.dart` **create this file**

- [ ] Create this new file. Parse `data.saved`, `data.progress`, `data.bookmarks`, `data.preferences`, and `data.lastRead` into the types already written.
- [ ] Validate the complete seed before saving: unique saved IDs, nonnegative chapter indexes, scroll `0..1`, integer timestamps, positive font size, and an allowed theme.
- [ ] Add `toStorageJson()` that adds your app's `schemaVersion: 1` and `initialized: true` to these five user-data fields.

### Step 39 Implement DemoStateApi

[lib/features/library/data/demo_state_api.dart](../lib/features/library/data/demo_state_api.dart)

- [ ] Create `DemoStateApi(Dio dio)` with `fetchDemoState()` returning the parsed model from GET `/api/v1/demo-state`. Send no query parameters. Expose its dependency through a provider used by bootstrap.

### Step 40 Add bootstrap and gate the app screens

`lib/core/bootstrap/app_bootstrap_provider.dart` **create this file**  
[lib/main.dart](../lib/main.dart)

- [ ] Create the new `appBootstrapProvider` as a FutureProvider. Read LocalStore first. If it is initialized, finish without fetching demo-state.
- [ ] For a genuinely new store, fetch and validate the seed, then write all seed fields plus the initialization marker in one queued update. Recheck the latest document in that update before applying the seed.
- [ ] If existing user data lacks a marker, preserve it and add the version/marker. Treat empty saved/progress/bookmark collections in an initialized document as valid.
- [ ] Make MyApp watch bootstrap before rendering MainScreen. Show LoadingView while it runs. On first-launch failure, provide Retry and Start empty; Start empty writes the defaults below with initialized true and reloads bootstrap.
- [ ] Show stored-data corruption as a recovery error. Any reset action must be explicit and explain that it removes local user state.

**Working result:** First launch creates the local state. Later launches keep that state, including deliberately empty collections.

## Then make saving whole books work everywhere

### Step 41 Implement the saved books local source

[lib/features/library/data/saved_books_local_source.dart](../lib/features/library/data/saved_books_local_source.dart)

- [ ] Create `SavedBooksLocalSource(LocalStore store)` with `loadSavedIds()`, `add(bookId)`, and `remove(bookId)`, returning `Future<Set<String>>`.
- [ ] Inside updates, convert the current `saved` list to a set, apply the action, and write it back as a list. Preserve every other document field.

### Step 42 Write and implement the saved books repository

[lib/features/library/domain/saved_books_repository.dart](../lib/features/library/domain/saved_books_repository.dart)  
[lib/features/library/data/saved_books_repository_impl.dart](../lib/features/library/data/saved_books_repository_impl.dart)

- [ ] Declare the same load/add/remove operations in `SavedBooksRepository`. Implement them in `SavedBooksRepositoryImpl` using the local source and app failures.

### Step 43 Create the saved books controller

[lib/features/library/presentation/providers/saved_books_provider.dart](../lib/features/library/presentation/providers/saved_books_provider.dart)

- [ ] Create source and repository providers using the shared LocalStore. Create `savedBooksProvider` with an AsyncNotifier whose state is `Set<String>`.
- [ ] Load the initial set in build. Add `save(bookId)` and `unsave(bookId)` actions; after the repository write succeeds, publish the returned set. On failure, retain the previous set and report the failure.

### Step 44 Connect save controls to shared state

[lib/features/home/presentation/widgets/book_detailes_sheet.dart](../lib/features/home/presentation/widgets/book_details_sheet.dart)  
[lib/features/home/presentation/widgets/book_card.dart](../lib/features/home/presentation/widgets/book_card.dart)  
[lib/features/library/presentation/widgets/reading_book_card.dart](../lib/features/library/presentation/widgets/reading_book_card.dart)  
[lib/core/constants/common/show_simple_snackbar.dart](../lib/core/constants/common/show_simple_snackbar.dart)

- [ ] Remove the sheet's local `isInLibrary` boolean. Derive its label and icon from `savedBooksProvider` and the selected ID.
- [ ] Make whole-book save icons on both card types use the same provider and actions. Rename their `onBookmarkTap` callback to `onSaveTap` if needed to distinguish this action from reading bookmarks.
- [ ] Block repeated taps while an action for that book is pending. Show the existing success snackbar only after the write succeeds.

**Working result:** A saved book stays saved after closing details, changing tabs, and restarting.

## Then save reading progress and make resume work

### Step 45 Implement the progress local source

[lib/features/reader/data/sources/progress_local_source.dart](../lib/features/reader/data/sources/progress_local_source.dart)

- [ ] Create `ProgressLocalSource(LocalStore store)` with `loadHistory()` and `savePosition(bookId, position)` returning `Future<ReadingHistory>`.
- [ ] Read/write positions inside the root `progress` map, using book ID as the key. In the same update, set `lastRead` to that ID. Preserve saved books, bookmarks, and preferences.
- [ ] Map chapter, scroll, and updatedAt between JSON and ReadingProgress in this source.

### Step 46 Add progress operations to the reader repository

[lib/features/reader/domain/repositories/reader_repository.dart](../lib/features/reader/domain/repositories/reader_repository.dart)  
[lib/features/reader/data/repositories/reader_repository_impl.dart](../lib/features/reader/data/repositories/reader_repository_impl.dart)  
[lib/features/reader/presentation/providers/reader_providers.dart](../lib/features/reader/presentation/providers/reader_providers.dart)

- [ ] Add `loadHistory()` and `savePosition(String bookId, ReadingProgress position)` returning `Future<ReadingHistory>`. Inject ProgressLocalSource into ReaderRepositoryImpl.
- [ ] Update `readerRepositoryProvider` to provide both ReaderApi and ProgressLocalSource.

### Step 47 Create the shared reading history controller

[lib/features/reader/presentation/providers/reader_providers.dart](../lib/features/reader/presentation/providers/reader_providers.dart)

- [ ] Create `readingHistoryProvider` with an AsyncNotifier holding `ReadingHistory`. Load after bootstrap and expose `savePosition(bookId, position)`.
- [ ] After a successful save publish the returned history, including lastRead. Keep the previous state on failure so a failed save does not erase history on screen.

### Step 48 Write resume navigation and progress tracking

`lib/features/reader/presentation/reader_navigation.dart` **create this file**  
[lib/features/reader/presentation/views/reader.dart](../lib/features/reader/presentation/views/reader.dart)  
[lib/features/home/presentation/widgets/book_detailes_sheet.dart](../lib/features/home/presentation/widgets/book_details_sheet.dart)

- [ ] Create the new `openReader` helper with `Future<void> openReader(BuildContext context, WidgetRef ref, {required String bookId, int? chapter, double? scroll})`. Without an explicit chapter, await `readingHistoryProvider.future` and read the saved position for the book, defaulting to chapter 0 and scroll 0. With an explicit chapter, use it and the supplied scroll, defaulting to 0. Check `context.mounted` after awaiting, then push ReadBook with those values.
- [ ] After the chapter loads and layout finishes, restore `initialScroll * maxScrollExtent`. Suppress progress writes during restoration.
- [ ] On user scrolling, capture the current chapter and clamp `offset / maxScrollExtent` to `0..1`. When maxScrollExtent is zero, mark the fully rendered chapter as fully visible (`scroll = 1`) after layout.
- [ ] Save with `DateTime.now().millisecondsSinceEpoch`. Limit scroll writes, and flush the pending position before chapter changes and normal/system back navigation; also flush on app backgrounding. Capture the old chapter's position before switching indexes.
- [ ] Dispose the controller, timers, and lifecycle listeners. Change the details reading button to use openReader.

**Working result:** Leaving and reopening a book restores its chapter and approximate position; home can later use the same history.

## Then finish reading bookmarks

### Step 49 Implement the bookmarks local source

[lib/features/bookmarks/data/bookmarks_local_source.dart](../lib/features/bookmarks/data/bookmarks_local_source.dart)

- [ ] Create `BookmarksLocalSource(LocalStore store)` with load/add/remove operations. Serialize bookmark entries with `bookId`, `chapter`, and `scroll`.
- [ ] Read the latest bookmarks list inside each update. Add only if the stable identity is absent; remove only the selected identity. Preserve all other document fields.

### Step 50 Write and implement the bookmarks repository

[lib/features/bookmarks/domain/repositories/bookmarks_repository.dart](../lib/features/bookmarks/domain/repositories/bookmarks_repository.dart)  
[lib/features/bookmarks/data/bookmarks_repository_impl.dart](../lib/features/bookmarks/data/bookmarks_repository_impl.dart)

- [ ] Declare `loadBookmarks`, `addBookmark(Bookmark)`, and `removeBookmark(String identity)`, returning the resulting `Future<List<Bookmark>>`. Implement them through the local source.

### Step 51 Create the shared bookmarks controller

[lib/features/bookmarks/presentation/providers/bookmarks_providers.dart](../lib/features/bookmarks/presentation/providers/bookmarks_providers.dart)

- [ ] Expose source/repository providers and an AsyncNotifier `bookmarksProvider`. Load the list and publish add/remove results only after storage succeeds.

### Step 52 Add the reader bookmark action

[lib/features/reader/presentation/views/reader.dart](../lib/features/reader/presentation/views/reader.dart)

- [ ] Add a bookmark button that captures the current book ID, chapter index, and scroll fraction and calls the bookmarks controller.
- [ ] Disable it while chapter loading/restoration or the write is pending. If the same rounded position already exists, display its saved state rather than adding another entry.

### Step 53 Build the bookmarks list

[lib/features/bookmarks/presentation/views/book_marks_screen.dart](../lib/features/bookmarks/presentation/views/book_marks_screen.dart)

- [ ] Replace the empty area below the header with rows from `bookmarksProvider`. Resolve book titles through `bookDetailsProvider(bookId)` and show chapter number as `chapter + 1`.
- [ ] A row tap calls openReader with that bookmark's explicit chapter and scroll. Its delete action removes that identity.
- [ ] Use loading/error/empty states. If a book is unavailable, retain its bookmark and allow deletion instead of silently removing user data.

**Working result:** Bookmarks can be added inside the reader, opened at their saved location, and removed without affecting whole-book saves.

## Then finish the Library

### Step 54 Create the Library result providers

[lib/features/library/presentation/providers/library_providers.dart](../lib/features/library/presentation/providers/library_providers.dart)

- [ ] Watch savedBooksProvider and readingHistoryProvider. Build three ID sets: All = union of saved IDs and history keys; Reading now = history entries below 100%; Saved = saved IDs.
- [ ] Resolve IDs through the book details provider. Keep an unavailable entry when lookup fails so its local data can still be removed. Count unique IDs using those same tab sets.
- [ ] Include each available book's current reading fraction from ReadingProgress.overallFraction(book.chapterCount). Keep tab selection in a provider or in LibraryScreen; the tabs and the content must share that selection.

### Step 55 Connect the tab labels and selection

[lib/features/library/presentation/widgets/tabs_library.dart](../lib/features/library/presentation/widgets/tabs_library.dart)

- [ ] Replace fixed counts with arguments for all, reading, and saved counts. Accept selected index and a selection callback.
- [ ] Remove the isolated DefaultTabController. Use the parent-selected tab to control both the indicator and the displayed list.

### Step 56 Finish the reading book card

[lib/features/library/presentation/widgets/reading_book_card.dart](../lib/features/library/presentation/widgets/reading_book_card.dart)

- [ ] Supply actual book fields and overall fraction to the card. Set its LinearProgressIndicator to that fraction and format the displayed percentage from it.
- [ ] Keep its real book ID for details and shared whole-book saving. For a saved book without a reading position, show zero progress or omit the progress row.

### Step 57 Replace the Library mock grid

[lib/features/library/presentation/views/library_screen.dart](../lib/features/library/presentation/views/library_screen.dart)

- [ ] Use the selected tab's entries from the Library providers. Remove the fixed item count, repeated sample cards, and fixed progress.
- [ ] Pass the three real counts into TabsLibrary. Render empty/error/unavailable states as appropriate.
- [ ] On a fresh seeded store verify the counts: All `3`, Reading now `1`, Saved `3`. They overlap because beginnings is already a saved book.

**Working result:** The three Library tabs show actual books, matching counts, and actual reading percentages.

## Then finish Home using the API and local history

### Step 58 Write the home response types

`lib/shared/books/domain/entities/home_data.dart` **create this file**  
`lib/shared/books/data/models/home_data_model.dart` **create this file**

- [ ] Create these new files. HomeData contains welcomeTitle, welcomeSubtitle, hero, quote, categories, featuredBooks, and demoContinueReading.
- [ ] Define hero with eyebrow/title/actionLabel/books; quote with text/attribution; demoContinueReading with book/position/progressPercent. Reuse Book, Category, and ReadingProgress.
- [ ] Parse the single `data` object into HomeDataModel and convert its nested models into HomeData.

### Step 59 Add home loading to the books layer

[lib/shared/books/data/sources/books_api.dart](../lib/shared/books/data/sources/books_api.dart)  
[lib/shared/books/domain/repositories/books_repository.dart](../lib/shared/books/domain/repositories/books_repository.dart)  
[lib/shared/books/data/repositories/books_repository_impl.dart](../lib/shared/books/data/repositories/books_repository_impl.dart)

- [ ] Add `fetchHome({String category = 'all'})` using GET `/api/v1/home` with only the category query. Return HomeDataModel.
- [ ] Add `getHome({String category = 'all'})` returning `Future<HomeData>` to the repository and implementation.

### Step 60 Write the Home providers

[lib/features/home/providers/home_providers.dart](../lib/features/home/providers/home_providers.dart)

- [ ] Create a selected home category controller, defaulting to all, and `homeDataProvider` that watches it and calls getHome.
- [ ] Create `continueReadingProvider` watching readingHistoryProvider. If lastRead is null return no card; otherwise resolve that book ID and combine the book with its local position.
- [ ] Use local history for the continue-reading card after bootstrap. The home endpoint's demoContinueReading is static seed content and must not replace the user's history.

### Step 61 Pass API content into the hero and quote widgets

[lib/features/home/presentation/widgets/hero_panner.dart](../lib/features/home/presentation/widgets/hero_panner.dart)  
[lib/features/home/presentation/widgets/header.dart](../lib/features/home/presentation/widgets/header.dart)

- [ ] Give HeroBanner arguments for eyebrow, title, actionLabel, its list of book covers, and onExploreTap. Replace the repeated cover URL and fixed text.
- [ ] Give Header quote text and attribution arguments. Replace its fixed quote with the API values.

### Step 62 Make ContinueReadingCard display and open its book

[lib/features/home/presentation/widgets/continue_reading_card.dart](../lib/features/home/presentation/widgets/continue_reading_card.dart)

- [ ] Accept the actual book and reading fraction plus onTap. Remove the fixed title, author, cover, and 67% value.
- [ ] Use the whole-sample fraction for the bar and percentage. Call openReader for that book when tapped; it loads the saved position.

### Step 63 Replace the Home mock sections and connect its search

[lib/features/home/presentation/views/home_screen.dart](../lib/features/home/presentation/views/home_screen.dart)  
[lib/features/main_screen.dart](../lib/features/main_screen.dart)

- [ ] Watch homeDataProvider and continueReadingProvider. Feed actual welcome text, hero, quote, categories, and featured books to the existing widgets. Give every BookCard its real ID.
- [ ] Connect category taps to the home category controller. That API filter changes featuredBooks only. Show an empty reading invitation if local history has no lastRead.
- [ ] Make onExploreTap and onLibraryTap required callbacks and remove the unsafe onExploreTap! use. Supply them from MainScreen.
- [ ] Give Home a search-submit callback. Make MainScreen a ConsumerStatefulWidget so the callback can set Explore's query through `ref.read(exploreQueryProvider.notifier)`. Then select destination index `2` so submitted Home search opens Explore with those results.

**Working result:** Home shows its actual content and resumes the book most recently read on this device.

## Then finish preferences and the shared presentation

### Step 64 Implement preferences storage

`lib/features/reader/data/sources/preferences_local_source.dart` **create this file**

- [ ] Create this new source using LocalStore. Add loadPreferences, setFontSize, and setTheme. Update only the root preferences object and return ReaderPreferences.
- [ ] Restrict your reader controls to font sizes `16..32`; preserve the API/default size `21`. Reject theme values other than light/dark.

### Step 65 Create the preferences controller

[lib/features/reader/presentation/providers/reader_providers.dart](../lib/features/reader/presentation/providers/reader_providers.dart)

- [ ] Expose PreferencesLocalSource and an AsyncNotifier `readerPreferencesProvider` with font-size and theme actions. Load from the bootstrapped store, publish successful writes, and retain old values on failure.

### Step 66 Move theme construction into AppTheme

[lib/core/theme/app_theme.dart](../lib/core/theme/app_theme.dart)  
[lib/core/theme/app_colors.dart](../lib/core/theme/app_colors.dart)  
[lib/main.dart](../lib/main.dart)

- [ ] Create AppTheme.light and AppTheme.dark with Tajawal and readable page/surface/text colors. Extend AppColors for the dark palette.
- [ ] Replace MyApp's inline ThemeData with these themes. Once bootstrap completes, watch readerPreferencesProvider and select the theme mode from its stored theme value. Use the light theme for bootstrap loading/error screens; do not load preferences before initialization finishes.

### Step 67 Connect reader controls

[lib/features/reader/presentation/views/reader.dart](../lib/features/reader/presentation/views/reader.dart)

- [ ] Watch the preferences controller and use fontSize for chapter text. Add increase/decrease and light/dark actions.
- [ ] Capture the fractional reading position before a font-size change and restore it after the new layout. Prevent the layout change from saving an accidental position of zero.

### Step 68 Finish navigation headers and cover fallback states

[lib/features/main_screen.dart](../lib/features/main_screen.dart)  
[lib/core/constants/common/screen_header.dart](../lib/core/constants/common/screen_header.dart)  
[lib/features/home/presentation/widgets/book_card.dart](../lib/features/home/presentation/widgets/book_card.dart)  
[lib/features/library/presentation/widgets/reading_book_card.dart](../lib/features/library/presentation/widgets/reading_book_card.dart)  
[lib/features/home/presentation/widgets/hero_panner.dart](../lib/features/home/presentation/widgets/hero_panner.dart)  
[lib/features/home/presentation/widgets/continue_reading_card.dart](../lib/features/home/presentation/widgets/continue_reading_card.dart)

- [ ] Use an IndexedStack in MainScreen if you want to preserve each screen's scroll/tab state when changing destinations. Keep the same bookmark/library/explore/home destination order.
- [ ] Make headers and cards fit a narrow phone and larger text. Use directional spacing for RTL where appropriate. Replace the whitespace-only Container in ScreenHeader with SizedBox.
- [ ] Add cover loading and error placeholders to each image widget. Remove unused imports and update category separator underscores to resolve the existing analyzer findings.

**Working result:** Reader controls and themes persist, and the completed screens fit the app shell.

## Finally verify the flows and create the installable build

### Step 69 Remove remaining sample data and finish failure actions

[lib/features/home/presentation/views/home_screen.dart](../lib/features/home/presentation/views/home_screen.dart)  
[lib/features/explore/presentation/views/explore_screen.dart](../lib/features/explore/presentation/views/explore_screen.dart)  
[lib/features/home/presentation/widgets/book_detailes_sheet.dart](../lib/features/home/presentation/widgets/book_details_sheet.dart)  
[lib/features/library/presentation/views/library_screen.dart](../lib/features/library/presentation/views/library_screen.dart)  
[lib/features/bookmarks/presentation/views/book_marks_screen.dart](../lib/features/bookmarks/presentation/views/book_marks_screen.dart)  
[lib/features/reader/presentation/views/reader.dart](../lib/features/reader/presentation/views/reader.dart)

- [ ] Remove leftover repeated mock titles, cover URLs, counts, and percentages. Keep ordinary UI labels.
- [ ] Check that every request has loading/error/retry handling, empty results have a valid empty state, and a failed local write does not show success.
- [ ] Try a missing book, empty search, empty Library tab, no bookmarks, network loss, and a restart after changing local state. Preserve local state during all network failures.

### Step 70 Replace the starter test with app tests

[test/widget_test.dart](../test/widget_test.dart)

- [ ] Remove the counter/plus-button assumptions. Add focused test files with fixed JSON and fake repositories or LocalStore.
- [ ] Verify: books/pagination parsing; query resets; actual selected book IDs; seed imports once; intentionally empty saved state stays empty; concurrent saved/progress updates preserve both; bookmarks open their location; Library counts use unique IDs.
- [ ] Verify reading progress: chapter 0 with scroll 0.96 over three chapters is 32%; final chapter bottom is 100%; zero scroll extent does not divide by zero.
- [ ] Run `dart format lib test`, `flutter analyze`, and `flutter test`. Resolve failures before building.

### Step 71 Build the Android app and replace the starter README

[pubspec.yaml](../pubspec.yaml)  
[android/app/build.gradle.kts](../android/app/build.gradle.kts)  
[android/app/src/main/AndroidManifest.xml](../android/app/src/main/AndroidManifest.xml)  
[README.md](../README.md)

- [ ] Set the app's display name/version and inspect its application ID. Keep the existing Internet permission and registered Tajawal fonts.
- [ ] Run `flutter build apk --release`; install `build/app/outputs/flutter-apk/app-release.apk` on a test phone.
- [ ] Use the final flow below on the installed app. Replace README with run/build/test commands and a short description of the API and device-local user state.
- [ ] The current release build uses debug signing. Configure your own signing before store distribution.

**Working result:** The app's real data, local state, reader, and navigation work together on an installed Android build.

## Book fields to implement

Use these fields in Book and BookModel. Do not translate their JSON keys.

| Dart type | Fields |
| --- | --- |
| `String` | `id`, `title`, `author`, `categoryId`, `categoryName`, `language`, `description`, `tagline`, `coverUrl`, `coverBackgroundColor`, `direction`, `contentType` |
| `double` | `rating` |
| `int` | `pageCount`, `coverWidth`, `coverHeight`, `chapterCount` |
| `bool` | `isFictional` |

Use `coverUrl` directly with Image.network. Use chapterCount for progress; pageCount describes an illustrative full book rather than the available sample length. [Book schema](https://maktabah-demo-api.ashahin.workers.dev/openapi.json)

## Local document to implement

Use this for Start empty. On a successful first initialization, replace the five user-data fields with the validated demo seed and keep the version/initialized fields.

```json
{
  "schemaVersion": 1,
  "initialized": true,
  "saved": [],
  "progress": {},
  "bookmarks": [],
  "preferences": {"fontSize": 21, "theme": "light"},
  "lastRead": null
}
```

Saved IDs stay in `saved`. A position under `progress[bookId]` has `chapter`, `scroll`, and `updatedAt`. A bookmark has `bookId`, `chapter`, and `scroll`. Only local initialization and updates write this document; the API has no user-state mutation endpoints. [Demo state schema](https://maktabah-demo-api.ashahin.workers.dev/openapi.json)

## API values to use

| Item | Use |
| --- | --- |
| Categories | `all`, `literature`, `self-development`, `history`, `science` |
| Sort | `catalog`, `title`, `rating` |
| Book list query keys | `q`, `category`, `page`, `limit`, `sort` |
| Book pages | Start at `1`; limit must be `1..50` |
| Chapter route indexes | Start at `0`; show the supplied display number starting at `1` |
| Books response | Parse `data` as a list and `meta.pagination` as the page metadata |
| Empty search | HTTP 200 with an empty list |
| Demo seed | Saved light/slow/beginnings; progress belongs to beginnings; overall progress 32% |

Replace the current UI IDs `lit`, `self`, `hist`, and `sci` with the API IDs. Unknown/duplicate query keys are rejected. [API contract](https://maktabah-demo-api.ashahin.workers.dev/openapi.json)

## Native files and assets

Keep the working native scaffolding while completing the numbered steps. These files do not need feature code:

| Existing file or group | Action |
| --- | --- |
| `analysis_options.yaml` | Keep the lint configuration and resolve analyzer findings |
| `pubspec.lock` | Let pub update resolved dependencies |
| `assets/fonts/Tajawal/` and `OFL.txt` | Keep registered font files and license |
| Android build/settings/Gradle wrapper files | Preserve the working configuration |
| Android MainActivity, debug/profile manifests, styles, launch resources, icons | Keep Flutter wiring; update identifiers/icons together if changing app identity |
| iOS Runner lifecycle files, Info.plist, storyboards, Assets.xcassets, Xcode project/workspace, Flutter config, RunnerTests | Preserve scaffolding; target iOS later using macOS/Xcode |
| Linux runner/CMake files and generated plugin registration | Preserve scaffolding; Flutter maintains generated registration |
| `.metadata`, `.gitignore`, and platform ignore files | Preserve tooling metadata and useful ignore rules |
| `.dart_tool/`, `build/`, machine-specific IDE/platform configuration | Let the tools manage these |

## Final flow on the installed app

1. Open a fresh installation: the demo state initializes once.
2. Search in Explore, change category/sort, and visit another page.
3. Open two different books and confirm the details match each selection.
4. Save a book and verify it appears in Library.
5. Open a book, read chapter 2, and add a bookmark.
6. Leave the reader, open the bookmark, and confirm its book/chapter/location.
7. Change reader font size and theme.
8. Close and reopen the app: saves, bookmarks, preferences, and reading position remain.
9. Resume through Home: it opens the locally most recently read book.
10. Remove a saved book and bookmark, restart, and confirm both stay removed.
11. Disable networking: requests show useful retry states and local user data remains.
12. Confirm analyzer/tests pass and the installed release APK follows the same flow.
