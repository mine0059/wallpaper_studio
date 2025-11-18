import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpaper_studio/core/common/constants/colors.dart';
import 'package:wallpaper_studio/mobile/chat_model.dart';
import 'package:wallpaper_studio/screens/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'mobile/coin_model.dart';
// import 'package:wallpaper_studio/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CoinModelAdapter());
  Hive.registerAdapter(RoiModelAdapter());
  Hive.registerAdapter(SparklineModelAdapter());
  Hive.registerAdapter(ChartModelAdapter());
  await Hive.openBox<CoinModel>('coins');
  await Hive.openBox('charts');
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // Status bar (top)
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light, // Dark icons
    statusBarBrightness: Brightness.dark, // iOS

    // Navigation bar (bottom)
    systemNavigationBarColor: Colors.white, // Match your bottom nav
    systemNavigationBarIconBrightness: Brightness.dark, // Dark icons
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: WColors.primary),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      // home: const HomeScreen(),
      home: const SplashScreen(),
    );
  }
}
