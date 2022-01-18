import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

import 'colors.dart';

ThemeData lightTheme = ThemeData(

  splashColor: greyBlue2,
  primaryColor: greyBlue6,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
  ),
  primarySwatch: Palette.lightMainColor,
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: greyBlue3),
    titleSpacing: 16,
    actionsIconTheme: IconThemeData(color: greyBlue3),
    backgroundColor: backGroundWhite,
    elevation: 0.0,
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: greyBlue1, statusBarIconBrightness: Brightness.dark),
    titleTextStyle:
        TextStyle(color: greyBlue3, fontWeight: FontWeight.bold, fontSize: 20),
  ),
  scaffoldBackgroundColor: backGroundWhite,
  cardTheme: const CardTheme(shadowColor: greyBlue1),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: greyBlue3,
      backgroundColor: Colors.white,
      unselectedItemColor: greyBlue2,
      elevation: 20),
  textTheme: const TextTheme(
      bodyText1: TextStyle(
    wordSpacing: 0.5,
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.normal,
  )),
  iconTheme: const IconThemeData(color: Colors.white,),
  fontFamily: 'Janh',
);

ThemeData darkTheme = ThemeData(
  splashColor: greyBlue2,
  primaryColor: greyBlue6,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
  ),
  primarySwatch: Palette.darkMainColor,
  appBarTheme: AppBarTheme(
    iconTheme: const IconThemeData(color: Colors.white, size: 25),
    titleSpacing: 16,
    actionsIconTheme: const IconThemeData(color: Colors.white),
    backgroundColor: HexColor('333739'),
    elevation: 0.0,
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: HexColor('333739'),
        statusBarIconBrightness: Brightness.light),
    titleTextStyle: const TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
  ),
  scaffoldBackgroundColor: HexColor('333739'),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: greyBlue3,
      backgroundColor: HexColor('333739'),
      unselectedItemColor: Colors.grey,
      elevation: 20),
  textTheme: const TextTheme(
      bodyText1: TextStyle(
          fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal)),
  iconTheme: const IconThemeData(color: Colors.black),
  fontFamily: 'Janh',
);
