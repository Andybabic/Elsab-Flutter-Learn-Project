import 'package:get/state_manager.dart';
import 'package:elsab/components/class_einsatz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

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
    var data = [
      Einsaetze(
        abschnitt: "abschnitt",
        accuracy: "accuracy",
        alarmiert: 0,
        alarmstufe: "alarmstufe",
        bemerkung: "bemerkung",
        dispositionen: "dispositionen",
        einsatzErzeugt: "einsatzErzeugt",
        einsatzID: 0,
        einsatznummer: 0,
        lat: 0,
        long: 0,
        meldebild: "meldebild",
        melder: "melder",
        meldertelefon: "meldertelefon",
        num1: "num1",
        num2: "num2",
        num3: "num3",
        objekt: "objekt",
        objektID: 0,
        ort: "ort",
        plz: 0,
        status: 0,
        strasse: "strasse",
      )
    ];
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
          einsatzErzeugt: doc["meldebild"],
          einsatzID: doc["einsatzID"],
          einsatznummer: doc["einsatznummer"],
          lat: 0,
          long: 0,
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
