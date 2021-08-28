
import 'package:get/state_manager.dart';


class Einsaetze {
  final String abschnitt;
  final String accuracy;
  final int alarmiert;
  final String alarmstufe;
  final String bemerkung;
  final String dispositionen;
  final String einsatzErzeugt;
  final int einsatzID;
  final int einsatznummer;
  final double lat;
  final double long;
  final String meldebild;
  final String melder;
  final String meldertelefon;
  final String num1;
  final String num2;
  final String num3;
  final String objekt;
  final int objektID;
  final String ort;
  final int plz;
  final int status;
  final String strasse;

  Einsaetze({
    this.abschnitt = '',
    this.accuracy = '',
    this.alarmiert = 0,
    this.alarmstufe = '',
    this.bemerkung = '',
    this.dispositionen = '',
    this.einsatzErzeugt = '',
    this.einsatzID = 0,
    this.einsatznummer = 0,
    this.lat = 0.0,
    this.long = 0.0,
    this.meldebild = '',
    this.melder = '',
    this.meldertelefon = '',
    this.num1 = '',
    this.num2 = '',
    this.num3 = '',
    this.objekt = '',
    this.objektID = 0,
    this.ort = '',
    this.plz = 0,
    this.status = 0,
    this.strasse = '',
  });

  Map<String,dynamic> toMap(){
    return {
      'einsatzID' : einsatzID,
      'alarmstufe' : alarmstufe,
      'meldebild' : meldebild,
      'objekt' : objekt,
      'ort' : ort,
      'plz' : plz,
      'strasse' : strasse,
      'status' : status,
    };
  }

  final isFavorite = false.obs;

  void addToCount() {}

  void updateData() {}
}
