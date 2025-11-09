import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpaper_studio/widgets/favourite_button.dart';
import 'package:wallpaper_studio/widgets/rounded_images.dart';

import '../core/common/constants/colors.dart';
import '../core/services/data_service.dart';
import '../core/services/icon_service.dart';
import '../mobile/nature.dart';
import '../widgets/app_button.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/view_toggle.dart';
import 'home_screen.dart';

enum DisplayMode {
  fit,
  fill,
  stretch,
  tile,
}

class NatureScreen extends StatefulWidget {
  final String categoryTitle;
  final List<Nature> natures;
  final int selectedIndex;
  final Function(Nature)? onToggleFavorite;

  const NatureScreen({
    super.key,
    required this.categoryTitle,
    required this.natures,
    required this.selectedIndex,
    this.onToggleFavorite,
  });

  @override
  State<NatureScreen> createState() => _NatureScreenState();
}

class _NatureScreenState extends State<NatureScreen> {
  bool _isNatureGridView = true;
  final DataService _dataService = DataService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _toggleNatureViewMode(bool isGrid) {
    setState(() {
      _isNatureGridView = isGrid;
    });
  }

  void _toggleFavorite(Nature item) {
    setState(() {
      item.isFavorite = !item.isFavorite;
    });

    // Notify parent about favorite change
    if (widget.onToggleFavorite != null) {
      widget.onToggleFavorite!(item);
    }
  }

  void openWallpaperSetup(BuildContext context) {
    if (isDesktop(context)) {
      _showDesktopSidebar(context);
    } else {
      _showMobileDialog(context);
    }
  }

