import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FoodCheckCNApp());
}

class FoodCheckCNApp extends StatelessWidget {
  const FoodCheckCNApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Import Food Check',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}