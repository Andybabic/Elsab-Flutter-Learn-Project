import 'package:elsab/components/AppStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:latlong2/latlong.dart';
import 'chat.dart';
import 'package:get/get.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  void _handlePressed(types.User otherUser, BuildContext context) async {
    final room = await FirebaseChatCore.instance
        .createRoom(otherUser, metadata: {'lastMessageFrom': otherUser.id});

    Navigator.of(context).pop();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          room: room,
        ),
      ),
    );
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

  Color getOnlineStatus(types.User user) {
    Color statusColor = Colors.red;
    int status = user.metadata?["status"] ?? 0;
    print(user.metadata?["status"].toString());

    if (status == 2) {
      statusColor = Colors.orange;
    } else if (status == 3) {
      statusColor = Colors.green;
    }

    return statusColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: const Text('Users'),
      ),
      body: Container(
        color: Colors.blueGrey,
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

            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];

                return GestureDetector(
                  onTap: () {
                    _handlePressed(user, context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ], borderRadius: BorderRadius.horizontal(right: Radius.circular(10))),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        child: Row(
                          children: [
                            _buildAvatar(user),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top:10),
                                  height: 8,
                                  width: 8,
                                  decoration: BoxDecoration(
                                    color: getOnlineStatus(user),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      title: Text(getUserName(user)),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
