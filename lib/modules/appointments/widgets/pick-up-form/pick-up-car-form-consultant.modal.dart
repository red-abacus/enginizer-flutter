import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/enum/car-receive-form-state.enum.dart';
import 'package:app/modules/appointments/enum/pick-up-form-state.enum.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/handover/procedure-info.model.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/appointments/model/request/assign-employee-request.model.dart';
import 'package:app/modules/appointments/providers/appointment-consultant.provider.dart';
import 'package:app/modules/appointments/providers/pick-up-car-form-consultant.provider.dart';
import 'package:app/modules/appointments/widgets/pick-up-form/pick-up-car-form-employees.widget.dart';
import 'package:app/modules/appointments/widgets/pick-up-form/pick-up-car-form-information.widget.dart';
import 'package:app/modules/shared/widgets/image-picker.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'image-selection.widget.dart';

class PickUpCarFormConsultantWidget extends StatefulWidget {
  final AppointmentDetail appointmentDetail;
  final Function refreshState;
  final CarReceiveFormState carReceiveFormState;
  final PickupFormState pickupFormState;

  PickUpCarFormConsultantWidget(
      {Key key,
      this.appointmentDetail,
      this.refreshState,
      this.carReceiveFormState,
      this.pickupFormState})
      : super(key: key);

  @override
  _PickUpCarFormConsultantWidgetState createState() =>
      _PickUpCarFormConsultantWidgetState();
}

class _PickUpCarFormConsultantWidgetState
    extends State<PickUpCarFormConsultantWidget> {
  bool _initDone = false;
  bool _isLoading = false;
  int _currentStepIndex = 0;

  PickUpCarFormConsultantProvider _provider;

  List<Step> steps = [];

  @override
  Widget build(BuildContext context) {
    steps = _buildSteps(context);
    return _getContent();
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
    }

    if (_provider.receiveFormRequest.files == null) {
      _provider.initialise();
    }

    _initDone = true;
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
          .then((_) async {
        await _provider
            .getProcedureInfo(
                widget.appointmentDetail.id, _provider.pickupFormState)
            .then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(ProviderService.GET_PROVIDER_EMPLOYEES_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_provider_employees, context);
      } else if (error
          .toString()
          .contains(AppointmentsService.GET_RECEIVE_PROCEDURE_INFO_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_receive_procedure_info, context);
      } else if (error
          .toString()
          .contains(AppointmentsService.GET_RETURN_PROCEDURE_INFO_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_return_procedure_info, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _getContent() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _buildStepper();
  }

  Widget _buildStepper() => Stepper(
      currentStep: _currentStepIndex,
      onStepContinue: _next,
      onStepCancel: _back,
      onStepTapped: (step) => _goTo(step),
      type: StepperType.horizontal,
      steps: steps,
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Row(
          children: <Widget>[
            SizedBox(height: 70),
            FlatButton(
              child: Text(S.of(context).general_back),
              onPressed: onStepCancel,
            ),
            RaisedButton(
              elevation: 0,
              child: Text(S.of(context).general_continue),
              textColor: Theme.of(context).cardColor,
              onPressed: onStepContinue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: Theme.of(context).primaryColor,
            )
          ],
        );
      });

  Future _addImage(int index) async {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) => ImagePickerWidget(imageSelected: (file) {
              if (file != null) {
                setState(() {
                  if (index < _provider.receiveFormRequest.files.length) {
                    _provider.receiveFormRequest.files[index] = file;

                    if (_provider.receiveFormRequest.files.length <
                        _provider.maxFiles) {
                      _provider.receiveFormRequest.files.add(null);
                    }
                  }
                });
              }
            }));
  }

  List<Step> _buildSteps(BuildContext context) {
    List<Step> list = [
      Step(
          isActive: _currentStepIndex == 0,
          title: Text(_currentStepIndex == 0
              ? S.of(context).appointment_receive_car_step_1
              : ''),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  S.of(context).appointment_consultant_car_form_photos_title,
                  style: TextHelper.customTextStyle(
                      color: red, weight: FontWeight.bold, size: 16),
                ),
                ImageSelectionWidget(
                    addImage: _addImage,
                    files: _provider.receiveFormRequest.files),
              ],
            ),
          ),
          state: StepState.indexed),
      Step(
          isActive: _currentStepIndex == 1,
          title: Text(_currentStepIndex == 1
              ? widget.pickupFormState == PickupFormState.Receive
                  ? S.of(context).appointment_receive_car_step_receive_2
                  : S.of(context).appointment_receive_car_step_return_2
              : ''),
          content: PickupCarFormInformationWidget(
              carReceiveFormState: widget.carReceiveFormState),
          state: StepState.indexed)
    ];

    if (widget.carReceiveFormState == CarReceiveFormState.Service) {
      list.add(Step(
          isActive: _currentStepIndex == 2,
          title: Text(_currentStepIndex == 2
              ? S.of(context).appointment_receive_car_step_3
              : ''),
          content: PickUpCarFormEmployeesWidget(
              appointmentDetail: widget.appointmentDetail),
          state: StepState.indexed));
    }

    return list;
  }

  _next() {
    switch (_currentStepIndex) {
      case 0:
        _goTo(1);
        break;
      case 1:
        if (_provider.informationFormState.currentState.validate()) {
          switch (widget.carReceiveFormState) {
            case CarReceiveFormState.Service:
              _goTo(2);
              break;
            case CarReceiveFormState.Pr:
              _createReceiveForm();
              break;
          }
        }
        break;
      case 2:
        _createReceiveForm();
        break;
    }
  }

  _back() {
    if (_currentStepIndex > 0) {
      _goTo(_currentStepIndex - 1);
    }
  }

  _goTo(stepIndex) {
    setState(() {
      _currentStepIndex = stepIndex;
    });
  }

  _createReceiveForm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _provider.receiveFormRequest.appointmentId = widget.appointmentDetail.id;
      await _provider
          .createProcedure(_provider.receiveFormRequest, widget.pickupFormState)
          .then((_) async {
        await _provider
            .addReceiveProcedurePhotos(_provider.receiveFormRequest)
            .then((_) async {
          if (_provider.selectedTimeSerie != null) {
            AssignEmployeeRequest request = new AssignEmployeeRequest();
            request.timeSerie = _provider.selectedTimeSerie;
            request.employeeId = _provider.selectedTimeSerie.employeeId;

            await _provider
                .assignEmployeeToAppointment(
                    widget.appointmentDetail.id, request)
                .then((_) {
              widget.refreshState();
              Provider.of<AppointmentConsultantProvider>(context).initDone =
                  false;
              Provider.of<AppointmentsProvider>(context).initDone = false;

              Navigator.pop(context);
            });
          } else {
            widget.refreshState();
            Provider.of<AppointmentConsultantProvider>(context).initDone =
                false;
            Provider.of<AppointmentsProvider>(context).initDone = false;

            Navigator.pop(context);
          }
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.CREATE_RECEIVE_PROCEDURE_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_create_receive_procedure, context);
      } else if (error.toString().contains(
          AppointmentsService.ADD_RECEIVE_PROCEDURE_IMAGES_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_add_procedure_photos, context);
      } else if (error
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
