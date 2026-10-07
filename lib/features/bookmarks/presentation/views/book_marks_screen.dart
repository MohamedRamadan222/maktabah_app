import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/common/custom_text_from_field.dart';
import '../../../../core/constants/common/screen_header.dart';

class BookMarksScreen extends StatefulWidget {
  const BookMarksScreen({super.key});

  @override
  State<BookMarksScreen> createState() => _BookMarksScreenState();
}

class _BookMarksScreenState extends State<BookMarksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 13),
        child: Column(
          children: [
            CustomTextFromField(),
            const Gap(24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // header
                    ScreenHeader(
                      title: 'هنا توقّفت، وهنا تعود',
                      subTitle: 'علامات تحتفظ لك بالصفحات التي تستحق العودة.',
                      icon: LucideIcons.bookmark,
                      haveShadow: true,
                    ),
                    const Gap(60),

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
