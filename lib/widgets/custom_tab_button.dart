import 'package:flutter/material.dart';

class CustomTabButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? unselectedColor;

  const CustomTabButton({
    super.key,
    required this.text,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (unselectedColor != null
                    ? unselectedColor!.withAlpha(77) // 30% opacity
                    : const Color(0xFFE0E0E0))
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.black : Colors.grey,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
