import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elsab/screens/fourth.dart';
import 'package:elsab/screens/home.dart';
import 'package:elsab/screens/second.dart';
import 'package:elsab/screens/third.dart';

//let run main app
void main() {
  runApp(MyApp());
}

// my app load screen/home.dart with navigation using GetX
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      home: Home(),
      theme: ThemeData(
        accentColor: Colors.redAccent,
        primaryColor: Color(0xFF0B3449),
      ),
      getPages: [
        GetPage(name: '/', page: () => Home()),
        GetPage(name: '/second', page: () => Second()),
        GetPage(
          name: '/third',
          page: () => Third(),
          transition: Transition.zoom,
        ),
        GetPage(name: "/fourth", page: () => Fourth()),
      ],
    );
  }
}