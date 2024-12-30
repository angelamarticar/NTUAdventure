import 'package:flutter/material.dart';

ThemeData get theme => ThemeHelper().themedata();
LightColors get lightColors => ThemeHelper().themeLightColors();

class ThemeHelper{

  LightColors _getLightColors(){
    return LightColors();
  }

  ThemeData _getThemeData(){
    var colorScheme = ColorSchemes.primaryColorScheme;
    return ThemeData(
    visualDensity: VisualDensity.standard,
    colorScheme: colorScheme,
    textTheme: TextThemes.textTheme(colorScheme),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Usa screenutil para el radio
        ),
        elevation: 0,
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
        padding: EdgeInsets.zero,
      ),
    ),
  );
  }

  LightColors themeLightColors()=> _getLightColors();
  ThemeData themedata() => _getThemeData();
}


class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
    bodyLarge: TextStyle(
      color: colorScheme.errorContainer,
      fontSize: 20.0, // Se recomienda usar valores double para fontSize
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
    ),
    displayMedium: TextStyle(
      color: colorScheme.onPrimary,
      fontSize: 40.0, // Se recomienda usar valores double para fontSize
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
    ),
    titleSmall: TextStyle(
      color: colorScheme.primaryContainer,
      fontSize: 14.0, // Se recomienda usar valores double para fontSize
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: TextStyle(
      color: colorScheme.onPrimaryContainer,
      fontSize: 20.0, // Se recomienda usar valores double para fontSize
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
    ),
    bodySmall: TextStyle(
      color: lightColors.gray700,
      fontSize: 80.0,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
    ) 
  );
}

class ColorSchemes {
  static final primaryColorScheme = ColorScheme.light(
    primary: Color(0xFF95A2C4),
    primaryContainer: Color(0xFF223565),
    secondaryContainer: Color(0xFFA5C5C4),
    errorContainer: Color(0xFF000000),
    onPrimary: Color(0xFF1D1B20),
    onPrimaryContainer: Color(0xFFFFFFFF),
  );
}

class LightColors{
  Color get gray200 => Color(0XFFE7E7E7);
  Color get gray700 => Color(0XFF49454F);
  Color get green300 => Color(0XFFA5C5C4);
}