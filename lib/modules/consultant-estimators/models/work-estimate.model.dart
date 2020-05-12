import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/work-estimate-form/enums/work-estimate-status.enum.dart';
import 'package:flutter/cupertino.dart';

class WorkEstimate {
  Appointment appointment;
  Car car;
  String createdDate;
  int id;
  ServiceProvider serviceProvider;
  WorkEstimateStatus status;

  WorkEstimate(
      {this.appointment,
      this.car,
      this.createdDate,
      this.id,
      this.serviceProvider,
      this.status});

  factory WorkEstimate.fromJson(Map<String, dynamic> json) {
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
        status: json['status'] != null ? WorkEstimateStatusUtils.fromString(json['status']) : null);
  }

  bool filtered(
      String value, WorkEstimateStatus workEstimateStatus, CarBrand carBrand) {
    bool filterStatus = false;

    if (workEstimateStatus != null) {
      if (workEstimateStatus == WorkEstimateStatus.All ||
          workEstimateStatus == status) {
        filterStatus = true;
      }
    } else {
      filterStatus = true;
    }

    return filterStatus;
  }

  String statusTitle(BuildContext context) {
    switch (this.status) {
      case WorkEstimateStatus.Pending:
        return S.of(context).work_estimate_status_pending;
      case WorkEstimateStatus.Accepted:
        return S.of(context).work_estimate_status_accepted;
      case WorkEstimateStatus.All:
        return S.of(context).general_all;
      default:
        return '';
    }
  }
}
