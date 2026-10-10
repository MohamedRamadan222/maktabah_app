import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../shared/books/domain/entities/home_hero.dart';

class HeroBanner extends StatelessWidget {
  final HomeHero hero;
  final VoidCallback onExploreTap;

  const HeroBanner({super.key, required this.onExploreTap, required this.hero});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = (constraints.maxWidth / 326).clamp(0.0, 1.2);
          final covers = hero.books.take(3).map((b) => b.coverUrl).toList();

          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xffE4EEF5),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: const Color(0xffD9E7F0)),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: -38 * scale,
                  top: -23 * scale,
                  child: _ring(234 * scale),
                ),
                Positioned(
                  left: -4 * scale,
                  top: 11 * scale,
                  child: _ring(166 * scale),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14 * scale,
                    vertical: 22 * scale,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 160 * scale,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.sparkles,
                                  size: 10 * scale,
                                  color: const Color(0xffB58B43),
                                ),
                                Gap(5 * scale),
                                Flexible(
                                  child: Text(
                                    hero.eyebrow,
                                    style: TextStyle(
                                      fontSize: 9 * scale,
                                      height: 1.3,
                                      color: const Color(0xff718A9A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Gap(9 * scale),
                            Text(
                              hero.title,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 24 * scale,
                                height: 1.35,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xff172D46),
                              ),
                            ),
                            Gap(15 * scale),
                            FilledButton(
                              onPressed: onExploreTap,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xff172D46),
                                foregroundColor: Colors.white,
                                minimumSize: Size(112 * scale, 40 * scale),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12 * scale,
                                  vertical: 8 * scale,
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      hero.actionLabel,
                                      style: TextStyle(
                                        fontSize: 10 * scale,
                                        height: 1.2,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Gap(8 * scale),
                                  Icon(
                                    CupertinoIcons.arrow_left,
                                    size: 11 * scale,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 139 * scale,
                          child: covers.isEmpty
                              ? const SizedBox.shrink()
                              : Center(
                                  child: _BooksStack(
                                    scale: scale,
                                    urls: covers,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _ring(double size) => Container(
  width: size,
  height: size,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: const Color(0xffCFDFE9), width: 0.8),
  ),
);

class _BooksStack extends StatelessWidget {
  final double scale;
  final List<String> urls;

  const _BooksStack({required this.scale, required this.urls});

  Widget _book(
    String url,
    double angle,
    Offset offset, {
    double w = 84,
    double h = 118,
  }) {
    return Transform.translate(
      offset: offset * scale,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: w * scale,
          height: h * scale,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Image.network(url, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150 * scale,
      height: 139 * scale,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // ورا شمال
          if (urls.length > 1) _book(urls[1], -0.17, const Offset(-20, 6)),
          // ورا يمين
          if (urls.length > 2) _book(urls[2], 0.30, const Offset(24, 4)),
          // اللي قدام
          _book(urls[0], -0.10, const Offset(-2, -6), w: 88, h: 124),
        ],
      ),
    );
  }
}
