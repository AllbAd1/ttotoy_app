// app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasks/core/variable_colors.dart';
import 'package:tasks/core/fixed_colors.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.notoSansKrTextTheme(),
    fontFamily: GoogleFonts.notoSansKr().fontFamily,
    extensions: const [VariableColors.light, FixedColors.constant],
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    textTheme: GoogleFonts.notoSansKrTextTheme(ThemeData.dark().textTheme),
    fontFamily: GoogleFonts.notoSansKr().fontFamily,
    extensions: const [VariableColors.dark, FixedColors.constant],
  );
}

VariableColors vrc(BuildContext context) =>
    Theme.of(context).extension<VariableColors>()!;

FixedColors fxc(BuildContext context) =>
    Theme.of(context).extension<FixedColors>()!;