import 'package:flutter/material.dart';

import 'colors.dart';

class AppStyles {
  static TextStyle getExtraLightTextStyle({required double fontSize, Color? color, bool isCurrency = false}) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: 'Raleway',
      color: color,
      fontWeight: FontWeight.w200,
    );
  }

  static TextStyle getLightTextStyle({required double fontSize, Color? color, bool isCurrency = false}) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: 'Raleway',
      color: color,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle getRegularTextStyle({required double fontSize, Color? color, bool isCurrency = false}) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: 'Raleway',
      color: color,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle getBoldTextStyle({required double fontSize, Color? color, bool isCurrency = false}) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle getSemiBoldTextStyle({required double fontSize, Color? color, bool isCurrency = false}) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle getMediumTextStyle({required double fontSize, Color? color, bool isCurrency = false}) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static ButtonStyle filledButton = TextButton.styleFrom(
    padding: const EdgeInsets.all(20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    backgroundColor: Colors.orange[700],
    foregroundColor: Colors.white,
  );

  static Color getButtonColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered)) {
      return Colors.transparent;
    }
    return AppColors.baseColor;
  }

  static Color getTextColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered)) {
      return AppColors.baseColor;
    }
    return Colors.transparent;
  }
}

// List of various text styles used within the app
