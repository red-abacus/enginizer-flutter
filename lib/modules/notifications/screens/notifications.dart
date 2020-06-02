import 'package:app/generated/l10n.dart';
import 'package:app/modules/notifications/cards/notification.card.dart';
import 'package:app/modules/notifications/providers/notification.provider.dart';
import 'package:app/modules/notifications/services/notification.service.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  NotificationProvider _provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey, body: _contentWidget());
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      _provider = Provider.of<NotificationProvider>(context);
      _provider.initialiseParams();
      _loadData();
    }

    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _provider.loadNotifications().then((_) async {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(NotificationService.GET_NOTIFICATIONS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_notifications, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _contentWidget() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            padding: EdgeInsets.only(top: 10),
            margin: EdgeInsets.only(left: 10, right: 10),
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                if (index == _provider.notifications.length-1) {
                  _loadData();
                }

                return NotificationCard(
                    appNotification: _provider.notifications[index]);
              },
              itemCount: _provider.notifications.length,
            ),
          );
  }
}
