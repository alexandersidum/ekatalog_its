import 'dart:ui';

import 'package:flutter/material.dart';

final kBlueMainColor = Color(0xFF025AB4);

final kBlueDarkColor = Color(0xFF17234d);

final kOrangeButtonColor = Color(0xFFFFC33A);

final kLightBlueButtonColor = Color(0xFF3AD0FF);

final kRedButtonColor = Color(0xFFE23434);

final kGrayTextColor = Color(0xFF625858);

final mBlueDarkColor = MaterialColor(0xFF17234d, color);

final kBackgroundMainColor = Color(0xFFf5f5f8);

final kGrayConcreteColor = Color(0xFFbdc3c7).withOpacity(0.5);

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

final kPriceTextStyle = TextStyle(
  fontWeight: FontWeight.w800,
  fontSize: 20,
);

final kItemNameTextStyle = TextStyle(
  fontWeight: FontWeight.w300,
  fontSize: 17,
);

final kBlackTextStyle = TextStyle(
  color: Colors.black,
);

final kItemNameStyle = TextStyle(color: Colors.white, fontSize: 15, shadows: [
  Shadow(
    blurRadius: 2,
    color: Colors.black,
  ),
]);

final kHintTextStyle = TextStyle(
  color: Colors.white54,
);

final kMavenBold = TextStyle(
  fontFamily: 'MavenPro',
  fontWeight: FontWeight.w700,
);

final kMaven = TextStyle(
  fontFamily: 'MavenPro',
);

final kCalibriBold = TextStyle(
  fontFamily: 'Calibri',
  fontWeight: FontWeight.bold,
);

final kCalibri = TextStyle(
  fontFamily: 'Calibri',
);

final kLabelStyle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: '');

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
