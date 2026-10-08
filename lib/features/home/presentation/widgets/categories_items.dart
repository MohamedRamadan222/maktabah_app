import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:maktabah_app/core/theme/app_colors.dart';
import 'package:maktabah_app/shared/books/domain/entities/category.dart';

class CategoryItem {
  final String id;
  final String title;
  final IconData icon;

  const CategoryItem({
    required this.id,
    required this.title,
    required this.icon,
  });
}

class CategoryChips extends StatefulWidget {
  final List<CategoryItem> categories;
  final String selectedId;
  final ValueChanged<CategoryItem>? onSelected;

  const CategoryChips({
    super.key,
    required this.categories,
    this.onSelected,
    required this.selectedId,
  });

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: widget.categories.length,
          separatorBuilder: (_, _) => const Gap(8),
          itemBuilder: (_, i) {
            final item = widget.categories[i];
            final isSelected = item.id == widget.selectedId;
            return GestureDetector(
              onTap: () {
                widget.onSelected?.call(item);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.pageColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1B2D45)
                        : const Color(0xFFE8ECF1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      size: 16,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF617286),
                    ),
                    const Gap(6),
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF617286),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

IconData categoryIcon(String name) {
  switch (name) {
    case 'feather':
      return LucideIcons.feather;
    case 'sprout':
      return LucideIcons.sprout;
    case 'history':
      return LucideIcons.history;
    case 'science':
      return LucideIcons.atom;
    default:
      return LucideIcons.layoutGrid;
  }
}

List<CategoryItem> buildCategoryItems(List<Category> categories) {
  return [
    const CategoryItem(id: 'all', title: 'الكل', icon: LucideIcons.layoutGrid),
    ...categories.map(
      (c) => CategoryItem(id: c.id, title: c.name, icon: categoryIcon(c.icon)),
    ),
  ];
}
