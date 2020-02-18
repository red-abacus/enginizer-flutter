import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/utils/date_utils.dart';

class Bid {
  int id;
  double cost;
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
        serviceProvider: json["provider"] != null
            ? ServiceProvider.fromJson(json["provider"])
            : null,
        providerAcceptedDateTime: json["providerAcceptedDateTime"],
        requestedServicesCount: json["requestedServicesCount"],
        status: json["status"]);
  }

  DateTime getAcceptedDate() {
    return DateUtils.dateFromString(providerAcceptedDateTime, _dateFormat());
  }

  String _dateFormat() {
    return "dd/MM/yyyy HH:mm";
  }
}
