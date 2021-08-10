import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:elsab/res/custom_colors.dart';
import 'package:elsab/widgets/mapbox/maps.dart';

// Snapshot übernehmen und Daten geordnet fetchen
// -> bestimmte felder direkt in finals abspeichern gelingt nicht
// nicht-finals verwenden oder stateful widget?
class EinsatzDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  EinsatzDetailScreen({required this.data});

  Widget getItemVal(String field, Object val) {
    if (val.toString() != "" && val.toString() != "0") {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(field.toUpperCase() + ": "),
              Container(
                alignment: Alignment.centerRight,
                width: 200,
                child: Text(val is Timestamp
                    ? val.toDate().toString()
                    : val.toString()),
              )
            ],
          ),
          Divider(),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    } else
      return SizedBox(
        width: 0,
        height: 0,
      );
  }

  Widget getMap(){
    if(data["lat"] == "" || data["lat"] == null)
      return Maps(ort: data["ort"],);
    else
      return Maps(lat: data["lat"], long: data["lng"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.firebaseNavy,
      appBar: AppBar(
        backgroundColor: Palette.firebaseOrange,
        title: Text("Einsatz Details"),
      ),
      body: Container(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 50.0,
            top: 50.0,
          ),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return getItemVal(data.keys.elementAt(index),
                          data.values.elementAt(index));
                    }),
                Container(
                  width: double.infinity,
                  height: 250,
                  child: getMap(),
                )
              ],
            ),
          )),
    );
  }
}
