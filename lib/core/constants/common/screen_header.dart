import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/app_colors.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final bool haveShadow;

  const ScreenHeader({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    this.haveShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        haveShadow
            ? Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xffE6EEF6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: Color(0xff5B7A99)),
              )
            : CircleAvatar(
                backgroundColor: Color(0xffE9E0D2),
                child: Center(
                  child: Icon(icon, size: 20, color: Color(0xffB58B43)),
                ),
              ),
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryColor,
              ),
            ),
            const Gap(6),
            Text(
              subTitle,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 11, color: Color(0xff617286)),
            ),
          ],
        ),
      ],
    );
  }
}
