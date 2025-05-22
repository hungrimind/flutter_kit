import 'package:flutter/material.dart';

@immutable
class RedColors extends ThemeExtension<RedColors> {
  final Color red50;
  final Color red100;
  final Color red200;
  final Color red300;
  final Color red400;
  final Color red500;
  final Color red600;
  final Color red700;
  final Color red800;
  final Color red900;
  final Color red950;

  const RedColors({
    this.red50 = RedColorValues.red50,
    this.red100 = RedColorValues.red100,
    this.red200 = RedColorValues.red200,
    this.red300 = RedColorValues.red300,
    this.red400 = RedColorValues.red400,
    this.red500 = RedColorValues.red500,
    this.red600 = RedColorValues.red600,
    this.red700 = RedColorValues.red700,
    this.red800 = RedColorValues.red800,
    this.red900 = RedColorValues.red900,
    this.red950 = RedColorValues.red950,
  });

  @override
  ThemeExtension<RedColors> copyWith({
    Color? red50,
    Color? red100,
    Color? red200,
    Color? red300,
    Color? red400,
    Color? red500,
    Color? red600,
    Color? red700,
    Color? red800,
    Color? red900,
    Color? red950,
  }) {
    return RedColors(
      red50: red50 ?? this.red50,
      red100: red100 ?? this.red100,
      red200: red200 ?? this.red200,
      red300: red300 ?? this.red300,
      red400: red400 ?? this.red400,
      red500: red500 ?? this.red500,
      red600: red600 ?? this.red600,
      red700: red700 ?? this.red700,
      red800: red800 ?? this.red800,
      red900: red900 ?? this.red900,
      red950: red950 ?? this.red950,
    );
  }

  @override
  ThemeExtension<RedColors> lerp(
    covariant ThemeExtension<RedColors>? other,
    double t,
  ) {
    if (other is! RedColors) {
      return this;
    }
    return RedColors(
      red50: Color.lerp(red50, other.red50, t)!,
      red100: Color.lerp(red100, other.red100, t)!,
      red200: Color.lerp(red200, other.red200, t)!,
      red300: Color.lerp(red300, other.red300, t)!,
      red400: Color.lerp(red400, other.red400, t)!,
      red500: Color.lerp(red500, other.red500, t)!,
      red600: Color.lerp(red600, other.red600, t)!,
      red700: Color.lerp(red700, other.red700, t)!,
      red800: Color.lerp(red800, other.red800, t)!,
      red900: Color.lerp(red900, other.red900, t)!,
      red950: Color.lerp(red950, other.red950, t)!,
    );
  }
}

class RedColorValues {
  const RedColorValues();

  static const red50 = Color(0xFFFEF2F2);
  static const red100 = Color(0xFFFEE2E2);
  static const red200 = Color(0xFFFECACA);
  static const red300 = Color(0xFFFCA5A5);
  static const red400 = Color(0xFFF87171);
  static const red500 = Color(0xFFEF4444);
  static const red600 = Color(0xFFDC2626);
  static const red700 = Color(0xFFB91C1C);
  static const red800 = Color(0xFF991B1B);
  static const red900 = Color(0xFF7F1D1D);
  static const red950 = Color(0xFF450A0A);
}
