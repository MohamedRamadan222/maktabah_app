import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:maktabah_app/core/theme/app_colors.dart';
import 'package:maktabah_app/features/explore/providers/explore_providers.dart';
import 'package:maktabah_app/features/home/presentation/widgets/book_card.dart';
import 'package:maktabah_app/shared/books/providers/books_providers.dart';

import 'package:maktabah_app/core/constants/common/custom_text_from_field.dart';
import 'package:maktabah_app/core/constants/common/screen_header.dart';
import 'package:maktabah_app/core/widgets/error_view.dart';
import 'package:maktabah_app/core/widgets/loading_view.dart';

import '../../../../core/widgets/empty_view.dart';
import '../../../home/presentation/widgets/categories_items.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 300) {
      ref.read(exploreFeedProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(exploreFeedProvider);
    final categories = ref.watch(categoriesProvider);
    final items = buildCategoryItems(categories.value ?? []);
    final query = ref.watch(exploreQueryProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 13),
        child: Column(
          children: [
            CustomTextFromField(
              onSubmitted: (text) {
                if (text.length > 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('الاستعلام طويل جدًا، يرجى تقصيره.'),
                    ),
                  );
                  return;
                }
                ref.read(exploreQueryProvider.notifier).setQuery(text.trim());
              },
            ),
            const Gap(24),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // header
                    ScreenHeader(
                      title: 'لكل فضول، كتاب',
                      subTitle: 'تجوّل بين الرفوف، واعثر على حكايتك القادمة.',
                      icon: LucideIcons.compass,
                      haveShadow: true,
                    ),
                    const Gap(20),
                    //categories items
                    CategoryChips(
                      selectedId: query.category,
                      categories: items,
                      onSelected: (c) {
                        ref
                            .read(exploreQueryProvider.notifier)
                            .setCategory(c.id);
                      },
                    ),
                    const Gap(15),
                    // 12 books to discover
                    catalog.when(
                      loading: () =>
                          SizedBox(height: 200, child: LoadingView()),
                      error: (error, stack) => ErrorView(
                        message: error.toString(),
                        onRetry: () => ref.invalidate(exploreFeedProvider),
                      ),
                      data: (page) => page.books.isEmpty
                          ? const EmptyView(message: 'لا توجد كتب حاليًا')
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${page.total} كتابًا للاكتشاف',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: AppColors.mutedColor,
                                    fontSize: 11,
                                  ),
                                ),
                                const Gap(20),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: page.books.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 18,
                                          mainAxisSpacing: 14,
                                          mainAxisExtent: 315,
                                        ),
                                    itemBuilder: (context, index) {
                                      final book = page.books[index];
                                      return BookCard(
                                        title: book.title,
                                        author: book.author,
                                        rating: book.rating.toStringAsFixed(1),
                                        imageUrl: book.coverUrl,
                                        width: 170,
                                        height: 240,
                                      );
                                    },
                                  ),
                                ),
                                if (page.isLoadingMore) ...[
                                  Gap(20),
                                  const Center(child: CircularProgressIndicator()),
                                  Gap(20),
                                ],
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
