import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maktabah_app/shared/books/domain/entities/chapter_summary.dart';

class ReaderChapterSelector extends StatelessWidget {
  final List<ChapterSummary> summaries;
  final int chapterIndex;
  final ValueChanged<int> onChanged;

  const ReaderChapterSelector({
    super.key,
    required this.summaries,
    required this.chapterIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'الفصل',
          style: TextStyle(fontSize: 10, color: Color(0xff617286)),
        ),
        const Gap(8),
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 124),
            child: Container(
              height: 30,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: const Color(0xffe7e7e0)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: summaries.isEmpty ? null : chapterIndex,
                  isExpanded: true,
                  isDense: true,
                  alignment: AlignmentDirectional.centerStart,
                  borderRadius: BorderRadius.circular(5),
                  dropdownColor: const Color(0xffFCFAF7),
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(fontSize: 10, color: const Color(0xff283d4c)),
                  icon: const Icon(
                    CupertinoIcons.chevron_down,
                    size: 12,
                    color: Color(0xff283d4c),
                  ),
                  items: summaries
                      .map(
                        (s) => DropdownMenuItem<int>(
                          value: s.index,
                          child: Text(
                            '${s.number}. ${s.title}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    onChanged(value);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
