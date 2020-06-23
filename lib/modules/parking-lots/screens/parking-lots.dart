import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ParkingLots extends StatefulWidget {
  static const String route = '/parkingLots';
  static final IconData icon = Icons.local_parking;

  @override
  _ParkingLotsState createState() => _ParkingLotsState();
}

class _ParkingLotsState extends State<ParkingLots> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: 'https://www.google.com/maps/search/parking near me',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
