import 'dart:ui';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/utils/firebase/firestore_manager.dart';
import 'package:app/utils/firebase/models/firestore-location.model.dart';
import 'package:app/utils/svg.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientMapDirectionsModal extends StatefulWidget {
  final AppointmentDetail appointmentDetail;

  ClientMapDirectionsModal({this.appointmentDetail});

  @override
  _ClientMapDirectionsModalState createState() =>
      _ClientMapDirectionsModalState();
}

class _ClientMapDirectionsModalState extends State<ClientMapDirectionsModal> {
  Set<Marker> _markers = Set();
  Marker _providerMarker;
  GoogleMapController _mapController;

  @override
  void initState() {
    _markers = widget.appointmentDetail.auctionMapDirections.markers;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 20),
        child: FractionallySizedBox(
            heightFactor: .8,
            child: Container(
                child: ClipRRect(
              borderRadius: new BorderRadius.circular(5.0),
              child: Container(
                decoration: new BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0))),
                child: Theme(
                  data: ThemeData(
                      accentColor: Theme.of(context).primaryColor,
                      primaryColor: Theme.of(context).primaryColor),
                  child: _contentWidget(),
                ),
              ),
            ))));
  }

  _contentWidget() {
    return widget.appointmentDetail.auctionMapDirections.destinationPoints
                .length >
            0
        ? GoogleMap(
            mapType: MapType.normal,
            markers: _markers,
            polylines: widget.appointmentDetail.auctionMapDirections.polylines,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  widget.appointmentDetail.auctionMapDirections
                      .destinationPoints[0].location.latitude,
                  widget.appointmentDetail.auctionMapDirections
                      .destinationPoints[0].location.longitude),
              zoom: 14.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;

              if (widget.appointmentDetail.canShareLocation()) {
                FirestoreManager.getInstance().getLocation(
                    widget.appointmentDetail.id,
                    widget.appointmentDetail.serviceProvider.id,
                    _providerChangedLocation);
              }
            },
          )
        : Center(
            child: Text(S.of(context).appointment_no_map_data),
          );
  }

  _providerChangedLocation(FirestoreLocation location) async {
    BitmapDescriptor markerIcon = await SvgHelper.bitmapDescriptorFromSvgAsset(
        context, 'assets/images/icons/tow_car.svg');

    _markers.removeWhere((element) {
      return element.markerId == MarkerId('providerLocation');
    });

    if (_providerMarker == null) {
      _mapController?.animateCamera(
          CameraUpdate.newLatLng(LatLng(location.latitude, location.longitude)));
    }

    setState(() {
      _providerMarker = Marker(
          icon: markerIcon,
          markerId: MarkerId('providerLocation'),
          infoWindow: InfoWindow(
            title: S.of(context).general_pickup_and_return,
          ),
          position: LatLng(location.latitude, location.longitude));
      _markers.add(_providerMarker);
    });
  }
}
