import 'package:flutter/material.dart';
import 'package:elsab/res/custom_colors.dart';

// Snapshot übernehmen und Daten geordnet fetchen
// -> bestimmte felder direkt in finals abspeichern gelingt nicht
// nicht-finals verwenden oder stateful widget?
class EinsatzDetailScreen extends StatelessWidget {
/*  final String alarmstufe;
  final String bemerkung;
  final String einsatzErzeugt;
  final String ort;*/

  const EinsatzDetailScreen({
    Key? key,
/*    required this.alarmstufe,
    required this.bemerkung,
    required this.einsatzErzeugt,
    required this.ort,*/
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Palette.firebaseNavy,
        appBar: AppBar(
          backgroundColor: Palette.firebaseOrange,
          title: Text("Einsatz Details"),
        ),
        body: Container(

        ),
    );
  }
}
