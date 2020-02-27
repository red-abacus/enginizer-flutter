import 'dart:io';

import 'package:enginizer_flutter/modules/consultant-appointments/enums/tank-quantity.enum.dart';
import 'package:flutter/cupertino.dart';

class PickUpCarFormConsultantProvider with ChangeNotifier {
  int maxFiles = 5;
  List<File> files;

  String km;
  TankQuantity tankQuantity;

  resetParams() {
    files = [];
    files.add(null);

    km = "";
    tankQuantity = null;
  }
}