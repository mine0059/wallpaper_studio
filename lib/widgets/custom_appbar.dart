import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpaper_studio/core/common/constants/colors.dart';

class CustomAppBar extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final int selectedIndex;
  final List<String> pages;
  final Function(int) onItemSelected;
  final Function() onMenuPressed;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(int, bool) getIcon;

  const CustomAppBar({
    super.key,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    required this.selectedIndex,
    required this.pages,
    required this.onItemSelected,
    required this.onMenuPressed,
    required this.scaffoldKey,
    required this.getIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 47 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
              color: WColors.primaryTextColor.withOpacity(0.2), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: isDesktop
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [WColors.secondary, WColors.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcIn,
                  child: SvgPicture.asset(
                    'assets/vectors/logo_vector.svg',
                    width: 14,
                    height: 14,
                    colorFilter:
                        const ColorFilter.mode(WColors.white, BlendMode.srcIn),
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'Wallpaper studio',
                  style: TextStyle(
                      color: WColors.primaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          if (isDesktop)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                pages.length,
                (index) {
                  final isSelected = selectedIndex == index;

                  return InkWell(
                    onTap: () => onItemSelected(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: isSelected
                          ? BoxDecoration(
                              color: WColors.grey,
                              borderRadius: BorderRadius.circular(12),
                            )
                          : null,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          getIcon(index, isSelected),
                          const SizedBox(width: 4),
                          Text(
                            pages[index],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: isSelected
                                  ? WColors.primaryTextColor
                                  : WColors.darkgrey,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          if (!isDesktop)
            IconButton(
              onPressed: onMenuPressed,
              icon: const Icon(Icons.menu),
            ),
        ],
      ),
    );
  }
}
