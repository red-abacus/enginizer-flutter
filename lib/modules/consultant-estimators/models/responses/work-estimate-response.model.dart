import 'package:enginizer_flutter/modules/auctions/models/work-estimate-details.model.dart';
import 'package:enginizer_flutter/modules/consultant-estimators/models/work-estimate.model.dart';

class WorkEstimateResponse {
  int total;
  int totalPages;
  List<WorkEstimate> workEstimates;

  WorkEstimateResponse({this.total, this.totalPages, this.workEstimates});

  factory WorkEstimateResponse.fromJson(Map<String, dynamic> json) {
    return WorkEstimateResponse(
        total: json['total'],
        totalPages: json['totalPages'],
        workEstimates: _mapWorkEstimates(json['items']));
  }

  static _mapWorkEstimates(List<dynamic> response) {
    List<WorkEstimate> list = [];
    response.forEach((item) {
      list.add(WorkEstimate.fromJson(item));
    });
    return list;
  }
}