import 'package:app/generated/l10n.dart';
import 'package:app/modules/mechanic-appointments/providers/appointment-mechanic.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentDetailsServiceHistory extends StatefulWidget {
  AppointmentDetailsServiceHistory();

  @override
  AppointmentDetailsServiceHistoryState createState() {
    return AppointmentDetailsServiceHistoryState();
  }
}

class AppointmentDetailsServiceHistoryState
    extends State<AppointmentDetailsServiceHistory> {
  AppointmentMechanicProvider appointmentMechanicProvider;

  @override
  Widget build(BuildContext context) {
    appointmentMechanicProvider =
        Provider.of<AppointmentMechanicProvider>(context, listen: false);

    List<dynamic> serviceHistory = appointmentMechanicProvider.serviceHistory;

    return serviceHistory.isNotEmpty
        ? _buildServiceHistory(context, serviceHistory)
        : Center(
        child: Text(S.of(context).appointment_details_service_history_error));
  }

  _buildServiceHistory(BuildContext context, List<dynamic> serviceHistory) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: serviceHistory.length,
        itemBuilder: (context, index) {
          // To be implemented
          return Container();
        });
  }

}
