import 'package:app/generated/l10n.dart';
import 'package:app/modules/mechanic-appointments/providers/appointment-mechanic.provider.dart';
import 'package:app/modules/mechanic-appointments/widgets/appointment-details-car-details.widget.dart';
import 'package:app/modules/mechanic-appointments/widgets/appointment-details-service-history.widget.dart';
import 'package:app/modules/mechanic-appointments/widgets/appointment-details-tasks-list.widget.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String route;

  var _initDone = false;
  var _isLoading = false;

  TabController _tabController;

  AppointmentDetailsMechanicState({this.route});

  AppointmentMechanicProvider appointmentMechanicProvider;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appointmentMechanicProvider =
        Provider.of<AppointmentMechanicProvider>(context, listen: false);

    if (appointmentMechanicProvider.selectedAppointment == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }

    return Consumer<AppointmentMechanicProvider>(
      builder: (context, appointmentMechanicProvider, _) => Scaffold(
        appBar: AppBar(
          key: _scaffoldKey,
          iconTheme: IconThemeData(color: Theme.of(context).cardColor),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: S.of(context).appointment_details_car_details),
              Tab(text: S.of(context).appointment_details_tasks_list),
              Tab(text: S.of(context).appointment_details_service_history),
            ],
          ),
          title: _titleText(),
        ),
        body: _buildContent(),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      appointmentMechanicProvider =
          Provider.of<AppointmentMechanicProvider>(context, listen: false);

      appointmentMechanicProvider
          .getAppointmentDetails(
              appointmentMechanicProvider.selectedAppointment)
          .then((_) {
        appointmentMechanicProvider
            .getWorkEstimateDetails(appointmentMechanicProvider
                .selectedAppointmentDetails.workEstimateId)
            .then((_) {
          appointmentMechanicProvider
              .getStandardTasks(
                  appointmentMechanicProvider.selectedAppointment.id)
              .then((mechanicTasks) {
            appointmentMechanicProvider.selectedMechanicTask = mechanicTasks[0];
            appointmentMechanicProvider.initFormValues();
            _isLoading = false;
          });
        });
      });

      _initDone = true;
    }
    super.didChangeDependencies();
  }

  _titleText() {
    return Text(
      appointmentMechanicProvider.selectedAppointment?.name ?? 'N/A',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    );
  }

  _buildContent() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _buildTabBarView();
  }

  TabBarView _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        AppointmentDetailsCarDetails(),
        AppointmentDetailsTasksList(),
        AppointmentDetailsServiceHistory(),
      ],
    );
  }
}
