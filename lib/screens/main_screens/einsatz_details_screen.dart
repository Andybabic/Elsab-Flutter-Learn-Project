import 'package:flutter/material.dart';
import 'package:elsab/res/custom_colors.dart';

// Snapshot übernehmen und Daten geordnet fetchen
// -> bestimmte felder direkt in finals abspeichern gelingt nicht
// nicht-finals verwenden oder stateful widget?
class EinsatzDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  EinsatzDetailScreen({required this.data});

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
          child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Text(data.keys.elementAt(index) + ": " + data.values.elementAt(index).toString()),
                    Divider(),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                );
              })),
    );
  }
}
