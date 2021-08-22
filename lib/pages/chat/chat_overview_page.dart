import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:elsab/components/menu.dart';
import 'package:get/get.dart';
import 'package:elsab/components/class_chat.dart';
import 'package:elsab/components/class_user.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

class ChatOverviewPage extends StatefulWidget {
  @override
  State<ChatOverviewPage> createState() => _ChatOverviewPageState();
}

class _ChatOverviewPageState extends State<ChatOverviewPage> {
  bool isRecentPage = true;

  Widget getAvailableUsers() {
    return Column(
      children: [
        Text("Available Users", style: TextStyle(fontSize: 17, letterSpacing: 2)),
        Container(
          width: 60,
            child: Divider(height: 40, thickness: 2,)
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            // <2> Pass `Stream<QuerySnapshot>` to stream
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Card(
                      shadowColor: Colors.grey,
                      child: ListTile(
                        leading: CircleAvatar(
                            radius: 30.0,
                            backgroundImage:
                                AssetImage('assets/images/placeholder.jpg')),
                        title: Text(data['name'] ?? 'Kein Name'),
                        subtitle: Text(data['id'] ?? 'Keine ID'),
                        onTap: () {
                          Get.to(() => ChatPage(chatUser: data));
                        },
                      ),
                    );
                  }).toList(),
                );
              } else if (snapshot.hasError) {
                return Text("It's an Error!");
              } else
                return Text("Aktuell keine User vorhanden...");
            },
          ),
        ),
      ],
    );
  }

  Widget getRecentChats() {
    return Center(child: Text("Recent Chats"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: menu(context),
        appBar: AppBar(
          title: Text("Chat"),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              height: 50,
              color: Colors.blueGrey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: TextButton.icon(
                      label:
                          Text("Recent", style: TextStyle(color: Colors.white)),
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          letterSpacing: 2,
                        ),
                      ),
                      icon: Icon(
                        Icons.history,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isRecentPage = true;
                        });
                      },
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.white,
                  ),
                  Expanded(
                    child: TextButton.icon(
                      label:
                          Text("Write", style: TextStyle(color: Colors.white)),
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          letterSpacing: 2,
                        ),
                      ),
                      icon: Icon(
                        Icons.chat,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isRecentPage = false;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: isRecentPage ? getRecentChats() : getAvailableUsers()),
            ),
          ],
        ));
  }
}
