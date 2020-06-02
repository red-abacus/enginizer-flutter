library Constants;

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String SUCCESS_MESSAGE = " You will be contacted by us very soon.";
const Color light_green = Color.fromARGB(255, 232, 240, 238);
const Color dark_green = Color.fromARGB(255, 246, 249, 249);
const Color black_text = Color.fromARGB(255, 57, 57, 57);
const Color grey_text = Color.fromARGB(255, 151, 151, 151);
const Color disabled_text = Color.fromARGB(255, 225, 225, 225);
const Color light_gray = Color.fromARGB(20, 211, 211, 211);
const Color darker_gray = Color.fromARGB(40, 193, 193, 193);

const Color active = Color(0xFF3D9970);
const Color pending = Color(0xFFFFC107);
const Color stop = Color(0xFFB94047);

const Color foreground = Color(0xFF424242);

const Color green = Color(0xFF009919);
const Color yellow = Color(0xFFECE43C);

const Color gray = Color(0xFF838383);
const Color gray2 = Color.fromRGBO(120, 120, 120, 1);
const Color gray3 = Color.fromRGBO(33, 33, 33, 1);
const Color gray_80 = Color.fromRGBO(70, 70, 72, 0.4);
const Color gray_20 = Color.fromRGBO(70, 70, 72, 0.2);
const Color gray_10 = Color.fromRGBO(120, 120, 120, 0.1);
const Color grey_graph = Color.fromRGBO(188, 193, 195, 1.0);
const Color light_gray_2 = Color.fromRGBO(241, 241, 241, 1);

const Color red = Color.fromRGBO(153, 0, 0, 1);
const Color red_graph = Color.fromRGBO(215, 178, 178, 1.0);
const Color red_dark = Color.fromRGBO(130, 0, 0, 1);
const Color red_light = Color.fromRGBO(194, 37, 37, 1);

const Color blue = Color.fromRGBO(99, 165, 216, 1.0);

const Color dark_gray = Color.fromRGBO(169, 169, 169, 1);
const Color switch_dark_gray = Color.fromRGBO(70, 70, 72, 1);

class Constants {
  static DateFormat time = new DateFormat("hh:mm");
  static DateFormat date = new DateFormat("dd/MM/yyyy");
}

const String kGoogleKeyiOS = 'AIzaSyD9M1eI1kL7GP62FoM8XAA4cKAS9kstTwE';
const String kGoogleKeyAndroid = 'AIzaSyCsA-lBjHv66qgd2TFvcV805w1Sq9LJNWg';

const String kFirebaseAppIdAndroid = '1:617758597624:android:1ce45d11b056053b87b60d';
const String kFirebaseAppIdiOS = '1:617758597624:ios:bf0e06b3eca8bdff87b60d';
const String kFirebaseGcmSenderId = '617758597624';
const String kFirebaseProjectId = 'autowass-dev';
const String kFirebaseProjectName = 'autowass-dev';

String get kGoogleApiKey {
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
      return kGoogleKeyiOS;
    case TargetPlatform.android:
      return kGoogleKeyAndroid;
    default:
      return kGoogleKeyAndroid;
  }
}

String get kFirebaseAppId {
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
      return kFirebaseAppIdiOS;
    case TargetPlatform.android:
      return kFirebaseAppIdAndroid;
    default:
      return kGoogleKeyAndroid;
  }
}
