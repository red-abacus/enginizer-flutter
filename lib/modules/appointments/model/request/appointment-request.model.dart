

class AppointmentRequest {
  String address;
  int carId;
  List<String> issues;
  int providerId;
  List<String> scheduledTimes;
  List<int> serviceIds;
  int userId;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      "address": address,
      "carId": carId,
      "issues": issues,
      "providerId": providerId,
      "scheduleDateTimes": scheduledTimes,
      "serviceIds": serviceIds,
      "userId": userId
    };

    return propMap;
  }
}
