import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/app_colors.dart';

class TabsLibrary extends StatefulWidget {
  const TabsLibrary({super.key});

  @override
  State<TabsLibrary> createState() => _TabsLibraryState();
}

class _TabsLibraryState extends State<TabsLibrary> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 3,
        child: TabBar(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: AppColors.primaryColor.withValues(alpha: 0.5),
          indicatorPadding: const EdgeInsets.only(bottom: 6),
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: AppColors.mutedColor,
          tabs: const [
            _TabLabel('جميع الكتب', '٣'),
            _TabLabel('أقرأ الآن', '٣'),
            _TabLabel('المحفوظة', '١'),
          ],
        ),
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel(this.title, this.count);

  final String title, count;

  @override
  Widget build(BuildContext context) => Tab(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: const TextStyle(fontSize: 12)),
        const Gap(6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black12, // خلفية البادج
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(count, style: const TextStyle(fontSize: 10)),
        ),
      ],
    ),
  );
}
