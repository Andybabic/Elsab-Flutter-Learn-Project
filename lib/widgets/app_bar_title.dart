import 'package:flutter/material.dart';

import 'package:elsab/res/custom_colors.dart';

class AppBarTitle extends StatelessWidget {
  final String sectionName;

  const AppBarTitle({
    Key? key,
    required this.sectionName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/elsab_logo.png',
          height: 200,
        ),


      ],
    );
  }
}
