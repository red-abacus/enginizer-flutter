import 'package:app/modules/appointments/model/generic-model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/auctions/models/auction-map.model.dart';
import 'package:app/modules/auctions/models/bid.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/authentication/models/user.model.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:flutter/cupertino.dart';

import '../../work-estimate-form/models/issue.model.dart';

class AuctionDetail {
  int id;
  Car car;
  String status;
  String scheduledDateTime;
  ServiceProvider serviceProvider;
  List<Issue> issues = [];
  String name;
  List<ServiceProviderItem> serviceItems = [];
  User user;
  int workEstimateId;
  String appointmentType;
  List<Bid> bids = [];
  AuctionMapDirections auctionMapDirections;
  GenericModel appointment;
  String type;

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
      this.bids,
      this.appointment,
      this.type});

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
        bids: json['bids'] != null ? _mapBids(json['bids']) : [],
        appointment: json['appointment'] != null
            ? GenericModel.fromJson(json['appointment'])
            : null,
        type: json['type'] != null ? json['type'] : '');
  }

  static _mapIssuesList(List<dynamic> response) {
    List<Issue> list = [];
    response.forEach((item) {
      list.add(Issue.fromJson(item));
    });
    return list;
  }

  static _mapServiceItems(List<dynamic> response) {
    List<ServiceProviderItem> services = [];
    response.forEach((item) {
      services.add(ServiceProviderItem.fromJson(item));
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

  isOrder() {
    return this.type == 'APPOINTMENT_ITEMS';
  }

  Future<void> loadMapData(BuildContext context) async {
//    auctionMapDirections = AuctionMapDirections(
//        destinationPoints:
//        appointmentTransportInfo.getLocations());
//    auctionMapDirections.appointmentDate = DateUtils.dateFromString(scheduledDate, 'dd/MM/yyyy HH:mm');
//
//    try {
//      await auctionMapDirections.setPolyLines(context);
//      await auctionMapDirections.fetchDistanceAndDurations(inject<AuctionsService>());
//    } catch (error) {
//      throw (error);
//    }
  }
}
