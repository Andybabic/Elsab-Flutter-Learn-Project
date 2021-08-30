import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elsab/components/class_user.dart' as myUserClass;
import 'package:elsab/pages/dashboard/dashboard_page.dart';
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
  bool _showUserRooms = true;
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
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => DashboardPage()),
      (route) => false,
    );
  }

  // String getUserName(types.User user) =>
  //     '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(
      types.Room room) async {
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

    DocumentSnapshot<Map<String, dynamic>> response = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(otherUser.id)
        .get();

    return response;
  }

  Widget _buildRoomAvatar(types.Room room, myUserClass.UserClass roomUser) {
    final hasImage = (room.imageUrl != null && room.imageUrl != '');
    final name = room.name ?? '';

    return Card(
      margin: EdgeInsets.only(top: 10),
      child: ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        leading: CircleAvatar(
          backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
          radius: 20,
          child: !hasImage
              ? Text(
                  name.isEmpty ? roomUser.lastName : name[0].toUpperCase(),
                )
              : null,
        ),
        title: name.isEmpty
            ? Text("${roomUser.firstName} ${roomUser.lastName}".trim())
            : Text(name),
        subtitle: Text('${room.lastMessages ?? 'keine Nachrichten'}'),
      ),
    );
  }

  // Stream<List<types.Room>> getCorrectRooms() {
  //   User? user = FirebaseAuth.instance.currentUser;
  //
  //   if (user == null) return const Stream.empty();
  //
  //   final collection = _showUserRooms
  //       ? FirebaseFirestore.instance
  //       .collection('rooms')
  //       .where('metadata', isNull: true)
  //       .where('userIds', arrayContains: user.uid)
  //       .orderBy('updatedAt', descending: true)
  //       : FirebaseFirestore.instance
  //       .collection('rooms')
  //       .where('metadata', isNull: false)
  //       .where('userIds', arrayContains: user.uid)
  //       .orderBy('updatedAt', descending: true);
  //
  //   return collection
  //       .snapshots()
  //       .asyncMap((query) => processRoomsQuery(user, query));
  // }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container();
    }

    if (!_initialized) {
      return Container();
    }

    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title:  TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.messenger),
              ),
              Tab(
                icon: Icon(Icons.group),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
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
          child: const Icon(Icons.add),
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
            :  TabBarView(
                children: <Widget>[
                  Center(child: getList(true)),
                  Center(child: getList(false))
                ],
              ),
      ),
    );
  }

  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> getListElement(
      types.Room room) {
    return FutureBuilder(
        future: getUser(room),
        builder: (context, AsyncSnapshot snapshot) {
          myUserClass.UserClass roomUser = myUserClass.UserClass();
          //myUser.User roomUser = myUser.User.fromJson(snapshot.data![0]);
          if (snapshot.hasData && snapshot.data.data() != null) {
            roomUser = myUserClass.UserClass.fromJson(snapshot.data.data());
          }

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    room: room,
                    isUserRoom: _showUserRooms,
                  ),
                ),
              );
            },
            child: _buildRoomAvatar(room, roomUser),
          );
        });
  }

  getList(_showUserRooms) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: StreamBuilder<List<types.Room>>(
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

              if ((room.metadata!.containsKey("einsatzID") &&
                      !_showUserRooms) ||
                  (!room.metadata!.containsKey("einsatzID") &&
                      _showUserRooms)) {
                return getListElement(room);
              } else
                return SizedBox(
                  width: 0,
                );
            },
          );
        },
      ),
    );
  }
}
