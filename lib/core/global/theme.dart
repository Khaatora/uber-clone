
import 'package:flutter/material.dart';

class AppTheme{
  static final light = ThemeData(
    textTheme: const TextTheme(
      displaySmall: TextStyle(
          fontSize: 16,
          color: Colors.black
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        color: Colors.white
      )
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
          foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
          elevation: MaterialStatePropertyAll<double>(0.0),
          side: MaterialStatePropertyAll<BorderSide>(BorderSide.none),
          alignment: Alignment.center,
          textStyle: MaterialStatePropertyAll<TextStyle>(TextStyle(
            color: Colors.white,
          )),
        overlayColor: MaterialStatePropertyAll<Color>(Colors.white24)
        )
      )
      );
}