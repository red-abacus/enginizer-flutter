import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/consultant-appointments/models/employee-timeserie.dart';
import 'package:app/modules/consultant-appointments/models/employee.dart';
import 'package:app/modules/consultant-appointments/providers/appointment-consultant.provider.dart';
import 'package:app/modules/consultant-appointments/providers/pick-up-car-form-consultant.provider.dart';
import 'package:app/modules/consultant-appointments/widgets/pick-up-form/pick-up-car-form-employee.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickUpCarFormEmployeesWidget extends StatefulWidget {
  Appointment appointment;
  Function selectEmployee;

  @override
  _PickUpCarFormEmployeesWidgetState createState() =>
      _PickUpCarFormEmployeesWidgetState();

  PickUpCarFormEmployeesWidget({this.appointment, this.selectEmployee});
}

class _PickUpCarFormEmployeesWidgetState
    extends State<PickUpCarFormEmployeesWidget> {
  PickUpCarFormConsultantProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<PickUpCarFormConsultantProvider>(context);

    return Consumer<AppointmentConsultantProvider>(
        builder: (context, appointmentsProvider, _) => Column(
              children: <Widget>[
                _employeesContainer()
              ],
            ));
  }

  _employeesContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for(Employee employee in _provider.employees)
                PickUpCarFormEmployeeWidget(employee: employee, selectedTimeSerie: _provider.selectedTimeSerie, selectEmployeeTimeSerie: _selectEmployeeTimeSerie,)
            ],
          ),
        ),
      ),
    );
  }

  _selectEmployeeTimeSerie(EmployeeTimeSerie timeSerie) {
    if (widget.selectEmployee != null) {
      widget.selectEmployee(timeSerie);
    }
    else {
      setState(() {
        _provider.selectedTimeSerie = timeSerie;
      });
    }
  }
}
