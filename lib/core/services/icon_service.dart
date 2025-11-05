import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpaper_studio/core/common/constants/colors.dart';

class IconService {
  static String getIconPath(int index) {
    final iconPaths = [
      'assets/vectors/home_vector.svg',
      'assets/vectors/browse_vector.svg',
      'assets/vectors/favorite_vector.svg',
      'assets/vectors/settings_vector.svg',
    ];
    return iconPaths[index % iconPaths.length];
  }

  static SvgPicture getIcon(int index, {bool isSelected = false}) {
    return SvgPicture.asset(
      getIconPath(index),
      width: 18,
      height: 18.75,
      colorFilter: ColorFilter.mode(
        isSelected ? WColors.primaryTextColor : WColors.darkgrey,
        BlendMode.srcIn,
      ),
    );
  }
}
