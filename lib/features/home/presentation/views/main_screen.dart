import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:maktabah_app/core/theme/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text('علاماتي', style: TextStyle(fontSize: 24))),
    const Center(child: Text('مكتبتي', style: TextStyle(fontSize: 24))),
    const Center(child: Text('استكشف', style: TextStyle(fontSize: 24))),
    const Center(child: Text('الرأيسية', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 30,
              height: 30,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(66),
              ),
              child: CircleAvatar(
                backgroundColor: Color(0xffb58b43).withValues(alpha: 0.2),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      'ق',
                      style: TextStyle(
                        color: Color(0xff806641).withValues(alpha: 0.9),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  margin: EdgeInsets.only(top: 7),
                  decoration: BoxDecoration(
                    color: Color(0xffB58B43),
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                Gap(2),
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
                Gap(6),
                Icon(
                  Icons.menu_book_outlined,
                  size: 29,
                  color: AppColors.primaryColor,
                ),
                Gap(16),
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
            indicatorColor: AppColors.primaryColor.withValues(alpha: 0.2),
            indicatorShape: const StadiumBorder(),
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            iconTheme: WidgetStateProperty.resolveWith(
              (states) => IconThemeData(
                size: 20,
                color: states.contains(WidgetState.selected)
                    ? AppColors.primaryColor
                    : const Color(0xFF617286),
              ),
            ),
            labelTextStyle: WidgetStateProperty.resolveWith(
              (states) => TextStyle(
                fontSize: 12,
                color: states.contains(WidgetState.selected)
                    ? AppColors.primaryColor
                    : const Color(0xFF617286),
              ),
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
