import 'package:elsab/components/class_user.dart';
import 'package:elsab/constants/app_constants.dart';
import 'package:elsab/widgets/user_online_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'chat_screen.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  bool _isChoosing = false;
  UserClass user = UserClass();
  List<types.User> chosenUsers = [];

  void _handlePressed(
      List<types.User> otherUsers, BuildContext context, bool isShowDialog,
      {imageURL = "", roomName = "", metadata}) async {
    TextEditingController _textFieldController = TextEditingController();
    types.Room room;

    if (isShowDialog && otherUsers.length > 1)
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Wie möchtest du diese Gruppe benennen?'),
              content: TextField(
                controller: _textFieldController,
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: "Name eingeben"),
              ),
              actions: <Widget>[
                new TextButton(
                  child: new Text('Abbrechen'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new TextButton(
                  child: new Text('Erstellen'),
                  onPressed: () async {
                    roomName = _textFieldController.value.text.toString();
                    Get.back();

                    room = await ChatConst.createGroupUserRoom(otherUsers,
                          imageURL: imageURL,
                          roomName: roomName,
                          metadata: metadata);

                    Get.off(
                      () => ChatScreen(
                        room: room,
                        isUserRoom: true,
                      ),
                    );
                  },
                ),
              ],
            );
          });
    else {
      room = await ChatConst.createSingleUserRoom(otherUsers[0]);
      Get.off(() => ChatScreen(
        room: room,
        isUserRoom: true,
      ));
    }
  }

  String getUserName(types.User user) =>
      '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();

  Widget _buildAvatar(types.User user) {
    final color = Colors.blue;
    final hasImage = (user.imageUrl != null && user.imageUrl != '');
    final name = getUserName(user);

    return CircleAvatar(
      backgroundColor: color,
      backgroundImage: hasImage ? NetworkImage(user.imageUrl!) : null,
      radius: 20,
      child: !hasImage
          ? Text(
              name.isEmpty ? user.lastName.toString() : name[0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            )
          : null,
    );
  }

  void cancelGroup() {
    setState(() {
      _isChoosing = !_isChoosing;
      chosenUsers = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: const Text('Users'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: TextButton(
                  child: Text(_isChoosing ? "Abbrechen" : "Gruppe erstellen",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        letterSpacing: 1.5,
                      )),
                  onPressed: () => cancelGroup()),
            ),
          )
        ],
      ),
      body: Container(
        child: StreamBuilder<List<types.User>>(
          stream: FirebaseChatCore.instance.users(),
          initialData: const [],
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                  bottom: 200,
                ),
                child: const Text('No users'),
              );
            }

            return Column(
              children: [
                _isChoosing
                    ? Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                                onPressed: () => {
                                      if (chosenUsers.isNotEmpty)
                                        _handlePressed(
                                            chosenUsers, context, true)
                                    },
                                child: Text("Auswahl akzeptieren",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      letterSpacing: 1.5,
                                    )),
                                style: TextButton.styleFrom(
                                  backgroundColor: ThemeConst.accent,
                                  padding: EdgeInsets.all(12),
                                ))
                          ],
                        ),
                      )
                    : Text(""),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data![index];

                      return GestureDetector(
                        onLongPress: () => {
                          setState(() => {_isChoosing = true})
                        },
                        onTap: () {
                          if (!_isChoosing) {
                            _handlePressed([user], context, false);
                          } else {
                            setState(() {
                              chosenUsers.contains(user)
                                  ? chosenUsers.remove(user)
                                  : chosenUsers.add(user);
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 0),
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ThemeConst.lightPrimary,
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                )
                              ],
                              borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(10))),
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              child: Row(
                                children: [
                                  _buildAvatar(user),
                                  UserOnlineStatus(userStatus: user.metadata?["status"]),
                                ],
                              ),
                            ),
                            title: Text(getUserName(user)),
                            trailing: _isChoosing
                                ? (Icon(chosenUsers.contains(user)
                                    ? Icons.check_box_outlined
                                    : Icons.check_box_outline_blank))
                                : Text(""),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
