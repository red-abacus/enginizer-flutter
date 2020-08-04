import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/personnel/employee-timeserie.dart';
import 'package:app/modules/appointments/model/request/assign-employee-request.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/models/auction-details.model.dart';
import 'package:app/modules/appointments/providers/pick-up-car-form-consultant.provider.dart';
import 'package:app/modules/shared/widgets/alert-confirmation-dialog.widget.dart';
import 'package:app/modules/shared/widgets/alert-warning-dialog.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'estimate-assign-employees.widget.dart';

class EstimateAssignMechanicModal extends StatefulWidget {
  final AppointmentDetail appointmentDetail;
  final AuctionDetail auctionDetail;
  final int providerId;

  final EmployeeTimeSerie employeeTimeSerie;

  EstimateAssignMechanicModal(
      {this.appointmentDetail,
      this.employeeTimeSerie,
      this.auctionDetail,
      this.providerId});

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
              child: Stack(
                children: [_buildContent(), _bottomButton()],
              ),
            ),
          ),
        )));
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<PickUpCarFormConsultantProvider>(context);
      _provider.initialise();

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

    String scheduleDateTime = '';

    if (widget.appointmentDetail != null) {
      scheduleDateTime = widget.appointmentDetail.scheduledDate;
    } else if (widget.auctionDetail != null) {
      scheduleDateTime = widget.auctionDetail.scheduledDateTime;
    }

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
          .getProviderEmployees(widget.providerId, startDate, endDate)
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
                selectEmployee: _selectEmployee,
                deselectEmployee: _deselectEmployee,
                employees: _provider.employees,
                employeeTimeSeries: _provider.selectedTimeSeries),
          );
  }

  _bottomButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 20),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Spacer(),
            FlatButton(
              color: red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: new Text(
                S.of(context).general_assign,
                style: TextHelper.customTextStyle(
                    color: Colors.white, weight: FontWeight.bold, size: 16.0),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                _save();
              },
            )
          ],
        ),
      ),
    );
  }

  _selectEmployee(EmployeeTimeSerie employeeTimeSerie) {
    setState(() {
      if (_provider.selectedTimeSeries.length > 0 &&
          _provider.selectedTimeSeries.first.employeeId !=
              employeeTimeSerie.employeeId) {
        _provider.selectedTimeSeries = [employeeTimeSerie];
      } else {
        _provider.selectedTimeSeries.add(employeeTimeSerie);
      }
    });
  }

  _deselectEmployee(EmployeeTimeSerie employeeTimeSerie) {
    setState(() {
      _provider.selectedTimeSeries.remove(employeeTimeSerie);
    });
  }

  _save() {
    if (_provider.selectedTimeSeries.length > 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertConfirmationDialogWidget(
            title: S.of(context).estimator_assign_mechanic_title,
            confirmFunction: (confirmation) async {
              if (confirmation) {
                _assignEmployee();
              }
            },
          );
        },
      );
    } else {
      AlertWarningDialog.showAlertDialog(context, S.of(context).general_warning,
          S.of(context).estimator_assign_no_mechanic_selected);
    }
  }

  _assignEmployee() async {
    setState(() {
      _isLoading = true;
    });

    AssignEmployeeRequest request = new AssignEmployeeRequest();
    request.timeSeries = _provider.selectedTimeSeries;
    request.employeeId = _provider.selectedTimeSeries.first.employeeId;

    try {
      await _provider
          .assignEmployeeToAppointment(widget.appointmentDetail.id, request)
          .then((_) {
        Navigator.of(context).pop();
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.ASSIGN_EMPLOYEE_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_assign_mechanic_to_appointment, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
