import 'package:enginizer_flutter/modules/auctions/enum/auction-status.enum.dart';
import 'package:enginizer_flutter/utils/string.utils.dart';
import 'package:flutter/gestures.dart';

import '../../appointments/model/appointment.model.dart';
import '../../appointments/model/appointment.model.dart';
import '../../cars/models/car.model.dart';

class Auction {
  int id;
  Appointment appointment;
  Car car;
  String createdDate;
  bool isLost;
  String status;

  Auction(
      {this.id,
      this.appointment,
      this.car,
      this.createdDate,
      this.isLost,
      this.status});

  factory Auction.fromJson(Map<String, dynamic> json) {
    return Auction(
        id: json["id"],
        appointment: json["appointment"] != null
            ? Appointment.fromJson(json["appointment"])
            : null,
        car: json["car"] != null ? Car.fromJson(json["car"]) : null,
        createdDate: json["createdDate"] != null ? json["createdDate"] : "",
        isLost: json["isLost"] != null ? json["isLost"] : true,
        status: json["status"] != null ? json["status"] : "");
  }

  bool filtered(String value) {
    var filtered = false;

    if (car != null) {
      filtered = StringUtils.containsIgnoreCase(car.registrationNumber, value);

      if (car.brand != null) {
        if (car.brand.name != null) {
          filtered =
              filtered || StringUtils.containsIgnoreCase(car.brand.name, value);
        }
      }
    }

    return filtered;
  }

  AuctionStatus getStatus() {
    if (this.status.toLowerCase() == "open") {
      return AuctionStatus.IN_BID;
    }

    return AuctionStatus.FINISHED;
  }
}
