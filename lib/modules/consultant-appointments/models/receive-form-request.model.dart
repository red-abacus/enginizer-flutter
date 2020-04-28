import 'dart:io';

import 'package:app/modules/consultant-appointments/enums/payment-method.enum.dart';
import 'package:app/modules/consultant-appointments/enums/tank-quantity.enum.dart';

class ReceiveFormRequest {
  List<File> files = [];
  String km = '';
  TankQuantity tankQuantity;
  bool clientParts = false;
  bool clientKeepParts = false;
  PaymentMethod paymentMethod;
  String oilChange = '';
  String damagedItems = '';
  String observations = '';
}