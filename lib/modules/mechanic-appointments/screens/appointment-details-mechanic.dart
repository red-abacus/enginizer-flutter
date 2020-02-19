import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/mechanic-appointments/providers/appointment-mechanic.provider.dart';
import 'package:enginizer_flutter/modules/mechanic-appointments/widgets/appointment-details-car-details.widget.dart';
import 'package:enginizer_flutter/modules/mechanic-appointments/widgets/appointment-details-service-history.widget.dart';
import 'package:enginizer_flutter/modules/mechanic-appointments/widgets/appointment-details-tasks-list.widget.dart';
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

  AppointmentMechanicProvider appointmentProviderMechanic;

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
    appointmentProviderMechanic =
        Provider.of<AppointmentMechanicProvider>(context);

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
        body: Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: _buildContent(),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      appointmentProviderMechanic =
          Provider.of<AppointmentMechanicProvider>(context);

      appointmentProviderMechanic
          .getAppointmentDetails(
              appointmentProviderMechanic.selectedAppointment)
          .then((_) {
        appointmentProviderMechanic
            .getProviderServices(appointmentProviderMechanic
                .selectedAppointment.serviceProvider.id)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }
    _initDone = true;
    super.didChangeDependencies();
  }

  _titleText() {
    return Text(
      appointmentProviderMechanic.selectedAppointment?.name ?? 'N/A',
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
        AppointmentDetailsCarDetails(
          appointment: appointmentProviderMechanic.selectedAppointment,
          appointmentDetails:
              appointmentProviderMechanic.selectedAppointmentDetail,
        ),
        AppointmentDetailsTasksList(
          appointment: appointmentProviderMechanic.selectedAppointment,
          appointmentDetails:
              appointmentProviderMechanic.selectedAppointmentDetail,
        ),
        AppointmentDetailsServiceHistory(
          appointment: appointmentProviderMechanic.selectedAppointment,
          appointmentDetails:
              appointmentProviderMechanic.selectedAppointmentDetail,
        ),
      ],
    );
  }
}
