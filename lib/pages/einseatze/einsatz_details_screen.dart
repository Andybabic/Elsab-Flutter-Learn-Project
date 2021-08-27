import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elsab/pages/chat/chat.dart';
import 'package:elsab/pages/chat/rooms.dart';
import 'package:elsab/pages/login/auth_screen.dart';
import 'package:elsab/pages/login/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elsab/components/class_einsatz.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:elsab/widgets/flutter_map.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'dart:async';
import 'dart:convert';

class EinsatzDetailScreen extends StatelessWidget {
  final Einsaetze data;
  double lat = 0.0;
  double long = 0.0;
  bool locationIsUnknown = false;

  EinsatzDetailScreen(this.data);

  // return one Detail - Row
  Widget getDetailRow(String fieldname, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(fieldname + ": ", textAlign: TextAlign.end),
            Container(
              alignment: Alignment.topRight,
              width: 200,
              child: Text(value, textAlign: TextAlign.end),
            ),
          ],
        ),
        Divider(
          color: Colors.grey,
        ),
      ],
    );
  }

  // sends location to phone-maps
  sendLocationToMaps(var map) {
    return map.showMarker(
      coords: Coords(lat, long),
      title: data.objekt + data.ort,
    );
  }

  // open available maps-option
  openMapsSheet(context) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => sendLocationToMaps(map),
                        title: Text(map.mapName),
                        leading: Icon(Icons.map),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  // load coordinates for Flutter_map first
  // TO DO: check if http request necessary..
  Future getCoords() async {
    lat = data.lat;
    long = data.long;
    locationIsUnknown = false;

    if (lat == 0 || long == 0) {
      var response = await http.get(Uri.parse(
          "http://api.positionstack.com/v1/forward?access_key=5790cd8f99adf5adf9c5bbfdcdefcb6a&query=" +
              data.ort +
              " " +
              data.strasse +
              " " +
              data.plz.toString() +
              " " +
              data.plz.toString() +
              "&output=json&limit=1"));

      var body = jsonDecode(response.body)["data"];

      try {
        lat = body[0]["latitude"];
        long = body[0]["longitude"];
      } on Exception catch (_) {
        locationIsUnknown = true;
      }
    }
    return [lat, long, locationIsUnknown];
  }

  void setEinsatzRoom(context) async {
    bool alreadyJoined = false;

    final roomDocument = await FirebaseFirestore.instance
        .collection("rooms")
        .where('metadata.einsatzID', isEqualTo: data.einsatzID)
        .get();

    if(roomDocument.docs.isNotEmpty)
      await roomDocument.docs.first["userIds"].forEach((element) => {
        if(element.toString() == FirebaseAuth.instance.currentUser?.uid){
          alreadyJoined = true
        }
      });

    if (roomDocument.docs.isEmpty) {
      FirebaseChatCore.instance.createGroupRoom(
          metadata: data.toMap(),
          name: data.objekt.isEmpty ? data.ort : data.objekt,

          users: [],
      );
    } else if(!alreadyJoined){
      await FirebaseFirestore.instance.collection("rooms").doc(roomDocument.docs.first.id).update({"userIds" : FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])});
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => RoomsPage(),
        ),
      );
    } else {
      showAlertDialog(context, "Raum öffnen/beitreten", "Du bist bereits diesem Raum beigetreten!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.meldebild.toString()),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.open_in_new),
            tooltip: 'Show Snackbar',
            onPressed: () {
              if(FirebaseAuth.instance.currentUser != null)
                setEinsatzRoom(context);
              else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => AuthScreen(),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Next page'),
                    ),
                    body: const Center(
                      child: Text(
                        'This is the next page',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  //margin: EdgeInsets.all(5),
                  //padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      getDetailRow("ALARMSTUFE", data.alarmstufe),
                      getDetailRow("BEMERKUNG", data.bemerkung),
                      getDetailRow("DATUM", data.einsatzErzeugt),
                      getDetailRow("MELDEBILD", data.meldebild),
                      getDetailRow("MELDER", data.melder),
                      getDetailRow("ORT", data.ort),
                      getDetailRow("OBJEKT", data.objekt),
                    ],
                  ),
                ),
              ),
              Container(
                height: 250,
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                            height: 200,
                            width: double.infinity,
                            child: FutureBuilder(
                                future: getCoords(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return FlutterMapWidget(
                                        context: context,
                                        lat: snapshot.data[0],
                                        long: snapshot.data[1],
                                        locationIsUnknown: snapshot.data[2]);
                                  } else
                                    return CircularProgressIndicator();
                                }))),
                    Container(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => openMapsSheet(context),
                        child: Text("Maps öffnen"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey.shade800,
                          minimumSize: Size(double.infinity, double.infinity),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
