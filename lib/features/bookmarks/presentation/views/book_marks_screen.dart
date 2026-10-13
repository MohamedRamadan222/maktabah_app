import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:maktabah_app/core/widgets/empty_view.dart';

import '../../../../core/constants/common/screen_header.dart';
import '../providers/bookmarks_providers.dart';
import '../widgets/bookmark_tile.dart';

class BookMarksScreen extends ConsumerWidget {
  const BookMarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarksProvider);
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
                  // header
                  const ScreenHeader(
                    title: 'هنا توقّفت، وهنا تعود',
                    subTitle: 'علامات تحتفظ لك بالصفحات التي تستحق العودة.',
                    icon: LucideIcons.bookmark,
                    haveShadow: true,
                  ),
                  const Gap(60),
                  Expanded(
                    child: bookmarks.isEmpty
                        ? const EmptyView(
                            message:
                                'لا توجد علامات بعد، احفظ فصلًا أثناء القراءة',
                          )
                        : Directionality(
                            textDirection: TextDirection.rtl,
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: bookmarks.length,
                              separatorBuilder: (_, _) => const Gap(14),
                              itemBuilder: (context, index) => BookmarkTile(
                                key: ValueKey(bookmarks[index].bookId),
                                bookmark: bookmarks[index],
                              ),
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
