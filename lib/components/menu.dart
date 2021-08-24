//import 'dart:async';
import 'package:flutter/material.dart';

//import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:elsab/pages/login/auth_screen.dart';
import 'package:elsab/pages/chat/rooms.dart';

Drawer menu(BuildContext context) {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountEmail: Text(''), // keep blank text because email is required
          accountName: Row(
            children: <Widget>[
              Container(
                width: 100,
                height: 60,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  child: Icon(
                    Icons.check,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('user'),
                  Text('@User'),
                ],
              ),
            ],
          ),
        ),
        ListTile(
          title: Text('HomeScreen'),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/',
            );
          },
        ),
        ListTile(
          title: Text('Login'),
          onTap: () {
            Get.to(() => AuthScreen());
          },
        ),
        ListTile(
          title: Text('Chat'),
          onTap: () {
            Get.to(() => RoomsPage());
          },
        ),
      ],
    ),
  );
}
