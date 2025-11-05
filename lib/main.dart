import 'package:flutter/material.dart';
import 'package:wallpaper_studio/core/common/constants/colors.dart';
import 'package:wallpaper_studio/screens/home_screen.dart';

void main() {
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
      home: const HomeScreen(),
    );
  }
}
