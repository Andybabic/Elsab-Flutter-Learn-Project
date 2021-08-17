import 'package:elsab/pages/einseatze/einsaetze_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import 'package:elsab/components/menu.dart';
import 'package:elsab/components/custom_colors.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return EinsatzlisteScreen();

  }
}
