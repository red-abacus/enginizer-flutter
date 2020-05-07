import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/consultant-appointments/models/assign-employee-request.model.dart';
import 'package:app/modules/consultant-appointments/models/employee-timeserie.dart';
import 'package:app/modules/consultant-appointments/providers/pick-up-car-form-consultant.provider.dart';
import 'package:app/modules/consultant-appointments/widgets/pick-up-form/pick-up-car-form-employees.widget.dart';
import 'package:app/modules/shared/widgets/alert-confirmation-dialog.widget.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'estimate-assign-employees.widget.dart';

class EstimateAssignMechanicModal extends StatefulWidget {
  final AppointmentDetail appointmentDetail;
  final Appointment appointment;

  final Function refreshState;
  final Function assignEmployee;
  final EmployeeTimeSerie employeeTimeSerie;

  EstimateAssignMechanicModal(
      {this.appointment,
      this.appointmentDetail,
      this.refreshState,
      this.assignEmployee,
      this.employeeTimeSerie});

  @override
  State<StatefulWidget> createState() {
    return _EstimateAssignMechanicModalState();
  }
}

class _EstimateAssignMechanicModalState
    extends State<EstimateAssignMechanicModal> {
  PickUpCarFormConsultantProvider _provider;

  bool _initDone = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
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
              child: _buildContent(),
            ),
          ),
        )));
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<PickUpCarFormConsultantProvider>(context);

      setState(() {
        _isLoading = true;
      });

      _loadData();
      _initDone = true;
    }

    super.didChangeDependencies();
  }

  _loadData() async {
    String startDate = DateUtils.stringFromDate(DateTime.now(), 'dd/MM/yyyy');
    String endDate = startDate;

    String scheduleDateTime = widget.appointmentDetail.scheduledDate;

    if (scheduleDateTime.isNotEmpty) {
      DateTime dateTime = DateUtils.dateFromString(
          scheduleDateTime, AppointmentDetail.scheduledTimeFormat());

      if (dateTime != null) {
        startDate = DateUtils.stringFromDate(dateTime, 'dd/MM/yyyy');
        endDate = startDate;
      }
    }

    try {
      await _provider
          .getProviderEmployees(
              widget.appointmentDetail.serviceProvider.id, startDate, endDate)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(ProviderService.GET_PROVIDER_EMPLOYEES_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_provider_employees, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildContent() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: EstimateAssignEmployeesWidget(
                appointment: widget.appointment,
                selectEmployee: _selectEmployee,
                employees: _provider.employees,
                employeeTimeSerie: _provider.selectedTimeSerie),
          );
  }

  _selectEmployee(EmployeeTimeSerie employeeTimeSerie) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertConfirmationDialogWidget(
          title: S.of(context).estimator_assign_mechanic_title,
          confirmFunction: (confirmation) async {
            if (confirmation) {
              widget.assignEmployee(employeeTimeSerie);
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

//  _assignEmployee(EmployeeTimeSerie employeeTimeSerie) async {
//    AssignEmployeeRequest request = new AssignEmployeeRequest();
//    request.timeSerie = employeeTimeSerie;
//    request.appointmentId = widget.appointmentDetail.id;
//    request.employeeId = employeeTimeSerie.employeeId;
//    request.providerId = widget.appointmentDetail.serviceProvider.id;
//
//    try {
//      await _provider.assignEmployeeToAppointment(request).then((_) {
//        Navigator.of(context).pop();
//      });
//    } catch (error) {
//      if (error.toString().contains(
//          ProviderService.ASSIGN_MECHANIC_TO_APPOINTMENT_EXCEPTION)) {
//        FlushBarHelper.showFlushBar(
//            S.of(context).general_error,
//            S.of(context).exception_assign_mechanic_to_appointment,
//            context);
//      }
//    }
//  }
}
