import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSelected;

  const AnswerButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: isSelected ? scheme.primaryContainer : scheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: isSelected ? Border.all(color: scheme.primary, width: 1.2) : null,
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isSelected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
