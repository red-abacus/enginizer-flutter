import 'dart:io';

import 'package:app/modules/consultant-appointments/enums/payment-method.enum.dart';
import 'package:app/modules/consultant-appointments/enums/tank-quantity.enum.dart';
import 'package:flutter/cupertino.dart';

class PickUpCarFormConsultantProvider with ChangeNotifier {
  int maxFiles = 5;
  List<File> files;

  String km;
  TankQuantity tankQuantity;
  bool clientParts = false;
  PaymentMethod paymentMethod;
  String oilChange;
  String damagedItems;
  String observations;

  resetParams() {
    files = [];
    files.add(null);

    km = "";
    tankQuantity = null;
    clientParts = false;
    paymentMethod = null;
    oilChange = "";
    damagedItems = "";
    observations = "";
  }
}