import 'package:app/modules/appointments/providers/appointment.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AppointmentMapWidget extends StatefulWidget {
  @override
  _AppointmentMapWidgetState createState() {
    return _AppointmentMapWidgetState();
  }
}

class _AppointmentMapWidgetState
    extends State<AppointmentMapWidget> {
  AppointmentProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<AppointmentProvider>(context);

    return new Container(
      child: GoogleMap(
        mapType: MapType.normal,
        markers: _provider.auctionMapDirections.markers,
        polylines: _provider.auctionMapDirections.polylines,
        initialCameraPosition: CameraPosition(
          target: LatLng(
              _provider.auctionMapDirections.destinationPoints[0].location.latitude,
              _provider.auctionMapDirections.destinationPoints[0].location.longitude),
          zoom: 14.0,
        ),
        onMapCreated: (GoogleMapController controller) {},
      ),
    );
  }
}
