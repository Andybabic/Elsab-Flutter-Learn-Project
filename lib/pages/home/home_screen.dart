import 'package:elsab/pages/einseatze/einsaetze_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';

class HomePage extends GetView<HomeController> {

  Future<bool> _backPressed(context) async{
    return await showDialog(
        context: context,
        builder: (context)
    {
      return AlertDialog(
        title: Text('App verlassen?'),
        actions: <Widget>[
          new TextButton(
            child: new Text('bleiben'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          new TextButton(
            child: new Text('verlassen'),
            onPressed: () async {
              return Navigator.pop(context, true);
            },
          ),
        ],
      );
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _backPressed(context),
        child: EinsatzlisteScreen()
    );
  }
}
