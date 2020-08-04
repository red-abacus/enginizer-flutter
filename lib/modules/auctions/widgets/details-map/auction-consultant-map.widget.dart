import 'package:app/modules/auctions/providers/auction-consultant.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AuctionConsultantMapWidget extends StatefulWidget {
  @override
  _AuctionConsultantMapWidgetState createState() {
    return _AuctionConsultantMapWidgetState();
  }
}

class _AuctionConsultantMapWidgetState
    extends State<AuctionConsultantMapWidget> {
  AuctionConsultantProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<AuctionConsultantProvider>(context);

    return new Container(
      child: GoogleMap(
        mapType: MapType.normal,
        markers: _provider.appointmentDetails.auctionMapDirections.markers,
        polylines: _provider.appointmentDetails.auctionMapDirections.polylines,
        initialCameraPosition: CameraPosition(
          target: LatLng(
              _provider.appointmentDetails.auctionMapDirections.destinationPoints[0].location.latitude,
              _provider.appointmentDetails.auctionMapDirections.destinationPoints[0].location.longitude),
          zoom: 14.0,
        ),
        onMapCreated: (GoogleMapController controller) {},
      ),
    );
  }
}
