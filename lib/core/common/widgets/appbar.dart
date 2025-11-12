import 'package:flutter/material.dart';
import 'package:wallpaper_studio/core/common/constants/crypto_colors.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TAppBar({
    super.key,
    this.showBackArrow = false,
    this.title,
    this.leadingIcon,
    this.actions,
    this.leadingOnpressed,
    this.centerTitle = false,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnpressed;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: centerTitle,
        leadingWidth: 40,
        leading: showBackArrow
            ? IconButton(
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(), // Remove default constraints
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: CColors.primaryTextColor,
                ))
            : leadingIcon != null
                ? IconButton(
                    onPressed: leadingOnpressed, icon: Icon(leadingIcon))
                : null,
        title: title,
        titleSpacing: 0,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
