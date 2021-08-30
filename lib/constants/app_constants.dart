import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elsab/components/class_user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date format

class UserConst {
  static var currentUser;
}

getData(value) {
  return 'UserExist';
}

class UtilsConst {
  static getTimeDiff(DateTime date1, [var secondDate]) {
    DateTime date2 = secondDate ?? DateTime.now();

    String date = DateFormat('dd.M.yyyy').format(date1).toString();

    var diff = date1.difference(date2).abs();
    String days = diff.inDays.toString() + "Tagen";
    String hours = (diff.inHours % 24).toString() + "Stunden";
    String minutes = (diff.inMinutes % 60).toString() + "Minuten";
    date = "am " + date ;
    if(diff.inDays > 7) return date;
    if(diff.inDays < 7) return "vor " + days ;
    if(diff.inDays < 1) return "vor " + days + ", " + hours + ", " + minutes;
  }
}

class ThemeConst {
  static Color lightPrimary = const Color(0xFFE5E5E5);
  static Color accent = const Color(0xFFA50104);
  static Color fontColor = const Color(0xFF071721);
  static Color dark = const Color(0xFF4E4E4E);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    accentColor: accent,
    scaffoldBackgroundColor: lightPrimary,
    highlightColor: lightPrimary,
    splashColor: lightPrimary,
    primaryColor: lightPrimary,
    cardColor: lightPrimary,
    bottomAppBarColor: lightPrimary,
    buttonColor: lightPrimary,
    disabledColor: lightPrimary,
    appBarTheme: AppBarTheme(
        textTheme: TextTheme(
            headline6: TextStyle(
              color: lightPrimary,
              fontSize: 30,
              fontWeight: FontWeight.w100,
            )
        ),
      color: accent,
      elevation: 40, // This removes the shadow from all App Bars.
    ),



    primaryIconTheme: IconThemeData(
      color: lightPrimary,
    ),


  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: dark,
    highlightColor: dark,
    splashColor: dark,
    primaryColor: dark,
    cardColor: dark,
    bottomAppBarColor: dark,
    buttonColor: dark,
    disabledColor: dark,
  );
}

class ChatConst {
  static getRoom(UserClass user, [Map<String, dynamic>? metadata]) {}

  static setRoom() {}

  static joinRoom(roomID) {}

  static deleteRoom(roomID) async {
    FirebaseFirestore.instance
        .collection("rooms")
        .where("__name__", isEqualTo: roomID)
        .get()
        .then((value) {
      value.docs.first.reference.delete();
    });
  }

  static leaveRoom() {}
}

//
// class AppStatusConst{
//   static AppStatusManager appStatus = AppStatusManager();
// }
