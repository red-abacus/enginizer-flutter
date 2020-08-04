import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/work-estimate-form/enums/work-estimate-status.enum.dart';
import 'package:app/modules/work-estimates/enums/work-estimate-payment-status.enum.dart';

class WorkEstimate {
  Appointment appointment;
  Car car;
  String createdDate;
  int id;
  ServiceProvider serviceProvider;
  WorkEstimateStatus status;
  double totalCost;
  double totalProducts;
  double totalServices;
  WorkEstimatePaymentStatus paymentStatus;

  WorkEstimate(
      {this.appointment,
      this.car,
      this.createdDate,
      this.id,
      this.serviceProvider,
      this.status,
      this.totalCost,
      this.paymentStatus,
      this.totalProducts,
      this.totalServices});

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
        status: json['status'] != null
            ? WorkEstimateStatusUtils.fromString(json['status'])
            : null,
        totalCost: json['totalCost'] != null ? json['totalCost'] : 0,
        paymentStatus: json['paymentStatus'] != null
            ? WorkEstimatePaymentStatusUtils.status(json['paymentStatus'])
            : null,
    totalProducts: json['productsCost'] != null ? json['productsCost'] : 0,
        totalServices: json['servicesCost'] != null ? json['servicesCost'] : 0);
  }
}
