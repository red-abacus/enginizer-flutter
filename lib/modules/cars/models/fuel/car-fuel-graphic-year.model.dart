import 'car-fuel-graphic-month.model.dart';

class CarFuelGraphicYear {
  List<CarFuelGraphicMonth> months;
  String year;

  CarFuelGraphicYear({this.year, this.months});

  factory CarFuelGraphicYear.fromJson(String year, Map<String, dynamic> json) {
    return CarFuelGraphicYear(year: year, months: _mapMonths(json));
  }

  static _mapMonths(Map<String, dynamic> json) {
    List<CarFuelGraphicMonth> months = [];

    for(String key in json.keys) {
      months.add(CarFuelGraphicMonth.fromJson(key, json[key]));
    }

    return months;
   }
}