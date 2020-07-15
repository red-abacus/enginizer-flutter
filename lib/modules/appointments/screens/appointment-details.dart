import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/model/personnel/time-entry.dart';
import 'package:app/modules/appointments/providers/appointment.provider.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/appointments/screens/appointment-camera.modal.dart';
import 'package:app/modules/appointments/screens/appointment-review.modal.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/widgets/details/appointment-details-children.widget.dart';
import 'package:app/modules/appointments/widgets/details/appointment-details.widget.dart';
import 'package:app/modules/appointments/widgets/map/client-map-directions.modal.dart';
import 'package:app/modules/appointments/widgets/service-details-modal.widget.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/cars/widgets/car-general-details.widget.dart';
import 'package:app/modules/notifications/screens/notifications.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/screens/work-estimate-form.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'appointments.dart';

class AppointmentDetails extends StatefulWidget {
  static const String route = '${Appointments.route}/appointmentDetails';
  static const String notificationsRoute =
      '${Notifications.route}/appointmentDetails';

  @override
  State<StatefulWidget> createState() {
    return AppointmentDetailsState(route: route);
  }
}

class AppointmentDetailsState extends State<AppointmentDetails>
    with TickerProviderStateMixin {
  String route;

  var _initDone = false;
  var _isLoading = false;

  AppointmentDetailsState({this.route});

  AppointmentProvider _provider;

  TabController _tabController;
  TabBar _tabBar;
  int _tabBarCount = 0;

  @override
  Widget build(BuildContext context) {
    if (_provider != null && _provider.selectedAppointment == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
      return Container();
    }

    if (_tabController == null && _provider.selectedAppointmentDetail != null) {
      _tabBarCount = 2;

      List<Tab> tabs = [
        Tab(text: S.of(context).general_details),
        Tab(text: S.of(context).appointment_details_car_details),
      ];

      if (_provider.selectedAppointmentDetail.children.length == 1) {
        _tabBarCount += 1;
        tabs.add(Tab(text: S.of(context).general_pickup_and_return));
      }

      _tabController =
          new TabController(vsync: this, length: _tabBarCount, initialIndex: 0);
      _tabController.addListener(_setActiveTabIndex);

      _tabBar = TabBar(
        controller: _tabController,
        tabs: tabs,
      );
    }

    return Consumer<AppointmentProvider>(
      builder: (context, appointmentProvider, _) => Scaffold(
        appBar: AppBar(
          title: Text(
            _provider.selectedAppointment.name,
            style: TextHelper.customTextStyle(
                color: Colors.white, weight: FontWeight.bold, size: 20),
          ),
          bottom: _isLoading ? null : _tabBar,
          iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _contentWidget(),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    _initDone = _initDone == false ? false : _provider.initDone;

    if (!_initDone) {
      _tabController = null;
      _tabBar = null;
      _provider = Provider.of<AppointmentProvider>(context);

      if (_provider.selectedAppointment != null) {
        setState(() {
          _isLoading = true;
        });

        _loadData();
      }
    }

    _initDone = true;
    _provider.initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _provider
          .getAppointmentDetails(_provider.selectedAppointment.id)
          .then((value) async {
        _provider.selectedAppointmentDetail = value;
        if (_provider.selectedAppointmentDetail.children.length > 0) {
          await _provider
              .getAppointmentDetails(
                  _provider.selectedAppointmentDetail.children[0].id)
              .then((value) async {
            _provider.children = [value];
            await _provider.children[0].loadMapData(context).then((value) {
              setState(() {
                _isLoading = false;
              });
            });
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.GET_APPOINTMENT_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_appointment_details, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _contentWidget() {
    var widgets = [
      AppointmentDetailsWidget(
          appointmentDetail: _provider.selectedAppointmentDetail,
          viewEstimate: _seeEstimate,
          cancelAppointment: _cancelAppointment,
          seeCamera: _seeCamera,
      writeReview: _writeReview,),
      CarGeneralDetailsWidget(car: _provider.selectedAppointmentDetail.car)
    ];

    if (_tabBarCount == 3) {
      widgets.add(AppointmentDetailsChildrenWidget(
        appointmentDetail: _provider.children[0],
        showProviderDetails: _showProviderDetails,
        showMap: _showMapDirections,
        seeEstimate: _seeEstimate,
      ));
    }

    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: widgets,
    );
  }

  _cancelAppointment(Appointment appointment) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider.cancelAppointment(appointment).then((appointment) {
        setState(() {
          Provider.of<AppointmentsProvider>(context)
              .refreshAppointment(appointment);
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.CANCEL_APPOINTMENT_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_cancel_appointment, context);
      }
    }
  }

  _seeEstimate(AppointmentDetail appointmentDetail) {
    int workEstimateId = appointmentDetail.lastWorkEstimate();

    if (workEstimateId != 0) {
      EstimatorMode mode =
          appointmentDetail.status.getState() == AppointmentStatusState.PENDING
              ? EstimatorMode.ClientAccept
              : EstimatorMode.Client;

      Provider.of<WorkEstimateProvider>(context).refreshValues(mode);
      Provider.of<WorkEstimateProvider>(context).workEstimateId =
          workEstimateId;
      Provider.of<WorkEstimateProvider>(context).selectedAppointmentDetail =
          appointmentDetail;
      Provider.of<WorkEstimateProvider>(context).serviceProviderId =
          appointmentDetail.serviceProvider.id;
      Provider.of<WorkEstimateProvider>(context).shouldAskForPr =
          _provider.selectedAppointmentDetail.id == appointmentDetail.id;

      DateEntry dateEntry = appointmentDetail.getWorkEstimateDateEntry();

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WorkEstimateForm(mode: mode, dateEntry: dateEntry)),
      );
    }
  }

  _seeCamera() {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AppointmentCameraModal();
          });
        });
  }

  _setActiveTabIndex() {
    setState(() {});
  }

  _showProviderDetails(int providerId) {
    Provider.of<ServiceProviderDetailsProvider>(context).serviceProviderId =
        providerId;

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

  _showMapDirections(AppointmentDetail appointmentDetail) {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return ClientMapDirectionsModal(
              appointmentDetail: appointmentDetail,
            );
          });
        });
  }

  _writeReview(AppointmentDetail appointmentDetail) {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
                return AppointmentReviewModal(
                  appointmentDetail: appointmentDetail,
                );
              });
        });
  }
}
