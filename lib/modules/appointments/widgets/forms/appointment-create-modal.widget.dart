import 'dart:math';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/enum/create-appointment-state.enum.dart';
import 'package:app/modules/appointments/model/request/appointment-request.model.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/appointments/widgets/forms/appointment-create-datetime.form.dart';
import 'package:app/modules/appointments/widgets/forms/appointment-create-issue.form.dart';
import 'package:app/modules/appointments/widgets/forms/appointment-create-pickup-map.form.dart';
import 'package:app/modules/appointments/widgets/forms/appointment-create-providers.form.dart';
import 'package:app/modules/appointments/widgets/forms/appointment-create-return-map.form.dart';
import 'package:app/modules/appointments/widgets/forms/appointment-create-services.form.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/shared/widgets/horizontal-stepper.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'appointment-create-datetime.form.dart';
import 'appointment-create-issue.form.dart';
import 'appointment-create-providers.form.dart';
import 'appointment-create-select-car.form.dart';
import 'appointment-create-services.form.dart';

final appointmentCarSelectionStateKey =
    new GlobalKey<AppointmentCreateSelectCarFormState>();
final appointmentServicesStateKey =
    new GlobalKey<AppointmentCreateServicesFormState>();
final appointmentIssuesStateKey =
    new GlobalKey<AppointmentCreateIssueFormState>();
final appointmentShopsStateKey =
    new GlobalKey<AppointmentCreateProvidersFormState>();

class AppointmentCreateModal extends StatefulWidget {
  @override
  _AppointmentCreateModalState createState() => _AppointmentCreateModalState();
}

class _AppointmentCreateModalState extends State<AppointmentCreateModal> {
  int _currentStepIndex = 0;
  bool isLastStep = false;
  List<FAStep> steps = [];

  FlatButton btnPrev;
  RaisedButton btnNext;

  ProviderServiceProvider _provider;

  bool _initDone = false;
  bool _isLoading = false;

  Key _stepperKey = Key(Random.secure().nextDouble().toString());

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    _provider.authUser = authProvider.authUser;

    steps = _buildSteps(context);

