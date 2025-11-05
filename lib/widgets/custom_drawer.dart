import 'package:flutter/material.dart';
import 'package:wallpaper_studio/core/common/constants/colors.dart';

class CustomDrawer extends StatelessWidget {
  final List<String> pages;
  final int selectedIndex;
  final void Function(int) onItemSelected;
  final Widget Function(int, bool) getIcon;

  const CustomDrawer({
    super.key,
    required this.pages,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.getIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: [
                ...List.generate(pages.length, (index) {
                  final isSelected = selectedIndex == index;
                  return Column(
                    children: [
                      ListTile(
                        leading: getIcon(index, isSelected),
                        title: Text(
                          pages[index],
                          style: TextStyle(
                            color: isSelected
                                ? WColors.primaryTextColor
                                : WColors.darkgrey,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        selected: isSelected,
                        onTap: () {
                          onItemSelected(index);
                          Navigator.pop(context);
                        },
                      ),
                      Divider(
                        thickness: 1,
                        height: 20,
                        color: WColors.primaryTextColor.withOpacity(0.1),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
