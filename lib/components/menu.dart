//import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';

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
                width: 50,
                height: 50,
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
          title: Text('Item 1'),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/details',
            );
          },
        ),
        ListTile(
          title: Text('testing'),
          onTap: () {},
        ),
      ],
    ),
  );
}


