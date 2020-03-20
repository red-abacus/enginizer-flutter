import 'package:flutter/cupertino.dart';

class AppConfig extends InheritedWidget {
  AppConfig({this.appInternalId,
    Widget child}):super(child: child);

  final int appInternalId;

  static AppConfig of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppConfig);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

}