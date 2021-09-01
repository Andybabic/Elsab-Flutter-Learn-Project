import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elsab/components/class_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:intl/intl.dart'; // for date format
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

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
    date = "am " + date;
    if (diff.inDays > 7) return date;
    if (diff.inDays < 7) return "vor " + days;
    if (diff.inDays < 1) return "vor " + days + ", " + hours + ", " + minutes;
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
      )),
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

  static Future<types.Room> createSingleUserRoom(types.User otherUser) async {
    final room = await FirebaseChatCore.instance
        .createRoom(otherUser, metadata: {'lastMessage': {}});

    FirebaseFirestore.instance.collection("rooms").doc(room.id).update(
        {"userRoles.${FirebaseAuth.instance.currentUser?.uid}": "User"});

    return room;
  }

  static Future<types.Room> createGroupUserRoom(List<types.User> otherUsers,
      {imageURL = "", roomName = "Kein Name", metadata}) async {
    final room = await FirebaseChatCore.instance.createGroupRoom(
        users: otherUsers,
        name: roomName,
        imageUrl: imageURL,
        metadata: metadata);

    FirebaseFirestore.instance.collection("rooms").doc(room.id).update(
        {"userRoles.${FirebaseAuth.instance.currentUser?.uid}": "admin"});

    return room;
  }

  static Future<bool> getRoomRole(String roomID) async {
    bool isAdmin = false;

    var room =
        await FirebaseFirestore.instance.collection("rooms").doc(roomID).get();

    print(FirebaseAuth.instance.currentUser?.uid);

    await room["userRoles"]?.forEach((key, val) {
      if (val != null &&
          key == FirebaseAuth.instance.currentUser?.uid &&
          val == "admin") {
        isAdmin = true;
      }
    });

    return isAdmin;
  }

  static joinRoom(roomID, user) async {
    await FirebaseFirestore.instance.collection("rooms").doc(roomID).update({
      "userIds": FieldValue.arrayUnion([user])
    });
  }

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
