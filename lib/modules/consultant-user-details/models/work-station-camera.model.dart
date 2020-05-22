
class WorkStationCamera {
  int id;
  String name;

  WorkStationCamera(
      {this.id, this.name});

  factory WorkStationCamera.fromJson(Map<String, dynamic> json) {
    return WorkStationCamera(
        id: json['id'],
        name: json['name'] != null ? json['name'] : '');
  }
}
