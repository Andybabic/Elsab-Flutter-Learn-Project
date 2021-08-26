import 'package:elsab/components/class_user.dart';
import 'package:flutter/material.dart';

class UserConst{
  static User currentUser = User();
}

class ThemeConst{
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black87,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    primaryColor: Colors.blueGrey.shade800,
  );
}

