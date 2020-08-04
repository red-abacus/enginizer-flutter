import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProviderAddress {
  String value;
  double lat;
  double long;

  ProviderAddress({this.value, this.lat, this.long});

  factory ProviderAddress.fromJson(Map<String, dynamic> json) {
    return ProviderAddress(
        value: json['value'] != null ? json['value'] : '',
        lat: json['lat'] != null ? json['lat'] : null,
        long: json['long'] != null ? json['long'] : null);
  }

  latLng() {
    if (lat != null && long != null) {
      return LatLng(this.lat, this.long);
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'value': this.value ?? '',
    };

    if (this.lat != null) {
      propMap['lat'] = this.lat;
    }

    if (this.long != null) {
      propMap['long'] = this.long;
    }

    return propMap;
  }
}
