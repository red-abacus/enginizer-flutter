import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/consultant-estimators/enums/work-estimate-status.enum.dart';
import 'package:flutter/cupertino.dart';

class WorkEstimate {
  Appointment appointment;
  Car car;
  String createdDate;
  int id;
  ServiceProvider serviceProvider;
  String status;

  WorkEstimate(
      {this.appointment,
      this.car,
      this.createdDate,
      this.id,
      this.serviceProvider,
      this.status});

  factory WorkEstimate.fromJson(Map<String, dynamic> json) {
    print('accepted work estimate $json');
    return WorkEstimate(
        appointment: json['appointment'] != null
            ? Appointment.fromJson(json['appointment'])
            : null,
        car: json['car'] != null ? Car.fromJson(json['car']) : null,
        createdDate: json['createdDate'],
        id: json['id'],
        serviceProvider: json['providerDto'] != null
            ? ServiceProvider.fromJson(json['providerDto'])
            : null,
        status: json['status']);
  }

  bool filtered(
      String value, WorkEstimateStatus workEstimateStatus, CarBrand carBrand) {
    bool filterStatus = false;

    if (workEstimateStatus != null) {
      if (workEstimateStatus == WorkEstimateStatus.ALL ||
          workEstimateStatus == getStatus()) {
        filterStatus = true;
      }
    } else {
      filterStatus = true;
    }

    return filterStatus;
  }

  WorkEstimateStatus getStatus() {
    if (this.status.toLowerCase() == "pending") {
      return WorkEstimateStatus.PENDING;
    }

    return WorkEstimateStatus.ACCEPTED;
  }

  String statusTitle(BuildContext context) {
    switch (getStatus()) {
      case WorkEstimateStatus.PENDING:
        return S.of(context).work_estimate_status_pending;
      case WorkEstimateStatus.ACCEPTED:
        return S.of(context).work_estimate_status_accepted;
      case WorkEstimateStatus.ALL:
        return S.of(context).general_all;
    }
  }
}
