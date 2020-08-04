import 'package:app/modules/appointments/model/handover/procedure-info-provider.model.dart';
import 'package:app/modules/cars/models/car.model.dart';

class ProcedureInfo {
  Car car;
  ProcedureInfoProvider handoverBy;
  ProcedureInfoProvider receivedBy;
  String image;

  ProcedureInfo({this.car, this.handoverBy, this.receivedBy});

  factory ProcedureInfo.fromJson(Map<String, dynamic> json) {
    return ProcedureInfo(
        car: json['car'] != null ? Car.fromJson(json['car']) : null,
        handoverBy: json['handoverBy'] != null ? ProcedureInfoProvider.fromJson(json['handoverBy']) : null,
        receivedBy: json['receivedBy'] != null ? ProcedureInfoProvider.fromJson(json['receivedBy']) : null);
  }
}
