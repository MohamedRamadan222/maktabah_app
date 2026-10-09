import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maktabah_app/shared/books/domain/entities/chapter.dart';

class ReaderChapterContent extends StatelessWidget {
  final Chapter chapter;
  final int fontSize;
  final ScrollController? scrollController;

  const ReaderChapterContent({
    super.key,
    required this.chapter,
    required this.fontSize,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الفصل ${chapter.number}',
            style: const TextStyle(fontSize: 12, color: Color(0xffB8860B)),
          ),
          const Gap(8),
          Text(
            chapter.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xff263e4b),
            ),
          ),
          const Gap(24),
          for (final p in chapter.paragraphs)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                p,
                style: TextStyle(
                  fontSize: fontSize.toDouble(),
                  height: 2,
                  color: const Color(0xff263e4b),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
