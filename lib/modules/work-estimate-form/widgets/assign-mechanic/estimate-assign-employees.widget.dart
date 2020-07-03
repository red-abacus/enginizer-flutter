import 'package:app/modules/appointments/model/personnel/employee-timeserie.dart';
import 'package:app/modules/appointments/widgets/pick-up-form/pick-up-car-form-employee.widget.dart';
import 'package:app/modules/appointments/model/personnel/employee.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EstimateAssignEmployeesWidget extends StatefulWidget {
  final Function selectEmployee;
  final Function deselectEmployee;
  final List<Employee> employees;
  final List<EmployeeTimeSerie> employeeTimeSeries;

  @override
  _EstimateAssignEmployeesWidgetState createState() =>
      _EstimateAssignEmployeesWidgetState();

  EstimateAssignEmployeesWidget(
      {this.selectEmployee,
      this.employees,
      this.employeeTimeSeries,
      this.deselectEmployee});
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
                  selectedTimeSeries: widget.employeeTimeSeries,
                  deselectEmployeeTimeSerie: widget.deselectEmployee,
                  selectEmployeeTimeSerie: widget.selectEmployee,
                )
            ],
          ),
        ),
      ),
    );
  }
}
