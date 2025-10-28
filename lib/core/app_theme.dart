// app_theme.dart
import 'package:flutter/material.dart';
import 'package:tasks/core/variable_colors.dart';
import 'package:tasks/core/fixed_colors.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    textTheme: ThemeData.light().textTheme,
    extensions: const [VariableColors.light, FixedColors.constant],
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    textTheme: ThemeData.dark().textTheme,
    extensions: const [VariableColors.dark, FixedColors.constant],
  );
}

VariableColors vrc(BuildContext context) =>
    Theme.of(context).extension<VariableColors>()!;

FixedColors fxc(BuildContext context) =>
    Theme.of(context).extension<FixedColors>()!;
