import 'package:flutter/material.dart';
import '../res/custom_colors.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Container(),
        ),
        Container(
          decoration: BoxDecoration(
            color: Palette.firebaseNavy,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
          height: 20.0,
          width: double.maxFinite,
        ),
      ],
    );
  }
}
