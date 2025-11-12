import 'package:flutter/material.dart';

import '../core/common/constants/crypto_colors.dart';

class UnderDevelopmentScreen extends StatelessWidget {
  final String featureName;

  const UnderDevelopmentScreen({super.key, required this.featureName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Construction Icon
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: CColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.construction,
                          size: 80,
                          color: CColors.primary,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                Text(
                  '$featureName Coming Soon',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: CColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'We\'re working hard to bring you this feature.\nStay tuned!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: CColors.secondaryTextColor,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                // Progress indicator
                SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Development Progress',
                            style: TextStyle(
                              fontSize: 12,
                              color: CColors.secondaryTextColor,
                            ),
                          ),
                          const Text(
                            '75%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: CColors.primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.75,
                          backgroundColor: CColors.grey,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(CColors.primary),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Feature highlights
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildFeatureItem(
                        Icons.check_circle_outline,
                        'Enhanced Security',
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureItem(
                        Icons.speed,
                        'Lightning Fast',
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureItem(
                        Icons.auto_awesome,
                        'User Friendly',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: CColors.primary,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: CColors.primaryTextColor,
          ),
        ),
      ],
    );
  }
}
