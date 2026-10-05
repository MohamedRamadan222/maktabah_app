import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:maktabah_app/core/constants/common/custom_text_from_field.dart';
import 'package:maktabah_app/core/constants/common/screen_header.dart';

import '../widgets/hero_panner.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onExploreTap;

  const HomeScreen({super.key, required this.onExploreTap});

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
                  children: [
                    ScreenHeader(
                      title: 'ماذا ستقرأ اليوم؟',
                      subTitle: 'صفحة جديدة، وعالم آخر ينتظرك.',
                      icon: LucideIcons.sun,
                      haveShadow: false,
                    ),
                    const Gap(16),
                    HeroBanner(onExploreTap: onExploreTap),
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