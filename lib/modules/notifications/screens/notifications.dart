import 'package:app/database/database.dart';
import 'package:app/database/models/notification.model.dart';
import 'package:app/modules/notifications/cards/notification.card.dart';
import 'package:app/modules/shared/widgets/notifications-manager.dart';
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

  bool _initDone = false;
  bool _isLoading = false;

  String route;

  NotificationsState({this.route});

  List<AppNotification> notifications = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey, body: _contentWidget());
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      Database.getInstance().markNotificationsAsRead();

      setState(() {
        _isLoading = true;
      });

      Database.getInstance().getNotifications().then((notifications) {
        setState(() {
          _isLoading = false;
          this.notifications = notifications;
        });

        NotificationsManager.refreshNotifications(0);
      });
    }

    _initDone = true;
    super.didChangeDependencies();
  }

  _contentWidget() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            padding: EdgeInsets.only(top: 10),
            margin: EdgeInsets.only(left: 10, right: 10),
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return NotificationCard(appNotification: notifications[index]);
              },
              itemCount: notifications.length,
            ),
          );
  }
}
