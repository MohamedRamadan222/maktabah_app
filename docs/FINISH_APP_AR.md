# إكمال الشاشات الخمس في هذه النسخة

الخطة مبنية على الكود الحالي، وهدفها تشغيل **الرئيسية، استكشف، مكتبتي، علاماتي، والقارئ** ببيانات API ومنطقها الصحيح.

**مهم:** محتوى الكتب يأتي من API. المكتبة تحفظ الكتاب كاملًا كمعرّف، والعلامة تحفظ مكانًا داخل قراءته. الحفظ والتقدم والعلامات تُخزن على الجهاز لأن API لا يقدم عمليات حفظ للمستخدم.

## ما أنجزته وما بقي

| الجزء | الموجود حاليًا | المتبقي |
| --- | --- | --- |
| استكشف | كتب حقيقية، بحث، تصنيفات، تحميل المزيد | تمرير معرّف الكتاب، الترتيب، وإظهار أخطاء تحميل المزيد |
| التفاصيل | الموديل والمستودع والمزود موجودة | عرض نتيجة الطلب بدل البيانات الثابتة، وربط الحفظ والقراءة |
| الرئيسية | التصميم وتصنيفات من API | محتوى الرئيسية الحقيقي، البحث، ومتابعة آخر قراءة |
| مكتبتي | التصميم فقط | كتب المستخدم، التبويبات، الأعداد والتقدم |
| علاماتي | العنوان فقط | إضافة العلامة وعرضها وفتحها وحذفها |
| القارئ | شاشة فارغة | الفصول والتنقل والتقدم |
| التخزين | الملفات فارغة والحزمة مثبتة | حفظ الحالة المشتركة واسترجاعها |

**تعديل** = تغيير الكود الموجود. **إكمال** = كتابة الكود في ملف موجود لكنه فارغ. **إنشاء** = ملف جديد.

## 1 إصلاح التفاصيل أولًا

الملفات في هذه الخطوة موجودة:

- [ ] **تعديل** [book_card.dart](../lib/features/home/presentation/widgets/book_card.dart) و[reading_book_card.dart](../lib/features/library/presentation/widgets/reading_book_card.dart): أضف `bookId` مطلوبًا، ومرره إلى `BookDetailsSheet(bookId: bookId)`. الاستدعاء الحالي لا يمرر المعامل المطلوب.
  - [ ] **تعديل** [explore_screen.dart](../lib/features/explore/presentation/views/explore_screen.dart): مرّر `book.id` لكل بطاقة. في الرئيسية والمكتبة، حدّث استدعاءات البطاقات أيضًا؛ مؤقتًا استخدم `slow` و`sea` إلى أن تربط القوائم الحقيقية.
  - [ ] **تعديل** [book_detailes_sheet.dart](../lib/features/home/presentation/widgets/book_details_sheet.dart): استخدم `bookDetailsAsync.when(...)` لعرض التحميل والخطأ والبيانات. اعرض الغلاف والعنوان والمؤلف والوصف والتقييم والإحصائيات و`notice` من نتيجة الطلب.
  - [ ] اجعل إعادة المحاولة تستدعي `ref.invalidate(bookDetailsProvider(widget.bookId))`، وأبقِ الإغلاق متاحًا في جميع الحالات.

`bookDetailsProvider` موجود في [books_providers.dart](../lib/shared/books/providers/books_providers.dart)؛ استخدمه كما هو، ولا تكرره في الملف الفارغ `book_details_provider.dart`.

## 2 تجهيز الحفظ المشترك

ابدأ بحالة مستخدم فارغة، ثم حدّثها من أفعال المستخدم.

| الملف | العمل والدوال |
| --- | --- |
| [core/storage/_store.dart](../lib/core/storage/_store.dart) | **إكمال** `LocalStore`: `readState()` و`updateState(transform)` |
| `lib/core/storage/local_store_provider.dart` | **نقل وإكمال** الملف الفارغ `lib/core/storage/local` إلى هذا الاسم؛ أضف `localStoreProvider` |
| [reader/domain/entities/reading_progress.dart](../lib/features/reader/domain/entities/reading_progress.dart) | **إكمال** `ReadingProgress(chapter, scroll, updatedAt)` و`ReadingHistory(positions, lastRead)`، ودالة `overallFraction(chapterCount)` |
| [bookmarks/domain/entities/bookmark.dart](../lib/features/bookmarks/domain/entities/bookmark.dart) | **إكمال** `Bookmark(bookId, chapter, scroll)` و`identity` مبني على هذه القيم، مع تقريب الموضع إلى ثلاث خانات |

