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
import 'package:app/modules/appointments/widgets/forms/appointment-create-providers.form.dart';
import 'package:app/modules/appointments/widgets/forms/appointment-create-services.form.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/cars/providers/cars.provider.dart';
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
  List<Step> steps = [];

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
      await _provider.loadServices().then((_) async {
        if (_provider.selectedCar == null) {
          await Provider.of<CarsProvider>(context).loadCars().then((_) {
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
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Stack(
            children: [_buildStepper(context), _bottomButtonsWidget()],
          );
  }

  Widget _buildStepper(BuildContext context) => Stepper(
      currentStep: _currentStepIndex,
      onStepContinue: _next,
      key: _stepperKey,
      onStepCancel: _back,
      type: StepperType.horizontal,
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

  List<Step> _buildSteps(BuildContext context) {
    List<Step> steps = [];

    if (_provider.createAppointmentState == CreateAppointmentState.SelectCar) {
      steps = [
        Step(
          isActive: _provider.stepStateData[0]["active"],
          title: _currentStepIndex == 0
              ? Text(S.of(context).appointment_create_step0)
              : Text(''),
          content: AppointmentCreateSelectCarForm(
              key: appointmentCarSelectionStateKey),
          state: _provider.stepStateData[0]['state'],
        ),
        Step(
            isActive: _provider.stepStateData[1]['active'],
            title: _currentStepIndex == 1
                ? Text(S.of(context).appointment_create_step1)
                : Text(''),
            content: AppointmentCreateServicesForm(
              key: appointmentServicesStateKey,
              serviceItems: _provider.serviceItems,
            ),
            state: _provider.stepStateData[1]['state']),
        Step(
            isActive: _provider.stepStateData[2]['active'],
            title: _currentStepIndex == 2
                ? Text(S.of(context).appointment_create_step2)
                : Text(''),
            content: AppointmentCreateIssueForm(key: appointmentIssuesStateKey),
            state: _provider.stepStateData[2]['state']),
        Step(
            isActive: _provider.stepStateData[3]['active'],
            title: _currentStepIndex == 3
                ? Text(S.of(context).appointment_create_step3)
                : Text(''),
            content: AppointmentCreateProvidersForm(
              key: appointmentShopsStateKey,
            ),
            state: _provider.stepStateData[3]['state']),
        Step(
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
        Step(
            isActive: _provider.stepStateData[0]['active'],
            title: _currentStepIndex == 0
                ? Text(S.of(context).appointment_create_step1)
                : Text(''),
            content: AppointmentCreateServicesForm(
              key: appointmentServicesStateKey,
              serviceItems: _provider.serviceItems,
            ),
            state: _provider.stepStateData[0]['state']),
        Step(
            isActive: _provider.stepStateData[1]['active'],
            title: _currentStepIndex == 1
                ? Text(S.of(context).appointment_create_step2)
                : Text(''),
            content: AppointmentCreateIssueForm(key: appointmentIssuesStateKey),
            state: _provider.stepStateData[1]['state']),
        Step(
            isActive: _provider.stepStateData[2]['active'],
            title: _currentStepIndex == 2
                ? Text(S.of(context).appointment_create_step3)
                : Text(''),
            content: AppointmentCreateProvidersForm(
              key: appointmentShopsStateKey,
            ),
            state: _provider.stepStateData[2]['state']),
        Step(
            isActive: _provider.stepStateData[3]['active'],
            title: _currentStepIndex == 3
                ? Text(S.of(context).appointment_create_step4)
                : Text(''),
            content: AppointmentDateTimeForm(),
            state: _provider.stepStateData[3]['state'])
      ];
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
      }
    } else if (_provider.createAppointmentState == CreateAppointmentState.Default) {
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
      }
    }
  }

  _carChecker() {
    if (appointmentCarSelectionStateKey.currentState.valid()) {
      setState(() {
        _provider.stepStateData[_currentStepIndex]['state'] =
            StepState.complete;
        _provider.stepStateData[_currentStepIndex + 1]['state'] =
            StepState.indexed;
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
            StepState.complete;
        _provider.stepStateData[_currentStepIndex + 1]['state'] =
            StepState.indexed;
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
            StepState.complete;
        _provider.stepStateData[_currentStepIndex + 1]['state'] =
            StepState.indexed;
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
            StepState.complete;
        _provider.stepStateData[_currentStepIndex + 1]['state'] =
            StepState.indexed;
        _provider.stepStateData[_currentStepIndex + 1]['active'] = true;
        _goTo(_currentStepIndex + 1);

        isLastStep = true;
      });
    }
  }

  _calendarChecker() {
    if (_provider.dateEntry != null) {
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
            StepState.disabled;
        _provider.stepStateData[_currentStepIndex]['active'] = false;
        _provider.stepStateData[_currentStepIndex - 1]['state'] =
            StepState.indexed;
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
