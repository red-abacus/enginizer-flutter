
import 'package:app/modules/notifications/cards/notification.card.dart';
import 'package:app/modules/shared/widgets/notifications-manager.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  static const String route = '/notifications';
  static final IconData icon = Icons.dashboard;

  @override
  State<StatefulWidget> createState() {
    return NotificationsState(route: route);
  }
}

class NotificationsState extends State<Notifications> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String route;

  NotificationsState({this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey, body: _contentWidget());
  }

  _contentWidget() {
    return Column(
      children: <Widget>[
        FlatButton(
          textColor: red,
          onPressed: () {
            NotificationsManager.showNotificationBanner(context);
          },
          child: Text('Test Notification'),
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: gray_80,
            ),
            itemBuilder: (ctx, index) {
              return NotificationCard();
            },
            itemCount: 10,
          ),
        ),
      ],
    );
  }
}
