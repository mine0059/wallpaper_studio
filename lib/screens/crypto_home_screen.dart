// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:chart_sparkline/chart_sparkline.dart';
// import 'package:flutter/material.dart';

// import '../core/common/constants/crypto_colors.dart';
// import '../core/common/widgets/appbar.dart';
// import 'package:http/http.dart' as http;

// import '../mobile/coin_model.dart';
// import 'coin_details_screen.dart';

// class CryptoHomeScreen extends StatefulWidget {
//   const CryptoHomeScreen({super.key});

//   @override
//   State<CryptoHomeScreen> createState() => _CryptoHomeScreenState();
// }

// class _CryptoHomeScreenState extends State<CryptoHomeScreen> {
//   final DraggableScrollableController _controller =
//       DraggableScrollableController();
//   final ValueNotifier<double> _sheetSize = ValueNotifier<double>(0.4);
//   List<CoinModel> coinMarket = [];
//   bool isLoading = true;

//   Future<void> getCoinMarket() async {
//     const url =
//         'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=true';

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       var response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         List<dynamic> jsonList = json.decode(response.body);
//         debugPrint('Fetched ${jsonList.length} coins');

//         setState(() {
//           coinMarket =
//               jsonList.map((json) => CoinModel.fromJson(json)).toList();
//           isLoading = false;
//         });
//       } else {
//         debugPrint('Error: ${response.statusCode}');
//         setState(() => isLoading = false);
//       }
//     } on TimeoutException {
//       debugPrint('Request timed out');
//       setState(() => isLoading = false);
//     } on SocketException {
//       debugPrint('No internet connection');
//       setState(() => isLoading = false);
//     } catch (e) {
//       debugPrint('Exception: $e');
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getCoinMarket();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_controller.isAttached) {
//         _controller.addListener(_updateSheetSize);
//         _sheetSize.value = _controller.size;
//       }
//     });
//   }

//   void _updateSheetSize() {
//     _sheetSize.value = _controller.size;
//   }

//   @override
//   void dispose() {
//     _controller.removeListener(_updateSheetSize);
//     _controller.dispose();
//     _sheetSize.dispose();
//     super.dispose();
//   }

//   void _toggleExpand() {
//     final target = _sheetSize.value < 0.6 ? 1.0 : 0.4;
//     _controller.animateTo(
//       target,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CColors.backgroundColor,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return Stack(
//             children: [
//               // === TOP CONTENT (Scrollable) ===
//               SingleChildScrollView(
//                 padding: EdgeInsets.only(bottom: 10),
//                 // padding: EdgeInsets.only(bottom: maxHeight * 0.4 + 10),
//                 child: Column(
//                   children: [
//                     _buildTopWhiteCard(),
//                     // const SizedBox(height: 10),
//                     const SizedBox(height: 20),
//                     _buildAdvertCard(),
//                     // const SizedBox(height: 100),
//                   ],
//                 ),
//               ),
//               // === DRAGGABLE BOTTOM SHEET ===
//               DraggableScrollableSheet(
//                 controller: _controller,
//                 snapSizes: const [0.4, 0.7, 1.0],
//                 initialChildSize: 0.4,
//                 minChildSize: 0.4,
//                 maxChildSize: 1.0,
//                 expand: true,
//                 builder: (context, scrollController) {
//                   return Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(16),
//                         topRight: Radius.circular(16),
//                       ),
//                     ),
//                     child: RefreshIndicator(
//                       onRefresh: getCoinMarket,
//                       child: CustomScrollView(
//                         controller: scrollController,
//                         slivers: [
//                           SliverPersistentHeader(
//                             pinned: true,
//                             delegate: _StickyHeaderDelegate(),
//                           ),
//                           const SliverToBoxAdapter(
//                             child: SizedBox(height: 10),
//                           ),
//                           isLoading
//                               ? const SliverFillRemaining(
//                                   child: Center(
//                                       child: CircularProgressIndicator(
//                                     strokeWidth: 3,
//                                     valueColor:
//                                         AlwaysStoppedAnimation(CColors.primary),
//                                   )),
//                                 )
//                               : coinMarket.isEmpty
//                                   ? SliverToBoxAdapter(
//                                       child: Center(
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             const Text('Failed to load data'),
//                                             TextButton(
//                                               onPressed: getCoinMarket,
//                                               child: const Text('Retry'),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     )
//                                   : SliverList(
//                                       delegate: SliverChildBuilderDelegate(
//                                         (context, index) {
//                                           final coin = coinMarket![index];
//                                           final isPositive =
//                                               coin.priceChangePercentage24h >=
//                                                   0;

//                                           return _buildCryptoItem(
//                                             context: context,
//                                             isPositive: isPositive,
//                                             coin: coin,
//                                           );
//                                         },
//                                         childCount: coinMarket!.length,
//                                       ),
//                                     ),
//                           // SliverToBoxAdapter(
//                           //   child: ValueListenableBuilder<double>(
//                           //     valueListenable: _sheetSize,
//                           //     builder: (context, size, child) {
//                           //       return AnimatedOpacity(
//                           //         opacity: size > 0.7 ? 1.0 : 0.0,
//                           //         duration: const Duration(milliseconds: 200),
//                           //         child: size > 0.7
//                           //             ? _buildAssetsSection()
//                           //             : const SizedBox.shrink(),
//                           //       );
//                           //     },
//                           //   ),
//                           // ),
//                           const SliverToBoxAdapter(
//                             child: SizedBox(height: 20),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               )
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTopWhiteCard() {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(16),
//           bottomRight: Radius.circular(16),
//         ),
//       ),
//       child: Column(
//         children: [
//           const TAppBar(
//             title: Row(
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Tyrone Wayne',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: CColors.primaryTextColor,
//                       ),
//                     ),
//                     Text(
//                       'user@gmail.com',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         color: CColors.secondaryTextColor,
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//             actions: [Icon(Icons.notifications)],
//           ),
//           const SizedBox(height: 10),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Portfolio',
//                       style: TextStyle(
//                           color: CColors.secondaryTextColor,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400),
//                     ),
//                     Text(
//                       '\$5,271.39',
//                       style: TextStyle(
//                           color: CColors.primaryTextColor,
//                           fontSize: 25,
//                           fontWeight: FontWeight.w600),
//                     )
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       '+130.62%',
//                       style: TextStyle(
//                           color: Colors.greenAccent,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     Text(
//                       '+\$2,979.23',
//                       style: TextStyle(
//                           color: CColors.secondaryTextColor,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: _buildTapSection(),
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   // Widget _buildAssetsSection() {
//   //   return Padding(
//   //     padding: const EdgeInsets.all(16),
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         const Text(
//   //           'Your Assets',
//   //           style: TextStyle(
//   //             fontSize: 20,
//   //             fontWeight: FontWeight.w700,
//   //             color: CColors.primaryTextColor,
//   //           ),
//   //         ),
//   //         const SizedBox(height: 16),
//   //         ...List.generate(3, (i) {
//   //           return Container(
//   //             margin: const EdgeInsets.only(bottom: 12),
//   //             padding: const EdgeInsets.all(16),
//   //             decoration: BoxDecoration(
//   //               color: CColors.backgroundColor,
//   //               borderRadius: BorderRadius.circular(12),
//   //             ),
//   //             child: Text('Asset ${i + 1}'),
//   //           );
//   //         }),
//   //       ],
//   //     ),
//   //   );
//   // }

//   Widget _buildCryptoItem({
//     required bool isPositive,
//     required CoinModel coin,
//     required BuildContext context, // ← Add context
//   }) {
//     final sparkline = coin.sparklineIn7d?.price ?? [];

//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => CoinDetailsScreen(coin: coin),
//           ),
//         );
//       },
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Row(
//           children: [
//             // === LEADING: Icon ===
//             Image.network(
//               coin.image,
//               width: 40,
//               height: 40,
//               errorBuilder: (_, __, ___) => const Icon(Icons.error, size: 20),
//             ),
//             const SizedBox(width: 12),

//             // === CENTER: Name + Sparkline ===
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     coin.name,
//                     style: const TextStyle(fontWeight: FontWeight.w600),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     coin.symbol.toUpperCase(),
//                     style: const TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 6),
//                   // === SPARKLINE IN MIDDLE ===
//                   if (sparkline.isNotEmpty)
//                     SizedBox(
//                       height: 20,
//                       width: 80,
//                       child: Sparkline(
//                         data: sparkline,
//                         lineColor: isPositive ? Colors.green : Colors.red,
//                         lineWidth: 1.5,
//                         fillMode: FillMode.below,
//                         fillGradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             (isPositive ? Colors.green : Colors.red)
//                                 .withOpacity(0.2),
//                             (isPositive ? Colors.green : Colors.red)
//                                 .withOpacity(0.0),
//                           ],
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),

//             // === TRAILING: Price + Change ===
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   '\$${coin.currentPrice.toStringAsFixed(2)}',
//                   style: const TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   '${isPositive ? '+' : ''}${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
//                   style: TextStyle(
//                     color: isPositive ? Colors.green : Colors.red,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTapSection() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//           border: Border.all(color: CColors.border),
//           borderRadius: BorderRadius.circular(16)),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildTapSectionItem('Analytics', Icons.bar_chart),
//           ),
//           // Vertical divider
//           Container(
//             width: 1,
//             height: 50, // Height of the divider
//             color: CColors.border,
//           ),
//           Expanded(
//             child: _buildTapSectionItem('Withdraw', Icons.arrow_upward),
//           ),
//           // Vertical divider
//           Container(
//             width: 1,
//             height: 50, // Height of the divider
//             color: CColors.border,
//           ),
//           Expanded(
//             child: _buildTapSectionItem('Deposit', Icons.arrow_downward),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTapSectionItem(String title, IconData icon) {
//     return InkWell(
//       onTap: () {
//         debugPrint("$title has been tapped");
//       },
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//                 width: 25,
//                 height: 25,
//                 decoration: BoxDecoration(
//                   color: CColors.primary,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(icon, size: 18, color: CColors.white)),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: const TextStyle(
//                   fontSize: 19,
//                   fontWeight: FontWeight.w600,
//                   color: CColors.primaryTextColor),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAdvertCard() {
//     return Container(
//       height: 160,
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(16)),
//       child: Row(
//         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Expanded(
//             flex: 3,
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
//               child: Text(
//                 'Invite a friend and you can both get \$10 in BTC',
//                 style: TextStyle(
//                     color: CColors.primaryTextColor,
//                     fontSize: 23,
//                     fontWeight: FontWeight.w600,
//                     height: 1.3),
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topRight: Radius.circular(16),
//                 bottomRight: Radius.circular(16),
//               ),
//               child: Image.asset(
//                 // 'assets/categories/category_4.jpg',
//                 'assets/images/btc_black.webp',
//                 height: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: [
//           const SizedBox(height: 10),
//           Center(
//             child: Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: CColors.grey,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Market',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
//                   ),
//                   Text(
//                     'Sort by: Capitalization',
//                     style: TextStyle(fontSize: 12, color: CColors.primary),
//                   ),
//                 ],
//               ),
//               Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   onTap: () => (context as Element)
//                       .findAncestorStateOfType<_CryptoHomeScreenState>()
//                       ?._toggleExpand(),
//                   borderRadius: BorderRadius.circular(20),
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: CColors.primary.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: ValueListenableBuilder<double>(
//                       valueListenable: (context as Element)
//                           .findAncestorStateOfType<_CryptoHomeScreenState>()!
//                           ._sheetSize,
//                       builder: (context, size, child) {
//                         return Icon(
//                           size > 0.6
//                               ? Icons.close_fullscreen
//                               : Icons.open_in_full,
//                           size: 20,
//                           color: CColors.primary,
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   double get maxExtent => 80;

//   @override
//   double get minExtent => 80;

//   @override
//   bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) => false;
// }

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';

import '../core/common/constants/crypto_colors.dart';
import '../core/common/widgets/appbar.dart';
import 'package:http/http.dart' as http;

import '../mobile/coin_model.dart';
import 'coin_details_screen.dart';

class CryptoHomeScreen extends StatefulWidget {
  const CryptoHomeScreen({super.key});

  @override
  State<CryptoHomeScreen> createState() => _CryptoHomeScreenState();
}

class _CryptoHomeScreenState extends State<CryptoHomeScreen> {
  late DraggableScrollableController _controller;
  final ValueNotifier<double> _sheetSize = ValueNotifier<double>(0.4);
  List<CoinModel> coinMarket = [];
  bool isLoading = true;

  Future<void> getCoinMarket() async {
    const url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=true';

    setState(() {
      isLoading = true;
    });

    try {
      var response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        debugPrint('Fetched ${jsonList.length} coins');

        setState(() {
          coinMarket =
              jsonList.map((json) => CoinModel.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        debugPrint('Error: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } on TimeoutException {
      debugPrint('Request timed out');
      setState(() => isLoading = false);
    } on SocketException {
      debugPrint('No internet connection');
      setState(() => isLoading = false);
    } catch (e) {
      debugPrint('Exception: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();
    getCoinMarket();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.isAttached) {
        _controller.addListener(_updateSheetSize);
        _sheetSize.value = _controller.size;
      }
    });
  }

  void _updateSheetSize() {
    _sheetSize.value = _controller.size;
  }

  @override
  void dispose() {
    _controller.removeListener(_updateSheetSize);
    _controller.dispose();
    _sheetSize.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    final target = _sheetSize.value < 0.6 ? 1.0 : 0.4;
    _controller.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bottomInset = MediaQuery.of(context).padding.bottom;
          return Stack(
            children: [
              // === TOP CONTENT (SCROLLABLE) ===
              Column(
                children: [
                  _buildTopWhiteCard(),
                  const SizedBox(height: 20),
                  _buildAdvertCard(),
                  // Extra space so sheet doesn't cover advert
                  SizedBox(height: constraints.maxHeight * 0.4 + bottomInset),
                ],
              ),

              // === DRAGGABLE BOTTOM SHEET ===
              DraggableScrollableSheet(
                controller: _controller,
                snapSizes: const [0.4, 0.7, 1.0],
                initialChildSize: 0.4,
                minChildSize: 0.4,
                maxChildSize: 1.0,
                expand: true,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: RefreshIndicator(
                      onRefresh: getCoinMarket,
                      child: CustomScrollView(
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        slivers: [
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _StickyHeaderDelegate(
                              toggleExpand: _toggleExpand,
                              sheetSize: _sheetSize,
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 10)),
                          isLoading
                              ? const SliverFillRemaining(
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation(
                                          CColors.primary),
                                    ),
                                  ),
                                )
                              : coinMarket.isEmpty
                                  ? SliverToBoxAdapter(
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text('Failed to load data'),
                                            TextButton(
                                              onPressed: getCoinMarket,
                                              child: const Text('Retry'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                          final coin = coinMarket[index];
                                          final isPositive =
                                              coin.priceChangePercentage24h >=
                                                  0;
                                          return _buildCryptoItem(
                                            context: context,
                                            isPositive: isPositive,
                                            coin: coin,
                                          );
                                        },
                                        childCount: coinMarket.length,
                                      ),
                                    ),
                          const SliverToBoxAdapter(child: SizedBox(height: 20)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopWhiteCard() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
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
                    ),
                  ],
                ),
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
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '\$5,271.39',
                      style: TextStyle(
                        color: CColors.primaryTextColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '+\$2,979.23',
                      style: TextStyle(
                        color: CColors.secondaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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
    );
  }

  Widget _buildCryptoItem({
    required bool isPositive,
    required CoinModel coin,
    required BuildContext context,
  }) {
    final sparkline = coin.sparklineIn7d?.price ?? [];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoinDetailsScreen(coin: coin),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Image.network(
              coin.image,
              width: 40,
              height: 40,
              errorBuilder: (_, __, ___) => const Icon(Icons.error, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    coin.symbol.toUpperCase(),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  if (sparkline.isNotEmpty)
                    SizedBox(
                      height: 20,
                      width: 80,
                      child: Sparkline(
                        data: sparkline,
                        lineColor: isPositive ? Colors.green : Colors.red,
                        lineWidth: 1.5,
                        fillMode: FillMode.below,
                        fillGradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            (isPositive ? Colors.green : Colors.red)
                                .withOpacity(0.2),
                            (isPositive ? Colors.green : Colors.red)
                                .withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${coin.currentPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '${isPositive ? '+' : ''}${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTapSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: CColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTapSectionItem('Analytics', Icons.bar_chart)),
          Container(width: 1, height: 50, color: CColors.border),
          Expanded(child: _buildTapSectionItem('Withdraw', Icons.arrow_upward)),
          Container(width: 1, height: 50, color: CColors.border),
          Expanded(
              child: _buildTapSectionItem('Deposit', Icons.arrow_downward)),
        ],
      ),
    );
  }

  Widget _buildTapSectionItem(String title, IconData icon) {
    return InkWell(
      onTap: () => debugPrint("$title tapped"),
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
              child: Icon(icon, size: 18, color: CColors.white),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: CColors.primaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvertCard() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
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
                  height: 1.3,
                ),
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
                'assets/images/btc_black.webp',
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

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final VoidCallback toggleExpand;
  final ValueNotifier<double> sheetSize;

  const _StickyHeaderDelegate({
    required this.toggleExpand,
    required this.sheetSize,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: const BoxDecoration(
        color: CColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: CColors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Market',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Sort by: Capitalization',
                    style: TextStyle(fontSize: 12, color: CColors.primary),
                  ),
                ],
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: toggleExpand,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: CColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ValueListenableBuilder<double>(
                      valueListenable: sheetSize,
                      builder: (context, size, child) {
                        return Icon(
                          size > 0.6
                              ? Icons.close_fullscreen
                              : Icons.open_in_full,
                          size: 20,
                          color: CColors.primary,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) => false;
}
