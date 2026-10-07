import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
  final ValueChanged<CategoryItem>? onSelected;

  const CategoryChips({super.key, required this.categories, this.onSelected});

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: widget.categories.length,
          separatorBuilder: (_, __) => const Gap(8),
          itemBuilder: (_, i) {
            final item = widget.categories[i];
            final isSelected = i == _selected;
            return GestureDetector(
              onTap: () {
                setState(() => _selected = i);
                widget.onSelected?.call(item);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1B2D45) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
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
