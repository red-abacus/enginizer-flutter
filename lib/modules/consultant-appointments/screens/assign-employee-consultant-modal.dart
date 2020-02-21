import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/providers/appointment-consultant.provider.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/widgets/details/employee-timetable-consultant.widget.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AssignEmployeeConsultantModal extends StatefulWidget {
  Appointment appointment;

  @override
  _AssignEmployeeConsultantModalState createState() =>
      _AssignEmployeeConsultantModalState();

  AssignEmployeeConsultantModal({this.appointment});
}

class _AssignEmployeeConsultantModalState
    extends State<AssignEmployeeConsultantModal> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentConsultantProvider>(
        builder: (context, appointmentsProvider, _) => _buildContent(context));
  }

  @override
  void didChangeDependencies() {
    // TODO - need to fetch Employees after API is in place
    /*
    String startDate = DateUtils.stringFromDate(DateTime.now(), 'dd/MM/yyyy');
    String endDate = startDate;

    String scheduleDateTime = widget.appointment.scheduleDateTime;

    if (scheduleDateTime.isNotEmpty) {
      DateTime dateTime = DateUtils.dateFromString(
          scheduleDateTime, Appointment.scheduledTimeFormat());

      if (dateTime != null) {
        startDate = DateUtils.stringFromDate(dateTime, 'dd/MM/yyyy');
        endDate = startDate;
      }
    }
     */

    super.didChangeDependencies();
  }

  _buildContent(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: .8,
        child: Container(
            child: ClipRRect(
          borderRadius: new BorderRadius.circular(5.0),
          child: Container(
            decoration: new BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0))),
            child: Theme(
              data: ThemeData(
                  accentColor: Theme.of(context).primaryColor,
                  primaryColor: Theme.of(context).primaryColor),
              child: _content(),
            ),
          ),
        )));
  }

  _content() {
    return Column(
      children: <Widget>[_titleContainer(), _employeesContainer()],
    );
  }

  _employeesContainer() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                for (int i = 0; i < 10; i++) EmployeeTimetableWidget()
              ],
            ),
          ),
        ),
      ),
    );

    /*
    ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              for (int i = 0; i < 10; i++) EmployeeTimetableWidget()
            ],
          ),
     */
  }

  _titleContainer() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Text(
        S.of(context).appointment_details_service_occupancy,
        style:
            TextHelper.customTextStyle(null, Colors.black, FontWeight.bold, 16),
      ),
    );
  }
}
