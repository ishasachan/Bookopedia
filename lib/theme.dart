import 'package:flutter/material.dart';

final ThemeData myTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xff7A5548),
  primaryColorLight: const Color.fromARGB(255, 207, 190, 177),
  primaryColorDark: const Color(0xffFFF4E6),
  canvasColor: const Color(0xfffafafa),
  scaffoldBackgroundColor: const Color(0xffF0F0F0),
  secondaryHeaderColor: const Color(0xfffdf4e7),
  dialogBackgroundColor: const Color(0xffffffff),
  indicatorColor: const Color(0xff7A5548),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff7A5548),
  ),
  buttonTheme: const ButtonThemeData(
    textTheme: ButtonTextTheme.normal,
    minWidth: 88,
    height: 36,
    buttonColor: Color(0xff7A5548),
    padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
    shape: RoundedRectangleBorder(
      side: BorderSide(
        color: Color(0xff000000),
        width: 0,
        style: BorderStyle.none,
      ),
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
    colorScheme: ColorScheme(
      primary: Color(0xff7A5548),
      secondary: Color(0xffFEF4E6),
      surface: Color(0xffffffff),
      background: Color(0xfff8d4a0),
      error: Color(0xffd32f2f),
      onPrimary: Color(0xff000000),
      onSecondary: Color(0xff000000),
      onSurface: Color(0xff000000),
      onBackground: Color(0xff000000),
      onError: Color(0xffffffff),
      brightness: Brightness.light,
    ),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xffffffff)),
  colorScheme: ColorScheme.fromSwatch(
          primarySwatch: const MaterialColor(4294832866, {
    50: Color(0xfffdf4e7),
    100: Color(0xfffceacf),
    200: Color(0xfff8d4a0),
    300: Color(0xfff5bf70),
    400: Color(0xfff2a940),
    500: Color(0xffef9410),
    600: Color(0xffbf760d),
    700: Color(0xff8f590a),
    800: Color(0xff5f3b07),
    900: Color(0xff301e03)
  }))
      .copyWith(background: const Color(0xfff8d4a0))
      .copyWith(error: const Color(0xffd32f2f))
      .copyWith(secondary: const Color(0xffef9410)),
);
