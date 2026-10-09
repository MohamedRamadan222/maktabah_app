import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReaderBottomBar extends StatelessWidget {
  final int chapterNumber;
  final int chapterCount;
  final double progress;
  final VoidCallback? onPreviousChapter;
  final VoidCallback? onNextChapter;

  const ReaderBottomBar({
    super.key,
    required this.chapterNumber,
    required this.chapterCount,
    required this.progress,
    this.onPreviousChapter,
    this.onNextChapter,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xffFCFAF7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1, color: Color(0xffe7e7e0)),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: _ChapterButton(
                      label: 'الفصل السابق',
                      icon: CupertinoIcons.arrow_right,
                      onPressed: onPreviousChapter,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          chapterCount > 0
                              ? 'الفصل $chapterNumber من $chapterCount · ${(progress * 100).round()}٪'
                              : 'جارٍ تحميل الفصل',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xff879398),
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 104,
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 3,
                            borderRadius: BorderRadius.circular(2),
                            color: const Color(0xff263e4b),
                            backgroundColor: const Color(0xffe7e7e0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _ChapterButton(
                      label: 'الفصل التالي',
                      icon: CupertinoIcons.arrow_left,
                      onPressed: onNextChapter,
                      iconAfterLabel: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChapterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool iconAfterLabel;

  const _ChapterButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.iconAfterLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final arrow = Icon(icon, size: 14);
    final text = Flexible(
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xff617286),
        disabledForegroundColor: const Color(0xffbec5c8),
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        textStyle: const TextStyle(fontSize: 10, fontFamily: 'Tajawal'),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: iconAfterLabel
            ? [text, const SizedBox(width: 4), arrow]
            : [arrow, const SizedBox(width: 4), text],
      ),
    );
  }
}
