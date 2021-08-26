import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elsab/components/class_user.dart' as myUser;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'chat.dart';
import 'userpage.dart';
import 'package:elsab/pages/login/login_screen.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  bool _error = false;
  bool _initialized = false;
  User? _user;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {
          _user = user;
        });
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(types.Room room) async {
    var otherUser;

    if (room.type == types.RoomType.direct) {
      try {
        otherUser = room.users.firstWhere(
              (u) => u.id != _user!.uid,
        );

      } catch (e) {
        otherUser = null;
        // Do nothing if other user is not found
      }
    }

    DocumentSnapshot<Map<String, dynamic>> response = await FirebaseFirestore.instance.collection("users").doc(otherUser.id).get();

    return response;
  }

  Widget _buildAvatar(types.Room room, myUser.User roomUser) {
    final hasImage = room.imageUrl != null;
    final name = room.name ?? 'Raum ohne Namen';
    var color = Colors.blue;

    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(9),
      width: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
        CircleAvatar(
          backgroundColor: color,
          backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
          radius: 20,
          child: !hasImage
              ? Text(
            name.isEmpty ? '-' : name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          )
              : null,
        ),
        Text(roomUser.firstName),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container();
    }

    if (!_initialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _user == null
                ? null
                : () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const UsersPage(),
                ),
              );
            },
          ),
        ],
        brightness: Brightness.dark,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: _user == null ? null : logout,
        ),
        title: const Text('Rooms'),
      ),
      body: _user == null
          ? Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(
          bottom: 200,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Not authenticated'),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      )
          : StreamBuilder<List<types.Room>>(
        stream: FirebaseChatCore.instance.rooms(),
        initialData: const [],
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: const Text('No rooms'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final room = snapshot.data![index];

              return FutureBuilder(
                  future: getUser(room),
                  builder: (context, AsyncSnapshot snapshot) {
                    myUser.User roomUser = myUser.User();
                    //myUser.User roomUser = myUser.User.fromJson(snapshot.data![0]);
                    if(snapshot.hasData && snapshot.data.data() != null)
                      roomUser = myUser.User.fromJson(snapshot.data.data());
                    else
                      return Text("");

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatPage(
                                  room: room,
                                ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            _buildAvatar(room, roomUser),
                            Text(room.name ?? ''),
                          ],
                        ),
                      ),
                    );
                  }
              );
            },
          );
        },
      ),
    );
  }
}
