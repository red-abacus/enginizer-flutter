import 'package:app/modules/auctions/enum/auction-status.enum.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/utils/string.utils.dart';
import 'package:flutter/gestures.dart';

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

  bool filtered(String value, AuctionStatus auctionStatus, CarBrand carBrand) {
    var filterTitle = false;

    if (value != null) {
      if (car != null) {
        filterTitle =
            StringUtils.containsIgnoreCase(car.registrationNumber, value);

        if (car.brand != null) {
          if (car.brand.name != null) {
            filterTitle = filterTitle ||
                StringUtils.containsIgnoreCase(car.brand.name, value);
          }
        }
      }
    }

    bool filterStatus = false;

    if (auctionStatus != null) {
      if (auctionStatus == AuctionStatus.ALL || getStatus() == auctionStatus) {
        filterStatus = true;
      }
    } else {
      filterStatus = true;
    }

    bool filterBrand = false;

    if (carBrand != null) {
      if (car != null && car.brand != null) {
        if (carBrand.id == car.brand.id) {
          filterBrand = true;
        }
      }
    } else {
      filterBrand = true;
    }

    return filterTitle && filterStatus && filterBrand;
  }

  AuctionStatus getStatus() {
    if (this.status.toLowerCase() == "open") {
      return AuctionStatus.IN_BID;
    }

    return AuctionStatus.FINISHED;
  }
}
