import 'package:app/modules/appointments/model/appointment-position.model.dart';
import 'package:app/utils/date_utils.dart';

class UsePromotionRequest {
  int carId;
  DateTime pickupDateTime;
  DateTime returnDateTime;
  DateTime scheduleDateTime;

  AppointmentPosition pickupPosition = new AppointmentPosition();
  AppointmentPosition returnPosition = new AppointmentPosition();

  int promotionId;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = Map();

    if (carId != null) {
      propMap['carId'] = carId;
    }

    if (pickupDateTime != null) {
      propMap['pickupDateTime'] = DateUtils.stringFromDate(pickupDateTime, 'dd/MM/yyyy HH:mm');
    }

    if (returnDateTime != null) {
      propMap['returnDateTime'] = DateUtils.stringFromDate(returnDateTime, 'dd/MM/yyyy HH:mm');
    }

    if (scheduleDateTime != null) {
      propMap['scheduleDateTime'] = DateUtils.stringFromDate(scheduleDateTime, 'dd/MM/yyyy HH:mm');
    }

    if (pickupPosition != null) {
      propMap['from'] = pickupPosition.toJson();
    }

    if (returnPosition != null) {
      propMap['to'] = returnPosition.toJson();
    }

    return propMap;
  }
}
