import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:maktabah_app/shared/books/providers/saved_books_provider.dart';

import '../../../../core/constants/common/screen_header.dart';
import '../widgets/saved_book_tile.dart' show SavedBookTile;

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = ref.watch(savedBooksProvider).toList();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 13),
        child: Column(
          children: [
            const Gap(24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ScreenHeader(
                    title: 'مكتبتي، على ذوقي',
                    subTitle: 'مكتبتي، على ذوقي',
                    icon: LucideIcons.library,
                    haveShadow: true,
                  ),
                  const Gap(20),
                  Expanded(
                    child: ids.isEmpty
                        ? const Center(
                            child: Text(
                              'مكتبتك فاضية، احفظ كتابًا ليظهر هنا',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Directionality(
                            textDirection: TextDirection.rtl,
                            child: GridView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: ids.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 18,
                                    mainAxisSpacing: 22,
                                    mainAxisExtent: 315,
                                  ),
                              itemBuilder: (context, index) =>
                                  SavedBookTile(bookId: ids[index]),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
