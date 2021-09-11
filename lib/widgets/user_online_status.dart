import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class UserOnlineStatus extends StatelessWidget{
  final userStatus;

  UserOnlineStatus({required this.userStatus});

  Color getOnlineStatus() {
    //print("status: " + userStatus.toString());
    int status = userStatus ?? 0;
    Color statusColor = Colors.red;

    if (status == 2) {
      statusColor = Colors.orange;
    } else if (status == 3) {
      statusColor = Colors.green;
    }

    return statusColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: getOnlineStatus(),
            borderRadius: BorderRadius.all(
                Radius.circular(10)),
          ),
        ),
      ],
    );
  }
}