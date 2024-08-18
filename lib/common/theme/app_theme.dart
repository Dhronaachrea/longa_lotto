import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';

enum AppTheme {
  LightAppTheme,
  DarkAppTheme,
}

final appThemeData = {
  AppTheme.LightAppTheme: ThemeData(
    fontFamily: 'Gilroy',
    primarySwatch: Colors.yellow,
    drawerTheme: const DrawerThemeData(
      backgroundColor: LongaColor.white,
    ),
    listTileTheme: const ListTileThemeData(
      style: ListTileStyle.drawer,
    ),
    textTheme: TextTheme(
      headline3: TextStyle(
        fontFamily: 'Gilroy',
        color: LongaColor.black_four.withOpacity(0.5),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodyText1: TextStyle(
        fontFamily: 'Gilroy',
        color: Colors.black,
        fontSize: 18,
      ),
    ),
  )
};
