import 'package:app/modules/consultant-appointments/models/employee-timeserie.dart';
import 'package:app/modules/consultant-appointments/models/employee.dart';
import 'package:app/modules/consultant-appointments/widgets/pick-up-form/pick-up-car-form-employee.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EstimateAssignEmployeesWidget extends StatefulWidget {
  final Function selectEmployee;
  final List<Employee> employees;
  final EmployeeTimeSerie employeeTimeSerie;

  @override
  _EstimateAssignEmployeesWidgetState createState() =>
      _EstimateAssignEmployeesWidgetState();

  EstimateAssignEmployeesWidget({this.selectEmployee, this.employees, this.employeeTimeSerie});
}

class _EstimateAssignEmployeesWidgetState
    extends State<EstimateAssignEmployeesWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[_employeesContainer()],
    );
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
              for (Employee employee in widget.employees)
                PickUpCarFormEmployeeWidget(
                  employee: employee,
                  selectedTimeSerie: widget.employeeTimeSerie,
                  selectEmployeeTimeSerie: _selectEmployeeTimeSerie,
                )
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
  }
}
