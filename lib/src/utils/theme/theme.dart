import 'package:flutter/material.dart';
import 'package:ghar_sathi/src/utils/theme/widget_themes/text_field_theme.dart';
import 'package:ghar_sathi/src/utils/theme/widget_themes/text_theme.dart';

class AppTheme{

  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: TTextTheme.LightTextTheme,
    inputDecorationTheme: TextformFieldTheme.lightInputDecorationTheme
  );

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      textTheme: TTextTheme.DarkTextTheme,
      inputDecorationTheme: TextformFieldTheme.darkInputDecorationTheme
  );
}