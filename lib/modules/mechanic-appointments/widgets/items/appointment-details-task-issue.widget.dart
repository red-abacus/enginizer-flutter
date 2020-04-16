import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsTaskIssueWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Material(
        elevation: 1,
        color: Colors.white,
        borderRadius: new BorderRadius.circular(5.0),
        child: ClipRRect(
            borderRadius: new BorderRadius.circular(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
              ],
            )),
      ),
    );
  }
}
