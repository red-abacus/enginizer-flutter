import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/widgets/personnel/appointment-details-mechanic-documentations.widget.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/notifications/screens/notifications.dart';
import 'package:app/modules/shared/managers/permissions/permissions-car.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:app/modules/appointments/providers/appointment-mechanic.provider.dart';
import 'package:app/modules/appointments/widgets/personnel/appointment-details-mechanic-car-details.widget.dart';
import 'package:app/modules/appointments/widgets/personnel/appointment-details-mechanic-service-history.widget.dart';
import 'package:app/modules/appointments/widgets/personnel/appointment-details-mechanic.widget.dart';
import 'package:app/modules/appointments/widgets/personnel/appointment-details-mechanic-tasks.widget.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/screens/work-estimate-form.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/locale.manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'appointments.dart';

class AppointmentDetailsMechanic extends StatefulWidget {
  static const String route =
      '${Appointments.route}/appointment-details-mechanic';
  static const String notificationsRoute =
      '${Notifications.route}/appointment-details-mechanic';

  @override
  State<StatefulWidget> createState() {
    return AppointmentDetailsMechanicState(route: route);
  }
}

class AppointmentDetailsMechanicState extends State<AppointmentDetailsMechanic>
    with TickerProviderStateMixin {
  String route;

  var _initDone = false;
  var _isLoading = false;

  TabController _tabController;

  AppointmentDetailsMechanicState({this.route});

  AppointmentMechanicProvider _provider;

  @override
  void initState() {
    super.initState();
    int count = 3;

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Cars, PermissionsCar.VIEW_CAR_HISTORY)) {
      count += 1;
    }

    if (PermissionsManager.getInstance().hasAccess(MainPermissions.Cars,
        PermissionsCar.VIEW_CAR_TECHNICAL_DOCUMENTATION)) {
      count += 1;
    }

    _tabController =
        new TabController(vsync: this, length: count, initialIndex: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_provider != null && _provider.selectedAppointment == null) {
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
                isScrollable: true,
                controller: _tabController,
                tabs: _getTabs(),
              ),
              title: _titleText(),
            ),
            body: _buildContent(),
          );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<AppointmentMechanicProvider>(context);

      if (_provider.selectedAppointment != null) {
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
      await _provider
          .getAppointmentDetails(_provider.selectedAppointment)
          .then((value) async {
        _provider.selectedAppointmentDetails = value;
        await _provider
            .getStandardTasks(_provider.selectedAppointment.id)
            .then((tasks) async {
          await _provider
              .getClientTasks(_provider.selectedAppointment.id)
              .then((tasks) async {
            await _provider
                .getCarHistory(_provider.selectedAppointment.car.id)
                .then((value) async {
              await _provider
                  .getCarDocumentationTopics(
                      _provider.selectedAppointment.car.id,
                      LocaleManager.language(context))
                  .then((value) {
                setState(() {
                  _isLoading = false;
                });
              });
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
      } else if (error.toString().contains(CarService.CAR_HISTORY_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_car_history, context);
      } else if (error
          .toString()
          .contains(CarService.CAR_DOCUMENTATION_TOPICS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_car_documentation_topics, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _titleText() {
    return Text(
      _provider.selectedAppointment?.name ?? 'N/A',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    );
  }

  _buildContent() {
    List<Widget> list = [
      AppointmentDetailsMechanicWidget(
          appointment: _provider.selectedAppointment,
          appointmentDetail: _provider.selectedAppointmentDetails,
          viewEstimate: _viewEstimate),
      AppointmentDetailsCarDetails(),
    ];

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Cars, PermissionsCar.VIEW_CAR_HISTORY)) {
      list.add(AppointmentDetailsServiceHistory());
    }

    if (PermissionsManager.getInstance().hasAccess(MainPermissions.Cars,
        PermissionsCar.VIEW_CAR_TECHNICAL_DOCUMENTATION)) {
      list.add(AppointmentDetailsMechanicDocumentationsWidget());
    }

    switch (_provider.selectedAppointment.status.getState()) {
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
      physics: ScrollPhysics(),
      controller: _tabController,
      children: list,
    );
  }

  _getTabs() {
    List<Tab> tabs = [
      Tab(text: S.of(context).general_details),
      Tab(text: S.of(context).appointment_details_car_details),
    ];

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Cars, PermissionsCar.VIEW_CAR_HISTORY)) {
      tabs.add(Tab(text: S.of(context).appointment_details_service_history));
    }

    if (PermissionsManager.getInstance().hasAccess(MainPermissions.Cars,
        PermissionsCar.VIEW_CAR_TECHNICAL_DOCUMENTATION)) {
      tabs.add(Tab(text: S.of(context).appointment_details_documentation));
    }

    switch (_provider.selectedAppointment.status.getState()) {
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
    int workEstimateId =
        _provider.selectedAppointmentDetails.lastWorkEstimate();

    if (workEstimateId != 0) {
      Provider.of<WorkEstimateProvider>(context)
          .refreshValues(EstimatorMode.ReadOnly);
      Provider.of<WorkEstimateProvider>(context).workEstimateId =
          workEstimateId;
      Provider.of<WorkEstimateProvider>(context).serviceProviderId =
          _provider.selectedAppointmentDetails.serviceProvider.id;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WorkEstimateForm(mode: EstimatorMode.ReadOnly)),
      );
    }
  }
}
