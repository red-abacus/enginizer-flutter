import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushBarHelper {
  static void showFlushBar(String title, String message, BuildContext context) {
    Flushbar(
        title: title,
        message: message,
        shouldIconPulse: false,
        // Even the button can be styled to your heart's content
        duration: Duration(seconds: 4),
        icon: Icon(Icons.error, color: Theme.of(context).accentColor)
        // Show it with a cascading operator
        )
      ..show(context);
  }
}