- [ ] استخدم `SharedPreferencesAsync` لحفظ JSON تحت مفتاح واحد مثل `maktabah.state.v1`:
  `{"saved":[],"progress":{},"bookmarks":[],"lastRead":null}`.
  - [ ] أعد الحالة الفارغة فقط عند عدم وجود بيانات سابقة. عند تلف البيانات، اعرض خطأ بدل مسحها.
  - [ ] نفّذ `updateState` بالتتابع؛ كل تعديل يقرأ أحدث حالة ويغير حقوله فقط.
  - [ ] استخدم نفس المخزن في كل الميزات، وانشر التغيير في المزود بعد نجاح الكتابة فقط.

## 3 تشغيل القارئ وحفظ التقدم

| الملف | العمل والدوال |
| --- | --- |
| [reader/domain/entities/chapter.dart](../lib/features/reader/domain/entities/chapter.dart) | **إكمال** `Chapter`: الكتاب، الفهرس، الرقم، العنوان، الفقرات، عدد الفصول، وفهرسا السابق والتالي القابلان لـ `null` |
| [reader/data/models/chapter_model.dart](../lib/features/reader/data/models/chapter_model.dart) | **إكمال** `ChapterModel.fromJson()` و`toEntity()` |
| [reader/data/sources/reader_api.dart](../lib/features/reader/data/sources/reader_api.dart) | **إكمال** `fetchChapter(bookId, index)` و`fetchChapterSummaries(bookId)` |
| [reader/data/sources/progress_local_source.dart](../lib/features/reader/data/sources/progress_local_source.dart) | **إكمال** `loadHistory()` و`savePosition(bookId, position)`؛ حدث `progress` و`lastRead` معًا |
| [reader/domain/repositories/reader_repository.dart](../lib/features/reader/domain/repositories/reader_repository.dart) و[reader_repository_impl.dart](../lib/features/reader/data/repositories/reader_repository_impl.dart) | **إكمال** `getChapter()` و`getChapterSummaries()` و`loadHistory()` و`savePosition()` |
| [reader_providers.dart](../lib/features/reader/presentation/providers/reader_providers.dart) | **إكمال** `readerApiProvider` و`progressLocalSourceProvider` و`readerRepositoryProvider` و`chapterProvider` و`chapterSummariesProvider` و`readingHistoryProvider` |
| `lib/features/reader/presentation/reader_navigation.dart` | **إنشاء** `openReader(context, ref, {required bookId, chapter, scroll})` لفتح الموضع المحدد أو آخر موضع محفوظ |

مسارا API:

```text
GET /api/v1/books/{bookId}/chapters
GET /api/v1/books/{bookId}/chapters/{index}
```

- [ ] **تعديل** [reader.dart](../lib/features/reader/presentation/views/reader.dart): اجعله Consumer يستقبل `bookId` و`initialChapterIndex` و`initialScroll`.
  - [ ] اعرض عنوان الفصل والفقرات بالعربية، وقائمة الفصول، وزري السابق والتالي حسب بيانات API.
  - [ ] مفتاح `chapterProvider` يجمع معرّف الكتاب وفهرس الفصل. الفهرس يبدأ من صفر، والرقم المعروض للمستخدم يبدأ من واحد.
  - [ ] أضف داخل الشاشة `changeChapter(index)` و`restorePosition(scroll)` و`saveCurrentPosition()`.
  - [ ] احفظ موضع التمرير بين صفر وواحد، واسترجعه بعد عرض الفصل. امنع الحفظ أثناء الاسترجاع، وتجنب القسمة على صفر إذا لم يحتج الفصل إلى تمرير.
  - [ ] احفظ التقدم قبل تغيير الفصل أو الخروج أو انتقال التطبيق للخلفية. قلل تكرار الكتابة أثناء التمرير.
  - [ ] احسب التقدم بـ `(chapter + scroll) / chapterCount`، واضبطه بين صفر وواحد.
  - [ ] استخدم `openReader` من زر القراءة في التفاصيل، مع فحص `context.mounted` بعد أي انتظار.

## 4 إضافة الكتاب إلى المكتبة وإزالته

| الملف | العمل والدوال |
| --- | --- |
| [saved_books_local_source.dart](../lib/features/library/data/saved_books_local_source.dart) | **إكمال** `loadSavedIds()` و`add(bookId)` و`remove(bookId)`؛ أعد `Set<String>` |
| [saved_books_repository.dart](../lib/features/library/domain/saved_books_repository.dart) و[saved_books_repository_impl.dart](../lib/features/library/data/saved_books_repository_impl.dart) | **إكمال** نفس العمليات باستخدام المصدر المحلي |
| [saved_books_provider.dart](../lib/features/library/presentation/providers/saved_books_provider.dart) | **إكمال** مزودي المصدر والمستودع، و`savedBooksProvider` كـ AsyncNotifier بدوال `build()` و`save(bookId)` و`unsave(bookId)` |

