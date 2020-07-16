import 'dart:async';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/enum/car-receive-form-state.enum.dart';
import 'package:app/modules/appointments/enum/pick-up-form-state.enum.dart';
import 'package:app/modules/appointments/providers/appointment.provider.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/widgets/appointment-car-receive-form.widget.dart';
import 'package:app/modules/appointments/widgets/map/appointment-map-details.widget.dart';
import 'package:app/modules/appointments/widgets/map/appointment-map.widget.dart';
import 'package:app/modules/appointments/widgets/service-details-modal.widget.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/auctions/screens/auctions.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/modules/auctions/widgets/details-map/auction-map-decline.widget.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/notifications/screens/notifications.dart';
import 'package:app/modules/shared/managers/permissions/permissions-appointment.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/modules/shared/widgets/locator/locator.manager.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/screens/work-estimate-form.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    with TickerProviderStateMixin {
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
      _initDone = true;
      _provider.initDone = true;

      setState(() {
        _isLoading = true;
      });

      _loadData();

      _initDone = true;
      _provider.initDone = true;
    }

    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _provider
          .getAppointmentDetails(_provider.selectedAppointment.id)
          .then((value) async {
        _provider.selectedAppointmentDetail = value;
        await _provider.selectedAppointmentDetail
            .loadMapData(context)
            .then((value) {
          setState(() {
            _isLoading = false;
          });
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
  }

  _setActiveTabIndex() {
    setState(() {});
  }

  _floatActionButtonContainer() {
    if (_tabController.index == 0) {
      switch (_provider.selectedAppointmentDetail?.status?.getState()) {
        case AppointmentStatusState.SUBMITTED:
          return Container(
            margin: EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
                    _declineAppointment();
                  },
                  label: Text(
                    S.of(context).general_decline.toUpperCase(),
                    style: TextHelper.customTextStyle(
                        color: red, weight: FontWeight.bold, size: 16),
                  ),
                  backgroundColor: Colors.white,
                ),
                if (PermissionsManager.getInstance().hasAccess(
                    MainPermissions.Appointments,
                    PermissionsAppointment.MANAGE_WORK_ESTIMATES))
                  FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: () {
                      _createEstimate();
                    },
                    label: Text(
                      S.of(context).auction_create_estimate.toUpperCase(),
                      style: TextHelper.customTextStyle(
                          color: red, weight: FontWeight.bold, size: 16),
                    ),
                    backgroundColor: Colors.white,
                  )
              ],
            ),
          );
          break;
        case AppointmentStatusState.IN_TRANSPORT:
          if (PermissionsManager.getInstance().hasAccess(
              MainPermissions.Appointments,
              PermissionsAppointment.EXECUTE_RETURN_CAR_PROCEDURE))
            return Container(
              child: FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  _createPickUpCarForm(PickupFormState.Return);
                },
                label: Text(
                  S.of(context).appointment_hand_over_car.toUpperCase(),
                  style: TextHelper.customTextStyle(
                      color: red, weight: FontWeight.bold, size: 16),
                ),
                backgroundColor: Colors.white,
              ),
            );
          break;
        default:
          break;
      }
    }
  }

  _titleText() {
    return Text(
      _provider.selectedAppointmentDetail?.name ?? 'N/A',
      style: TextHelper.customTextStyle(
          color: Colors.white, weight: FontWeight.bold, size: 20),
    );
  }

  _contentWidget() {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: [
        AppointmentMapDetailsWidget(
            showProviderDetails: _showProviderDetails,
            createPickUpCarForm: _createPickUpCarForm),
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

  _declineAppointment() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AuctionMapDeclineWidget();
      },
    );
  }

  _createEstimate() {
    Provider.of<WorkEstimateProvider>(context)
        .refreshValues(EstimatorMode.CreatePr);
    Provider.of<WorkEstimateProvider>(context)
        .setIssues(context, _provider.selectedAppointmentDetail.issues);
    Provider.of<WorkEstimateProvider>(context).serviceProviderId =
        Provider.of<Auth>(context).authUserDetails.userProvider.id;
    Provider.of<WorkEstimateProvider>(context).selectedAppointmentDetail =
        _provider.selectedAppointmentDetail;

    Provider.of<WorkEstimateProvider>(context).defaultQuantity =
        _provider.selectedAppointmentDetail.auctionMapDirections.totalDistance /
            1000.roundToDouble();
    Provider.of<WorkEstimateProvider>(context).maxDate = _provider
        .selectedAppointmentDetail
        .auctionMapDirections
        .destinationPoints[0]
        .dateTime;

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WorkEstimateForm(mode: EstimatorMode.CreatePr)),
    );
  }

  _createPickUpCarForm(PickupFormState formState) {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AppointmentCarReceiveFormModal(
                carReceiveFormState: CarReceiveFormState.Pr,
                appointmentDetail: _provider.selectedAppointmentDetail,
                refreshState: _refreshState,
                pickupFormState: formState);
          });
        });
  }

  _refreshState() {
    LocatorManager.getInstance().removeActiveAppointment();
    LocatorManager.getInstance().getActiveAppointment(context);

    Provider.of<AppointmentsProvider>(context).initDone = false;

    setState(() {
      _isLoading = true;
    });

    _loadData();
  }
}
