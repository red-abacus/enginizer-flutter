import 'package:app/generated/l10n.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/enums/issue-recommendation-status.enum.dart';
import 'package:app/modules/work-estimate-form/models/requests/send-appointment-request.model.dart';
import 'package:flutter/cupertino.dart';

import 'issue-item.model.dart';

class IssueRecommendation {
  int id;
  String name;
  List<IssueItem> items;
  bool expanded = false;
  String priority;
  bool isStandard;
  bool isAccepted;
  IssueRecommendationStatus status;

  IssueRecommendation(
      {this.id,
      this.name,
      this.items,
      this.priority,
      this.isStandard,
      this.isAccepted,
      this.status});

  factory IssueRecommendation.fromJson(Map<String, dynamic> json) {
    return IssueRecommendation(
        id: json['id'],
        name: json['name'] != null ? json['name'] : '',
        items: json['items'] != null ? _mapItems(json['items']) : [],
        priority: json['priority'] != null ? json['priority'] : '',
        isStandard: json['isStandard'] != null ? json['isStandard'] : true,
        isAccepted: json['isAccepted'] != null ? json['isAccepted'] : true,
        status: json['status'] != null
            ? IssueRecommendationStatusUtils.fromString(json['status'])
            : null);
  }

  static _mapItems(List<dynamic> response) {
    List<IssueItem> issueItems = [];
    response.forEach((item) {
      issueItems.add(IssueItem.fromJson(item));
    });
    return issueItems;
  }

  clearItems() {
    items = [];
  }

  static IssueRecommendation defaultRecommendation(BuildContext context) {
    IssueRecommendation recommendation = new IssueRecommendation();
    recommendation.name = S.of(context).estimator_default_recommendation;
    recommendation.id = null;
    recommendation.items = [];
    return recommendation;
  }

  static IssueRecommendation defaultPrRecommendation(BuildContext context) {
    IssueRecommendation recommendation = new IssueRecommendation();
    recommendation.name = S.of(context).estimator_default_issue;
    recommendation.id = null;
    recommendation.items = [];
    return recommendation;
  }

  static IssueRecommendation defaultRentRecommendation(BuildContext context) {
    IssueRecommendation recommendation = new IssueRecommendation();
    recommendation.name = S.of(context).estimator_rent_default_recommendation;
    recommendation.id = null;
    recommendation.items = [];
    return recommendation;
  }


  Map<String, dynamic> toCreateJson(EstimatorMode estimatorMode) {
    Map<String, dynamic> propMap = {
      'id': estimatorMode == EstimatorMode.CreatePart ? id : null,
      'name': estimatorMode == EstimatorMode.CreatePart || estimatorMode == EstimatorMode.CreatePr || estimatorMode == EstimatorMode.CreateRent ? name : null,
      'items': items.map((item) => item.toCreateJson()).toList()
    };

    return propMap;
  }

  double totalCost() {
    double total = 0.0;
    for (IssueItem item in this.items) {
      total += item.getTotalPrice();
    }
    return total;
  }

  SendAppointmentRequest sendRequest(bool accept) {
    return SendAppointmentRequest(
        recommendationId: this.id, isAccepted: accept, message: '');
  }
}
