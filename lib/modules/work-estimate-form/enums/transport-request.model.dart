import 'package:app/modules/appointments/model/appointment-position.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';

class TransportRequest {
  AppointmentPosition appointmentPosition;
  ServiceProvider serviceProvider;

  TransportRequest({this.appointmentPosition, this.serviceProvider});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = new Map();
    map['address'] = appointmentPosition.toJson();

    if (serviceProvider != null) {
      map['providerId'] = serviceProvider.id.toString();
    }
    return map;
  }
}