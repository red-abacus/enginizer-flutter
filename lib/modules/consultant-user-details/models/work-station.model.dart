import 'package:app/modules/consultant-user-details/models/work-station-camera.model.dart';
import 'package:app/modules/consultant-user-details/models/work-station-personnel.model.dart';

class WorkStation {
  int id;
  String name;
  WorkStationCamera workStationCamera;
  List<WorkStationPersonnel> workStationPersonnel;

  WorkStation(
      {this.id, this.name, this.workStationCamera, this.workStationPersonnel});

  factory WorkStation.fromJson(Map<String, dynamic> json) {
    return WorkStation(
        id: json['id'],
        name: json['name'] != null ? json['name'] : '',
        workStationCamera: WorkStationCamera.fromJson(json['camera']),
        workStationPersonnel: _mapWorkStationPersonnel(json['personnel']));
  }

  static _mapWorkStationPersonnel(List<dynamic> response) {
    List<WorkStationPersonnel> list = [];
    response.forEach((item) {
      list.add(WorkStationPersonnel.fromJson(item));
    });
    return list;
  }
}
