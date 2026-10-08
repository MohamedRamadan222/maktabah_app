import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:maktabah_app/shared/books/providers/books_providers.dart';

import '../../../../core/constants/common/show_simple_snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../reader/presentation/views/reader.dart';

class BookDetailsSheet extends ConsumerStatefulWidget {
  final String bookId;

  const BookDetailsSheet({super.key, required this.bookId});

  @override
  ConsumerState<BookDetailsSheet> createState() => _BookDetailsSheetState();
}

class _BookDetailsSheetState extends ConsumerState<BookDetailsSheet> {
  bool isInLibrary = false;
  final _contentKey = GlobalKey();
  double? _sheetHeight;

  @override
  Widget build(BuildContext context) {
    final bookDetailsAsync = ref.watch(bookDetailsProvider(widget.bookId));

    final buttonStyle = OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF32679D),
      minimumSize: const Size.fromHeight(48),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      textStyle: Theme.of(context).textTheme.labelLarge
          ?.copyWith(fontSize: 12, fontWeight: FontWeight.w700),
      side: const BorderSide(color: Color(0xFFCFDFEF)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    final content = Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTextStyle.merge(
        style: const TextStyle(fontSize: 13, color: AppColors.mutedColor),
        child: SingleChildScrollView(
          child: Column(
            key: _contentKey,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: const Color(0xFFEDF3F7),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD5DFE8),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const Gap(30),
                        Row(
                          children: [
                            Container(
                              width: 105,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x18172D46),
                                    blurRadius: 16,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  'https://maktabah-demo-api.ashahin.workers.dev/images/light.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const ColoredBox(
                                    color: Color(0xFFE2E1CD),
                                    child: Icon(LucideIcons.bookOpen, size: 32),
                                  ),
                                ),
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: const Color(0xFFCFDFEF),
                                      ),
                                    ),
                                    child: const Text(
                                      'أدب وروايات',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                  const Gap(8),
                                  const Text(
                                    'أثر الضوء',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  const Gap(4),
                                  const Text(
                                    'ليلى مراد',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const Gap(12),
                                  const Wrap(
                                    spacing: 4,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        size: 14,
                                        color: Color(0xFFBF8D35),
                                      ),
                                      Text(
                                        '٤٫٨',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      Text(
                                        'تقييم توضيحي',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      left: -8,
                      top: 6,
                      child: IconButton.filled(
                        onPressed: () => Navigator.pop(context),
                        tooltip: 'إغلاق',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF527397),
                          minimumSize: const Size(36, 36),
                          padding: const EdgeInsets.all(10),
                        ),
                        icon: const Icon(LucideIcons.x, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 26, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'بين دفّتي هذا الكتاب',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const Gap(12),
                      const Text(
                        'في بيت قديم تحيط به الأشجار، تعثر سلمى على دفتر لا يحمل اسمًا. وبين صفحاته، تكتشف حكايات صغيرة عن الضوء الذي نتركه في حياة الآخرين، وعن الأشياء التي تنمو في صمت.',
                        style: TextStyle(height: 1.9),
                      ),
                      const Gap(20),
                      const Divider(height: 1, color: AppColors.borderColor),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _BookStat('٢١٦ صفحة', 'حجم الكتاب التوضيحي'),
                            _BookStat('العربية', 'لغة الكتاب'),
                            _BookStat('٣ فصول', 'مقتطف متاح للقراءة'),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.borderColor),
                      const Gap(18),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ReadBook(),
                                  ),
                                );
                              },
                              style: buttonStyle.copyWith(
                                backgroundColor: const WidgetStatePropertyAll(
                                  AppColors.primaryColor,
                                ),
                                foregroundColor: const WidgetStatePropertyAll(
                                  Colors.white,
                                ),
                                side: const WidgetStatePropertyAll(
                                  BorderSide.none,
                                ),
                              ),
                              icon: const Icon(LucideIcons.bookText, size: 16),
                              label: const Text('متابعة القراءة'),
                            ),
                          ),
                          const Gap(9),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  isInLibrary = !isInLibrary;
                                });
                                showSimpleSnackBar(
                                  context,
                                  isAdded: isInLibrary,
                                );
                              },
                              style: buttonStyle,
                              icon: isInLibrary
                                  ? const Icon(LucideIcons.check, size: 16)
                                  : const Icon(LucideIcons.bookmark, size: 16),
                              label: isInLibrary
                                  ? const Text('في مكتبتي')
                                  : const Text('أضف إلى مكتبتي'),
                            ),
                          ),
                        ],
                      ),
                      const Gap(12),
                      const Center(
                        child: Text(
                          'كتاب ومؤلفة تخيليان؛ النصوص أصلية ومخصصة لتجربة القراءة.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return LayoutBuilder(
      builder: (_, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final contentHeight = _contentKey.currentContext?.size?.height;
          if (contentHeight == null) return;
          final height = constraints.constrainHeight(contentHeight);
          if (_sheetHeight != height) {
            setState(() => _sheetHeight = height);
          }
        });

        return SizedBox(
          height: _sheetHeight,
          child: Scaffold(backgroundColor: Colors.white, body: content),
        );
      },
    );
  }
}

class _BookStat extends StatelessWidget {
  const _BookStat(this.value, this.label);

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryColor,
            ),
          ),
          const Gap(6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9),
          ),
        ],
      ),
    );
  }
}
