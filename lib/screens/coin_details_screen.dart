import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_studio/core/common/constants/crypto_colors.dart';
import 'package:wallpaper_studio/mobile/chat_model.dart';
import 'package:wallpaper_studio/mobile/coin_model.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_studio/widgets/crypto_button.dart';

import '../core/common/widgets/appbar.dart';

class CoinDetailsScreen extends StatefulWidget {
  const CoinDetailsScreen({super.key, required this.coin});

  final CoinModel coin;

  @override
  State<CoinDetailsScreen> createState() => _CoinDetailsScreenState();
}

class _CoinDetailsScreenState extends State<CoinDetailsScreen> {
  List<ChartModel>? charts;
  String selectedDays = '1';

  @override
  void initState() {
    super.initState();
    getChart();
  }

  Future<void> getChart() async {
    String url =
        'https://api.coingecko.com/api/v3/coins/${widget.coin.id}/ohlc?vs_currency=usd&days=$selectedDays';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Iterable x = json.decode(response.body);
        List<ChartModel> modelList =
            x.map((e) => ChartModel.fromJson(e)).toList();
        setState(() {
          charts = modelList;
        });
      } else {
        debugPrint('Error: ${response.statusCode}');
      }
    } on TimeoutException {
      debugPrint('Request timed out');
    } on SocketException {
      debugPrint('No internet connection');
    } catch (e) {
      debugPrint('Exception: $e');
    }
  }

  LineChartData mainData(bool isPositive) {
    if (charts == null || charts!.isEmpty) {
      return LineChartData();
    }

    final spots =
        charts!.map((c) => FlSpot(c.time!.toDouble(), c.close!)).toList();

    return LineChartData(
      gridData: const FlGridData(show: true),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: spots.first.x,
      maxX: spots.last.x,
      minY: spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) * 0.98,
      maxY: spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.02,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          barWidth: 2,
          color: isPositive ? Colors.green : Colors.red,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          // tooltipBgColor: Colors.black.withOpacity(0.8),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
              final timeStr = selectedDays == '1'
                  ? '${date.hour}:${date.minute.toString().padLeft(2, '0')}'
                  : '${date.month}/${date.day}';
              return LineTooltipItem(
                '\$${spot.y.toStringAsFixed(2)}\n$timeStr',
                const TextStyle(color: Colors.white, fontSize: 12),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    final isPositive = widget.coin.priceChangePercentage24h >= 0;
    return Scaffold(
      backgroundColor: CColors.backgroundColor,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                TAppBar(
                  showBackArrow: true,
                  centerTitle: true,
                  title: Text(
                    '${widget.coin.symbol.toUpperCase()}/USDT',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  actions: const [
                    Icon(
                      Icons.star,
                      color: CColors.primary,
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${widget.coin.currentPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: CColors.primaryTextColor,
                                fontSize: 25,
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              Text(
                                '${widget.coin.priceChange24h.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    color: CColors.secondaryTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${isPositive ? '+' : ''}${widget.coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                                style: TextStyle(
                                    color:
                                        isPositive ? Colors.green : Colors.red,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'High',
                                style: TextStyle(
                                    color: CColors.secondaryTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${widget.coin.high24h.toString()}',
                                style: const TextStyle(
                                    color: CColors.primaryTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Low',
                                style: TextStyle(
                                    color: CColors.secondaryTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${widget.coin.low24h.toString()}',
                                style: const TextStyle(
                                    color: CColors.primaryTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            height: myHeight * 0.4,
            width: myWidth,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // === CHART ===
                Expanded(
                  child: SizedBox(
                    height: myHeight * 0.35, // Leave space for toggle
                    child: charts == null
                        ? const Center(child: CircularProgressIndicator())
                        : LineChart(
                            mainData(isPositive),
                            duration: const Duration(milliseconds: 250),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTimeToggle(),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                children: [
                  // === TABS ===
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        _buildTab('Order Book', true),
                        _buildTab('History', false),
                        _buildTab('Notes', false),
                        _buildTab('Info', false),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bid',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: CColors.primaryTextColor),
                            ),
                            const SizedBox(height: 10),
                            ..._mockBids().map((bid) {
                              return Column(
                                children: [
                                  _buildOrderRow(
                                    bid['price']!,
                                    bid['amount']!,
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ask',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: CColors.primaryTextColor),
                          ),
                          const SizedBox(height: 10),
                          ..._mockAsks().map((ask) {
                            return Column(
                              children: [
                                _buildOrderRow(
                                  isAsk: true,
                                  ask['price']!,
                                  ask['amount']!,
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          })
                        ],
                      )),
                    ],
                  ),

                  // const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(child: CryptoButton(label: 'Buy', onPressed: () {})),
              const SizedBox(width: 8),
              Expanded(child: CryptoButton(label: 'Sell', onPressed: () {}))
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildTimeToggle() {
    final options = [
      {'label': '1H', 'value': '1'},
      {'label': '7D', 'value': '7'},
      {'label': '30D', 'value': '30'},
      {'label': '90D', 'value': '90'},
      {'label': '1Y', 'value': '365'},
    ];

    return Wrap(
      spacing: 8,
      alignment: WrapAlignment.center,
      children: options.map((option) {
        final isSelected = selectedDays == option['value'];
        return ChoiceChip(
          label: Text(
            option['label']!,
            style: TextStyle(
              color: isSelected
                  ? CColors.primaryTextColor
                  : CColors.secondaryTextColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          selected: isSelected,
          selectedColor: Colors.grey[100],
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? CColors.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          onSelected: (_) {
            setState(() {
              selectedDays = option['value']!;
            });
            getChart();
          },
        );
      }).toList(),
    );
  }

  Widget _buildTab(String label, bool isActive) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? CColors.primary : CColors.secondaryTextColor,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderRow(String price, String amount, {bool isAsk = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!isAsk) ...[
          Text(price,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          Text(amount,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ] else ...[
          Text(amount,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
          Text(price,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ],
    );
  }

  List<Map<String, String>> _mockBids() => [
        {'price': '\$2,490', 'amount': '493.28.201'},
        {'price': '\$2,480', 'amount': '853.77.018'},
        {
          'price': '\$2,450',
          'amount': '2.559.531.054',
        },
      ];

  List<Map<String, String>> _mockAsks() => [
        {'price': '\$2,495', 'amount': '88128.501'},
        {'price': '\$2,500', 'amount': '1620.09122'},
        {'price': '\$2,505', 'amount': '5.821501.904'},
      ];
}
