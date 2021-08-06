import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elsab/res/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:elsab/screens/main_screens/einsatz_details_screen.dart';

class EinsatzlisteScreen extends StatefulWidget {
  const EinsatzlisteScreen({Key? key}) : super(key: key);

  @override
  _EinsatzlisteScreenState createState() => _EinsatzlisteScreenState();
}

class _EinsatzlisteScreenState extends State<EinsatzlisteScreen> {
  Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance.collection("Einsätze").orderBy("einsatzErzeugt", descending: true).snapshots();

  String calculateTime(DateTime date){
    DateTime now = DateTime.now();
    var diff = now.difference(date);
    String days = diff.inDays.toString() + "Tagen";
    String hours = (diff.inHours % 24).toString() + "Stunden";
    String minutes = (diff.inMinutes % 60).toString() + "Minuten";

    return "vor " + days + ", " + hours + ", " + minutes;
  }

  refreshSnapshots() async{
    Stream<QuerySnapshot> snapshots_new = FirebaseFirestore.instance.collection("Einsätze").orderBy("einsatzErzeugt", descending: true).snapshots();
    setState((){
      snapshots = snapshots_new;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.firebaseNavy,
      appBar: AppBar(
        backgroundColor: Palette.firebaseOrange,
        title: Text("Einsatzliste"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          refreshSnapshots();
        },
        child: Container(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 50.0,
            top: 50.0,
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: snapshots,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(!snapshot.hasData)
                return Center(
                    child: Text("Keine Einsätze vorhanden"),
                );
              if (snapshot.hasError) {
                return Text('Ups! Etwas ist schief gelaufen');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              else
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return Container(
                      height: 90,
                      child: Card(
                        margin: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                        ),
                        color: Colors.white30,
                        child: Center(
                          child: ListTile(
                            leading: Icon(Icons.access_alarm),
                            title: Text((data['objekt'] != null && data['objekt'] != "") ? data['objekt'].toString() : "Kein Ort eingetragen"),
                            subtitle: Text(data['einsatzErzeugt'] != null ? calculateTime(data['einsatzErzeugt'].toDate()) : "Kein Datum bekannt"),
                            trailing: Text(data['alarmstufe'].toString()),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EinsatzDetailScreen(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
            },
          ),
        ),
      ),
    );
  }
}
