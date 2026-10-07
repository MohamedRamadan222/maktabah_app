import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:maktabah_app/core/theme/app_colors.dart';
import 'package:maktabah_app/features/bookmarks/presentation/views/book_marks_screen.dart';
import 'package:maktabah_app/features/home/presentation/views/home_screen.dart';
import 'package:maktabah_app/features/library/presentation/views/library_screen.dart';

import 'explore/presentation/views/explore_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentPageIndex = 3;

  List<Widget> get _pages => [
    const BookMarksScreen(),
    const LibraryScreen(),
    const ExploreScreen(),
    HomeScreen(
      onExploreTap: () => setState(() => _currentPageIndex = 2),
      onLibraryTap: () => setState(() => _currentPageIndex = 1),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          leadingWidth: 54,
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 37,
                  height: 37,
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    backgroundColor: AppColors.goldColor.withValues(alpha: 0.2),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        'ق',
                        style: TextStyle(
                          color: const Color(0XFF806641),
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 1,
                  right: 1, // بدّلها لـ left لو ظهرت في الجهة الغلط
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xff6B9AA5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Text(
              'عالمك يبدأ بكتاب',
              style: TextStyle(fontSize: 10, color: AppColors.mutedColor),
            ),
            const Gap(10),
            Container(width: 1, height: 22, color: Colors.black12),
            const Gap(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.only(top: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xffB58B43),
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                const Gap(2),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'مكتبة',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                const Gap(6),
                Icon(
                  Icons.menu_book_outlined,
                  size: 29,
                  color: AppColors.primaryColor,
                ),
                const Gap(16),
              ],
            ),
          ],
        ),
        body: _pages[_currentPageIndex],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            height: 64,
            elevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white,
            indicatorColor: const Color(0xffE4EEF5),
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            iconTheme: WidgetStateProperty.resolveWith(
                  (states) => IconThemeData(
                size: 20,
                color: states.contains(WidgetState.selected)
                    ? AppColors.primaryColor
                    : AppColors.mutedColor,
              ),
            ),
            labelTextStyle: WidgetStateProperty.resolveWith(
                  (states) {
                final selected = states.contains(WidgetState.selected);
                return TextStyle(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                  color: selected ? AppColors.primaryColor : AppColors.mutedColor,
                );
              },
            ),
          ),
          child: NavigationBar(
            selectedIndex: _currentPageIndex,
            animationDuration: const Duration(milliseconds: 300),
            onDestinationSelected: (index) =>
                setState(() => _currentPageIndex = index),
            destinations: const [
              NavigationDestination(
                icon: Icon(LucideIcons.bookmark),
                label: 'علاماتي',
              ),
              NavigationDestination(
                icon: Icon(LucideIcons.library),
                label: 'مكتبتي',
              ),
              NavigationDestination(
                icon: Icon(LucideIcons.compass),
                label: 'استكشف',
              ),
              NavigationDestination(
                icon: Icon(LucideIcons.house),
                label: 'الرئيسية',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
