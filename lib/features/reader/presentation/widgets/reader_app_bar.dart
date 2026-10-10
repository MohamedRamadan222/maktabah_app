import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'reader_icon_button.dart';

class ReaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String author;
  final VoidCallback onBackPressed;
  final VoidCallback onBookmarkPressed;
  final VoidCallback onThemePressed;

  const ReaderAppBar({
    super.key,
    required this.title,
    required this.author,
    required this.onBackPressed,
    required this.onBookmarkPressed,
    required this.onThemePressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xffFCFAF7),
      foregroundColor: const Color(0xff263e4b),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 64,
      leadingWidth: 62,
      leading: Padding(
        padding: const EdgeInsets.only(right: 16, left: 12),
        child: Center(
          child: ReaderIconButton(
            icon: CupertinoIcons.arrow_right,
            iconSize: 17,
            onPressed: onBackPressed,
          ),
        ),
      ),
      centerTitle: false,
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff263e4b),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: Color(0xff879398)),
          ),
        ],
      ),
      actions: [
        ReaderIconButton(
          icon: CupertinoIcons.bookmark,
          onPressed: onBookmarkPressed,
        ),
        const SizedBox(width: 8),
        ReaderIconButton(icon: CupertinoIcons.moon, onPressed: onThemePressed),
        const SizedBox(width: 16),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: Color(0xffe7e7e0)),
      ),
    );
  }
}
