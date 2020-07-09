import 'dart:async';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/request/appointments-request.model.dart';
import 'package:app/modules/appointments/providers/appointment.provider.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/screens/appointment-details-map.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/shared/managers/permissions/permissions-appointment.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/firebase/firestore_manager.dart';
import 'package:app/utils/firebase/models/firestore-location.model.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class LocatorManager {
  static final LocatorManager _singleton = LocatorManager._internal();

  factory LocatorManager() {
    return _singleton;
  }

  LocatorManager._internal();

  static getInstance() {
    return _singleton;
  }

  bool _shouldDownload = true;
  Appointment _appointment;
  AppointmentDetail _appointmentDetail;
  StreamSubscription _getPositionSubscription;
  OverlaySupportEntry _entry;

  void refresh() {
    _shouldDownload = true;
  }

  void getActiveAppointment(BuildContext context) {
    if (PermissionsManager.getInstance().hasAccess(MainPermissions.Appointments,
        PermissionsAppointment.SHARE_APPOINTMENT_LOCATION)) {
      if (_shouldDownload) {
        _shouldDownload = false;

        AppointmentsRequest request = new AppointmentsRequest();
        request.state = AppointmentStatusState.IN_TRANSPORT;
        request.pageSize = 1;
        Provider.of<AppointmentsProvider>(context)
            .getActiveAppointments(request)
            .then((value) {
          _shouldDownload = false;
          if (value.length > 0) {
            Provider.of<AppointmentsProvider>(context)
                .getAppointmentDetails(value.first.id)
                .then((appointmentDetail) {
              if (_appointmentDetail != null &&
                  appointmentDetail.id == _appointmentDetail.id) {
              } else {
                _dismissGeolocator();
                _appointment = value[0];
                _appointmentDetail = appointmentDetail;
                _initialiseLocator(context);
              }
            });
          } else {
            _dismissGeolocator();
            _appointment = null;
            _appointmentDetail = null;
          }
        });
      }
    }
  }

  void removeActiveAppointment() {
    _shouldDownload = true;
    _appointment = null;
    _appointmentDetail = null;
    _dismissGeolocator();
  }

  void logout() {
    _shouldDownload = false;
    _appointment = null;
    _appointmentDetail = null;
    _dismissGeolocator();
  }

  _dismissGeolocator() {
    if (_getPositionSubscription != null) {
      _getPositionSubscription.cancel();
      _getPositionSubscription = null;
    }

    if (_entry != null) {
      _entry.dismiss(animate: true);
      _entry = null;
    }
  }

  _initialiseLocator(BuildContext context) async {
    if (_appointmentDetail != null) {
      showLocatorBanner(context);

      var locationOptions =
          LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);

      _getPositionSubscription = Geolocator()
          .getPositionStream(locationOptions)
          .listen((Position position) {
        if (position != null) {
          FirestoreLocation location = FirestoreLocation();
          location.latitude = position.latitude;
          location.longitude = position.longitude;
          location.providerId = Provider.of<Auth>(context).authUser.providerId;
          location.appointmentId = _appointmentDetail.id;

          FirestoreManager.getInstance().writeLocation(location.toJson());
        }
      });
    }
  }

  showLocatorBanner(BuildContext context) {
    if (_entry != null) {
      _entry.dismiss(animate: false);
      _entry = null;
    }

    _entry = showSimpleNotification(
      Text(
        '${_appointmentDetail.name}\n${S.of(context).appointment_locator_title}',
        style: TextHelper.customTextStyle(color: gray, size: 16),
      ),
      leading: Container(
        width: 24,
        height: 24,
        child: Icon(
          Icons.location_on,
          color: green,
          size: 24,
        ),
      ),
      background: Colors.white,
      autoDismiss: false,
      slideDismiss: false,
      trailing: InkWell(
        onTap: () => {_showAppointmentDetails(context)},
        child: Container(
          width: 20,
          height: 20,
          child: Icon(Icons.info, color: green),
        ),
      ),
    );
  }

  _showAppointmentDetails(BuildContext context) {
    if (_appointmentDetail.serviceItems.length > 0) {
      ServiceProviderItem item = _appointmentDetail.serviceItems.first;

      if (item.isPickUpAndReturnService() || item.isTowService()) {
        Provider.of<AppointmentProvider>(context).initialise();
        Provider.of<AppointmentProvider>(context).selectedAppointment =
            _appointment;
        Navigator.of(context).pushNamed(AppointmentDetailsMap.route);
      }
    }
  }
}
