import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/utils/date_utils.dart';

class ReportsRequest {
  DateTime startDate = DateUtils.startOfMonth(DateTime.now());
  DateTime endDate = DateUtils.endOfMonth(DateTime.now());
  Car car;

  isValid() {
    return startDate != null && endDate != null && car != null;
  }

  Map<String, dynamic> toJson() => {
        'startDate': DateUtils.stringFromDate(startDate, 'dd/MM/yyyy'),
        'endDate': DateUtils.stringFromDate(endDate, 'dd/MM/yyyy'),
        'carId': car.id.toString()
      };
}
