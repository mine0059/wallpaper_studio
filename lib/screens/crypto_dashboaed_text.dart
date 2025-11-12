import 'package:flutter/material.dart';
import 'package:wallpaper_studio/core/common/constants/crypto_colors.dart';
import 'package:wallpaper_studio/core/common/widgets/appbar.dart';

const minimumDragSize = 0.33;
const maximumDragSize = 1.0;

class CryptoHomeScreenTest extends StatefulWidget {
  const CryptoHomeScreenTest({super.key});

  @override
  State<CryptoHomeScreenTest> createState() => _CryptoHomeScreenTestState();
}

class _CryptoHomeScreenTestState extends State<CryptoHomeScreenTest> {
  final DraggableScrollableController _draggableScrollableController =
      DraggableScrollableController();

  bool _isExpanded = false;
  double draggableSheetSize = minimumDragSize;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.darkgrey,
      body: Column(
        children: [
          // Top fixed content (NOT scrollable)
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16)),
            ),
            child: Column(
              children: [
                const TAppBar(
                  title: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tyrone Wayne',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: CColors.primaryTextColor,
                            ),
                          ),
                          Text(
                            'user@gmail.com',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: CColors.secondaryTextColor,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  actions: [Icon(Icons.notifications)],
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Portfolio',
                            style: TextStyle(
                                color: CColors.secondaryTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            '\$5,271.39',
                            style: TextStyle(
                                color: CColors.primaryTextColor,
                                fontSize: 25,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '+130.62%',
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '+\$2,979.23',
                            style: TextStyle(
                                color: CColors.secondaryTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildTapSection(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Advert Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildAdvertCard(),
          ),

          const SizedBox(height: 10),

          DraggableScrollableSheet(
              snap: true,
              controller: _draggableScrollableController,
              initialChildSize: minimumDragSize,
              minChildSize: minimumDragSize,
              builder: (context, scrollController) => Stack(
                    children: [Container()],
                  ))

          // Bottom Sheet - takes remaining space
          // Expanded(
          //   child: _isExpanded
          //       ? _buildExpandedBottomSheet()
          //       : _buildPersistentBottomSheet(),
          // ),
        ],
      ),
    );
  }

  Widget _buildExpandedBottomSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          _buildSheetHeader(),
          const Divider(height: 1, color: CColors.border),
          Expanded(
            child: _buildBottomSheetContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildPersistentBottomSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSheetHeader(),
          const Divider(height: 1, color: CColors.border),
          Expanded(
            child: _buildBottomSheetContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Drag handle indicator
          Expanded(
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: CColors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Expand/Collapse button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleExpanded,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _isExpanded ? Icons.close_fullscreen : Icons.open_in_full,
                  size: 20,
                  color: CColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Assets',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: CColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: CColors.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Content will go here',
                style: TextStyle(
                  color: CColors.secondaryTextColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: CColors.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'More content here',
                style: TextStyle(
                  color: CColors.secondaryTextColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: CColors.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Even more content',
                style: TextStyle(
                  color: CColors.secondaryTextColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTapSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(color: CColors.border),
          borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: _buildTapSectionItem('Analytics', Icons.bar_chart),
          ),
          Container(
            width: 1,
            height: 50,
            color: CColors.border,
          ),
          Expanded(
            child: _buildTapSectionItem('Withdraw', Icons.arrow_upward),
          ),
          Container(
            width: 1,
            height: 50,
            color: CColors.border,
          ),
          Expanded(
            child: _buildTapSectionItem('Deposit', Icons.arrow_downward),
          ),
        ],
      ),
    );
  }

  Widget _buildTapSectionItem(String title, IconData icon) {
    return InkWell(
      onTap: () {
        debugPrint("$title has been tapped");
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: CColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: CColors.white)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: CColors.primaryTextColor),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAdvertCard() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Text(
                'Invite a friend and you can both get \$10 in BTC',
                style: TextStyle(
                    color: CColors.primaryTextColor,
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    height: 1.3),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Image.asset(
                'assets/categories/category_4.jpg',
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
