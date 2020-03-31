import 'package:flutter/material.dart';

class SnackBarManager {
  static void showSnackBar(String title, String message, ScaffoldState state) {
    final SnackBar snackBar = new SnackBar(
      content: new Text(message),
      action: SnackBarAction(
        label: title,
        onPressed: () {},
      ),
    );

    state.showSnackBar(snackBar);
  }
}