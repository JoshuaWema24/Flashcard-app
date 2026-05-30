// app.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Premium, high-contrast dark slate & vibrant indigo/violet palette
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          primary: const Color(0xFF6366F1),      // Indigo
          secondary: const Color(0xFF10B981),    // Emerald
          surface: const Color(0xFF1E1E2E),      // Deep Slate Card
          background: const Color(0xFF0F0F1A),   // Dark Midnight Canvas
          error: const Color(0xFFEF4444),        // Rose/Red
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: const Color(0xFFF3F4F6),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
        fontFamily: 'Roboto', // Consider upgrading to 'Inter' or 'Plus Jakarta Sans' in pubspec.yaml
        
        // Modern elevated buttons featuring subtle shadows and soft corners
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: const Color(0xFF6366F1).withOpacity(0.4),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // Sleek, borderless-style glass input fields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E1E2E),
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 15),
          labelStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),

        // Custom extensions for linear gradients across your cards and backgrounds
        extensions: [
          CustomThemeGradients(
            primaryGradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color.fromARGB(220, 127, 77, 244)], // Indigo to Violet
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            secondaryGradient: const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF059669)], // Emerald to Green
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            cardBackgroundGradient: const LinearGradient(
              colors: [Color(0xFF1E1E2E), Color(0xFF27273F)], // Rich Glassy Slates
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ],
      ),
      home: const HomeScreen(),
    );
  }
}

/// Allows you to seamlessly use custom gradients anywhere via: 
/// Theme.of(context).extension<CustomThemeGradients>()
class CustomThemeGradients extends ThemeExtension<CustomThemeGradients> {
  const CustomThemeGradients({
    this.primaryGradient,
    this.secondaryGradient,
    this.cardBackgroundGradient,
  });

  final LinearGradient? cardBackgroundGradient;
  final LinearGradient? primaryGradient;
  final LinearGradient? secondaryGradient;

  @override
  ThemeExtension<CustomThemeGradients> copyWith({
    LinearGradient? primaryGradient,
    LinearGradient? secondaryGradient,
    LinearGradient? cardBackgroundGradient,
  }) {
    return CustomThemeGradients(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      secondaryGradient: secondaryGradient ?? this.secondaryGradient,
      cardBackgroundGradient: cardBackgroundGradient ?? this.cardBackgroundGradient,
    );
  }

  @override
  ThemeExtension<CustomThemeGradients> lerp(
    ThemeExtension<CustomThemeGradients>? other,
    double t,
  ) {
    if (other is! CustomThemeGradients) return this;
    return CustomThemeGradients(
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t),
      secondaryGradient: LinearGradient.lerp(secondaryGradient, other.secondaryGradient, t),
      cardBackgroundGradient: LinearGradient.lerp(cardBackgroundGradient, other.cardBackgroundGradient, t),
    );
  }
}