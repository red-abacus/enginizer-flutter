import 'package:app/modules/appointments/model/provider/service-provider-schedule.model.dart';

class ServiceProviderSchedule {
  String localDate;
  List<ServiceProviderTimeSerie> timeSeries;

  ServiceProviderSchedule({this.localDate, this.timeSeries});

  factory ServiceProviderSchedule.fromJson(Map<String, dynamic> json) {
    return ServiceProviderSchedule(
        localDate: json['localDate'],
        timeSeries: _mapTimeSeries(json['timeSeries']));
  }

  static _mapTimeSeries(List response) {
    List<ServiceProviderTimeSerie> list = [];

    for (Map<String, dynamic> item in response) {
      list.add(ServiceProviderTimeSerie.fromJson(item));
    }

    return list;
  }
}
