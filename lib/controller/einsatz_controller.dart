import 'package:get/state_manager.dart';
import 'package:elsab/components/class_einsatz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EinsatzController extends GetxController {
  //RxList<Product> products = [].obs as RxList<Product>;
  var einsatzlist = RxList<Einsaetze>();
  final String title = 'Home';

  @override
  void onInit() {
    super.onInit();
    fetchEinsaetze();
  }

  void fetchEinsaetze() async {
    List<Einsaetze> data = [];

    await FirebaseFirestore.instance
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
          lat: doc["lat"].toDouble(),
          long: doc["lng"].toDouble(),
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

  int einsatzcounter(){
    return einsatzlist.length;
  }
}
