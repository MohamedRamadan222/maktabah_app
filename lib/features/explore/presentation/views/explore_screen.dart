import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:maktabah_app/core/theme/app_colors.dart';
import 'package:maktabah_app/features/home/presentation/widgets/book_card.dart';

import '../../../../core/constants/common/custom_text_from_field.dart';
import '../../../../core/constants/common/screen_header.dart';
import '../../../home/presentation/widgets/categores_items.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 13),
        child: Column(
          children: [
            CustomTextFromField(),
            const Gap(24),
            Expanded(
              child: SingleChildScrollView(
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
                      categories: const [
                        CategoryItem(
                          id: 'all',
                          title: 'الكل',
                          icon: LucideIcons.layoutGrid,
                        ),
                        CategoryItem(
                          id: 'lit',
                          title: 'أدب وروايات',
                          icon: LucideIcons.bookOpen,
                        ),
                        CategoryItem(
                          id: 'self',
                          title: 'تطوير الذات',
                          icon: LucideIcons.sprout,
                        ),
                        CategoryItem(
                          id: 'hist',
                          title: 'تاريخ وحضارة',
                          icon: LucideIcons.landmark,
                        ),
                        CategoryItem(
                          id: 'sci',
                          title: 'علوم ومعرفة',
                          icon: LucideIcons.atom,
                        ),
                      ],
                      onSelected: (c) {},
                    ),
                    const Gap(15),
                    // 12 books to discover
                    Text(
                      '١٢ كتابًا للاكتشاف',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.mutedColor,
                      ),
                    ),
                    const Gap(20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: 5,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 14,
                            mainAxisExtent: 315,
                          ),
                      itemBuilder: (context, index) => const BookCard(
                        title: 'على مهل',
                        author: 'نور إبراهيم',
                        rating: '٤٫٦',
                        imageUrl: 'https://maktabah-demo-api.ashahin.workers.dev/images/light.png',
                        width: 170,
                        height: 240,
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
