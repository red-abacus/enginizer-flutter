import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment/appointment-transport.model.dart';
import 'package:app/modules/appointments/model/generic-model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/model/service-item.model.dart';
import 'package:app/modules/appointments/model/personnel/time-entry.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/appointments/model/personnel/mechanic-task.model.dart';
import 'package:app/modules/auctions/models/auction-map.model.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/modules/work-estimate-form/models/issue-recommendation.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/authentication/models/user.model.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/utils/date_utils.dart';
import 'package:flutter/cupertino.dart';

import 'appointment-status.model.dart';

class AppointmentDetail {
  int id;
  String name;
  Car car;
  List<Issue> issues = [];
  List<ServiceItem> serviceItems = [];
  String scheduledDate;
  User user;
  List<int> workEstimateIds;
  ServiceProvider serviceProvider;
  AppointmentStatus status;
  String providerAcceptedDateTime;
  int bidId;
  double forwardPaymentPercent;
  String timeToRespond;
  List<IssueRecommendation> recommendations;
  DateTime deliveryDateTime;
  List<IssueItem> items;
  GenericModel buyer;
  GenericModel seller;
  AppointmentTransportInfo appointmentTransportInfo;
  GenericModel personnel;
  List<GenericModel> children;

  AuctionMapDirections auctionMapDirections;

  AppointmentDetail(
      {this.id,
      this.name,
      this.car,
      this.issues,
      this.serviceItems,
      this.scheduledDate,
      this.user,
      this.workEstimateIds,
      this.serviceProvider,
      this.status,
      this.providerAcceptedDateTime,
      this.bidId,
      this.forwardPaymentPercent,
      this.timeToRespond,
      this.recommendations,
      this.deliveryDateTime,
      this.items,
      this.buyer,
      this.seller,
      this.appointmentTransportInfo,
      this.personnel,
      this.children});

  factory AppointmentDetail.fromJson(Map<String, dynamic> json) {
    return AppointmentDetail(
        id: json['id'] != null ? json['id'] : 0,
        name: json['name'] != null ? json['name'] : '',
        car: Car.fromJson(json["car"]),
        issues: json["issues"] != null ? _mapIssuesList(json["issues"]) : [],
        serviceItems:
            json["services"] != null ? _mapServiceItems(json["services"]) : [],
        scheduledDate: json["scheduledDateTime"],
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
        workEstimateIds: json["workEstimateIds"] != null
            ? _mapWorkEstimateIds(json['workEstimateIds'])
            : [],
        serviceProvider: json['provider'] != null
            ? ServiceProvider.fromJson(json['provider'])
            : null,
        status: json['status'] != null
            ? AppointmentStatus.fromJson(json['status'])
            : null,
        providerAcceptedDateTime: json['providerAcceptedDateTime'] != null
            ? json['providerAcceptedDateTime']
            : '',
        bidId: json['bidId'] != null ? json['bidId'] : 0,
        forwardPaymentPercent: json['forwardPaymentPercent'] != null
            ? json['forwardPaymentPercent']
            : 0,
        timeToRespond:
            json['timeToRespond'] != null ? json['timeToRespond'] : '',
        recommendations: json['recommendations'] != null
            ? _mapRecommendations(json['recommendations'])
            : [],
        deliveryDateTime: json['deliveryDateTime'] != null
            ? DateUtils.dateFromString(
                json['deliveryDateTime'], 'dd/MM/yyyy HH:mm')
            : null,
        items: json['items'] != null ? _mapIssueItems(json['items']) : [],
        buyer:
            json['buyer'] != null ? GenericModel.fromJson(json['buyer']) : null,
        seller: json['seller'] != null
            ? GenericModel.fromJson(json['seller'])
            : null,
        appointmentTransportInfo: json['transportInfo'] != null
            ? AppointmentTransportInfo.fromJson(json['transportInfo'])
            : null,
        personnel: json['personalProductive'] != null
            ? GenericModel.fromJson(json['personalProductive'])
            : null,
        children:
            json['children'] != null ? _mapChildren(json['children']) : []);
  }

  static _mapChildren(List<dynamic> response) {
    List<GenericModel> list = [];
    response.forEach((item) {
      list.add(GenericModel.fromJson(item));
    });
    return list;
  }

  static _mapIssueItems(List<dynamic> response) {
    List<IssueItem> list = [];
    response.forEach((item) {
      list.add(IssueItem.fromJson(item));
    });
    return list;
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

  static _mapWorkEstimateIds(List<dynamic> response) {
    List<int> ids = [];
    response.forEach((item) {
      if (item is int) {
        ids.add(item);
      }
    });
    return ids;
  }

  static _mapRecommendations(List<dynamic> response) {
    List<IssueRecommendation> recommendations = [];
    response.forEach((item) {
      recommendations.add(IssueRecommendation.fromJson(item));
    });
    return recommendations;
  }

  bool hasWorkEstimate() {
    if (workEstimateIds.length > 0) {
      int lastWorkEstimate = workEstimateIds[workEstimateIds.length - 1];
      return lastWorkEstimate > 0;
    }

    return false;
  }

  int lastWorkEstimate() {
    if (workEstimateIds.length > 0) {
      int lastWorkEstimate = workEstimateIds[workEstimateIds.length - 1];

      if (lastWorkEstimate > 0) {
        return lastWorkEstimate;
      }
    }

    return 0;
  }

  List<MechanicTask> tasksFromIssues() {
    List<MechanicTask> tasks = [];

    for (Issue issue in this.issues) {
      tasks.add(MechanicTask.from(issue));
    }

    return tasks;
  }

  DateEntry getWorkEstimateDateEntry() {
    DateTime dateTime =
        DateUtils.dateFromString(providerAcceptedDateTime, 'dd/MM/yyyy HH:mm');

    if (dateTime == null) {
      dateTime = DateUtils.dateFromString(scheduledDate, 'dd/MM/yyyy HH:mm');
    }

    if (dateTime != null) {
      DateEntry dateEntry = new DateEntry(dateTime);
      dateEntry.status = DateEntryStatus.Booked;
      return dateEntry;
    }

    return null;
  }

  static String scheduledTimeFormat() {
    return "dd/MM/yyyy HH:mm";
  }

  bool canEditWorkEstimate() {
    switch (status.getState()) {
      case AppointmentStatusState.SCHEDULED:
      case AppointmentStatusState.IN_UNIT:
      case AppointmentStatusState.IN_WORK:
      case AppointmentStatusState.ON_HOLD:
        return true;
      default:
        return false;
    }
  }

  bool canShareLocation() {
    return status.getState() == AppointmentStatusState.IN_TRANSPORT;
  }

  bool canCreateCarReceiveForm() {
    return status.getState() == AppointmentStatusState.SCHEDULED;
  }

  ServiceItem pickupServiceItem() {
    for (ServiceItem serviceItem in this.serviceItems) {
      if (serviceItem.isPickUpAndReturnService()) {
        return serviceItem;
      }
    }
    return null;
  }

  Future<void> loadMapData(BuildContext context) async {
    auctionMapDirections = AuctionMapDirections(
        destinationPoints: appointmentTransportInfo.getLocations());
    auctionMapDirections.appointmentDate =
        DateUtils.dateFromString(scheduledDate, 'dd/MM/yyyy HH:mm');

    try {
      await auctionMapDirections.setPolyLines(context);
      await auctionMapDirections
          .fetchDistanceAndDurations(inject<AuctionsService>());
    } catch (error) {
      throw (error);
    }
  }
}
