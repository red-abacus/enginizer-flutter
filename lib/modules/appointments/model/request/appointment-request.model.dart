import 'package:app/modules/appointments/model/appointment/appointment-provider-type.dart';

import '../appointment-position.model.dart';

class AppointmentRequest {
  String address;
  int carId;
  List<String> issues;
  int providerId;
  String scheduledTime;
  List<int> serviceIds;
  int userId;
  AppointmentProviderType providerType;
  int promotionId;

  AppointmentPosition pickupPosition = new AppointmentPosition();
  AppointmentPosition returnPosition = new AppointmentPosition();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      "address": address,
      "carId": carId,
      "clientId": userId,
      "issues": issues,
      "providerId": providerId,
      "scheduledDateTime": scheduledTime,
      "serviceIds": serviceIds,
      'specific':
          providerType == AppointmentProviderType.Specific ? true : false
    };

    if (pickupPosition != null) {
      propMap['from'] = pickupPosition.toJson();
    }

    if (returnPosition != null) {
      propMap['to'] = returnPosition.toJson();
    }

    if (promotionId != null) {
      propMap['promotionId'] = promotionId;
    }

    return propMap;
  }
}
