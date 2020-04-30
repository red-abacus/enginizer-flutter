import 'package:app/generated/l10n.dart';
import 'package:app/layout/navigation_toolbar.app.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/auctions/services/work-estimates.service.dart';
import 'package:app/modules/mechanic-appointments/providers/appointment-mechanic.provider.dart';
import 'package:app/modules/mechanic-appointments/widgets/appointment-details-mechanic-car-details.widget.dart';
import 'package:app/modules/mechanic-appointments/widgets/appointment-details-mechanic-service-history.widget.dart';
import 'package:app/modules/mechanic-appointments/widgets/appointment-details-mechanic.widget.dart';
import 'package:app/modules/mechanic-appointments/widgets/appointment-details-mechanic-tasks.widget.dart';
import 'package:app/modules/work-estimate-form/models/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/screens/work-estimate-form.dart';
import 'package:app/utils/app_config.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentDetailsMechanic extends StatefulWidget {
  static const String route =
      '/appointments-mechanic/appointment-details-mechanic';

  @override
  State<StatefulWidget> createState() {
    return AppointmentDetailsMechanicState(route: route);
  }
}

class AppointmentDetailsMechanicState extends State<AppointmentDetailsMechanic>
    with SingleTickerProviderStateMixin {
  String route;

  var _initDone = false;
  var _isLoading = false;

  TabController _tabController;

  AppointmentDetailsMechanicState({this.route});

  AppointmentMechanicProvider _appointmentMechanicProvider;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 4, initialIndex: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_appointmentMechanicProvider != null &&
        _appointmentMechanicProvider.selectedAppointment == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }

    return Consumer<AppointmentMechanicProvider>(
      builder: (context, appointmentMechanicProvider, _) => _getContent(),
    );
  }

  _getContent() {
    return _isLoading
        ? Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Theme.of(context).cardColor),
              title: _titleText(),
            ),
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Theme.of(context).cardColor),
              bottom: TabBar(
                controller: _tabController,
                tabs: _getTabs(),
              ),
              title: _titleText(),
            ),
            body: _buildContent(),
            bottomNavigationBar: _getBottomBar(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: _getBottomBarFloatingAction(),
          );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _appointmentMechanicProvider =
          Provider.of<AppointmentMechanicProvider>(context);

      if (_appointmentMechanicProvider.selectedAppointment != null) {
        _loadData();
      }
      _initDone = true;
    }
    super.didChangeDependencies();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _appointmentMechanicProvider
          .getAppointmentDetails(
              _appointmentMechanicProvider.selectedAppointment)
          .then((_) async {
        await _appointmentMechanicProvider
            .getStandardTasks(
                _appointmentMechanicProvider.selectedAppointment.id)
            .then((tasks) async {
          await _appointmentMechanicProvider
              .getClientTasks(
                  _appointmentMechanicProvider.selectedAppointment.id)
              .then((tasks) {
            setState(() {
              _isLoading = false;
            });
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
          .contains(WorkEstimatesService.GET_WORK_ESTIMATE_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_work_estimate_details, context);
      } else if (error
          .toString()
          .contains(AppointmentsService.GET_STANDARD_TASKS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_standard_tasks, context);
      } else if (error
          .toString()
          .contains(AppointmentsService.GET_CLIENT_TASKS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_client_tasks, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _getBottomBar() {
    return AppConfig.of(context).enviroment == Enviroment.Dev_Toolbar
        ? NavigationToolbarAppState.bottomBarApp
        : null;
  }

  _getBottomBarFloatingAction() {
    return AppConfig.of(context).enviroment == Enviroment.Dev_Toolbar
        ? FloatingActionButton(
            onPressed: () {},
            backgroundColor: red,
            tooltip: S.of(context).general_add,
            child: Icon(Icons.add),
            elevation: 2.0,
          )
        : Container();
  }

  _titleText() {
    return Text(
      _appointmentMechanicProvider.selectedAppointment?.name ?? 'N/A',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    );
  }

  _buildContent() {
    List<Widget> list = [
      AppointmentDetailsMechanicWidget(
          appointment: _appointmentMechanicProvider.selectedAppointment,
          appointmentDetail:
              _appointmentMechanicProvider.selectedAppointmentDetails,
          viewEstimate: _viewEstimate),
      AppointmentDetailsCarDetails(),
      AppointmentDetailsServiceHistory()
    ];

    switch (
        _appointmentMechanicProvider.selectedAppointment.status.getState()) {
      case AppointmentStatusState.IN_UNIT:
      case AppointmentStatusState.IN_WORK:
      case AppointmentStatusState.ON_HOLD:
      case AppointmentStatusState.IN_REVIEW:
        list.insert(2, AppointmentDetailsTasksList());
        break;
      default:
        break;
    }

    return TabBarView(
      controller: _tabController,
      children: list,
    );
  }

  _getTabs() {
    List<Tab> tabs = [
      Tab(text: S.of(context).general_details),
      Tab(text: S.of(context).appointment_details_car_details),
      Tab(text: S.of(context).appointment_details_service_history)
    ];

    switch (
        _appointmentMechanicProvider.selectedAppointment.status.getState()) {
      case AppointmentStatusState.IN_UNIT:
      case AppointmentStatusState.IN_WORK:
      case AppointmentStatusState.ON_HOLD:
      case AppointmentStatusState.IN_REVIEW:
        tabs.insert(
            2, Tab(text: S.of(context).mechanic_appointment_tasks_title));
        break;
      case AppointmentStatusState.SUBMITTED:
        tabs.insert(
            2, Tab(text: S.of(context).mechanic_appointment_receive_form));
        break;
      default:
        break;
    }

    return tabs;
  }

  _viewEstimate() {
    int workEstimateId = _appointmentMechanicProvider.selectedAppointmentDetails
        .lastWorkEstimate();

    if (workEstimateId != 0) {
      Provider.of<WorkEstimateProvider>(context).refreshValues();
      Provider.of<WorkEstimateProvider>(context).workEstimateId =
          workEstimateId;
      Provider.of<WorkEstimateProvider>(context).serviceProviderId =
          _appointmentMechanicProvider
              .selectedAppointmentDetails.serviceProvider.id;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WorkEstimateForm(mode: EstimatorMode.ReadOnly)),
      );
    }
  }
}
