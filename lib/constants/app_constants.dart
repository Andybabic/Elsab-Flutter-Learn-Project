import 'package:elsab/components/class_user.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class UserConst{
  static var currentUser = auth.FirebaseAuth.instance.currentUser?? UserClass();
}

class UtilsConst{
  static getTimeDiff(DateTime date1, [var secondDate]){

    DateTime date2 = secondDate?? DateTime.now();

    var diff = date1.difference(date2).abs();
    String days = diff.inDays.toString() + "Tagen";
    String hours = (diff.inHours % 24).toString() + "Stunden";
    String minutes = (diff.inMinutes % 60).toString() + "Minuten";

    return "vor " + days + ", " + hours + ", " + minutes;
  }
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

class ChatConst{
  static getRoom(UserClass user, [Map<String,dynamic>? metadata]){

  }

  static setRoom(){

  }
}

//
// class AppStatusConst{
//   static AppStatusManager appStatus = AppStatusManager();
// }

