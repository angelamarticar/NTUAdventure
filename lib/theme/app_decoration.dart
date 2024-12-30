import 'package:flutter/material.dart';
import '../theme/theme_helper.dart';

class AppDecoration {
  //Background decorations
  static BoxDecoration get backgroundGradient => BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment(0.5, 0),
        end: Alignment(0.5, 1),
        colors: [ColorSchemes.primaryColorScheme.secondaryContainer,
          ColorSchemes.primaryColorScheme.primary])
  );
  static BoxDecoration get outlineBlueGray => BoxDecoration(
    color:LightColors().gray200,
  );
}
