import 'package:flutter/material.dart';

final kBlueMainColor = Color(0xFF5078f2);

final kBlueDarkColor = Color(0xFF17234d);

final kGrayMainColor = Color(0xFFf5f5f8);

final kGrayConcreteColor = Color(0xFFbdc3c7).withOpacity(0.5);

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

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

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
