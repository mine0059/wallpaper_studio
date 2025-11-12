import 'package:flutter/material.dart';
import 'package:wallpaper_studio/core/common/constants/crypto_colors.dart';

import 'crypto_home_screen.dart';
import 'under_development.dart';

class CryptoDashboard extends StatefulWidget {
  const CryptoDashboard({super.key});

  @override
  State<CryptoDashboard> createState() => _CryptoDashboardState();
}

class _CryptoDashboardState extends State<CryptoDashboard> {
  int _currentBottomIndex = 0;

  final List<Widget> _screens = [
    const CryptoHomeScreen(),
    const UnderDevelopmentScreen(featureName: 'Wallet'),
    const UnderDevelopmentScreen(featureName: 'Transfer'),
    const UnderDevelopmentScreen(featureName: 'Analytics'),
    const UnderDevelopmentScreen(featureName: 'Settings'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: SafeArea(child: _buildBottomNav()),
      floatingActionButton: _buildCenterButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _currentBottomIndex,
      children: _screens,
    );
  }

  Widget _buildCenterButton() {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      decoration: BoxDecoration(
        color: CColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: FloatingActionButton(
        onPressed: () {
          setState(() => _currentBottomIndex = 2);
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(
          Icons.swap_horiz,
          size: 32,
          color: CColors.white,
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
              _buildNavItem(Icons.wallet_outlined, Icons.wallet, 'Wallet', 1),
              const SizedBox(width: 60),
              _buildNavItem(
                  Icons.bar_chart_outlined, Icons.bar_chart, 'Analytics', 3),
              _buildNavItem(
                  Icons.settings_outlined, Icons.settings, 'Settings', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, IconData activeIcon, String label, int index) {
    final isActive = _currentBottomIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentBottomIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                size: 24,
                color: isActive
                    ? CColors.primaryTextColor
                    : CColors.secondaryTextColor,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? CColors.primaryTextColor
                      : CColors.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
