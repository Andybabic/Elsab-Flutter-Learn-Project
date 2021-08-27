import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elsab/components/class_user.dart' as myUserClass;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserConst{
  static var currentUser = FirebaseAuth.instance.currentUser?? myUserClass.User();

  static logout() async {
    await FirebaseAuth.instance.signOut();
  }
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

  static void joinRoom(){

  }

  static void deleteRoom(types.Room room) async{
    final roomDocument = await FirebaseFirestore.instance
        .collection("rooms")
        .doc(room.id)
        .get();

    if(FirebaseAuth.instance.currentUser?.uid == roomDocument["role"]){
      FirebaseFirestore.instance.collection("rooms").doc(room.id).delete();
    }
  }

  static void leaveRoom(){

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
  static getRoom(User user, [Map<String,dynamic>? metadata]){

  }

  static setRoom(){

  }
}

//
// class AppStatusConst{
//   static AppStatusManager appStatus = AppStatusManager();
// }

