import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';

import '../issue-item.model.dart';

class AppointmentRequest {
  String address;
  int carId;
  List<String> issues;
  int providerId;
  List<String> scheduledTimes;
  List<int> serviceIds;
  int userId;

  AppointmentRequest(ProviderServiceProvider provider) {
    address = provider.selectedProvider.address;

    issues = [];
    for (IssueItem item in provider.issuesFormState) {
      issues.add(item.description);
    }

    serviceIds = [];

    for(ServiceItem item in provider.selectedServiceItems) {
      serviceIds.add(item.id);
    }

    providerId = provider.selectedProvider.id;
    scheduledTimes = [provider.dateEntry.dateForAppointment()];
    carId = provider.car.id;
    userId = provider.userCredentials.id;
  }

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
