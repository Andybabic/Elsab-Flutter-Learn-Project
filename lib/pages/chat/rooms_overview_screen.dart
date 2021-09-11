import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elsab/components/class_user.dart';
import 'package:elsab/constants/app_constants.dart';
import 'package:elsab/pages/einseatze/einsaetze_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'chat_screen.dart';
import 'users_choosing_screen.dart';
import 'package:elsab/pages/login/login_screen.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({Key? key}) : super(key: key);

  @override
  _RoomsScreenState createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  bool _error = false;
  bool _initialized = false;
  bool _showUserRooms = true;
  int _currentIndex = 0;
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

  Widget _buildRoomAvatar(types.Room room, UserClass roomUser) {
    final hasImage = (room.imageUrl != null && room.imageUrl != '');
    var roomName = room.name ?? '';
    var lastMessage = "Keine Nachricht";

    // get last messages
    try {
      String key = room.metadata?['lastMessage'].keys.elementAt(0)?? "";
      String val = room
          .metadata?['lastMessage'].values.elementAt(0)?? "";

      if(val.isNotEmpty)
      lastMessage = "$key: $val";
    }catch(_){}

    if (roomName.isEmpty && room.type == types.RoomType.group) {
      roomName = "Kein Gruppenname (${roomUser.firstName},..)";
    }

    return Card(
      margin: EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -1),
          leading: CircleAvatar(
            backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
            radius: 20,
            child: !hasImage
                ? Text(
              roomName.isEmpty
                  ? roomUser.lastName
                  : roomName[0].toUpperCase(),
            )
                : null,
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom:6.0),
            child: roomName.isEmpty
                ? Text("${roomUser.firstName} ${roomUser.lastName}".trim())
                : Text(roomName),
          ),
          subtitle: Text(lastMessage),
        ),
      ),
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

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Builder(
        builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context)!;
          tabController.animation!.addListener(() {
            // check if tabcontroller swipe-animation is finished
            // get index and save as currentIndex
            int value = tabController.animation!.value.round();
            if (value != _currentIndex) {
                setState((){
                  _currentIndex = value;
                  _currentIndex == 0? _showUserRooms = true : _showUserRooms = false;
                });
            }
          });

          return Scaffold(
            appBar: AppBar(
              title: TabBar(
                tabs: <Widget>[
                  Tab(
                    //     splashColor: Colors.blue,
                    // highlightColor: Colors.grey,
                    icon: Icon(Icons.messenger),
                  ),
                  Tab(
                    icon: Icon(Icons.group),
                  ),
                ],
                onTap: (int index) {
                  setState(() {
                    _showUserRooms = (index == 0 ? true : false);
                  });
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _user == null
                  ? null
                  : () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) {
                        return _currentIndex == 0
                            ? const UsersPage()
                            : EinsatzlisteScreen(isCreatingRoom: true);
                      }),
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
                : TabBarView(
              children: <Widget>[
                Center(child: getList()),
                Center(child: getList())
              ],
            ),
          );
        },
      ),
    );
  }

  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> getListElement(
      types.Room room) {
    return FutureBuilder(
        future: ChatConst.getOtherRoomUsers(room),
        builder: (context, AsyncSnapshot snapshot) {
          UserClass roomUser = UserClass();
          //myUser.User roomUser = myUser.User.fromJson(snapshot.data![0]);
          if (snapshot.hasData && snapshot.data.data() != null) {
            roomUser = UserClass.fromJson(snapshot.data.data());
          }

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ChatScreen(
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

  getList() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: StreamBuilder<List<types.Room>>(
        stream: FirebaseChatCore.instance.rooms(),
        initialData: const [],
        builder: (context, snapshot) {
          if(!snapshot.hasData || snapshot.data!.isEmpty){
            if (snapshot.connectionState == ConnectionState.active) {
              return Center(
                child: const Text('No rooms'),
              );
            }
            else{
              return Center(child: CircularProgressIndicator());
            }
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final room = snapshot.data![index];

              if (((room.metadata == null ||
                  !room.metadata!.containsKey("einsatzID")) &&
                  _showUserRooms) ||
                  (room.metadata != null &&
                      room.metadata!.containsKey("einsatzID") &&
                      !_showUserRooms)) {
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
