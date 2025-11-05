import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../core/common/constants/colors.dart';

class FavouriteButton extends StatelessWidget {
  const FavouriteButton(
      {super.key, required this.onTap, required this.isFavorite});

  final VoidCallback onTap;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isFavorite ? Colors.white : Colors.white.withOpacity(0.2),
          border: Border.all(
              color: !isFavorite
                  ? Colors.white.withOpacity(0.2)
                  : Colors.transparent),
        ),
        child: SvgPicture.asset(
          'assets/vectors/favorite_vector.svg',
          width: 18,
          height: 16,
          colorFilter: ColorFilter.mode(
            isFavorite ? WColors.primary : WColors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
