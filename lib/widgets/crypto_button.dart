import 'package:flutter/material.dart';
import '../core/common/constants/crypto_colors.dart'; // ← Your colors

class CryptoButton extends StatelessWidget {
  const CryptoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fullWidth = false,
    this.height = 50,
    this.width = 200,
    this.isLoading = false,
    this.disabled = false,
    this.variant = CryptoButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final double width;
  final bool fullWidth;
  final bool isLoading;
  final bool disabled;
  final CryptoButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onPressed != null && !isLoading && !disabled;

    // Button style based on variant
    final buttonStyle = _getButtonStyle(variant, theme, enabled);

    return SizedBox(
      height: height,
      width: fullWidth ? double.infinity : width,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: buttonStyle,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: enabled ? Colors.white : Colors.white70,
                ),
              ),
      ),
    );
  }

  // === BUTTON STYLES ===
  ButtonStyle _getButtonStyle(
    CryptoButtonVariant variant,
    ThemeData theme,
    bool enabled,
  ) {
    switch (variant) {
      case CryptoButtonVariant.primary:
        return FilledButton.styleFrom(
          backgroundColor:
              enabled ? CColors.primary : CColors.primary.withOpacity(0.5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: enabled ? 2 : 0,
          shadowColor: CColors.primary.withOpacity(0.3),
        );

      case CryptoButtonVariant.secondary:
        return FilledButton.styleFrom(
          backgroundColor:
              enabled ? CColors.secondary : CColors.secondary.withOpacity(0.5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: enabled ? 1 : 0,
        );

      case CryptoButtonVariant.outline:
        return OutlinedButton.styleFrom(
          foregroundColor:
              enabled ? CColors.primary : CColors.primary.withOpacity(0.5),
          side: BorderSide(
            color: enabled ? CColors.primary : CColors.primary.withOpacity(0.5),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );

      case CryptoButtonVariant.danger:
        return FilledButton.styleFrom(
          backgroundColor: enabled ? Colors.red.shade600 : Colors.red.shade300,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: enabled ? 2 : 0,
        );
    }
  }
}

// === BUTTON VARIANTS ===
enum CryptoButtonVariant {
  primary,
  secondary,
  outline,
  danger,
}
