import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';

class Bid {
  int id;
  int cost;
  int coveredServicesCount;
  String createdDate;
  ServiceProvider serviceProvider;
  String providerAcceptedDateTime;
  int requestedServicesCount;
  String status;

  Bid(
      {this.id,
      this.cost,
      this.coveredServicesCount,
      this.createdDate,
      this.serviceProvider,
      this.providerAcceptedDateTime,
      this.requestedServicesCount,
      this.status});

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json["id"],
      cost: json["cost"],
      coveredServicesCount: json["coveredServicesCount"],
      createdDate: json["createdDate"],
      serviceProvider: ServiceProvider.fromJson(json["provider"]),
      providerAcceptedDateTime: json["providerAcceptedDateTime"],
      requestedServicesCount: json["requestedServicesCount"],
      status: json["status"]
    );
  }
}
