import 'package:flutter/material.dart';
import 'package:wallpaper_studio/core/common/constants/colors.dart';

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const GradientText(
    this.text, {
    super.key,
    this.fontSize = 60,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [WColors.primary, WColors.secondary],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "ClashDisplay",
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: Colors.white,
          height: 1.0,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
