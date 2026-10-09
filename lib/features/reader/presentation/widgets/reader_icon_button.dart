import 'package:flutter/material.dart';

class ReaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;
  final double borderRadius;
  final Color? color;

  const ReaderIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 34,
    this.iconSize = 16,
    this.borderRadius = 120,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: const Color(0xffe7e7e0)),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: iconSize),
        color: color,
        onPressed: onPressed,
      ),
    );
  }
}
