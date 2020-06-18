import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/personnel/employee-timeserie.dart';
import 'package:app/modules/appointments/widgets/pick-up-form/pick-up-car-form-employee.widget.dart';
import 'package:app/modules/appointments/model/personnel/employee.dart';
import 'package:app/modules/appointments/providers/appointment-consultant.provider.dart';
import 'package:app/modules/appointments/providers/pick-up-car-form-consultant.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickUpCarFormEmployeesWidget extends StatefulWidget {
  final AppointmentDetail appointmentDetail;

  PickUpCarFormEmployeesWidget({this.appointmentDetail});

  @override
  _PickUpCarFormEmployeesWidgetState createState() =>
      _PickUpCarFormEmployeesWidgetState();
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
                _assignedEmployeeContainer(),
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

  _assignedEmployeeContainer() {
    var employee = widget.appointmentDetail?.personnel;

    return employee != null
        ? Container(
            margin: EdgeInsets.only(right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).appointment_details_assiged_mechanic,
                  style: TextHelper.customTextStyle(
                      color: red, weight: FontWeight.bold, size: 16),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: <Widget>[
                      FadeInImage.assetNetwork(
                        image: employee.profilePhoto,
                        placeholder:
                            'assets/images/defaults/default_profile_icon.png',
                        fit: BoxFit.fitHeight,
                        height: 32,
                        width: 32,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 4),
                          child: Text(
                            employee?.name,
                            style: TextHelper.customTextStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        : Container();
  }
}
