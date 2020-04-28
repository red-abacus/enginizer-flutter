import 'package:app/modules/consultant-appointments/models/employee-timeserie.dart';

class Employee {
  int id;
  String name;
  String image;

  List<EmployeeTimeSerie> timeSeries = [];

  Employee({this.id, this.name, this.image, this.timeSeries});

  factory Employee.fromJson(Map<String, dynamic> json) {
    int employeeId = json['employee'] != null ? json['employee']['id'] : 0;
    return Employee(
        id: employeeId,
        name: json['employee'] != null ? json['employee']['name'] : '',
        image: json['image'] != null ? json['image'] : '',
        timeSeries: json['timetables'] != null
            ? _mapTimeSeries(employeeId, json['timetables'])
            : []);
  }

  static _mapTimeSeries(int employeeId, List<dynamic> response) {
    List<EmployeeTimeSerie> timeSeries = [];
    response.forEach((item) {
      String date = item['localDate'];

      if (item['timeSeries'] != null) {
        List<dynamic> timeSeriesObjects = item['timeSeries'];

        timeSeriesObjects.forEach((object) {
          timeSeries.add(EmployeeTimeSerie.fromJson(employeeId, date, object));
        });
      }

    });
    return timeSeries;
  }
}