    return FractionallySizedBox(
        heightFactor: .8,
        child: Scaffold(
          body: Container(
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(5.0),
              child: Container(
                decoration: new BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(40.0),
                        topRight: const Radius.circular(40.0))),
                child: Theme(
                  data: ThemeData(
                      accentColor: Theme.of(context).primaryColor,
                      primaryColor: Theme.of(context).primaryColor),
                  child: _buildContent(context),
                ),
              ),
            ),
          ),
        ));
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });
      _provider = Provider.of<ProviderServiceProvider>(context);
      _provider.generateStateData(_provider.selectedCar == null);

      _loadData();
    }
    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _provider.loadServices('APPOINTMENT').then((_) async {
        if (_provider.selectedCar == null) {
          await _provider.loadCars().then((_) {
            setState(() {
              _isLoading = false;
            });
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (error) {
      if (error.toString().contains(ProviderService.GET_SERVICES_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_services, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildContent(BuildContext context) {
    bool showBottomButtons = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Stack(
            children: [_buildStepper(context), if (showBottomButtons) _bottomButtonsWidget()],
          );
  }

  Widget _buildStepper(BuildContext context) => FAStepper(
      stepNumberColor: red,
      type: FAStepperType.horizontal,
      titleIconArrange: FAStepperTitleIconArrange.row,
      currentStep: _currentStepIndex,
      onStepContinue: _next,
      key: _stepperKey,
      onStepCancel: _back,
      steps: steps,
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Row(
          children: <Widget>[],
        );
      });

  _bottomButtonsWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 20),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            btnPrev = FlatButton(
              child: Text(S.of(context).general_back),
              onPressed: _back,
            ),
            btnNext = RaisedButton(
              elevation: 0,
              child: isLastStep
                  ? Text(S.of(context).general_add)
                  : Text(S.of(context).general_continue),
              textColor: Theme.of(context).cardColor,
              onPressed: _next,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }

  List<FAStep> _buildSteps(BuildContext context) {
    List<FAStep> steps = [];

    if (_provider.createAppointmentState == CreateAppointmentState.SelectCar) {
      steps = [
        FAStep(
          isActive: _provider.stepStateData[0]["active"],
          title: _currentStepIndex == 0
              ? Text(S.of(context).appointment_create_step0)
              : Text(''),
          content: AppointmentCreateSelectCarForm(
              key: appointmentCarSelectionStateKey),
          state: _provider.stepStateData[0]['state'],
        ),
        FAStep(
            isActive: _provider.stepStateData[1]['active'],
            title: _currentStepIndex == 1
                ? Text(S.of(context).appointment_create_step1)
                : Text(''),
            content: AppointmentCreateServicesForm(
              key: appointmentServicesStateKey,
              serviceItems: _provider.serviceItems,
            ),
            state: _provider.stepStateData[1]['state']),
        FAStep(
            isActive: _provider.stepStateData[2]['active'],
            title: _currentStepIndex == 2
                ? Text(S.of(context).appointment_create_step2)
                : Text(''),
            content: AppointmentCreateIssueForm(key: appointmentIssuesStateKey),
            state: _provider.stepStateData[2]['state']),
        FAStep(
            isActive: _provider.stepStateData[3]['active'],
            title: _currentStepIndex == 3
                ? Text(S.of(context).appointment_create_step3)
                : Text(''),
            content: AppointmentCreateProvidersForm(
              key: appointmentShopsStateKey,
            ),
            state: _provider.stepStateData[3]['state']),
        FAStep(
            isActive: _currentStepIndex == 4,
            title: _provider.stepStateData[4]['active']
                ? Text(S.of(context).appointment_create_step4)
                : Text(''),
            content: AppointmentDateTimeForm(),
            state: _provider.stepStateData[4]['state'])
      ];
    } else if (_provider.createAppointmentState ==
        CreateAppointmentState.Default) {
      steps = [
        FAStep(
            isActive: _provider.stepStateData[0]['active'],
            title: _currentStepIndex == 0
                ? Text(S.of(context).appointment_create_step1)
                : Text(''),
            content: AppointmentCreateServicesForm(
              key: appointmentServicesStateKey,
              serviceItems: _provider.serviceItems,
            ),
            state: _provider.stepStateData[0]['state']),
        FAStep(
            isActive: _provider.stepStateData[1]['active'],
            title: _currentStepIndex == 1
                ? Text(S.of(context).appointment_create_step2)
                : Text(''),
            content: AppointmentCreateIssueForm(key: appointmentIssuesStateKey),
            state: _provider.stepStateData[1]['state']),
        FAStep(
            isActive: _provider.stepStateData[2]['active'],
            title: _currentStepIndex == 2
                ? Text(S.of(context).appointment_create_step3)
                : Text(''),
            content: AppointmentCreateProvidersForm(
              key: appointmentShopsStateKey,
            ),
            state: _provider.stepStateData[2]['state']),
        FAStep(
            isActive: _provider.stepStateData[3]['active'],
            title: _currentStepIndex == 3
                ? Text(S.of(context).appointment_create_step4)
                : Text(''),
            content: AppointmentDateTimeForm(),
            state: _provider.stepStateData[3]['state'])
      ];
    }

    if (_provider.hasTowService()) {
      int towIndex =
          _provider.createAppointmentState == CreateAppointmentState.SelectCar
              ? 5
              : 4;

      steps.add(FAStep(
          isActive: _provider.stepStateData[towIndex]['active'],
          title: _currentStepIndex == towIndex
              ? Text(S.of(context).appointment_create_step5)
              : Text(''),
          content: AppointmentCreatePickupMapForm(),
          state: _provider.stepStateData[towIndex]['state']));

      steps.add(FAStep(
          isActive: _provider.stepStateData[towIndex + 1]['active'],
          title: _currentStepIndex == towIndex + 1
              ? Text(S.of(context).appointment_create_step6)
              : Text(''),
          content: AppointmentCreateReturnMapForm(),
          state: _provider.stepStateData[towIndex + 1]['state']));
    }

    return steps;
  }

  _next() {
    _resetStepTitles();

    if (_provider.createAppointmentState == CreateAppointmentState.SelectCar) {
      switch (_currentStepIndex) {
        case 0:
          _carChecker();
          break;
        case 1:
          _servicesChecker();
          break;
        case 2:
          _issuesChecker();
          break;
        case 3:
          _providersChecker();
          break;
        case 4:
          _calendarChecker();
          break;
        case 5:
          _pickupChecker();
          break;
        case 6:
          _returnChecker();
      }
    } else if (_provider.createAppointmentState ==
        CreateAppointmentState.Default) {
      switch (_currentStepIndex) {
        case 0:
          _servicesChecker();
          break;
        case 1:
          _issuesChecker();
          break;
        case 2:
          _providersChecker();
          break;
        case 3:
          _calendarChecker();
          break;
        case 4:
          _pickupChecker();
          break;
        case 5:
          _returnChecker();
      }
    }
  }

  _carChecker() {
    if (appointmentCarSelectionStateKey.currentState.valid()) {
      setState(() {
        _provider.stepStateData[_currentStepIndex]['state'] =
            FAStepstate.complete;
        _provider.stepStateData[_currentStepIndex + 1]['state'] =
            FAStepstate.indexed;
        _provider.stepStateData[_currentStepIndex + 1]['active'] = true;
        _goTo(_currentStepIndex + 1);
        isLastStep = false;
      });
    }
  }

  _servicesChecker() {
    if (appointmentServicesStateKey.currentState.valid()) {
      setState(() {
        _stepperKey = Key(Random.secure().nextDouble().toString());

        _provider.stepStateData[_currentStepIndex]['state'] =
            FAStepstate.complete;
        _provider.stepStateData[_currentStepIndex + 1]['state'] =
            FAStepstate.indexed;
        _provider.stepStateData[_currentStepIndex + 1]['active'] = true;
        _goTo(_currentStepIndex + 1);
        isLastStep = false;
      });
    }
  }

  _issuesChecker() async {
    if (appointmentIssuesStateKey.currentState.valid()) {
      setState(() {
        _provider.stepStateData[_currentStepIndex]['state'] =
            FAStepstate.complete;
        _provider.stepStateData[_currentStepIndex + 1]['state'] =
            FAStepstate.indexed;
        _provider.stepStateData[_currentStepIndex + 1]['active'] = true;
        _goTo(_currentStepIndex + 1);
        isLastStep = false;
      });
    }
  }

  _providersChecker() {
    if (!appointmentShopsStateKey.currentState.valid())
      return;
    else {
      setState(() {
        _provider.stepStateData[_currentStepIndex]['state'] =
            FAStepstate.complete;
        _provider.stepStateData[_currentStepIndex + 1]['state'] =
            FAStepstate.indexed;
        _provider.stepStateData[_currentStepIndex + 1]['active'] = true;
        _goTo(_currentStepIndex + 1);

        if (!_provider.hasTowService()) {
          isLastStep = true;
        } else {
          isLastStep = false;
        }
      });
    }
  }

  _calendarChecker() {
    if (_provider.dateEntry != null) {
      if (!_provider.hasTowService()) {
        _submit();
      } else {
        setState(() {
          _provider.stepStateData[_currentStepIndex]['state'] =
              FAStepstate.complete;
          _provider.stepStateData[_currentStepIndex + 1]['state'] =
              FAStepstate.indexed;
          _provider.stepStateData[_currentStepIndex + 1]['active'] = true;
          _goTo(_currentStepIndex + 1);
        });
      }
    }
  }

  _pickupChecker() {
    if (_provider.pickupPosition.isValid()) {
      setState(() {
        _provider.stepStateData[_currentStepIndex]['state'] =
            FAStepstate.complete;
        _provider.stepStateData[_currentStepIndex + 1]['state'] =
            FAStepstate.indexed;
        _provider.stepStateData[_currentStepIndex + 1]['active'] = true;
        _goTo(_currentStepIndex + 1);

        isLastStep = true;
      });
    }
  }

  _returnChecker() {
    if (_provider.returnPosition.isValid()) {
      _submit();
    }
  }

  _resetStepTitles() {
    for (int i = 0; i < _provider.stepStateData.length; i++) {
      _provider.stepStateData[i]['title'] = Text('');
    }
  }

  _back() {
    setState(() {
      if (_currentStepIndex > 0) {
        _provider.stepStateData[_currentStepIndex]['state'] =
            FAStepstate.disabled;
        _provider.stepStateData[_currentStepIndex]['active'] = false;
        _provider.stepStateData[_currentStepIndex - 1]['state'] =
            FAStepstate.indexed;
        _provider.stepStateData[_currentStepIndex - 1]['active'] = true;
        _goTo(_currentStepIndex - 1);
        isLastStep = false;
      }
    });
  }

  _goTo(stepIndex) {
    setState(() {
      _currentStepIndex = stepIndex;
    });
  }

  _submit() async {
    AppointmentRequest appointmentRequest = _provider.appointmentRequest();

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<AppointmentsProvider>(context)
          .createAppointment(appointmentRequest)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.CREATE_APPOINTMENT_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_create_appointment, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
