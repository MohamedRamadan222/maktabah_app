import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:maktabah_app/core/constants/common/custom_text_from_field.dart';
import 'package:maktabah_app/core/constants/common/screen_header.dart';
import 'package:maktabah_app/core/error/failure.dart';
import 'package:maktabah_app/core/widgets/error_view.dart';
import 'package:maktabah_app/core/widgets/loading_view.dart';
import 'package:maktabah_app/features/explore/providers/explore_providers.dart';
import 'package:maktabah_app/features/home/presentation/widgets/header.dart';
import 'package:maktabah_app/shared/books/providers/books_providers.dart';

import '../../../../core/theme/app_colors.dart';
import '../../providers/home_providers.dart';
import '../widgets/book_card.dart';
import '../widgets/categories_items.dart';
import '../widgets/continue_reading_card.dart';
import '../widgets/hero_panner.dart';

class HomeScreen extends ConsumerWidget {
  final VoidCallback onExploreTap;
  final VoidCallback onLibraryTap;

  const HomeScreen({
    super.key,
    required this.onExploreTap,
    required this.onLibraryTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeDataProvider);
    final categories = ref.watch(categoriesProvider);
    final items = buildCategoryItems(categories.value ?? []);
    final selectedCategory = ref.watch(homeCategoryProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 13),
        child: Column(
          children: [
            // search field
            CustomTextFromField(
              onSubmitted: (text) {
                final trimmed = text.trim();
                if (trimmed.isEmpty) return;
                if (trimmed.length > 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('الاستعلام طويل جدًا، يرجى تقصيره.'),
                    ),
                  );
                  return;
                }
                ref.read(exploreQueryProvider.notifier).setQuery(trimmed);
                onExploreTap();
              },
            ),
            const Gap(24),
            Expanded(
              child: homeAsync.when(
                data: (home) {
                  final books = selectedCategory == 'all'
                      ? home.featuredBooks
                      : home.featuredBooks
                            .where((b) => b.categoryId == selectedCategory)
                            .toList();
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // header
                        ScreenHeader(
                          title: home.welcomeTitle,
                          subTitle: home.welcomeSubtitle,
                          icon: LucideIcons.sun,
                          haveShadow: false,
                        ),
                        const Gap(16),
                        // hero banner
                        HeroBanner(hero: home.hero, onExploreTap: onExploreTap),
                        const Gap(16),
                        // continue reading ROW
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: onLibraryTap,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    CupertinoIcons.arrow_left,
                                    size: 14,
                                    color: AppColors.primaryColor,
                                  ),
                                  const Gap(6),
                                  Text(
                                    'مكتبتي',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              'متابعة القراءة',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const Gap(15),
                        // continue reading card
                        ContinueReadingCard(),
                        const Gap(16),
                        // we selected for you  Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: onExploreTap,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    CupertinoIcons.arrow_left,
                                    size: 14,
                                    color: AppColors.primaryColor,
                                  ),
                                  const Gap(6),
                                  Text(
                                    'عرض الكل',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              'اخترنا لك',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const Gap(15),
                        // categories
                        CategoryChips(
                          selectedId: selectedCategory,
                          categories: items,
                          onSelected: (c) {
                            ref
                                .read(homeCategoryProvider.notifier)
                                .selectCategory(c.id);
                          },
                        ),
                        const Gap(15),
                        // books list
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: SizedBox(
                            height: 270,
                            child: books.isEmpty
                                ? const Center(
                                    child: Text('لا توجد كتب في هذه الفئة'),
                                  )
                                : ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: books.length,
                                    separatorBuilder: (_, _) => const Gap(14),
                                    itemBuilder: (_, i) {
                                      final book = books[i];
                                      return BookCard(
                                        bookId: book.id,
                                        title: book.title,
                                        author: book.author,
                                        rating: book.rating.toStringAsFixed(1),
                                        imageUrl: book.coverUrl,
                                      );
                                    },
                                  ),
                          ),
                        ),
                        const Gap(24),
                        // header
                        Header(quote: home.quote),
                      ],
                    ),
                  );
                },
                error: (error, stackTrace) => ErrorView(
                  message: error is AppFailure
                      ? error.message
                      : 'حدث خطأ غير متوقع',
                  onRetry: () => ref.invalidate(homeDataProvider),
                ),
                loading: () => const LoadingView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
