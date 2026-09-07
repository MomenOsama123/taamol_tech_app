import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label);

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: icon == null
          ? ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: backgroundColor == null
                  ? null
                  : ElevatedButton.styleFrom(backgroundColor: backgroundColor),
              child: buttonChild,
            )
          : ElevatedButton.icon(
              onPressed: isLoading ? null : onPressed,
              style: backgroundColor == null
                  ? null
                  : ElevatedButton.styleFrom(backgroundColor: backgroundColor),
              icon: Icon(icon),
              label: buttonChild,
            ),
    );
  }
}
