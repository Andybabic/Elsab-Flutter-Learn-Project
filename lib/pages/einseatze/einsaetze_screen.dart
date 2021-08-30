import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'einsatz_controller.dart';
import 'einsatz_details_screen.dart';
import 'einsatz_item.dart';
import 'dart:async';

class EinsatzlisteScreen extends StatelessWidget {
  final EinsatzController einsatz = Get.put(EinsatzController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: GetX<EinsatzController>(
                  builder: (controller) {
                    Timer(Duration(seconds: 5), () {});
                    return Container(
                      child: ListView(
                        children: List.generate(
                          controller.einsatzlist.length,
                          (index) {
                            return Container(
                              //margin: const EdgeInsets.fromLTRB(1, 2, 1, 2),
                              padding: const EdgeInsets.all(2.0),

                              child: InkWell(
                                onTap: () {
                                  Get.to(() => EinsatzDetailScreen(
                                      controller.einsatzlist[index]));
                                }, // Handle your callback

                                //height: 90,
                                child: Card(
                                  child: Center(
                                      child: EinsatzItem(
                                          data: controller.einsatzlist[index])),
                                ),
                              ),

                            );
                          },
                        ),
                      ),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.8),
                            spreadRadius: 0.1,
                            blurRadius: 0.1,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