- [ ] خزّن معرّفات الكتب في `saved` دون تكرار.
  - [ ] اربط أيقونات الحفظ في `BookCard` و`ReadingBookCard` ونافذة التفاصيل بنفس المزود.
  - [ ] احذف `isInLibrary` المحلي في التفاصيل، واقرأ حالة الكتاب من `savedBooksProvider`.
  - [ ] امنع الضغط المتكرر أثناء الحفظ، وأظهر رسالة النجاح بعد نجاح الكتابة فقط.

## 5 إضافة علامات القراءة وتشغيل علاماتي

| الملف | العمل والدوال |
| --- | --- |
| [bookmarks_local_source.dart](../lib/features/bookmarks/data/bookmarks_local_source.dart) | **إكمال** `loadBookmarks()` و`addBookmark(bookmark)` و`removeBookmark(identity)` |
| [bookmarks_repository.dart](../lib/features/bookmarks/domain/repositories/bookmarks_repository.dart) و[bookmarks_repository_impl.dart](../lib/features/bookmarks/data/bookmarks_repository_impl.dart) | **إكمال** نفس العمليات باستخدام المصدر المحلي |
| [bookmarks_providers.dart](../lib/features/bookmarks/presentation/providers/bookmarks_providers.dart) | **إكمال** مزودي المصدر والمستودع، و`bookmarksProvider` بدوال `build()` و`addBookmark()` و`removeBookmark()` |

- [ ] في القارئ، أضف `addCurrentBookmark()` لحفظ الكتاب والفصل وموضع القراءة الحالي.
  - [ ] لا تضف علامة مكررة في نفس الموضع، ولا تسمح بالحفظ أثناء تحميل الفصل.
  - [ ] **تعديل** [book_marks_screen.dart](../lib/features/bookmarks/presentation/views/book_marks_screen.dart): اعرض العلامات من المزود، وعنوان الكتاب من `bookDetailsProvider(bookId)`.
  - [ ] الضغط على العلامة يفتح `openReader` بفصلها وموضعها، وزر الحذف يزيلها وحدها.
  - [ ] اعرض حالة فارغة عند عدم وجود علامات. إذا تعذر جلب كتاب، احتفظ بالعلامة مع إمكانية إعادة المحاولة أو حذفها.

## 6 تشغيل مكتبتي ببيانات المستخدم

| الملف | التعديل |
| --- | --- |
| [library_providers.dart](../lib/features/library/presentation/providers/library_providers.dart) | **إكمال** `libraryDataProvider`: اقرأ الحفظ والتقدم، ثم اجلب تفاصيل الكتب بمعرّفاتها |
| [tabs_library.dart](../lib/features/library/presentation/widgets/tabs_library.dart) | استقبل `selectedIndex` و`onSelected` وأعداد التبويبات بدل القيم الثابتة |
| [library_screen.dart](../lib/features/library/presentation/views/library_screen.dart) | اجعل اختيار التبويب يحدد القائمة؛ استبدل البطاقات المتكررة بالنتائج |
| [reading_book_card.dart](../lib/features/library/presentation/widgets/reading_book_card.dart) | اعرض بيانات الكتاب ونسبة تقدمه الحقيقية بدل `0.4` |

- [ ] **جميع الكتب:** اتحاد الكتب المحفوظة والكتب التي بدأت قراءتها، دون تكرار.
  - [ ] **أقرأ الآن:** الكتب التي لها تقدم أقل من `100%`.
  - [ ] **المحفوظة:** الكتب الموجودة في `saved`.
  - [ ] احسب العدد من نفس قائمة التبويب. الكتاب المحفوظ الذي لم تبدأه تقدمه صفر.
  - [ ] اجعل اختيار التبويب في الشاشة يتحكم في المؤشر والمحتوى؛ أزل `DefaultTabController` المنفصل الحالي.
  - [ ] عند فشل جلب كتاب، اعرض عنصرًا غير متاح مع إعادة المحاولة وإزالة الحفظ، بدل حذف بيانات المستخدم.

## 7 ربط الرئيسية بـ API وبآخر قراءة

| الملف | العمل والدوال |
| --- | --- |
| `lib/shared/books/domain/entities/home_data.dart` | **إنشاء** `HomeData` للترحيب والبنر والاقتباس والتصنيفات والكتب المقترحة |
| `lib/shared/books/data/models/home_data_model.dart` | **إنشاء** `HomeDataModel.fromJson()` و`toEntity()`، باستخدام موديلات الكتب والتصنيفات الموجودة |
| [books_api.dart](../lib/shared/books/data/sources/books_api.dart) | **تعديل**: أضف `fetchHome({String category = 'all'})` من `GET /api/v1/home` |
| [books_repository.dart](../lib/shared/books/domain/repositories/books_repository.dart) و[books_repository_impl.dart](../lib/shared/books/data/repositories/books_repository_impl.dart) | **تعديل**: أضف `getHome({String category = 'all'})` |
| [home_providers.dart](../lib/features/home/providers/home_providers.dart) | **إكمال** `homeCategoryProvider` مع `setCategory()`، و`homeDataProvider`، و`continueReadingProvider` |

