import 'package:app/layout/navigation.app.dart';
import 'package:app/layout/navigation_toolbar.app.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overlay_support/overlay_support.dart';

class NotificationsManager {
  static NavigationAppState navigationAppState;
  static NavigationToolbarAppState navigationToolbarAppState;
  static var notificationsCount = 0;

  static showNotificationBanner(BuildContext context) {
    notificationsCount += 1;
    if (navigationAppState != null) {
      navigationAppState.updateNotifications();
    }

    if (navigationToolbarAppState != null) {
      navigationToolbarAppState.updateNotifications();
    }

    showSimpleNotification(
      Text(
        'Masina CJ-12-XYZ a primit o locitatie pentru programare.',
        style: TextHelper.customTextStyle(null, gray, FontWeight.normal, 16),
      ),
      leading: Container(
        width: 24,
        height: 24,
        child: Icon(
          Icons.info,
          color: green,
          size: 24,
        ),
      ),
      background: Colors.white,
      autoDismiss: true,
      slideDismiss: true,
      trailing: InkWell(
        onTap: () => _showNotificationsScreen(context),
        child: Container(
          width: 20,
          height: 20,
          child: SvgPicture.asset('assets/images/icons/export_icon.svg',
              color: red, semanticsLabel: 'Export Icon'),
        ),
      ),
    );
  }

  static _showNotificationsScreen(BuildContext context) {
    if (navigationAppState != null) {
      navigationAppState.selectNotifications();
    }

    if (navigationToolbarAppState != null) {
      navigationToolbarAppState.selectNotifications();
    }
  }
}
