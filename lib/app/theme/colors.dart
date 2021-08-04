import 'dart:ui';

import 'package:flutter/widgets.dart';

// BACKGROUND
const WHITE = Color(0xFFFFFFFF);
const OFF_WHITE = Color(0xFFF0F0F0);

//TEXT
const TEXT_COLOR = Color(0xFF1E3340);
const TEXT_SECONDARY_COLOR = Color.fromARGB(255, 75, 75, 75);

// PRIMARY
const PRIMARY = Color(0xFFFFDB5D);
const LIGHT_PRIMARY = Color.fromARGB(255, 104, 171, 203);
const LIGHT_ACCENT = Color.fromARGB(255, 164, 208, 220);
const ORANGE = Color(0xFFFF913E);

const BORDER_COLOR = Color(0xFFE6E6E6);

//SECONDARY
const ACCENT = Color(0xFFFE0000);
const FUCHSIA = Color.fromARGB(255, 229, 13, 80);
const GREY = Color.fromARGB(255, 194, 194, 194);
const DARK_GREY = Color.fromARGB(255, 75, 75, 75);
const LIGHT_GREY = Color.fromARGB(255, 225, 225, 225);
const BLUE = Color.fromARGB(255, 66, 135, 218);
//const GREY = Color.fromARGB(255, 150, 150, 150);
const ERROR_COLOR = Color.fromARGB(255, 243, 67, 54);
const SHADOW_COLOR = Color.fromARGB(255, 200, 200, 200);
const BACKGROUND_COLOR = Color.fromARGB(255, 244, 245, 250);
const YELLOW = Color(0xFFFFDB5D);
const RED = Color(0xFFFE0000);
const GREEN = Color(0xff4cd964);

const LinearGradient GREY_GRADIENT = LinearGradient(
  colors: [LIGHT_GREY, GREY],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const LinearGradient ACCENT_GRADIENT = LinearGradient(
  colors: [LIGHT_ACCENT, ACCENT],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const LinearGradient PRIMARY_GRADIENT = LinearGradient(
  colors: [LIGHT_PRIMARY, PRIMARY],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const LinearGradient WHITE_GRADIENT = LinearGradient(
  colors: [WHITE, WHITE],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const LinearGradient RED_GRADIENT = LinearGradient(
  colors: [Color(0xFFFFCDD2), RED],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const LinearGradient BUTTON_GRADIENT = LinearGradient(
  colors: [YELLOW, RED],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

final Shader linearGradient = const LinearGradient(
  colors: <Color>[YELLOW, RED],
).createShader(const Rect.fromLTWH(0.0, 0.0, 400.0, 100.0));
