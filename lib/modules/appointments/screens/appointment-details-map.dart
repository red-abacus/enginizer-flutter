import 'dart:async';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/providers/appointment.provider.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/widgets/map/appointment-map-details.widget.dart';
import 'package:app/modules/appointments/widgets/map/appointment-map.widget.dart';
import 'package:app/modules/appointments/widgets/map/car-reception-form/car-reception-form.modal.dart';
import 'package:app/modules/appointments/widgets/service-details-modal.widget.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/auctions/screens/auctions.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/notifications/screens/notifications.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/screens/work-estimate-form.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/firebase/firestore_manager.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class AppointmentDetailsMap extends StatefulWidget {
  static const String route = '${Auctions.route}/appointment-details-map';
  static const String notificationsRoute =
      '${Notifications.route}/appointment-details-map';

  @override
  State<StatefulWidget> createState() {
    return AppointmentDetailsMapState(route: route);
  }
}

class AppointmentDetailsMapState extends State<AppointmentDetailsMap>
    with SingleTickerProviderStateMixin {
  String route;

  var _initDone = false;
  var _isLoading = false;

  AppointmentDetailsMapState({this.route});

  AppointmentProvider _provider;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2, initialIndex: 0);
    _tabController.addListener(_setActiveTabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentProvider>(
        builder: (context, appointmentsProvider, _) => Scaffold(
            appBar: AppBar(
              title: _titleText(),
              iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
              bottom: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: S.of(context).general_details),
                  Tab(text: S.of(context).auction_route_title),
                ],
              ),
            ),
            floatingActionButton: _floatActionButtonContainer(),
            body: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _contentWidget()));
  }

  @override
  Future<void> didChangeDependencies() async {
    _provider = Provider.of<AppointmentProvider>(context);
    _initDone = _initDone == false ? false : _provider.initDone;

    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _provider
            .getAppointmentDetails(_provider.selectedAppointment)
            .then((_) async {
          await _provider.loadMapData(context);

          setState(() {
            _isLoading = false;
          });
        });
      } catch (error) {
        if (error
            .toString()
            .contains(AppointmentsService.GET_APPOINTMENT_DETAILS_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_get_appointment_details, context);
        } else if (error
            .toString()
            .contains(AuctionsService.GET_POINTS_DISTANCE_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_get_points_distance, context);
        }

        setState(() {
          _isLoading = false;
        });
      }

      _initDone = true;
      _provider.initDone = true;
    } else {
      _initialiseLocator();
    }

    super.didChangeDependencies();
  }

  _setActiveTabIndex() {
    setState(() {});
  }

  _floatActionButtonContainer() {
    if (_tabController.index == 0) {
      switch (_provider.selectedAppointmentDetail?.status?.getState()) {
        case AppointmentStatusState.SUBMITTED:
          return FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
              _createEstimate();
            },
            label: Text(
              S.of(context).auction_create_estimate.toUpperCase(),
              style: TextHelper.customTextStyle(null, red, FontWeight.bold, 16),
            ),
            backgroundColor: Colors.white,
          );
          break;
        default:
          break;
      }
    }

    return Container();
    return _tabController.index == 0 &&
            !_provider.selectedAppointmentDetail.canShareLocation()
        ? Container(
            child: FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                _createVehicleReception();
              },
              label: Text(
                S.of(context).auction_vehicle_reception.toUpperCase(),
                style:
                    TextHelper.customTextStyle(null, red, FontWeight.bold, 16),
              ),
              backgroundColor: Colors.white,
            ),
          )
        : Container();
  }

  _titleText() {
    return Text(
      _provider.selectedAppointmentDetail?.name ?? 'N/A',
      style:
          TextHelper.customTextStyle(null, Colors.white, FontWeight.bold, 20),
    );
  }

  _contentWidget() {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: [
        AppointmentMapDetailsWidget(showProviderDetails: _showProviderDetails),
        AppointmentMapWidget()
      ],
    );
  }

  _showProviderDetails() {
    Provider.of<ServiceProviderDetailsProvider>(context).serviceProviderId = 7;

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return ServiceDetailsModal();
          });
        });
  }

  _createVehicleReception() {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return CarReceptionFormModal(
                appointmentDetail: _provider.selectedAppointmentDetail);
          });
        });
  }

  _initialiseLocator() async {
    if (_provider.selectedAppointmentDetail.canShareLocation()) {
      var locationOptions =
          LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);
      Geolocator()
          .getPositionStream(locationOptions)
          .listen((Position position) {
        if (position != null) {
          Map<String, dynamic> map = {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'provider_id': '6'
          };
          FirestoreManager.getInstance().writeLocation(map);
        }
      });
    }
  }

  _createEstimate() {
    Provider.of<WorkEstimateProvider>(context)
        .refreshValues(EstimatorMode.CreatePr);
    Provider.of<WorkEstimateProvider>(context)
        .setIssues(context, [Issue.defaultIssue(context)]);
    Provider.of<WorkEstimateProvider>(context).serviceProviderId =
        Provider.of<Auth>(context).authUserDetails.userProvider.id;
    Provider.of<WorkEstimateProvider>(context).selectedAppointmentDetail =
        _provider.selectedAppointmentDetail;
    Provider.of<WorkEstimateProvider>(context).defaultQuantity =
    (_provider.auctionMapDirections.totalDistance / 1000).round();

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WorkEstimateForm(mode: EstimatorMode.CreatePr)),
    );
  }
}
