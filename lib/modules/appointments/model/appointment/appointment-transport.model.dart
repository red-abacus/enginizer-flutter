import 'package:app/modules/appointments/model/appointment-position.model.dart';
import 'package:app/modules/auctions/models/auction-map.model.dart';

class AppointmentTransportInfo {
  AppointmentPosition from;
  AppointmentPosition to;

  AppointmentTransportInfo({this.from, this.to});

  factory AppointmentTransportInfo.fromJson(dynamic json) {
    return AppointmentTransportInfo(
        from: json['from'] != null
            ? AppointmentPosition.fromJson(json['from'])
            : null,
        to: json['to'] != null
            ? AppointmentPosition.fromJson(json['to'])
            : null);
  }

  List<AuctionMapLocation> getLocations() {
    List<AuctionMapLocation> locations = [];

    if (from != null) {
      locations.add(
          AuctionMapLocation(location: from.latLng, address: from.address));
    }

    if (to != null) {
      locations
          .add(AuctionMapLocation(location: to.latLng, address: to.address));
    }

    return locations;
  }
}
