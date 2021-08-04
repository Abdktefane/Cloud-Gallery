import 'package:core_sdk/utils/colors.dart';
import 'package:flutter/material.dart';
// import 'package:tawreed_common_sdk/theme/colors.dart';

TextTheme buildTextTheme(TextTheme base, ColorScheme scheme, bool isArabic) {
  return base
      .copyWith(
        headline1: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),

        // headline4: base.headline4.copyWith(
        //   letterSpacing: _defaultLetterSpacing,
        //   fontSize: 34.0,
        //   fontWeight: FontWeight.w400,
        //   color: scheme.primary,
        // ),

        headline5:
            base.headline5!.copyWith(fontWeight: FontWeight.w400, fontSize: 23),

        headline6: base.headline6!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 19,
          letterSpacing: 0.15,
        ),

        bodyText1: base.bodyText1!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 15.0,
          letterSpacing: 0.5,
        ),

        bodyText2: base.bodyText2!.copyWith(
            fontWeight: FontWeight.w400, fontSize: 13.0, letterSpacing: 0.25),

        subtitle1: base.subtitle1!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
          letterSpacing: 0.15,
        ),

        // subtitle2: base.subtitle2.copyWith(
        //   letterSpacing: _defaultLetterSpacing,
        //   fontSize: 14.0,
        //   fontWeight: FontWeight.w600,
        // ),

        // button: base.button.copyWith(
        //   fontWeight: FontWeight.w600,
        //   fontSize: 14,
        //   letterSpacing: _defaultLetterSpacing,
        // ),

        // caption: base.caption.copyWith(
        //   letterSpacing: _defaultLetterSpacing,
        //   fontSize: 12.0,
        //   fontWeight: FontWeight.w400,
        // ),
      )
      .apply(
        fontFamily: isArabic ? 'Cairo' : 'Poppins',
        displayColor: TEXT_COLOR,
        bodyColor: TEXT_COLOR,

        // displayColor: LightColors.onPrimary,
        // bodyColor: LightColors.onPrimary,
      );
}
