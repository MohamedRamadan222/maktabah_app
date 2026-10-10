import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:maktabah_app/features/reader/presentation/widgets/reader_icon_button.dart';

class ReaderFontSizeControls extends StatelessWidget {
  final int fontSize;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const ReaderFontSizeControls({
    super.key,
    required this.fontSize,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'حجم الخط',
          style: TextStyle(fontSize: 10, color: Color(0xff617286)),
        ),
        const Gap(8),
        ReaderIconButton(
          icon: CupertinoIcons.minus,
          size: 30,
          iconSize: 12,
          borderRadius: 5,
          color: const Color(0xff617286),
          onPressed: onDecrease,
        ),
        const Gap(10),
        Text(
          fontSize.toString(),
          style: const TextStyle(fontSize: 10, color: Color(0xff879398)),
        ),
        const Gap(10),
        ReaderIconButton(
          icon: CupertinoIcons.plus,
          size: 30,
          iconSize: 12,
          borderRadius: 5,
          color: const Color(0xff617286),
          onPressed: onIncrease,
        ),
      ],
    );
  }
}
