import '../../appointments/model/appointment.model.dart';
import '../../appointments/model/appointment.model.dart';
import '../../cars/models/car.model.dart';

class Auction {
  int id;
  Appointment appointment;
  Car car;
  String createdDate;
  bool isLost;
  String status;

  Auction(
      {this.id,
      this.appointment,
      this.car,
      this.createdDate,
      this.isLost,
      this.status});

  factory Auction.fromJson(Map<String, dynamic> json) {
    return Auction(
        id: json["id"],
        appointment: json["appointment"] != null
            ? Appointment.fromJson(json["appointment"])
            : null,
        car: json["car"] != null ? Car.fromJson(json["car"]) : null,
        createdDate: json["createdDate"] != null ? json["createdDate"] : "",
        isLost: json["isLost"] != null ? json["isLost"] : true,
        status: json["status"] != null ? json["status"] : "");
  }
}
