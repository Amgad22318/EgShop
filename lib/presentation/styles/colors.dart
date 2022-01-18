import 'package:flutter/material.dart';

const defaultGrey = Colors.grey;
const backGroundWhite = Color(0xfff0f0f0);
const greyBlue0 = Color(0xFFE0E7F3);
const greyBlue1 = Color(0xFFD9E2F8);
const greyBlue2 = Color(0xFF7B89DC);
const greyBlue3 = Color(0xFF56639C);
const greyBlue4 = Color(0xff454f7d);
const greyBlue5 = Color(0xff3c456d);
const greyBlue6 = Color(0xff343b5e);
const greyBlue7 = Color(0xff2b324e);
const greyBlue8 = Color(0xff22283e);




class Palette {
  static const MaterialColor lightMainColor = MaterialColor(
    0xFF56639C, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xFFE0E7F3 ),//10%
      100: Color(0xFFD9E2F8),//20%
      200: Color(0xFF7B89DC),//30%
      300: Color(0xFF56639C),//40%
      400: Color(0xff4d598c),//50%
      500: Color(0xff454f7d),//60%
      600: Color(0xff3c456d),//70%
      700: Color(0xff343b5e),//80%
      800: Color(0xff2b324e),//90%
      900: Color(0xff22283e),//100%
    },
  );
  static const MaterialColor darkMainColor = MaterialColor(
    0xFFD9E2F8, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xFFE0E7F3 ),//10%
      100: Color(0xFFD9E2F8),//20%
      200: Color(0xFF7B89DC),//30%
      300: Color(0xFF56639C),//40%
      400: Color(0xff4d598c),//50%
      500: Color(0xff454f7d),//60%
      600: Color(0xff3c456d),//70%
      700: Color(0xff343b5e),//80%
      800: Color(0xff2b324e),//90%
      900: Color(0xff22283e),//100%
    },
  );
}