import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maktabah_app/shared/books/domain/entities/chapter_summary.dart';

import 'reader_chapter_selector.dart';
import 'reader_font_size_controls.dart';

class ReaderControls extends StatelessWidget {
  final List<ChapterSummary> summaries;
  final int chapterIndex;
  final int fontSize;
  final ValueChanged<int> onChapterChanged;
  final VoidCallback onIncreaseFontSize;
  final VoidCallback onDecreaseFontSize;

  const ReaderControls({
    super.key,
    required this.summaries,
    required this.chapterIndex,
    required this.fontSize,
    required this.onChapterChanged,
    required this.onIncreaseFontSize,
    required this.onDecreaseFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final chapterSelector = ReaderChapterSelector(
                summaries: summaries,
                chapterIndex: chapterIndex,
                onChanged: onChapterChanged,
              );
              final fontSizeControls = ReaderFontSizeControls(
                fontSize: fontSize,
                onIncrease: onIncreaseFontSize,
                onDecrease: onDecreaseFontSize,
              );

              if (constraints.maxWidth < 320) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    chapterSelector,
                    const Gap(8),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: fontSizeControls,
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: chapterSelector),
                  const Gap(16),
                  fontSizeControls,
                ],
              );
            },
          ),
        ),
        const Divider(height: 1, color: Color(0xffe7e7e0)),
      ],
    );
  }
}
