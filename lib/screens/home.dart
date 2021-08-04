import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elsab/screens/second.dart';
import 'package:elsab/components/navBar.dart';

import 'malek.dart';

class Home extends StatelessWidget {
  goToNext() {
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>Second()));
    //navigator.push(MaterialPageRoute(builder: (context) => Second()));
    Get.to(Second());
  }

  // Go to Malek-Screen
  goToMalek(){
    Get.to(Malek());
  }

  _showSnackBar() {
    Get.snackbar(
      "Hey There",
      "Snackbar is easy",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  _showDialog() {
    Get.defaultDialog(
      title: "Simple Dialog",
      content: Text("Too Easy"),
    );
  }

  _showBottomSheet() {
    Get.bottomSheet(
      Container(
        child: Wrap(
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.music_note),
                title: Text('Music'),
                onTap: () => {}),
            ListTile(
              leading: Icon(Icons.videocam),
              title: Text('Video'),
              onTap: () => {},
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainMenu(),
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text("Go To Second"),
              onPressed: () => goToNext(),
            ),
            ElevatedButton(
              child: Text("Snackbar"),
              onPressed: _showSnackBar,
            ),
            ElevatedButton(
              child: Text("Dialog"),
              onPressed: _showDialog,
            ),
            ElevatedButton(
              child: Text("Bottom Sheet"),
              onPressed: _showBottomSheet,
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              child: Text("Name Route: /second"),
              onPressed: () {
                Get.toNamed("/second");
              },
            ),
            Divider(
              color: Colors.black,
            ),
            SizedBox(
              height: 40,
            ),
            Text("Addition"),
            ElevatedButton(
                onPressed: goToMalek,
                child: Text("Let's go to Malek's Screen"),
            ),
          ],
        ),
      ),
    );
  }
}