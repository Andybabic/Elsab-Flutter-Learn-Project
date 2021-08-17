
import 'package:flutter/material.dart';
import 'package:elsab/components/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'einsatz_controller.dart';
import 'package:elsab/components/class_einsatz.dart';



class EinsatzDetailScreen extends StatelessWidget {

  //final einsatzController = Get.put(EinsatzController());
  final Einsaetze data;

  EinsatzDetailScreen( this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(data.meldebild.toString()),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Next page'),
                    ),
                    body: const Center(
                      child: Text(
                        'This is the next page',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: GetX<EinsatzController>(
                  builder: (controller) {
                    return ListView(
                      children: List.generate(
                        controller.einsatzlist.length,
                            (index) {
                          return Card(
                            margin: const EdgeInsets.all(6),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                //crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        //crossAxisAlignment:CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${controller.einsatzlist[index].meldebild}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                              'Preis= ${controller.einsatzlist[index].meldebild} Euro',
                                              style: TextStyle(fontSize: 14)),
                                          Text(
                                              ' ${controller.einsatzlist[index].meldebild} ',
                                              style: TextStyle(fontSize: 14)),
                                        ],
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


