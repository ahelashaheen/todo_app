import 'package:flutter/material.dart';

class Mytheme {
  static Color PrimaryLight = Color(0xff5D9CEC);
  static Color backgroundLight = Color(0xffDFECDB);
  static Color greenColor = Color(0xff61E757);
  static Color redColor = Color(0xffEC4B4B);
  static Color blackColor = Color(0xff383838);
  static Color whiteColor = Color(0xffFFFFFF);
  static Color greyColor = Color(0xff505d67);
  static Color backgroundDark = Color(0xff060E1E);
  static Color blackDark = Color(0xff141922);
  static Color colorbottombar = Color(0xff707070);

  static ThemeData LightTheme = ThemeData(
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: AppBarTheme(backgroundColor: PrimaryLight, elevation: 0),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: PrimaryLight,
        unselectedItemColor: greyColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: PrimaryLight,
          shape: StadiumBorder(side: BorderSide(color: whiteColor, width: 3))),
      textTheme: TextTheme(
        titleLarge: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: whiteColor),
        titleMedium: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: blackColor),
        titleSmall: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: blackColor),
      ));

  static ThemeData DarkTheme = ThemeData(
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: AppBarTheme(backgroundColor: PrimaryLight, elevation: 0),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: PrimaryLight,
        unselectedItemColor: whiteColor,
        backgroundColor: colorbottombar,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: blackDark,
          shape: StadiumBorder(side: BorderSide(color: whiteColor, width: 3))),
      textTheme: TextTheme(
        titleLarge: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: whiteColor),
        titleMedium: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: PrimaryLight),
        titleSmall: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: greenColor),
      ));
}
