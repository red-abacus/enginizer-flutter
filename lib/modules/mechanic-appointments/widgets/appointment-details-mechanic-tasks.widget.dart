import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/mechanic-appointments/providers/appointment-mechanic.provider.dart';
import 'package:app/modules/mechanic-appointments/providers/appointments-mechanic.provider.dart';
import 'package:app/modules/mechanic-appointments/widgets/appointment-details-mechanic-efficiency.widget.dart';
import 'package:app/modules/mechanic-appointments/widgets/items/tasks/appointment-details-mechanic-tasks-issues.widget.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentDetailsTasksList extends StatefulWidget {
  AppointmentDetailsTasksList();

  @override
  AppointmentDetailsTasksListState createState() {
    return AppointmentDetailsTasksListState();
  }
}

class AppointmentDetailsTasksListState
    extends State<AppointmentDetailsTasksList> {
  AppointmentMechanicProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<AppointmentMechanicProvider>(context);

    if (_provider.selectedAppointmentDetails != null) {
      if (_provider.selectedAppointmentDetails.status.getState() != AppointmentStatusState.IN_REVIEW) {
        return AppointmentDetailsMechanicTasksIssuesWidget(
            stopAppointment: _stopAppointment);
      }
      else {
        return AppointmentDetailsMechanicEfficiencyWidget();
      }
    }

    return Container();
  }

  _stopAppointment(AppointmentDetail appointmentDetail) async {
    try {
      await _provider.stopAppointment(appointmentDetail.id).then((_) {
        Provider.of<AppointmentsMechanicProvider>(context).initDone = false;
        setState(() {});
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.STOP_APPOINTMENT_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_stop_appointment, context);
      }
    }
  }
}
