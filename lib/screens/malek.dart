import 'package:flutter/material.dart';

class Malek extends StatelessWidget {
  const Malek({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 0,),
            Text("Malek's Screen"),
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/malek_profile.jpg"),
            )
          ],
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Malek succeeded", textScaleFactor: 2,),
                SizedBox(height: 20,),
                Text("This is his very interesting text about how he created this screen. Very interesting."),
                SizedBox(height: 40,),
                Text("His beautiful face:", textScaleFactor: 1.5,),
                SizedBox(height: 20,),
                Wrap(
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 8.0, // gap between lines
                  children: <Widget>[
                    Image(
                      width: MediaQuery.of(context).size.width*0.4,
                      image: AssetImage("assets/images/malek_face/left-eye.jpg"),
                    ),
                    Image(
                      width: MediaQuery.of(context).size.width*0.4,
                      image: AssetImage("assets/images/malek_face/right-eye.jpg"),
                    ),
                    Image(
                      width: MediaQuery.of(context).size.width*0.4,
                      image: AssetImage("assets/images/malek_face/mouth-nose.jpg"),
                    ),
                    Image(
                      width: MediaQuery.of(context).size.width*0.4,
                      image: AssetImage("assets/images/malek_face/kinn.jpg"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      )
    );
  }
}