- [ ] **تعديل** [home_screen.dart](../lib/features/home/presentation/views/home_screen.dart): اعرض `welcomeTitle` و`welcomeSubtitle` و`hero` و`quote` و`categories` و`featuredBooks` من API.
  - [ ] مرّر بيانات البنر إلى [hero_panner.dart](../lib/features/home/presentation/widgets/hero_panner.dart)، ونص الاقتباس ومصدره إلى [header.dart](../lib/features/home/presentation/widgets/header.dart)، بدل القيم الثابتة.
  - [ ] اجعل تصنيف الرئيسية يغير `homeCategoryProvider`، بدل تغيير بحث استكشف كما يحدث حاليًا. تصنيف API يغير الكتب المقترحة فقط.
  - [ ] اجعل `continueReadingProvider` يستخدم `lastRead` والتقدم المحلي، ثم يجلب تفاصيل الكتاب.
  - [ ] مرّر الكتاب ونسبته و`onTap` إلى [continue_reading_card.dart](../lib/features/home/presentation/widgets/continue_reading_card.dart). افتحه بـ `openReader`، واعرض دعوة للقراءة إذا لم يوجد سجل.
  - [ ] لا تستخدم `demoContinueReading` القادم من API كأنه تقدم المستخدم الحالي، وأزل نسبة `67%` الثابتة.
  - [ ] اربط بحث الرئيسية بـ callback يضبط `exploreQueryProvider` ثم يفتح استكشف من [main_screen.dart](../lib/features/main_screen.dart). حوّل MainScreen إلى Consumer، واجعل callbacks التنقل مطلوبة.
  - [ ] طبق حد البحث الموجود، وهو 200 وحدة نصية، واعرض نفس قيمة البحث عند فتح استكشف.

## 8 إكمال الربط في استكشف والشاشات

- [ ] في [explore_screen.dart](../lib/features/explore/presentation/views/explore_screen.dart)، أضف اختيار ترتيب يستدعي `setSort()`: القيم `catalog` و`title` و`rating`.
  - [ ] في [explore_providers.dart](../lib/features/explore/providers/explore_providers.dart)، احتفظ بالتمرير اللانهائي الموجود. أظهر خطأ `loadMore()` مع إعادة المحاولة، وامنعه أثناء تحديث الفلاتر حتى لا تختلط النتائج.
  - [ ] أضف زر تحميل المزيد إذا كانت النتائج لا تكفي لجعل الشاشة قابلة للتمرير، مع احترام `hasNextPage`.
  - [ ] أظهر أخطاء تحميل التصنيفات بدل تحويلها إلى قائمة فارغة فقط.
  - [ ] أضف `controller` اختياريًا إلى [custom_text_from_field.dart](../lib/core/constants/common/custom_text_from_field.dart) حتى يتطابق النص الظاهر مع البحث الحالي.
  - [ ] في MainScreen استخدم `IndexedStack` لحفظ حالة الصفحات عند التنقل.
  - [ ] في الشاشات الخمس والتفاصيل، استخدم التحميل والخطأ وإعادة المحاولة والحالة الفارغة. أضف بديلًا للصورة عند فشل تحميل الغلاف.

## النتيجة المطلوبة لهذه النسخة

- [ ] أبحث عن كتاب، وأفتح تفاصيله وفصوله الصحيحة.
  - [ ] أحفظ كتابًا فيظهر في مكتبتي، وأزيله فيختفي من المحفوظة.
  - [ ] أضيف علامة أثناء القراءة، ثم أفتحها من علاماتي عند نفس المكان.
  - [ ] أستكمل آخر قراءة من الرئيسية، وأرى التقدم الصحيح في المكتبة.
  - [ ] أغلق التطبيق وأفتحه، فأجد الحفظ والعلامات والتقدم كما تركتهم.

الملفات الجديدة فقط: `home_data.dart` و`home_data_model.dart` و`reader_navigation.dart`، بالإضافة إلى إعادة تسمية ملف مزود التخزين. بقية الملفات موجودة وتحتاج تعديلًا أو إكمالًا.

هذه النسخة تركز على الشاشات الخمس؛ الثيم والإعدادات وتجهيز النشر ليست ضمن خطواتها. [مرجع أشكال استجابات API](API_RESEARCH.md).
