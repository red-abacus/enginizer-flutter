import 'package:app/utils/date_utils.dart';

class CarFuelRequest {
  DateTime startDate = DateUtils.startOfMonth(DateTime.now());
  DateTime endDate = DateTime.now();
  int carId;

  CarFuelRequest({this.carId});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = new Map();

    if (startDate != null) {
      propMap['startDate'] = DateUtils.stringFromDate(startDate, 'dd/MM/yyyy');
    }

    if (endDate != null) {
      propMap['endDate'] = DateUtils.stringFromDate(endDate, 'dd/MM/yyyy');
    }

    return propMap;
  }

  isValid() {
    return startDate != null && endDate != null;
  }
}
