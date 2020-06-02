import 'package:app/modules/appointments/model/personnel/employee-timeserie.dart';
import 'package:app/modules/appointments/providers/car-reception-form.provider.dart';
import 'package:app/modules/appointments/widgets/pick-up-form/pick-up-car-form-employee.widget.dart';
import 'package:app/modules/appointments/model/personnel/employee.dart';
import 'package:app/modules/appointments/providers/appointment-consultant.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarReceptionFormEmployeesWidget extends StatefulWidget {
  @override
  _CarReceptionFormEmployeesWidgetState createState() =>
      _CarReceptionFormEmployeesWidgetState();
}

class _CarReceptionFormEmployeesWidgetState
    extends State<CarReceptionFormEmployeesWidget> {
  CarReceptionFormProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<CarReceptionFormProvider>(context);

    return Consumer<AppointmentConsultantProvider>(
        builder: (context, appointmentsProvider, _) => Column(
              children: <Widget>[_employeesContainer()],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              for (Employee employee in _provider.employees)
                PickUpCarFormEmployeeWidget(
                  employee: employee,
                  selectedTimeSerie: _provider.selectedTimeSerie,
                  selectEmployeeTimeSerie: _selectEmployeeTimeSerie,
                )
            ],
          ),
        ),
      ),
    );
  }

  _selectEmployeeTimeSerie(EmployeeTimeSerie timeSerie) {
    setState(() {
      _provider.selectedTimeSerie = timeSerie;
    });
  }
}
