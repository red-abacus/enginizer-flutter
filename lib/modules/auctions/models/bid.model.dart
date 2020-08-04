import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/auctions/enum/bid-status.enum.dart';
import 'package:app/utils/date_utils.dart';

import 'bid-details.model.dart';

class Bid {
  int id;
  double cost;
  int coveredServicesCount;
  String createdDate;
  ServiceProvider serviceProvider;
  String providerAcceptedDateTime;
  int requestedServicesCount;
  String status;
  int workEstimateId;
  int appointmentId;

  Bid(
      {this.id,
      this.cost,
      this.coveredServicesCount,
      this.createdDate,
      this.serviceProvider,
      this.providerAcceptedDateTime,
      this.requestedServicesCount,
      this.status,
      this.workEstimateId,
      this.appointmentId});

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
        status: json["status"],
        workEstimateId:
            json['workEstimateId'] != null ? json['workEstimateId'] : 0,
        appointmentId:
            json['appointmentId'] != null ? json['appointmentId'] : 0);
  }

  factory Bid.fromBidDetails(BidDetails bidDetails) {
    return Bid(
        id: bidDetails.id,
        cost: bidDetails.cost,
        coveredServicesCount: bidDetails.coveredServicesCount,
        createdDate: bidDetails.createdDate,
        serviceProvider: bidDetails.serviceProvider,
        providerAcceptedDateTime: bidDetails.providerAcceptedDateTime,
        requestedServicesCount: bidDetails.requestedServicesCount,
        status: bidDetails.status,
        workEstimateId: bidDetails.workEstimateId,
        appointmentId:
            bidDetails.appointment != null ? bidDetails.appointment.id : 0);
  }

  DateTime getAcceptedDate() {
    return DateUtils.dateFromString(providerAcceptedDateTime, _dateFormat());
  }

  String _dateFormat() {
    return "dd/MM/yyyy HH:mm";
  }

  bool filtered(String searchString) {
    if (serviceProvider != null) {
      if (serviceProvider.name
          .toLowerCase()
          .contains(searchString.toLowerCase())) {
        return true;
      }
    }

    return false;
  }

  BidStatus bidStatus() {
    switch (this.status.toLowerCase()) {
      case 'rejected':
        return BidStatus.REJECTED;
      case 'accepted':
        return BidStatus.ACCEPTED;
      default:
        return BidStatus.PENDING;
    }
  }
}
