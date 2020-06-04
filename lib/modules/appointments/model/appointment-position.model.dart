import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppointmentPosition {
  LatLng latLng;
  String address = '';

  isValid() {
    return latLng != null && address != null && address.isNotEmpty;
  }

  Map<String, dynamic> toJson() =>
      {'lat': latLng.latitude, 'long': latLng.longitude, 'value': address};
}
