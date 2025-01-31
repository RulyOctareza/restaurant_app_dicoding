import 'package:flutter/material.dart';
import 'package:restaurant_app/theme/colors/restaurant_colors.dart';

import 'typhography/restaurant_text_style.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: purpleColor,
  hintColor: blackColor,
  textTheme: TextTheme(
    bodyLarge: blackTextStyle,
    bodyMedium: regularTextStyle,
    titleLarge: blackTextStyle.copyWith(fontSize: 24),
    titleMedium: greyTextStyle.copyWith(fontSize: 16),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: purpleColor,
  hintColor: whiteColor,
  textTheme: TextTheme(
    bodyLarge: whiteTextStyle,
    bodyMedium: whiteTextStyle,
    titleLarge: whiteTextStyle.copyWith(fontSize: 24),
    titleMedium: greyTextStyle.copyWith(fontSize: 16),
  ),
);
