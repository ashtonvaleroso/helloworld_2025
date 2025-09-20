import 'package:flutter/material.dart';

extension ColorThemeExtension on BuildContext {
  ColorScheme get colorTheme => Theme.of(this).colorScheme;
}
