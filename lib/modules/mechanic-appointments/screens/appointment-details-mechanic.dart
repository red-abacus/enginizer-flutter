import 'package:app/generated/l10n.dart';
import 'package:app/layout/navigation_toolbar.app.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/auctions/services/work-estimates.service.dart';
import 'package:app/modules/mechanic-appointments/providers/appointment-mechanic.provider.dart';
import 'package:app/modules/mechanic-appointments/widgets/appointment-details-mechanic-car-details.widget.dart';
import 'package:app/modules/mechanic-appointments/widgets/appointment-details-mechanic-receive-form.widget.dart';
import 'package:app/modules/mechanic-appointments/widgets/appointment-details-mechanic-service-history.widget.dart';
import 'package:app/modules/mechanic-appointments/widgets/appointment-details-mechanic.widget.dart';
import 'package:app/modules/mechanic-appointments/widgets/appointment-details-mechanic-tasks.widget.dart';
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

  AppointmentMechanicProvider appointmentMechanicProvider;

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
    if (appointmentMechanicProvider != null &&
        appointmentMechanicProvider.selectedAppointment == null) {
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
      appointmentMechanicProvider =
          Provider.of<AppointmentMechanicProvider>(context);

      if (appointmentMechanicProvider.selectedAppointment != null) {
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
      await appointmentMechanicProvider
          .getAppointmentDetails(
              appointmentMechanicProvider.selectedAppointment)
          .then((_) async {

        appointmentMechanicProvider
            .getStandardTasks(
                appointmentMechanicProvider.selectedAppointment.id)
            .then((mechanicTasks) {
          appointmentMechanicProvider.selectedMechanicTask = mechanicTasks[0];

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
          .contains(WorkEstimatesService.GET_WORK_ESTIMATE_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_work_estimate_details, context);
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
      appointmentMechanicProvider.selectedAppointment?.name ?? 'N/A',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    );
  }

  _buildContent() {
    List<Widget> list = [
      AppointmentDetailsMechanicWidget(
          appointment: appointmentMechanicProvider.selectedAppointment,
          appointmentDetail:
              appointmentMechanicProvider.selectedAppointmentDetails),
      AppointmentDetailsCarDetails(),
      AppointmentDetailsServiceHistory()
    ];

    if (appointmentMechanicProvider.selectedAppointment.getState() ==
        AppointmentStatusState.SUBMITTED) {
      list.insert(
          2,
          AppointmentDetailsReceiveFormWidget(
              appointmentDetails:
                  appointmentMechanicProvider.selectedAppointmentDetails));
    } else if (appointmentMechanicProvider.selectedAppointment.getState() ==
        AppointmentStatusState.ON_HOLD) {
      list.insert(2, AppointmentDetailsTasksList());
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

    switch (appointmentMechanicProvider.selectedAppointment.getState()) {
      case AppointmentStatusState.SUBMITTED:
        tabs.insert(
            2, Tab(text: S.of(context).mechanic_appointment_receive_form));
        break;
      case AppointmentStatusState.ON_HOLD:
        tabs.insert(
            2, Tab(text: S.of(context).mechanic_appointment_tasks_title));
        break;
      default:
        break;
    }

    return tabs;
  }
}
