class WorkStationPersonnel {
  int id;
  String name;
  String image;

  WorkStationPersonnel({this.id, this.name, this.image});

  factory WorkStationPersonnel.fromJson(Map<String, dynamic> json) {
    return WorkStationPersonnel(
        id: json['id'],
        name: json['name'] != null ? json['name'] : '',
        image: json['image'] != null ? json['image'] : '');
  }
}
