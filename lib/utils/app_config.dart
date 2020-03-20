import 'package:flutter/cupertino.dart';

enum Enviroment {Dev, Beta}

class AppConfig extends InheritedWidget {
  AppConfig({this.enviroment,
    Widget child}):super(child: child);

  final Enviroment enviroment;

  static AppConfig of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppConfig);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

}