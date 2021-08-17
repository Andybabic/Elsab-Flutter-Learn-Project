/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:weinkost/components/order_item.dart';
import 'package:weinkost/pages/orders/order_controller.dart';
import 'package:get/get.dart';


class GetProducts extends GetView<OrderController>{


  String category;
  GetProducts(this.category);
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Produkte')
          .where('Kategorie ', isEqualTo: category)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Fehler beim Laden');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else
          return Container(
              child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 6,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Container(
                height: 50,
                child: Card(
                  margin: EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                  ),
                  color: Colors.white30,
                  child: Column(
                    children: <Widget>[
                      Text(data['Name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      Text(data['Preis'].toString() + '0 €',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                              onTap: ()=>OrderController(data['Name']).addCount(),
                              child: Icon(
                                Icons.add,
                                color: Colors.lightGreen,
                                size: 50.0,
                                semanticLabel:
                                    'Text to announce in accessibility modes',
                              ),
                            ),
                            Obx(() => Text("hier ${OrderController(data['Name']).count.value}")),
                            Text(OrderController(data['Name']).getCount().toString()),
                                InkWell(
                                  onTap: ()=>OrderController(data['Name']).reduceCount(),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.redAccent,
                                    size: 50.0,
                                    semanticLabel:
                                    'Text to announce in accessibility modes',
                                  ),
                                ),

                          ]),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                ),
              );
            }).toList(),
          ));
      },
    );
  }
}
*/