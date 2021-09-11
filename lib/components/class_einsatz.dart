
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';


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

  factory Einsaetze.fromJson(Map<String, dynamic> parsedJson) {
    return new Einsaetze(
      abschnitt: parsedJson['abschnitt'] ?? '',
      accuracy: parsedJson['accuracy'] ?? '',
      alarmiert: parsedJson['alarmiert'] ?? '',
      alarmstufe: parsedJson['alarmstufe'] ?? '',
      bemerkung: parsedJson['bemerkung'] ?? '',
      dispositionen: parsedJson['dispositionen'] ?? '',
      einsatzErzeugt: DateFormat('yyyy-MM-dd hh:mm').format(parsedJson['einsatzErzeugt'].toDate()).toString(),
      einsatzID: parsedJson['einsatzID'] ?? '',
      einsatznummer: parsedJson['einsatznummer'] ?? '',
      lat: parsedJson['lat'] == null ? 0.0 : parsedJson['lat'].toDouble(),
      long: parsedJson['long'] == null ? 0.0 : parsedJson['long'].toDouble(),
      meldebild: parsedJson['meldebild'] ?? '',
      melder: parsedJson['melder'] ?? '',
      meldertelefon: parsedJson['meldertelefon'] ?? '',
      num1: parsedJson['num1'] ?? '',
      num2: parsedJson['num2'] ?? '',
      num3: parsedJson['num3'] ?? '',
      objekt: parsedJson['objekt'] ?? '',
      objektID: parsedJson['objektID'] ?? '',
      ort: parsedJson['ort'] ?? '',
      plz: parsedJson['plz'] ?? '',
      status: parsedJson['status'] ?? '',
      strasse: parsedJson['strasse'] ?? '',
    );
  }

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
