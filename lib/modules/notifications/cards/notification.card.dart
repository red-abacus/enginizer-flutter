import 'package:app/modules/notifications/models/app-notification.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification appNotification;
  final Function selectNotification;

  NotificationCard({this.appNotification, this.selectNotification});

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
            onTap: () => {
              selectNotification(this.appNotification)
            },
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(10.0),
              child: Container(
                margin: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            appNotification.translateNotificationType(context),
                            style: TextHelper.customTextStyle(
                                null, black_text, FontWeight.bold, 14),
                          ),
                          Text(
                            appNotification.date != null
                                ? DateUtils.periodFromDate(
                                context, appNotification.date)
                                : '',
                            style: TextHelper.customTextStyle(
                                null, gray, FontWeight.normal, 14),
                          )
                        ],
                      ),
                    ),
                    if (!appNotification.seen)
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: red,
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
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
