import 'package:app/database/models/notification.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification appNotification;

  NotificationCard({this.appNotification});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Material(
          elevation: 1,
          color: Colors.white,
          borderRadius: new BorderRadius.circular(5.0),
          child: InkWell(
            splashColor: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
            onTap: () => {},
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(10.0),
              child: Container(
                margin: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      appNotification.title,
                      style: TextHelper.customTextStyle(
                          null, black_text, FontWeight.bold, 14),
                    ),
                    Text(
                      appNotification.body,
                      style: TextHelper.customTextStyle(
                          null, gray, FontWeight.normal, 14),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
