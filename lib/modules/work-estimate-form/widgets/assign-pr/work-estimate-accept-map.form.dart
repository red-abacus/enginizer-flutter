import 'dart:async';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate-accept.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/locale.manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:geocoder/geocoder.dart';

class WorkEstimateAcceptMapForm extends StatefulWidget {
  final Function refreshState;

  WorkEstimateAcceptMapForm({this.refreshState});

  @override
  WorkEstimateAcceptMapFormState createState() {
    return WorkEstimateAcceptMapFormState();
  }
}

class WorkEstimateAcceptMapFormState
    extends State<WorkEstimateAcceptMapForm> {
  WorkEstimateAcceptProvider _provider;

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGoogleFlex;
  Set<Marker> _markers = Set();

  GoogleMapController _googleMapController;
  TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<WorkEstimateAcceptProvider>(context);

    if (_kGoogleFlex == null) {
      getUserLocation();
    } else {
      if (_provider.appointmentPosition.latLng != null) {
        _googleMapController?.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(_provider.appointmentPosition.latLng.latitude,
                _provider.appointmentPosition.latLng.longitude),
            14.0));
      }
    }

    _textEditingController = TextEditingController(
        text: _provider.appointmentPosition.address != null
            ? _provider.appointmentPosition.address
            : '');

    return Container(
      child: Column(
        children: [
          PlacesAutocompleteField(
            language: LocaleManager.language(context),
            mode: Mode.fullscreen,
            onError: _onError,
            onSelected: _onSelected,
            hint: S.of(context).appointment_address_location_hint,
            apiKey: kGoogleApiKey,
            controller: _textEditingController,
          ),
          if (_kGoogleFlex != null)
          // TODO - map should not have fixed height
            Container(
              height: 360,
              child: GoogleMap(
                mapType: MapType.normal,
                markers: _markers,
                myLocationEnabled: true,
                initialCameraPosition: _kGoogleFlex,
                onTap: (latLng) => _onTap(latLng, true),
                gestureRecognizers: Set()
                  ..add(Factory<PanGestureRecognizer>(
                          () => PanGestureRecognizer()))
                  ..add(Factory<VerticalDragGestureRecognizer>(
                          () => VerticalDragGestureRecognizer())),
                onMapCreated: (GoogleMapController controller) {
                  _googleMapController = controller;
                  _controller.complete(controller);
                },
              ),
            )
        ],
      ),
    );
  }

  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    Position currentLocation = await locateUser();
    setState(() {
      LatLng _center =
      LatLng(currentLocation.latitude, currentLocation.longitude);
      _kGoogleFlex = CameraPosition(
        target: LatLng(_center.latitude, _center.longitude),
        zoom: 14.0,
      );
    });
  }

  _onSelected(Prediction prediction) async {
    PlacesDetailsResponse detail =
    await _places.getDetailsByPlaceId(prediction.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;

    _provider.appointmentPosition.address = detail.result.name;

    setState(() {
      _kGoogleFlex = CameraPosition(
        target: LatLng(lat, lng),
        zoom: 14.0,
      );
    });

    _onTap(LatLng(lat, lng), false);
  }

  _onError(PlacesAutocompleteResponse response) {
    FlushBarHelper.showFlushBar(
        S.of(context).general_error, response.errorMessage, context);
  }

  _onTap(LatLng latLng, bool reverseAddress) {
    _markers.clear();

    setState(() {
      _provider.appointmentPosition.latLng =
          LatLng(latLng.latitude, latLng.longitude);
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(latLng.toString()),
        position: latLng,
        infoWindow: InfoWindow(
          title: S.of(context).appointment_your_car,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });

    if (reverseAddress) {
      _geocodeLatLng(latLng);
    }
  }

  _geocodeLatLng(LatLng latLng) async {
    final coordinates = new Coordinates(latLng.latitude, latLng.longitude);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    var address = first.locality != null ? first.locality : '';
    address = first.adminArea != null ? '$address ${first.adminArea}' : address;
    address =
    first.subLocality != null ? '$address ${first.subLocality}' : address;
    address =
    first.subAdminArea != null ? '$address ${first.subAdminArea}' : address;
    address =
    first.addressLine != null ? '$address ${first.addressLine}' : address;
    address =
    first.featureName != null ? '$address ${first.featureName}' : address;
    address =
    first.thoroughfare != null ? '$address ${first.thoroughfare}' : address;
    address = first.subThoroughfare != null
        ? '$address ${first.subThoroughfare}'
        : address;

    setState(() {
      _provider.appointmentPosition.address = address;
    });
  }
}
