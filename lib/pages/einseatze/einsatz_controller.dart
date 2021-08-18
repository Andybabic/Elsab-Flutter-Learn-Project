import 'package:get/state_manager.dart';
import 'package:elsab/components/class_einsatz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EinsatzController extends GetxController {
  //RxList<Product> products = [].obs as RxList<Product>;
  var einsatzlist = RxList<Einsaetze>();
  final String title = 'Home';
  final String positionstack_url = "http://api.positionstack.com/v1/forward?access_key=5790cd8f99adf5adf9c5bbfdcdefcb6a&query=";
  double lat = 46.52694;
  double long = 48.81667;

  @override
  void onInit() {
    super.onInit();
    fetchEinsaetze();
  }

  void fetchEinsaetze() async {
    List<Einsaetze> data = [];

    FirebaseFirestore.instance
        .collection("Einsätze")
        .orderBy("einsatzErzeugt", descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {

        data.add(Einsaetze(
          abschnitt: doc["abschnitt"],
          accuracy: doc["accuracy"],
          alarmiert: doc["alarmiert"],
          alarmstufe: doc["alarmstufe"].toString(),
          bemerkung: doc["bemerkung"],
          dispositionen: doc["dispositionen"],
          einsatzErzeugt: DateFormat('yyyy-MM-dd hh:mm').format(doc["einsatzErzeugt"].toDate()),
          einsatzID: doc["einsatzID"],
          einsatznummer: doc["einsatznummer"],
          lat: lat,
          long: long,
          meldebild: doc["meldebild"],
          melder: doc["melder"],
          meldertelefon: doc["meldertelefon"],
          num1: doc["num1"],
          num2: doc["num2"],
          num3: doc["num3"],
          objekt: doc["objekt"],
          objektID: doc["objektID"],
          ort: doc["ort"],
          plz: doc["plz"],
          status: doc["status"],
          strasse: doc["strasse"],
        ));
      });
    });
    einsatzlist.value = data;
  }
}
