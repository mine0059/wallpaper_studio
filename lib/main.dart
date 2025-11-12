import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpaper_studio/core/common/constants/colors.dart';
import 'package:wallpaper_studio/screens/splash_screen.dart';
// import 'package:wallpaper_studio/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
