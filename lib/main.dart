import 'package:bg3cr/screens/bg3_randomizer_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BG3 Randomizer',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF2C2A26),
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37), // Gold accent
          secondary: Color(0xFF9E2A2B), // Red accent
          background: Color(0xFF1A1A1A),
          surface: Color(0xFF2C2A26),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C2A26),
          foregroundColor: Color(0xFFEAE0D5),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF2C2A26),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.5), width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9E2A2B), // Red accent
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFD4AF37),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFD4AF37)),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Bg3RandomizerScreen(),
    );
  }
}
