import 'dart:io';

import 'package:app/modules/appointments/enum/payment-method.enum.dart';
import 'package:app/modules/appointments/enum/tank-quantity.enum.dart';

class ReceiveFormRequest {
  int appointmentId = 0;
  int receiveFormId = 0;

  List<File> files = [];
  String km = '';
  TankQuantity tankQuantity;
  bool clientParts = false;
  bool clientKeepParts = false;
  PaymentMethod paymentMethod;
  String oilChange = '';
  String damagedItems = '';
  String observations = '';

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'id': 0,
      'appointmentProcedureType': 'RECEIVE_CAR',
      'fuel': TankQuantityUtils.quantity(tankQuantity),
      'hasClientComponents': clientParts,
      'hasClientKeepComponents': clientKeepParts,
      'missingOrDamagedComponents': damagedItems,
      'observations': observations,
      'oilReplacementConvention': oilChange,
      'paymentMethod': PaymentMethodUtilities.paymentMethod(paymentMethod),
      'realKms': km
    };
    return propMap;
  }
}
