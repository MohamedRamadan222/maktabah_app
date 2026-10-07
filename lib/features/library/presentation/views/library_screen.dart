import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/common/custom_text_from_field.dart';
import '../../../../core/constants/common/screen_header.dart';
import '../widgets/reading_book_card.dart';
import '../widgets/tabs_library.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 13),
        child: Column(
          children: [
            const Gap(24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // header
                    ScreenHeader(
                      title: 'مكتبتي، على ذوقي',
                      subTitle: 'مكتبتي، على ذوقي',
                      icon: LucideIcons.library,
                      haveShadow: true,
                    ),
                    const Gap(20),
                    // tabs
                    TabsLibrary(),
                    const Gap(10),
                    // grid view of books
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: 5,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 18,
                              mainAxisSpacing: 22,
                              mainAxisExtent: 315,
                            ),
                        itemBuilder: (context, index) => const ReadingBookCard(
                          title: 'رسائل إلى البحر',
                          author: 'يوسف عادل',
                          imageUrl: 'https://maktabah-demo-api.ashahin.workers.dev/images/light.png',
                          progress: 0.4,
                          category: 'تطوير الذات',
                          rating: '4.5',
                        ),
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
