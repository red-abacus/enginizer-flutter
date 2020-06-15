
import 'package:app/modules/appointments/providers/appointment.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AppointmentMapWidget extends StatefulWidget {
  @override
  _AppointmentMapWidgetState createState() {
    return _AppointmentMapWidgetState();
  }
}

class _AppointmentMapWidgetState extends State<AppointmentMapWidget> {
  AppointmentProvider _provider;

  CameraPosition _kGooglePlex;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<AppointmentProvider>(context);

    if (_provider.selectedAppointmentDetail.canShareLocation()) {
      getUserLocation();
    } else {
      _kGooglePlex = CameraPosition(
        target: LatLng(
            _provider.selectedAppointmentDetail
                .auctionMapDirections.destinationPoints[0].location.latitude,
            _provider.selectedAppointmentDetail
                .auctionMapDirections.destinationPoints[0].location.longitude),
        zoom: 14.0,
      );
    }

    return _kGooglePlex == null
        ? Container()
        : Container(
            child: GoogleMap(
              myLocationEnabled: _provider.selectedAppointmentDetail.canShareLocation(),
              mapType: MapType.normal,
              markers: _provider.selectedAppointmentDetail.auctionMapDirections.markers,
              polylines: _provider.selectedAppointmentDetail.auctionMapDirections.polylines,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {},
            ),
          );
  }

  getUserLocation() async {
    Position currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      LatLng _center =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      _kGooglePlex = CameraPosition(
        target: LatLng(_center.latitude, _center.longitude),
        zoom: 14.0,
      );
    });
  }
}
