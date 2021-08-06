import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elsab/res/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:elsab/screens/main_screens/einsatz_details_screen.dart';
import 'package:elsab/widgets/einsatz_item.dart';

class EinsatzlisteScreen extends StatefulWidget {
  const EinsatzlisteScreen({Key? key}) : super(key: key);

  @override
  _EinsatzlisteScreenState createState() => _EinsatzlisteScreenState();
}

class _EinsatzlisteScreenState extends State<EinsatzlisteScreen> {
  Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance
      .collection("Einsätze")
      .orderBy("einsatzErzeugt", descending: true)
      .snapshots();

  refreshSnapshots() async {
    setState(() {
      snapshots = loadData();
    });
  }

  Stream<QuerySnapshot> loadData(){
    Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance
        .collection("Einsätze")
        .orderBy("einsatzErzeugt", descending: true)
        .snapshots();
    return snapshots;
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
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Center(
                    child: Text("Keine Einsätze vorhanden"),
                  );
                }
              } else
                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Container(
                      height: 90,
                      child: Card(
                        margin: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                        ),
                        color: Colors.white30,
                        child: Center(
                          child: EinsatzItem(data: data)
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
