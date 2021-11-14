import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/app/theme/typo.dart';

import 'colors.dart';

// const double _defaultLetterSpacing = 0.03;

const ColorScheme _lightColorScheme = ColorScheme.light(
  brightness: Brightness.light,
  primary: PRIMARY,
  primaryVariant: LIGHT_PRIMARY,
  onPrimary: WHITE,
  secondary: ACCENT,
  // secondaryVariant: LightColors.secondaryLightVarient,
  onSecondary: WHITE,

  background: OFF_WHITE,
  onBackground: DARK_GREY,

  surface: WHITE,
  // onSurface: LightColors.onSurface,

  error: ERROR_COLOR,
);

ThemeData _buildMawahebLightTheme(bool isArabic) {
  final ThemeData base = ThemeData.light();
  final TextTheme textTheme = buildTextTheme(base.textTheme, _lightColorScheme, isArabic);

  return base.copyWith(
    cursorColor: const Color.fromARGB(255, 213, 194, 148),
    cupertinoOverrideTheme: const CupertinoThemeData(
      primaryColor: Color.fromARGB(255, 213, 194, 148),
    ),

    typography: Typography.material2018(),
    colorScheme: _lightColorScheme,
    primaryColor: _lightColorScheme.primary,
    accentColor: _lightColorScheme.secondary,
    buttonColor: _lightColorScheme.secondary,
    scaffoldBackgroundColor: _lightColorScheme.background,
    backgroundColor: _lightColorScheme.background,
    cardColor: _lightColorScheme.surface,
    textSelectionColor: _lightColorScheme.primary,
    errorColor: _lightColorScheme.error,

    textTheme: textTheme,
    primaryTextTheme: textTheme, //_buildTextTheme(base.primaryTextTheme, _lightColorScheme),
    accentTextTheme: textTheme, // _buildTextTheme(base.accentTextTheme, _lightColorScheme),

    //* COMPONENTS THEME *//
    appBarTheme: AppBarTheme(
      color: _lightColorScheme.surface,
      textTheme: textTheme,
      elevation: 0,
    ),
    buttonTheme: ButtonThemeData(
      colorScheme: _lightColorScheme.copyWith(secondary: Colors.white),
      textTheme: ButtonTextTheme.accent,
      // buttonColor: _lightColorScheme.secondary,

      /* shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ), */
    ),

    // dialogTheme: _buildDialogTheme(base.dialogTheme, _lightColorScheme),
    // iconTheme: _customIconTheme(base.iconTheme),
    // primaryIconTheme: _customIconTheme(base.iconTheme),
    // floatingActionButtonTheme: FloatingActionButtonThemeData(
    //   foregroundColor: _lightColorScheme.onPrimary,
    //   backgroundColor: _lightColorScheme.primary,
    // ),
  );
}

// DialogTheme _buildDialogTheme(DialogTheme theme, ColorScheme scheme) {
//   return theme.copyWith(
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//     backgroundColor: scheme.background,
//     elevation: 2.0,
//   );
// }

// IconThemeData _customIconTheme(IconThemeData original) {
//   return original.copyWith(color: _lightColorScheme.primary, size: 32.0);
// }

// final ThemeData lightTheme = _buildTawreedLightTheme();

ThemeData lightTheme({bool isArabic = true}) => _buildMawahebLightTheme(isArabic);
