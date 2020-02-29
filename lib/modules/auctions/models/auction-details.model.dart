import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';
import 'package:enginizer_flutter/modules/auctions/enum/bid-status.enum.dart';
import 'package:enginizer_flutter/modules/auctions/models/bid.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue.model.dart';
import 'package:enginizer_flutter/modules/authentication/models/user.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';

class AuctionDetail {
  int id;
  Car car;
  String status;
  String scheduledDateTime;
  ServiceProvider serviceProvider;
  List<Issue> issues = [];
  String name;
  List<ServiceItem> serviceItems = [];
  User user;
  int workEstimateId;
  String appointmentType;
  List<Bid> bids = [];

  AuctionDetail(
      {this.id,
      this.car,
      this.status,
      this.scheduledDateTime,
      this.serviceProvider,
      this.issues,
      this.name,
      this.serviceItems,
      this.user,
      this.workEstimateId,
      this.appointmentType,
      this.bids});

  factory AuctionDetail.fromJson(Map<String, dynamic> json) {
    return AuctionDetail(
        id: json['id'],
        car: json['car'] != null ? Car.fromJson(json['car']) : null,
        status: json['status'],
        scheduledDateTime: json['scheduledDateTime'],
        serviceProvider: json['provider'] != null
            ? ServiceProvider.fromJson(json['provider'])
            : null,
        issues: json['issues'] != null ? _mapIssuesList(json['issues']) : [],
        name: json['name'],
        serviceItems:
            json['services'] != null ? _mapServiceItems(json['services']) : [],
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        workEstimateId: json['workEstimateId'],
        appointmentType: json['appointmentType'],
        bids: json['bids'] != null ? _mapBids(json['bids']) : []);
  }

  static _mapIssuesList(List<dynamic> response) {
    List<Issue> list = [];
    response.forEach((item) {
      list.add(Issue.fromJson(item));
    });
    return list;
  }

  static _mapServiceItems(List<dynamic> response) {
    List<ServiceItem> services = [];
    response.forEach((item) {
      services.add(ServiceItem.fromJson(item));
    });
    return services;
  }

  static _mapBids(List<dynamic> response) {
    List<Bid> bids = [];
    response.forEach((item) {
      bids.add(Bid.fromJson(item));
    });
    return bids;
  }

  Bid getConsultantBid(int providerId) {
    for (Bid bid in bids) {
      if (bid.serviceProvider.id == providerId) {
        return bid;
      }
    }
    return null;
  }
}
