import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpaper_studio/core/common/constants/colors.dart';

class ViewToggle extends StatelessWidget {
  final bool isGridView;
  final Function(bool) onToggle;

  const ViewToggle({
    super.key,
    required this.isGridView,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => onToggle(true),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: isGridView
                  ? WColors.primary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              'assets/vectors/grid_vector.svg',
              width: 18,
              height: 18.75,
              colorFilter: ColorFilter.mode(
                isGridView ? WColors.primary : WColors.darkgrey,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => onToggle(false),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: !isGridView
                  ? WColors.primary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              'assets/vectors/list_vector.svg',
              width: 18,
              height: 18.75,
              colorFilter: ColorFilter.mode(
                !isGridView ? WColors.primary : WColors.darkgrey,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
