import 'package:flutter/material.dart';
import 'package:wallpaper_studio/core/common/constants/colors.dart';
import 'package:wallpaper_studio/widgets/rounded_images.dart';

import '../core/services/data_service.dart';
import '../core/services/icon_service.dart';
import '../mobile/nature.dart';
import '../widgets/app_button.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/favourite_button.dart';
import '../widgets/gradient_text.dart';
import '../widgets/view_toggle.dart';
import 'nature_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isGridView = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DataService _dataService = DataService();
  List<Nature> _favoriteNatures = [];

  void _toggleViewMode(bool isGrid) {
    setState(() {
      _isGridView = isGrid;
    });
  }

  void _toggleFavorite(Nature nature) {
    setState(() {
      if (_favoriteNatures.contains(nature)) {
        _favoriteNatures.remove(nature);
        nature.isFavorite = false;
      } else {
        _favoriteNatures.add(nature);
        nature.isFavorite = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentSection = _dataService.sectionHeadings[_selectedIndex];
    return Scaffold(
      backgroundColor: WColors.backgroundColor,
      key: _scaffoldKey,
      endDrawer: CustomDrawer(
        pages: _dataService.pages,
        selectedIndex: _selectedIndex,
        onItemSelected: (index) => setState(() => _selectedIndex = index),
        getIcon: (index, isSelected) =>
            IconService.getIcon(index, isSelected: isSelected),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        bool isTablet =
            constraints.maxWidth >= 600 && constraints.maxWidth < 900;
        bool isDesktop = constraints.maxWidth >= 900;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              isMobile: isMobile,
              isTablet: isTablet,
              isDesktop: isDesktop,
              selectedIndex: _selectedIndex,
              pages: _dataService.pages,
              onItemSelected: (index) => setState(() => _selectedIndex = index),
              onMenuPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
              scaffoldKey: _scaffoldKey,
              getIcon: (index, isSelected) =>
                  IconService.getIcon(index, isSelected: isSelected),
            ),
            Padding(
              padding: isDesktop
                  ? const EdgeInsets.symmetric(horizontal: 35)
                  : const EdgeInsets.symmetric(horizontal: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 870),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    GradientText(
                      currentSection.title,
                      fontSize: !isDesktop ? 24 : 60,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(currentSection.description,
                              style: const TextStyle(
                                  color: WColors.secondaryTextColor)),
                        ),
                        if (_selectedIndex == 1)
                          ViewToggle(
                            isGridView: _isGridView,
                            onToggle: _toggleViewMode,
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: isDesktop
                    ? const EdgeInsets.symmetric(horizontal: 35)
                    : const EdgeInsets.symmetric(horizontal: 16),
                child: _buildPageContent(isMobile, isTablet, isDesktop),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPageContent(bool isMobile, bool isTablet, bool isDesktop) {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent(isMobile, isTablet, isDesktop);
      case 1:
        return _isGridView
            ? _buildHomeContent(isMobile, isTablet, isDesktop)
            : _buildHomeContentList(isMobile, isTablet, isDesktop);
      case 2:
        return _favoriteNatures.isEmpty
            ? _buildEmptyFavoriteScreen()
            : _buildFavouriteScreen(isMobile, isTablet, isDesktop);
      default:
        return _buildSettingsScreen(isMobile, isTablet, isDesktop);
      // return _buildDefaultScreen();
    }
  }

  Widget _buildHomeContent(bool isMobile, bool isTablet, bool isDesktop) {
    return LayoutBuilder(builder: (context, constraints) {
      const double outerHorizontalPadding = 16;
      final double availableWidth =
          constraints.maxWidth - (outerHorizontalPadding * 2);

      final int crossAxisCount = isDesktop
          ? 3
          : isTablet
              ? 2
              : 1;
      const double spacing = 23;

      // itemWidth = (total - gaps) / count
      final double totalGapWidth = (crossAxisCount - 1) * spacing;
      final double itemWidth =
          (availableWidth - totalGapWidth) / crossAxisCount;

      final double desiredItemHeight = isDesktop
          ? 290
          : isTablet
              ? 300
              : 260;

      final double childAspectRatio = itemWidth / desiredItemHeight;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: !isDesktop ? 20 : 32,
                  color: WColors.primaryTextColor,
                ),
              ),
              Text(
                'See All',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: !isDesktop ? 16 : 24,
                  color: WColors.darkgrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            itemCount: _dataService.categories.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              final category = _dataService.categories[index];
              return _buildCategotyItem(
                isMobile,
                isTablet,
                isDesktop,
                category.image,
                category.title,
                category.description,
                category.tag,
                () {
                  debugPrint("category Pressed");
                },
              );
            },
          ),
        ],
      );
    });
  }

  Widget _buildHomeContentList(bool isMobile, bool isTablet, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: !isDesktop ? 20 : 32,
                color: WColors.primaryTextColor,
              ),
            ),
            Text(
              'See All',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: !isDesktop ? 16 : 24,
                color: WColors.darkgrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          itemCount: _dataService.categories.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final category = _dataService.categories[index];
            return _buildListCategoryItem(
              isMobile,
              isTablet,
              isDesktop,
              category.image,
              category.title,
              category.description,
              category.tag,
              () {
                debugPrint("List category pressed: ${category.title}");
              },
            );
          },
          separatorBuilder: (context, index) => Divider(
            height: 32,
            thickness: 1,
            color: WColors.primaryTextColor.withOpacity(0.1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Container(
            height: 1,
            color: WColors.primaryTextColor.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildListCategoryItem(
      bool isMobile,
      bool isTablet,
      bool isDesktop,
      String imageUrl,
      String title,
      String description,
      String tag,
      VoidCallback onPressed) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              child: SizedBox(
                height: isDesktop ? 185.12 : 150.0,
                width: isDesktop ? 277.21 : 150,
                child: Image(fit: BoxFit.cover, image: AssetImage(imageUrl)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 19),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: WColors.primaryTextColor)),
              const SizedBox(height: 4),
              Container(
                child: Text(description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: WColors.primaryTextColor)),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    color: WColors.grey,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 0.5, color: WColors.greyshade)),
                child: Text(
                  tag,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: WColors.primaryTextColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategotyItem(
    bool isMobile,
    bool isTablet,
    bool isDesktop,
    String imageUrl,
    String title,
    String description,
    String tag,
    VoidCallback onPressed,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to NatureScreen when category is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NatureScreen(
                  categoryTitle: title,
                  natures: _dataService.natures,
                  selectedIndex: _selectedIndex,
                  onToggleFavorite: _toggleFavorite,
                ),
              ),
            );
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: RoundedImage(
                  imageUrl: imageUrl,
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
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(width: 0.5, color: Colors.white)),
                      child: Text(
                        tag,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
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

  Widget _buildSettingsScreen(bool isMobile, bool isTablet, bool isDesktop) {
    final bool isWide = isDesktop;
    final double maxWidth = isWide ? 1100 : double.infinity;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 35),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child:
              isWide ? _buildSettingsRowLayout() : _buildSettingsColumnLayout(),
        ),
      ),
    );
  }

  Widget _buildSettingsRowLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildSettingsForm(isDesktop: true)),
        const SizedBox(width: 37),
        Expanded(flex: 2, child: _buildPhonePreview()),
      ],
    );
  }

  Widget _buildSettingsColumnLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSettingsForm(isDesktop: false),
        const SizedBox(height: 30),
        _buildPhonePreview(),
      ],
    );
  }

  Widget _buildSettingsForm({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Wallpaper Setup',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: WColors.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Configure your wallpaper settings and enable auto-rotation',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: WColors.primaryTextColor),
        ),
        const SizedBox(height: 26),

        // Image Quality block...
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: WColors.border)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Image Quality',
                style: TextStyle(
                    color: WColors.primaryTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: WColors.border),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'High ( Best Quality )',
                      style: TextStyle(
                          color: WColors.secondaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 26),

        // Auto-Rotation block...
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
                      'Notification',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: WColors.primaryTextColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Get notified about new wallpapers and updates',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: WColors.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: true,
                  onChanged: (bool value) {},
                  activeColor: Colors.white,
                  activeTrackColor: WColors.primary,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),

        // Buttons
        isDesktop
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    label: "Cancel",
                    type: ButtonType.outline,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),
                  AppButton(
                    label: "Save Settings",
                    type: ButtonType.filled,
                    onPressed: () {},
                  ),
                ],
              )
            : Column(
                children: [
                  AppButton(
                    label: "Cancel",
                    type: ButtonType.outline,
                    fullWidth: true,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: "Save Settings",
                    type: ButtonType.filled,
                    fullWidth: true,
                    onPressed: () {},
                  ),
                ],
              )
      ],
    );
  }

  Widget _buildPhonePreview() {
    return LayoutBuilder(builder: (context, constraints) {
      final double phoneWidth = constraints.maxWidth.clamp(250, 380);
      // final double phoneHeight = phoneWidth * 1.9;
      final double phoneHeight = phoneWidth * 1.5;

      return Center(
        child: SizedBox(
          width: phoneWidth,
          height: phoneHeight,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/Rectangle_4.png',
                  fit: BoxFit.contain,
                  width: phoneWidth,
                  height: phoneHeight,
                ),
              ),

              // Notch
              Positioned(
                top: phoneHeight * 0.03,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    'assets/images/mobile_notch.png',
                    width: phoneWidth * 0.30,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Status box
              Positioned(
                bottom: phoneHeight * 0.4,
                left: phoneWidth * 0.17,
                right: phoneWidth * 0.17,
                child: Container(
                  width: 181,
                  height: 44,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xffcfffc3),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.rotate(
                          angle: -0.8,
                          child:
                              const Icon(Icons.link, color: Color(0xff168200))),
                      const SizedBox(width: 8),
                      const Text(
                        'Connected to device',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff168200)),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                bottom: phoneHeight * 0.35,
                left: 0,
                right: 0,
                child: const Center(
                  child: Text(
                    'Click to disconnect',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: WColors.primaryTextColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFavouriteScreen(bool isMobile, bool isTablet, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Saved Wallpapers',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: !isDesktop ? 20 : 32,
                color: WColors.primaryTextColor,
              ),
            ),
            Text(
              '${_favoriteNatures.length} items',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: !isDesktop ? 16 : 24,
                color: WColors.darkgrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildFavoritesGrid(isMobile, isTablet, isDesktop),
      ],
    );
  }

  Widget _buildFavoritesGrid(bool isMobile, bool isTablet, bool isDesktop) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double outerHorizontalPadding = 16;
        final double availableWidth =
            constraints.maxWidth - (outerHorizontalPadding * 2);

        // Responsive grid configuration
        final int crossAxisCount = isDesktop ? 4 : (isTablet ? 3 : 2);
        const double spacing = 23;

        final double totalGapWidth = (crossAxisCount - 1) * spacing;
        final double itemWidth =
            (availableWidth - totalGapWidth) / crossAxisCount;

        final double desiredItemHeight =
            isDesktop ? 290 : (isTablet ? 300 : 260);
        final double childAspectRatio = itemWidth / desiredItemHeight;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _favoriteNatures.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final nature = _favoriteNatures[index];
            return _buildFavoriteGridItem(
              isMobile,
              isTablet,
              isDesktop,
              nature,
              () => _toggleFavorite(nature),
            );
          },
        );
      },
    );
  }

  Widget _buildFavoriteGridItem(
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
          onTap: () {},
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
              // Favorite button
              Positioned(
                top: 12,
                right: 12,
                child: FavouriteButton(
                  isFavorite: item.isFavorite,
                  onTap: onFavTapped,
                ),
              ),
              // Item info
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
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: item.tag.take(2).map((tagItem) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 0.5, color: Colors.white),
                          ),
                          child: Text(
                            tagItem,
                            style: const TextStyle(
                              fontSize: 12,
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

  Widget _buildDefaultScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction,
              size: 100, color: Theme.of(context).primaryColor),
          const Text(
            'Page Under Contruction',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyFavoriteScreen() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background frame (larger one)
                  Positioned(
                    // bottom: 0,
                    child: Image.asset(
                      'assets/images/frame_1.png',
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Top frame (smaller one, positioned above)
                  Positioned(
                    // top: 0,
                    bottom: 0,
                    left: 10,
                    child: Image.asset(
                      'assets/images/frame.png',
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              'No Saved WallPapers',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: WColors.secondaryTextColor),
            ),
            const SizedBox(height: 12),
            const Text(
              'Start saving your favorite wallpapers to see them here',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: WColors.secondaryTextColor),
            ),
            const SizedBox(height: 20),
            AppButton(
              label: "Browse Wallpapers",
              type: ButtonType.filled,
              fullWidth: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
