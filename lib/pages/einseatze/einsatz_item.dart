import 'package:flutter/material.dart';
import 'package:elsab/components/class_einsatz.dart';
import 'package:elsab/constants/app_constants.dart';


class EinsatzItem extends StatelessWidget {
  final Einsaetze data;

  EinsatzItem({required this.data});

  IconData setEinsatzIcon(String alarm){
    switch(alarm[0]){
      case "T":
        return Icons.electrical_services;
        // or Icons.build_circle_outlined;
      case "B":
        return Icons.local_fire_department_rounded;
      default:
        return Icons.priority_high;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Column(
        children: [Icon(setEinsatzIcon(data.alarmstufe.toString()))],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      title: Text(
          (data.objekt.isNotEmpty && data.objekt != "")
              ? data.objekt.toString()
              : "Kein Ort eingetragen"),
      subtitle: Text(data.einsatzErzeugt.isEmpty
          ? "Kein Datum bekannt"
          : UtilsConst.getTimeDiff(DateTime.parse( data.einsatzErzeugt ))),
      trailing: Text(data.alarmstufe.toString()),
    );
  }
}
