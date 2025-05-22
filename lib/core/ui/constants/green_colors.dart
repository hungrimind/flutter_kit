import 'package:flutter/material.dart';

@immutable
class GreenColors extends ThemeExtension<GreenColors> {
  final Color green50;
  final Color green100;
  final Color green200;
  final Color green300;
  final Color green400;
  final Color green500;
  final Color green600;
  final Color green700;
  final Color green800;
  final Color green900;
  final Color green950;

  const GreenColors({
    this.green50 = GreenColorValues.green50,
    this.green100 = GreenColorValues.green100,
    this.green200 = GreenColorValues.green200,
    this.green300 = GreenColorValues.green300,
    this.green400 = GreenColorValues.green400,
    this.green500 = GreenColorValues.green500,
    this.green600 = GreenColorValues.green600,
    this.green700 = GreenColorValues.green700,
    this.green800 = GreenColorValues.green800,
    this.green900 = GreenColorValues.green900,
    this.green950 = GreenColorValues.green950,
  });

  @override
  ThemeExtension<GreenColors> copyWith({
    Color? green50,
    Color? green100,
    Color? green200,
    Color? green300,
    Color? green400,
    Color? green500,
    Color? green600,
    Color? green700,
    Color? green800,
    Color? green900,
    Color? green950,
  }) {
    return GreenColors(
      green50: green50 ?? this.green50,
      green100: green100 ?? this.green100,
      green200: green200 ?? this.green200,
      green300: green300 ?? this.green300,
      green400: green400 ?? this.green400,
      green500: green500 ?? this.green500,
      green600: green600 ?? this.green600,
      green700: green700 ?? this.green700,
      green800: green800 ?? this.green800,
      green900: green900 ?? this.green900,
      green950: green950 ?? this.green950,
    );
  }

  @override
  ThemeExtension<GreenColors> lerp(
    covariant ThemeExtension<GreenColors>? other,
    double t,
  ) {
    if (other is! GreenColors) {
      return this;
    }
    return GreenColors(
      green50: Color.lerp(green50, other.green50, t)!,
      green100: Color.lerp(green100, other.green100, t)!,
      green200: Color.lerp(green200, other.green200, t)!,
      green300: Color.lerp(green300, other.green300, t)!,
      green400: Color.lerp(green400, other.green400, t)!,
      green500: Color.lerp(green500, other.green500, t)!,
      green600: Color.lerp(green600, other.green600, t)!,
      green700: Color.lerp(green700, other.green700, t)!,
      green800: Color.lerp(green800, other.green800, t)!,
      green900: Color.lerp(green900, other.green900, t)!,
      green950: Color.lerp(green950, other.green950, t)!,
    );
  }
}

class GreenColorValues {
  const GreenColorValues();

  static const green50 = Color(0xFFF0FDF4);
  static const green100 = Color(0xFFDCFCE7);
  static const green200 = Color(0xFFBBF7D0);
  static const green300 = Color(0xFF86EFAC);
  static const green400 = Color(0xFF4ADE80);
  static const green500 = Color(0xFF22C55E);
  static const green600 = Color(0xFF16A34A);
  static const green700 = Color(0xFF15803D);
  static const green800 = Color(0xFF166534);
  static const green900 = Color(0xFF14532D);
  static const green950 = Color(0xFF052E16);
}
