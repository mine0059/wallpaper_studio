import 'package:flutter/material.dart';
import 'package:wallpaper_studio/core/common/constants/colors.dart';

enum ButtonType { filled, outline }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonType type;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final double height;
  final double width;
  final double borderRadius;
  final double spacing;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = ButtonType.filled,
    this.color,
    this.textColor,
    this.icon,
    this.height = 50,
    this.width = 200,
    this.borderRadius = 21,
    this.spacing = 10,
    this.fullWidth = false,
  });

  bool get _isDisabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    final bgColor = type == ButtonType.filled
        ? (color ?? WColors.primary)
        : Colors.transparent;

    final borderColor =
        type == ButtonType.outline ? WColors.border : Colors.transparent;

    final txtColor = textColor ??
        (type == ButtonType.filled ? Colors.white : WColors.primaryTextColor);

    return Opacity(
      opacity: _isDisabled ? 0.4 : 1,
      child: InkWell(
        onTap: _isDisabled ? null : onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          height: height,
          width: fullWidth ? double.infinity : width,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor, width: 1.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: txtColor),
                SizedBox(width: spacing),
              ],
              Text(
                label,
                style: TextStyle(
                  color: txtColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
