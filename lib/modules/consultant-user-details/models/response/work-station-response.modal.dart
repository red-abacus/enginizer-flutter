import 'package:app/modules/consultant-user-details/models/work-station.model.dart';

class WorkStationResponse {
  int total;
  int totalPages;
  List<WorkStation> items;

  WorkStationResponse({this.total, this.totalPages, this.items});

  factory WorkStationResponse.fromJson(Map<String, dynamic> json) {
    return WorkStationResponse(
        total: json['total'],
        totalPages: json['totalPages'],
        items: _mapWorkStations(json['items']));
  }

  static _mapWorkStations(List<dynamic> response) {
    List<WorkStation> workStations = [];
    response.forEach((item) {
      workStations.add(WorkStation.fromJson(item));
    });
    return workStations;
  }
}
