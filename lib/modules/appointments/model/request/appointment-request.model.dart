import 'package:app/modules/appointments/model/appointment/appointment-provider-type.dart';

class AppointmentRequest {
  String address;
  int carId;
  List<String> issues;
  int providerId;
  String scheduledTime;
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
      "scheduledDateTime": scheduledTime,
      "serviceIds": serviceIds,
      'specific':
          providerType == AppointmentProviderType.Specific ? true : false
    };

    return propMap;
  }
}
