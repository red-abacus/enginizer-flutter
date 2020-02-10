library Constants;

import 'dart:ui';

import 'package:intl/intl.dart';

const String SUCCESS_MESSAGE = " You will be contacted by us very soon.";
const Color light_green = Color.fromARGB(255, 232, 240, 238);
const Color dark_green = Color.fromARGB(255, 246, 249, 249);
const Color black_text = Color.fromARGB(255, 57, 57, 57);
const Color grey_text = Color.fromARGB(255, 151, 151, 151);
const Color disabled_text = Color.fromARGB(255, 225, 225, 225);

const Color green = Color(0xFF009919);
const Color yellow = Color(0xFFECE43C);

const Color gray = Color(0xFF838383);
const Color gray2 = Color.fromRGBO(120, 120, 120, 1);
const Color gray3 = Color.fromRGBO(33, 33, 33, 1);
const Color gray_80 = Color.fromRGBO(70, 70, 72, 0.4);
const Color gray_20 = Color.fromRGBO(70, 70, 72, 0.2);

const Color red = Color.fromRGBO(153, 0, 0, 1);

const Color dark_gray= Color.fromRGBO(169, 169, 169, 1);
const Color switch_dark_gray = Color.fromRGBO(70, 70, 72, 1);

class Constants {
  static DateFormat time = new DateFormat("hh:mm");
  static DateFormat date = new DateFormat("dd/MM/yyyy");
}
