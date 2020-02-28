import 'package:enginizer_flutter/modules/appointments/model/appointment-provider-type.dart';

class AppointmentRequest {
  String address;
  int carId;
  List<String> issues;
  int providerId;
  List<String> scheduledTimes;
  List<int> serviceIds;
  int userId;
  AppointmentProviderType providerType;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      "address": address,
      "carId": carId,
      "clientId": userId,
      "issues": issues,
      "providerId": providerId,
      "scheduledDateTimes": scheduledTimes,
      "serviceIds": serviceIds,
      'specific':
          providerType == AppointmentProviderType.Specific ? true : false
    };

    return propMap;
  }
}
