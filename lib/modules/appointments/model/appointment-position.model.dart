import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppointmentPosition {
  LatLng latLng;
  String address = '';

  AppointmentPosition({this.latLng, this.address});

  factory AppointmentPosition.fromJson(dynamic json) {
    double latitude = json['lat'] != null ? json['lat'] : 0.0;
    double longitude = json['long'] != null ? json['long'] : 0.0;

    return AppointmentPosition(
        latLng: LatLng(latitude, longitude),
        address: json['value'] != null ? json['value'] : '');
  }

  isValid() {
    return latLng != null && address != null && address.isNotEmpty;
  }

  Map<String, dynamic> toJson() =>
      {'lat': latLng.latitude, 'long': latLng.longitude, 'value': address};
}
