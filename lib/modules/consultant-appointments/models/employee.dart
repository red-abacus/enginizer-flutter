import 'package:app/modules/consultant-appointments/models/employee-timeserie.dart';

class Employee {
  int id;
  String name;
  String image;

  List<EmployeeTimeSerie> timeSeries = [];

  Employee({this.id, this.name, this.image, this.timeSeries});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
        id: json['id'] != null ? json['id'] : 0,
        name: json['name'] != null ? json['name'] : '',
        image: json['image'] != null ? json['image'] : '',
        timeSeries: json['timeSeries'] != null
            ? _mapTimeSeries(json['timeSeries'])
            : []);
  }

  static _mapTimeSeries(List<dynamic> response) {
    List<EmployeeTimeSerie> timeSeries = [];
    response.forEach((item) {
      timeSeries.add(EmployeeTimeSerie.fromJson(item));
    });
    return timeSeries;
  }
}
