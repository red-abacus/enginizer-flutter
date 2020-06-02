import 'package:app/generated/l10n.dart';
import 'package:app/modules/auctions/models/google-distance.response.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/svg.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AuctionMapDirections {
  PolylinePoints polylinePoints = PolylinePoints();

  List<AuctionMapLocation> destinationPoints = [AuctionMapLocation(location: LatLng(46.777019, 23.615115)),
    AuctionMapLocation(location: LatLng(46.781949, 23.613342)),
    AuctionMapLocation(location: LatLng(46.786477, 23.605170)),
    AuctionMapLocation(location: LatLng(46.784087, 23.587493)),
    AuctionMapLocation(location: LatLng(46.765421, 23.587589)),
    AuctionMapLocation(location: LatLng(46.772055, 23.601009))];

  Set<Marker> markers = Set();
  Set<Polyline> polylines = Set();
  List<LatLng> polylineCoordinates = [];

  DateTime appointmentDate;
  int totalKm = 0;

  int get totalDistance {
    int total = 0;

    if (destinationPoints.length > 0) {
      destinationPoints.forEach((point) {
        total += point.distance;
      });
    }
    return total;
  }

  setPolyLines(BuildContext context) async {
    BitmapDescriptor icon = await SvgHelper.bitmapDescriptorFromSvgAsset(
        context, 'assets/images/icons/marker_gray.svg');
    BitmapDescriptor redIcon = await SvgHelper.bitmapDescriptorFromSvgAsset(
        context, 'assets/images/icons/marker_red.svg');

    for (int i = 0; i < destinationPoints.length - 1; i++) {
      Marker marker = Marker(
          icon: i == 0 ? icon : redIcon,
          markerId: MarkerId(''),
          position: destinationPoints[i].location,
          infoWindow: InfoWindow(
            title: i == 0
                ? S.of(context).auction_route_start_point
                : destinationPoints[i].address,
          ));

      markers.add(marker);

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          kGoogleApiKey,
          PointLatLng(destinationPoints[i].location.latitude,
              destinationPoints[i].location.longitude),
          PointLatLng(destinationPoints[i + 1].location.latitude,
              destinationPoints[i + 1].location.longitude),
          travelMode: TravelMode.driving);

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
      _addPolyLine();
    }

    markers.add(Marker(
        icon: icon,
        markerId: MarkerId(''),
        infoWindow: InfoWindow(
          title: S.of(context).auction_route_destination,
        ),
        position: destinationPoints[destinationPoints.length - 1].location));
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline =
        Polyline(polylineId: id, color: blue, points: polylineCoordinates);
    polylines.add(polyline);
  }

  fetchDistanceAndDurations(AuctionsService auctionsService) async {
    for (int i = 1; i < destinationPoints.length; i++) {
      try {
        destinationPoints[i].distanceResponse =
            await auctionsService.getPointsDistance(
                destinationPoints[i - 1].location,
                destinationPoints[i].location,
                kGoogleApiKey);
      } catch (error) {
        throw (error);
      }
    }

    destinationPoints[destinationPoints.length - 1].dateTime = appointmentDate;

    for (int i = destinationPoints.length - 2; i >= 0; i--) {
      destinationPoints[i].dateTime = DateUtils.addSecondsToDate(
          destinationPoints[i + 1].dateTime, -destinationPoints[i + 1].seconds);
    }
  }
}

class AuctionMapLocation {
  final LatLng location;
  String address = '';
  DateTime dateTime;
  GoogleDistanceResponse distanceResponse;

  int get seconds {
    int total = 0;

    if (distanceResponse != null) {
      if (distanceResponse.rows.length > 0) {
        distanceResponse.rows.forEach((element) {
          if (element.rows.length > 0) {
            element.rows.forEach((row) {
              if (row.googleDurationElement != null) {
                total += row.googleDurationElement.duration;
              }
            });
          }
        });
      }
    }

    return total;
  }

  int get distance {
    int meters = 0;

    if (distanceResponse != null) {
      if (distanceResponse.rows.length > 0) {
        distanceResponse.rows.forEach((element) {
          if (element.rows.length > 0) {
            element.rows.forEach((row) {
              if (row.googleDistanceElement != null) {
                meters += row.googleDistanceElement.meters;
              }
            });
          }
        });
      }
    }

    return meters;
  }

  AuctionMapLocation({this.location}) {
    _loadAddress();
  }

  _loadAddress() async {
    final coordinates =
        new Coordinates(this.location.latitude, this.location.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    address =
        first.addressLine != null ? '$address ${first.addressLine}' : address;
  }
}