  void _openPreview(Nature nature, BuildContext context) {
    final mq = MediaQuery.of(context);
    final bool isMobile = mq.size.width < 600;
    final bool isTablet = mq.size.width >= 600 && mq.size.width < 900;

    // For mobile we want a full width dialog with some padding.
    // For tablet we constrain width to something comfortable (e.g. 700).
    final double maxWidth = isMobile ? mq.size.width : (isTablet ? 700 : 700);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              // limit height so content can scroll inside the dialog if needed
              maxHeight: mq.size.height * 0.9,
            ),
            child: Padding(
              padding: EdgeInsets.zero,
              child: isMobile
                  ? _buildMobileNaturePreview(nature)
                  : _buildNaturePreview(nature),
            ),
          ),
        );
      },
    );
  }

  void _showDesktopSidebar(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss sidebar",
      barrierColor: Colors.black.withOpacity(0.40), // 40% dim
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return const _WallpaperSidebarWrapper();
      },
    );
  }

  void _showMobileDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.40),
      builder: (_) {
        return const Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          backgroundColor: Colors.white,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: WallpaperSetupPanel(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WColors.backgroundColor,
      key: _scaffoldKey,
      // endDrawer: CustomDrawer(
      //   pages: _dataService.pages,
      //   // selectedIndex: widget.selectedIndex,
      //   selectedIndex: _selectedIndex,
      //   onItemSelected: (index) => setState(() {
      //     _selectedIndex = index;
      //   }
      //   ),
      //   getIcon: (index, isSelected) =>
      //       IconService.getIcon(index, isSelected: isSelected),
      // ),
      endDrawer: CustomDrawer(
        pages: _dataService.pages,
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Navigate back to HomeScreen when a different nav item is selected
          if (index != widget.selectedIndex) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
            );
          }
        },
        getIcon: (index, isSelected) =>
            IconService.getIcon(index, isSelected: isSelected),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        bool isTablet =
            constraints.maxWidth >= 600 && constraints.maxWidth < 900;
        bool isDesktop = constraints.maxWidth >= 900;

        return Column(
          children: [
            CustomAppBar(
              isMobile: isMobile,
              isTablet: isTablet,
              isDesktop: isDesktop,
              selectedIndex: widget.selectedIndex,
              pages: _dataService.pages,
              // onItemSelected: (index) => setState(() {
              //   _selectedIndex = index;
              // }),
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });

                // Navigate back to HomeScreen when a different nav item is selected
                if (index != widget.selectedIndex) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false,
                  );
                }
              },
              onMenuPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
              scaffoldKey: _scaffoldKey,
              getIcon: (index, isSelected) =>
                  IconService.getIcon(index, isSelected: isSelected),
            ),
            Expanded(
                child: Padding(
              padding: isDesktop
                  ? const EdgeInsets.symmetric(horizontal: 35)
                  : const EdgeInsets.symmetric(horizontal: 16),
              child: _buildNatureScreenContent(isMobile, isTablet, isDesktop),
            )),
          ],
        );
      }),
    );
  }

  Widget _buildNatureScreenContent(
      bool isMobile, bool isTablet, bool isDesktop) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double outerHorizontalPadding = 16;
        final double availableWidth =
            constraints.maxWidth - (outerHorizontalPadding * 2);
        final int crossAxisCount = isDesktop ? 3 : 2;
        const double spacing = 23;

        final double totalGapWidth = (crossAxisCount - 1) * spacing;
        final double itemWidth =
            (availableWidth - totalGapWidth) / crossAxisCount;

        final double desiredItemHeight = isDesktop
            ? 290.71
            : isTablet
                ? 300
                : 260;

        // final double childAspectRatio = itemWidth / desiredItemHeight;
        // this below is just for testing
        final double childAspectRatio = 3 / 4;

        return Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back,
                          )),
                      const SizedBox(width: 4),
                      const Text('Back to categories',
                          style: TextStyle(
                            color: WColors.secondaryTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nature',
                        style: TextStyle(
                            color: WColors.primaryTextColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 48),
                      ),
                      ViewToggle(
                        isGridView: _isNatureGridView,
                        onToggle: _toggleNatureViewMode,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                      child: SingleChildScrollView(
                    // padding: const EdgeInsets.all(16),
                    child: _isNatureGridView
                        ? _buildNatureGridView(isMobile, isTablet, isDesktop,
                            crossAxisCount, spacing, childAspectRatio)
                        : _buildNatureListView(isMobile, isTablet, isDesktop),
                  ))
                ],
              ),
            ),
            if (isDesktop) ...[
              const SizedBox(width: 20),
              Expanded(child: _buildNaturePreview(widget.natures.first)),
            ]
          ],
        );
      },
    );
  }

  Widget _buildNaturePreview(Nature nature) {
    const double _buttonBreakpoint = 430;
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Preview',
                          style: TextStyle(
                              color: WColors.primaryTextColor,
                              fontSize: 32,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 32),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Name',
                            style: TextStyle(
                                color: WColors.secondaryTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            nature.title,
                            style: const TextStyle(
                                color: WColors.primaryTextColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tags',
                            style: TextStyle(
                                color: WColors.secondaryTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          Wrap(
                            spacing: 5,
                            children: nature.tag.map((tagItem) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: WColors.grey,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  tagItem,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: WColors.primaryTextColor,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description',
                            style: TextStyle(
                              color: WColors.secondaryTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.black, Colors.white],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(Rect.fromLTWH(
                                0, 0, bounds.width, bounds.height)),
                            child: AutoSizeText(
                              nature.description,
                              maxLines: 8,
                              minFontSize: 10,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 37),
                      Row(
                        children: [
                          _actionIcon('assets/vectors/download_vector.svg'),
                          const SizedBox(width: 16.33),
                          _actionIcon('assets/vectors/expand_vector.svg'),
                          const SizedBox(width: 16.33),
                          _actionIcon('assets/vectors/settings_vector.svg'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 37),
                Flexible(
                  flex: 2,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxHeight =
                          constraints.maxHeight * 0.75; // 75% of column max
                      return ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: maxHeight),
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/Frame_127.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 41),
            LayoutBuilder(
              builder: (context, constraints) {
                final bool stackButtons =
                    constraints.maxWidth < _buttonBreakpoint;

                final buttons = [
                  AppButton(
                    label: "Save to Favorites",
                    icon: Icons.favorite_border,
                    type: ButtonType.outline,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16, height: 16),
                  AppButton(
                    label: "Set to Wallpaper",
                    type: ButtonType.filled,
                    onPressed: () => openWallpaperSetup(context),
                  ),
                ];

                return stackButtons
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: buttons,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: buttons,
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileNaturePreview(Nature nature) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: Image.asset(
                  'assets/images/Frame_127.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Preview',
              style: TextStyle(
                color: WColors.primaryTextColor,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Name',
              style: TextStyle(
                color: WColors.secondaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              nature.title,
              style: const TextStyle(
                color: WColors.primaryTextColor,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tags',
              style: TextStyle(
                color: WColors.secondaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: nature.tag.map((tagItem) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: WColors.grey,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    tagItem,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: WColors.primaryTextColor,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(
                color: WColors.secondaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 6),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.black, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: AutoSizeText(
                nature.description,
                maxLines: 8,
                minFontSize: 10,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _actionIcon('assets/vectors/download_vector.svg'),
                const SizedBox(width: 16),
                _actionIcon('assets/vectors/expand_vector.svg'),
                const SizedBox(width: 16),
                _actionIcon('assets/vectors/settings_vector.svg'),
              ],
            ),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppButton(
                  label: "Save to Favorites",
                  icon: Icons.favorite_border,
                  type: ButtonType.outline,
                  onPressed: () {},
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: "Set to Wallpaper",
                  type: ButtonType.filled,
                  onPressed: () => openWallpaperSetup(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionIcon(String asset) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(6.53),
      decoration: BoxDecoration(
        color: WColors.containergrey,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: WColors.border2.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: SvgPicture.asset(
        asset,
        width: 18,
        height: 18,
        colorFilter: const ColorFilter.mode(
          WColors.darkgrey,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildNatureGridView(
    bool isMobile,
    bool isTablet,
    bool isDesktop,
    int crossAxisCount,
    double spacing,
    double childAspectRatio,
  ) {
    final items = widget.natures;
    return GridView.builder(
      shrinkWrap: true,
      itemCount: widget.natures.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final nature = items[index];
        return _buildNatureGridItem(isMobile, isTablet, isDesktop, nature,
            () => _toggleFavorite(nature));
      },
    );
  }

  Widget _buildNatureListView(bool isMobile, bool isTablet, bool isDesktop) {
    final items = widget.natures;
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          itemCount: widget.natures.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final nature = items[index];
            return _buildNatureListItem(isMobile, isTablet, isDesktop, nature,
                () => _toggleFavorite(nature));
          },
          separatorBuilder: (context, index) => const SizedBox(height: 16),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildNatureGridItem(
    bool isMobile,
    bool isTablet,
    bool isDesktop,
    Nature item,
    VoidCallback onFavTapped,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              (isMobile || isTablet) ? () => _openPreview(item, context) : null,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AspectRatio(
                aspectRatio: 3 / 4,
                child: RoundedImage(
                  imageUrl: item.imagePath,
                  fit: BoxFit.cover,
                  height: null,
                  width: null,
                  padding: EdgeInsets.zero,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.45),
                      Colors.black.withOpacity(0.08),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: FavouriteButton(
                  isFavorite: item.isFavorite,
                  onTap: () => _toggleFavorite(item),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: item.tag.take(1).map((tagItem) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(width: 0.5, color: Colors.white),
                          ),
                          child: Text(
                            tagItem,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNatureListItem(
    bool isMobile,
    bool isTablet,
    bool isDesktop,
    Nature item,
    VoidCallback onFavTapped,
  ) {
    return Row(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: (isMobile || isTablet)
                      ? () => _openPreview(item, context)
                      : null,
                  child: SizedBox(
                    height: isDesktop ? 185.12 : 150.0,
                    width: isDesktop ? 277.21 : 150,
                    child: Image(
                        fit: BoxFit.cover, image: AssetImage(item.imagePath)),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.45),
                    Colors.black.withOpacity(0.08),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: FavouriteButton(
                isFavorite: item.isFavorite,
                onTap: () => _toggleFavorite(item),
              ),
            ),
          ],
        ),
        const SizedBox(width: 19),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: WColors.primaryTextColor)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: item.tag.map((tagItem) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: WColors.grey,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(width: 0.5, color: WColors.greyshade),
                    ),
                    child: Text(
                      tagItem,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: WColors.primaryTextColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WallpaperSidebarWrapper extends StatefulWidget {
  const _WallpaperSidebarWrapper({super.key});

  @override
  State<_WallpaperSidebarWrapper> createState() =>
      _WallpaperSidebarWrapperState();
}

class _WallpaperSidebarWrapperState extends State<_WallpaperSidebarWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slide = Tween(begin: const Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Stack(
          children: [
            // 🔹 Blur Layer
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: const SizedBox(),
              ),
            ),

            // 🔹 Sidebar
            Align(
              alignment: Alignment.centerRight,
              child: SlideTransition(
                position: _slide,
                child: Container(
                  width: 656,
                  height: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(32),
                  child: const WallpaperSetupPanel(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WallpaperSetupPanel extends StatelessWidget {
  const WallpaperSetupPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 500;
    DisplayMode _selectedMode = DisplayMode.fit;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Wallpaper Setup",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          const Text(
            'Configure your wallpaper settings and enable auto-rotation',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 26),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: WColors.border),
              borderRadius: BorderRadius.circular(16),
            ),
            child: !isWide
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Activate Wallpaper',
                        style: TextStyle(
                            color: WColors.primaryTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Set the selected wallpaper as your desktop background',
                        style: TextStyle(
                            color: WColors.secondaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 144,
                        height: 44,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xffc8ffbd),
                          borderRadius: BorderRadius.circular(38),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Color(0xff1ba400),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Activited',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff1ba400)),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Activate Wallpaper',
                            style: TextStyle(
                                color: WColors.primaryTextColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Set the selected wallpaper as your desktop background',
                            style: TextStyle(
                                color: WColors.secondaryTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Container(
                        width: 144,
                        height: 44,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xffc8ffbd),
                          borderRadius: BorderRadius.circular(38),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Color(0xff1ba400),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Activited',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Display Mode',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: WColors.primaryTextColor),
          ),
          const SizedBox(height: 8),
          _displayMode(
            DisplayMode.fit,
            'Fit',
            'Scale to fit without cropping',
          ),
          const SizedBox(height: 8),
          _displayMode(
            DisplayMode.fill,
            'Fill',
            'Scale to fill the entire screen',
          ),
          const SizedBox(height: 8),
          _displayMode(
            DisplayMode.stretch,
            'Stretch',
            'Stretch to fill the screen',
          ),
          const SizedBox(height: 8),
          _displayMode(
            DisplayMode.tile,
            'Tile',
            'Repeat the image to fill the screen',
          ),
          const SizedBox(height: 26),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: WColors.border)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auto - Rotation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: WColors.primaryTextColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Automatically change your wallpaper at regular intervals',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: WColors.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: true,
                  onChanged: (bool value) {},
                  activeColor: Colors.white,
                  activeTrackColor: WColors.primary,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Advanced Settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 8),
          _advanceSettings(
              DisplayMode.fit, 'Lock Wallpaper', 'Prevent accidental changes'),
          const SizedBox(height: 8),
          _advanceSettings(DisplayMode.fill, 'Sync Across Device',
              'Keep wallpaper consistent on all devices'),
          const SizedBox(height: 8),
          const SizedBox(height: 40),
          if (isWide)
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: "Cancel",
                    type: ButtonType.outline,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppButton(
                    label: "Apply Wallpaper",
                    onPressed: () {},
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                AppButton(
                  label: "Apply Wallpaper",
                  width: double.infinity,
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: "Cancel",
                  type: ButtonType.outline,
                  width: double.infinity,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _displayMode(
    DisplayMode mode,
    String title,
    String description,
  ) {
    final bool isSelected = mode == DisplayMode.fit;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: WColors.border)),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? WColors.primary : WColors.border,
                  width: 1,
                ),
                color: Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 19,
                        height: 19,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: WColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: WColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: WColors.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _advanceSettings(
    DisplayMode mode,
    String title,
    String description,
  ) {
    final bool isSelected = mode == DisplayMode.fit;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: WColors.border)),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.99),
                border: Border.all(
                  color: isSelected ? WColors.primary : WColors.border,
                  width: 1,
                ),
                color: Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 19,
                        height: 19,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.99),
                          color: WColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: WColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: WColors.secondaryTextColor,
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
