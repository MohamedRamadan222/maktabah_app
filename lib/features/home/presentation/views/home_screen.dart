import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:maktabah_app/core/constants/common/custom_text_from_field.dart';
import 'package:maktabah_app/core/constants/common/screen_header.dart';
import 'package:maktabah_app/features/explore/providers/explore_providers.dart';
import 'package:maktabah_app/features/home/presentation/widgets/header.dart';
import 'package:maktabah_app/shared/books/providers/books_providers.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/book_card.dart';
import '../widgets/categories_items.dart';
import '../widgets/continue_reading_card.dart';
import '../widgets/hero_panner.dart';

class HomeScreen extends ConsumerWidget {
  final VoidCallback? onExploreTap;
  final VoidCallback? onLibraryTap;

  const HomeScreen({super.key, this.onExploreTap, this.onLibraryTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final items = buildCategoryItems(categories.value ?? []);
    final query = ref.watch(exploreQueryProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 13),
        child: Column(
          children: [
            // search field
            CustomTextFromField(onSubmitted: (_) {}),
            const Gap(24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // header
                    ScreenHeader(
                      title: 'ماذا ستقرأ اليوم؟',
                      subTitle: 'صفحة جديدة، وعالم آخر ينتظرك.',
                      icon: LucideIcons.sun,
                      haveShadow: false,
                    ),
                    const Gap(16),
                    // hero banner
                    HeroBanner(onExploreTap: onExploreTap!),
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
                      selectedId: query.category,
                      categories: items,
                      onSelected: (c) {
                        ref
                            .read(exploreQueryProvider.notifier)
                            .setCategory(c.id);
                      },
                    ),
                    const Gap(15),
                    // books list
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: SizedBox(
                        height: 270,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          separatorBuilder: (_, _) => const Gap(14),
                          itemBuilder: (_, i) => const BookCard(
                            bookId: 'slow',
                            title: 'على مهل',
                            author: 'نور إبراهيم',
                            rating: '٤٫٦',
                            imageUrl: 'https://maktabah-demo-api.ashahin.workers.dev/images/light.png',
                          ),
                        ),
                      ),
                    ),
                    const Gap(24),
                    // header
                    Header(),
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
