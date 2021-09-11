import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elsab/components/class_user.dart';
import 'package:elsab/pages/chat/chat_screen.dart';
import 'package:elsab/pages/dashboard/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart'; // for date format
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class UserConst {
  static var currentUser;

  static void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => DashboardPage());
    /*
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => DashboardPage()),
          (route) => false,
    );
     */
  }
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
  static final Color lightPrimary = const Color(0xFFE5E5E5);
  static final Color accent = const Color(0xFFA50104);
  static final Color fontColor = const Color(0xFF071721);
  static final Color dark = const Color(0xFF4E4E4E);
  static final double cardTitleSize = 19.0;

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
        fontSize: 23,
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
      backgroundColor: dark,
      highlightColor: dark,
      splashColor: dark,
      primaryColor: dark,
      canvasColor: Colors.grey,
      cardColor: Colors.white70,
      bottomAppBarColor: Colors.white70,
      buttonColor: Colors.white,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.white70,
      ),
      //disabledColor: dark,
      //canvasColor: Colors.white60,
      appBarTheme: AppBarTheme(
        textTheme: TextTheme(
            headline6: TextStyle(
          color: dark,
          fontSize: 23,
          fontWeight: FontWeight.w100,
        )),
        color: dark,
        elevation: 40, // This removes the shadow from all App Bars.
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.black),
        bodyText2: TextStyle(color: Colors.black),
        headline1: TextStyle(color: Colors.black),
        caption: TextStyle(color: Colors.black),
        button: TextStyle(color: Colors.white),
        subtitle1: TextStyle(color: Colors.black, fontSize: cardTitleSize),
      ));
}

class ChatConst {
  static getRoom(UserClass user, [Map<String, dynamic>? metadata]) {}

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getOtherRoomUsers (
      types.Room room) async* {
    var otherUser;

    if (room.type == types.RoomType.direct ||
        room.type == types.RoomType.group) {
      try {
        otherUser = room.users.firstWhere(
              (u) => u.id != FirebaseAuth.instance.currentUser!.uid,
        );
      } catch (e) {
        otherUser = null;
        // Do nothing if other user is not found
      }
    }

    DocumentSnapshot<Map<String, dynamic>> response = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(otherUser.id)
        .get();

    yield response;
  }

  // static Future<DocumentSnapshot<Map<String, dynamic>>> getOtherRoomUsers(
  //     types.Room room) async {
  //   var otherUser;
  //
  //   if (room.type == types.RoomType.direct ||
  //       room.type == types.RoomType.group) {
  //     try {
  //       otherUser = room.users.firstWhere(
  //             (u) => u.id != FirebaseAuth.instance.currentUser!.uid,
  //       );
  //     } catch (e) {
  //       otherUser = null;
  //       // Do nothing if other user is not found
  //     }
  //   }
  //
  //   DocumentSnapshot<Map<String, dynamic>> response = await FirebaseFirestore
  //       .instance
  //       .collection("users")
  //       .doc(otherUser.id)
  //       .get();
  //
  //   return response;
  // }

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

  static void setEinsatzRoom(roomData) async {
    String? user = FirebaseAuth.instance.currentUser?.uid;

    //looking for existing room
    final roomDocument = await FirebaseFirestore.instance
        .collection("rooms")
        .where('metadata.einsatzID', isEqualTo: roomData.einsatzID)
        .get();

    // when exists, look if user already joined
    // if user not already joined => user joins the room
    // finally, send user to chat room
    if (roomDocument.docs.isNotEmpty) {
      if (!roomDocument.docs.first["userIds"].contains(user)) {
        ChatConst.joinRoom(roomDocument.docs.first.id, user);
      }
      // send user to the chatroom
      final room = FirebaseChatCore.instance.rooms();
      room.listen(
        (value) {
          for (var i = 0; i < value.length; i++) {
            if (value[i].id == roomDocument.docs.first.id) {
              Get.to(() => ChatScreen(room: value[i], isUserRoom: false));
            }
          }
        },
      );
    } //if empty than create room and send user to room
    else if (roomDocument.docs.isEmpty) {
      final newRoom = await ChatConst.createGroupUserRoom([],
          roomName:
              "EinsatzRaum ${roomData.einsatzID}:\n${roomData.objekt.isEmpty ? roomData.meldebild : roomData.objekt}",
          metadata: roomData.toMap());

      Get.to(() => ChatScreen(room: newRoom, isUserRoom: false));
    }
  }

  static Future<bool> getRoomRole(String roomID) async {
    bool isAdmin = false;

    var room =
        await FirebaseFirestore.instance.collection("rooms").doc(roomID).get();

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
