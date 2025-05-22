import 'package:flutter/material.dart';

@immutable
class YellowColors extends ThemeExtension<YellowColors> {
  final Color yellow50;
  final Color yellow100;
  final Color yellow200;
  final Color yellow300;
  final Color yellow400;
  final Color yellow500;
  final Color yellow600;
  final Color yellow700;
  final Color yellow800;
  final Color yellow900;
  final Color yellow950;

  const YellowColors({
    this.yellow50 = YellowColorValues.yellow50,
    this.yellow100 = YellowColorValues.yellow100,
    this.yellow200 = YellowColorValues.yellow200,
    this.yellow300 = YellowColorValues.yellow300,
    this.yellow400 = YellowColorValues.yellow400,
    this.yellow500 = YellowColorValues.yellow500,
    this.yellow600 = YellowColorValues.yellow600,
    this.yellow700 = YellowColorValues.yellow700,
    this.yellow800 = YellowColorValues.yellow800,
    this.yellow900 = YellowColorValues.yellow900,
    this.yellow950 = YellowColorValues.yellow950,
  });

  @override
  ThemeExtension<YellowColors> copyWith({
    Color? yellow50,
    Color? yellow100,
    Color? yellow200,
    Color? yellow300,
    Color? yellow400,
    Color? yellow500,
    Color? yellow600,
    Color? yellow700,
    Color? yellow800,
    Color? yellow900,
    Color? yellow950,
  }) {
    return YellowColors(
      yellow50: yellow50 ?? this.yellow50,
      yellow100: yellow100 ?? this.yellow100,
      yellow200: yellow200 ?? this.yellow200,
      yellow300: yellow300 ?? this.yellow300,
      yellow400: yellow400 ?? this.yellow400,
      yellow500: yellow500 ?? this.yellow500,
      yellow600: yellow600 ?? this.yellow600,
      yellow700: yellow700 ?? this.yellow700,
      yellow800: yellow800 ?? this.yellow800,
      yellow900: yellow900 ?? this.yellow900,
      yellow950: yellow950 ?? this.yellow950,
    );
  }

  @override
  ThemeExtension<YellowColors> lerp(
    covariant ThemeExtension<YellowColors>? other,
    double t,
  ) {
    if (other is! YellowColors) {
      return this;
    }
    return YellowColors(
      yellow50: Color.lerp(yellow50, other.yellow50, t)!,
      yellow100: Color.lerp(yellow100, other.yellow100, t)!,
      yellow200: Color.lerp(yellow200, other.yellow200, t)!,
      yellow300: Color.lerp(yellow300, other.yellow300, t)!,
      yellow400: Color.lerp(yellow400, other.yellow400, t)!,
      yellow500: Color.lerp(yellow500, other.yellow500, t)!,
      yellow600: Color.lerp(yellow600, other.yellow600, t)!,
      yellow700: Color.lerp(yellow700, other.yellow700, t)!,
      yellow800: Color.lerp(yellow800, other.yellow800, t)!,
      yellow900: Color.lerp(yellow900, other.yellow900, t)!,
      yellow950: Color.lerp(yellow950, other.yellow950, t)!,
    );
  }
}

class YellowColorValues {
  const YellowColorValues();

  static const yellow50 = Color(0xFFFEFCE8);
  static const yellow100 = Color(0xFFFEF9C3);
  static const yellow200 = Color(0xFFFEF08A);
  static const yellow300 = Color(0xFFFDE047);
  static const yellow400 = Color(0xFFFACC15);
  static const yellow500 = Color(0xFFEAB308);
  static const yellow600 = Color(0xFFCA8A04);
  static const yellow700 = Color(0xFFA16207);
  static const yellow800 = Color(0xFF854D0E);
  static const yellow900 = Color(0xFF713F12);
  static const yellow950 = Color(0xFF422006);
}
