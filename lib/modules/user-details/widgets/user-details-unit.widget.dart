import 'dart:async';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/authentication/providers/user.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/locale.manager.dart';
import 'package:app/utils/string.utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'package:google_maps_webservice/places.dart';

class UserDetailsUnitWidget extends StatefulWidget {
  final Function getUnitProfileImage;
  final Function saveUnitDetails;

  UserDetailsUnitWidget({this.getUnitProfileImage, this.saveUnitDetails});

  @override
  _UserDetailsUnitWidgetState createState() => _UserDetailsUnitWidgetState();
}

class _UserDetailsUnitWidgetState extends State<UserDetailsUnitWidget> {
  UserProvider _provider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  Completer<GoogleMapController> _controller = Completer();

  GoogleMapController _googleMapController;
  TextEditingController _textEditingController;
  CameraPosition _kGooglePlex;
  Set<Marker> _markers = Set();

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<UserProvider>(context);

    _textEditingController = TextEditingController(
        text: _provider.updateUnitRequest?.providerAddress?.value ?? '');

    if (_kGooglePlex == null) {
      LatLng latLng = _provider.updateUnitRequest?.providerAddress?.latLng();

      if (latLng != null) {
        if (_markers.length == 0) {
          _markers.add(Marker(
            // This marker id can be anything that uniquely identifies each marker.
            markerId: MarkerId(_provider.updateUnitRequest.name.toString()),
            position: latLng,
            infoWindow: InfoWindow(
              title: S.of(context).unit_profile_position,
            ),
            icon: BitmapDescriptor.defaultMarker,
          ));
        }

        _kGooglePlex = CameraPosition(
          target: LatLng(latLng.latitude, latLng.longitude),
          zoom: 14.0,
        );

        _googleMapController
            ?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14.0));
      } else {
        Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            .then((currentLocation) {
          setState(() {
            LatLng _center =
                LatLng(currentLocation.latitude, currentLocation.longitude);
            _kGooglePlex = CameraPosition(
              target: LatLng(_center.latitude, _center.longitude),
              zoom: 14.0,
            );
          });
        });
      }
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _avatarContainer(),
            _descriptionContainer(),
            _nameContainer(),
            _fiscalName(),
            _billingAddress(),
            _contactPerson(),
            _cuiContainer(),
            _invoiceSerie(),
            _invoiceNumber(),
            PlacesAutocompleteField(
              language: LocaleManager.language(context),
              mode: Mode.fullscreen,
              onError: (response) {
                FlushBarHelper.showFlushBar(S.of(context).general_error,
                    response.errorMessage, context);
              },
              onSelected: _onSelected,
              hint: S.of(context).appointment_address_location_hint,
              apiKey: kGoogleApiKey,
              controller: _textEditingController,
            ),
            if (_kGooglePlex != null)
              Container(
                height: 400,
                child: GoogleMap(
                  mapType: MapType.normal,
                  markers: _markers,
                  initialCameraPosition: _kGooglePlex,
                  onTap: (latLng) => _onTap(latLng),
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
              ),
            _saveButtonContainer(),
          ],
        ),
      ),
    );
  }

  _avatarContainer() {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => widget.getUnitProfileImage(),
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: Container(
                  height: 120,
                  child: FadeInImage.assetNetwork(
                    image:
                        _provider.userDetails?.userProvider?.profilePhotoUrl ??
                            '',
                    placeholder:
                        'assets/images/defaults/default_profile_icon.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _descriptionContainer() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: Text(
              '${S.of(context).unit_profile_description} : ',
              style: TextHelper.customTextStyle(color: gray2, size: 14),
            ),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 20),
            child: TextFormField(
              minLines: 2,
              maxLines: 4,
              initialValue: _provider.updateUnitRequest?.description ?? '',
              style: TextHelper.customTextStyle(
                  color: black_text, weight: FontWeight.bold, size: 16),
              onChanged: (val) {
                _provider.updateUnitRequest?.description = val;
              },
            ),
          ))
        ],
      ),
    );
  }

  _nameContainer() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: Text(
              '${S.of(context).unit_profile_name} : ',
              style: TextHelper.customTextStyle(color: gray2, size: 14),
            ),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 20),
            child: TextFormField(
              autovalidate: true,
              initialValue: _provider.updateUnitRequest?.name ?? '',
              style: TextHelper.customTextStyle(
                  color: black_text, weight: FontWeight.bold, size: 16),
              onChanged: (val) {
                _provider.updateUnitRequest?.name = val;
              },
            ),
          ))
        ],
      ),
    );
  }

  _fiscalName() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: Text(
              '${S.of(context).unit_profile_fiscal_name} : ',
              style: TextHelper.customTextStyle(color: gray2, size: 14),
            ),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 20),
            child: TextFormField(
              autovalidate: true,
              initialValue: _provider.updateUnitRequest?.fiscalName ?? '',
              style: TextHelper.customTextStyle(
                  color: black_text, weight: FontWeight.bold, size: 16),
              onChanged: (val) {
                _provider.updateUnitRequest?.fiscalName = val;
              },
            ),
          ))
        ],
      ),
    );
  }

  _billingAddress() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: Text(
              '${S.of(context).unit_profile_billing_address} : ',
              style: TextHelper.customTextStyle(color: gray2, size: 14),
            ),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 20),
            child: TextFormField(
              autovalidate: true,
              initialValue: _provider.updateUnitRequest?.billingAddress ?? '',
              style: TextHelper.customTextStyle(
                  color: black_text, weight: FontWeight.bold, size: 16),
              onChanged: (val) {
                _provider.updateUnitRequest?.billingAddress = val;
              },
            ),
          ))
        ],
      ),
    );
  }

  _contactPerson() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: Text(
              '${S.of(context).unit_profile_contact_person} : ',
              style: TextHelper.customTextStyle(color: gray2, size: 14),
            ),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 20),
            child: TextFormField(
              autovalidate: true,
              initialValue: _provider.updateUnitRequest?.contactPerson ?? '',
              style: TextHelper.customTextStyle(
                  color: black_text, weight: FontWeight.bold, size: 16),
              onChanged: (val) {
                _provider.updateUnitRequest?.contactPerson = val;
              },
            ),
          ))
        ],
      ),
    );
  }

  _cuiContainer() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              '${S.of(context).unit_profile_registartion_number}: ',
              style: TextHelper.customTextStyle(color: gray2, size: 14),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                initialValue: _provider.updateUnitRequest?.registrationNumber,
                style: TextHelper.customTextStyle(
                    color: black_text, weight: FontWeight.bold, size: 16),
                validator: (value) {
                  if (!StringUtils.registrationNumberMatches(value)) {
                    return S.of(context).user_profile_registration_format_error;
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  setState(() {
                    _provider.updateUnitRequest?.registrationNumber = val;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  _invoiceSerie() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              '${S.of(context).unit_profile_invoice_serie}: ',
              style: TextHelper.customTextStyle(color: gray2, size: 14),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                initialValue: _provider.updateUnitRequest?.invoiceSerie,
                style: TextHelper.customTextStyle(
                    color: black_text, weight: FontWeight.bold, size: 16),
                onChanged: (val) {
                  setState(() {
                    _provider.updateUnitRequest?.invoiceSerie = val;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  _invoiceNumber() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              '${S.of(context).unit_profile_invoice_number}: ',
              style: TextHelper.customTextStyle(color: gray2, size: 14),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                keyboardType: TextInputType.number,
                initialValue:
                    _provider.updateUnitRequest?.invoiceNumber?.toString() ??
                        '',
                style: TextHelper.customTextStyle(
                    color: black_text, weight: FontWeight.bold, size: 16),
                onChanged: (val) {
                  int value;

                  try {
                    value = int.parse(val);
                  } catch (error) {}

                  if (value != null) {
                    setState(() {
                      _provider.updateUnitRequest?.invoiceNumber = value;
                    });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  _saveButtonContainer() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(right: 20, top: 20),
        child: FlatButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              if (widget.saveUnitDetails != null) {
                widget.saveUnitDetails();
              }
            }
          },
          color: red,
          textColor: Colors.white,
          child: Text(S.of(context).general_save_changes),
        ),
      ),
    );
  }

  _onSelected(Prediction prediction) async {
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(prediction.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;

    _provider.updateUnitRequest.providerAddress.value = detail.result.name;

    setState(() {
      _kGooglePlex = CameraPosition(
        target: LatLng(lat, lng),
        zoom: 14.0,
      );
    });

    _onTap(LatLng(lat, lng));
  }

  _onTap(LatLng latLng) {
    _markers.clear();

    setState(() {
      _provider.updateUnitRequest?.providerAddress?.lat = latLng.latitude;
      _provider.updateUnitRequest?.providerAddress?.long = latLng.longitude;

      _markers.add(Marker(
        markerId: MarkerId(latLng.toString()),
        position: latLng,
        infoWindow: InfoWindow(
          title: S.of(context).unit_profile_position,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });

    _geocodeLatLng(latLng);
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
      _provider.updateUnitRequest?.providerAddress?.value = address;
    });
  }
}
