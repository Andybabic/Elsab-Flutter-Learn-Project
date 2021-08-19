import 'package:flutter/material.dart';
import 'package:elsab/components/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'einsatz_controller.dart';
import 'einsatz_details_screen.dart';
import 'einsatz_item.dart';
import 'package:elsab/components/menu.dart';

class EinsatzlisteScreen extends StatelessWidget {
  final einsatzController = Get.put(EinsatzController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: menu(context),
      appBar: AppBar(),
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: GetX<EinsatzController>(
                  builder: (controller) {
                    return Container(
                      margin: EdgeInsets.all(5),
                      child: ListView(
                        children: List.generate(
                          controller.einsatzlist.length,
                          (index) {
                            return Card(
                              child: InkWell(
                                onTap: () {
                                  Get.to(EinsatzDetailScreen(
                                      controller.einsatzlist[index]));
                                }, // Handle your callback
                                child: Container(
                                  height: 90,
                                  child: Card(
                                    margin: EdgeInsets.only(
                                      top: 5,
                                      //bottom: 5,
                                    ),
                                    child: Center(
                                        child: EinsatzItem(
                                            data: controller.einsatzlist[index])),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
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
