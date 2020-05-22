import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/request/appointment-request.model.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/appointments/widgets/forms/appointment-create-datetime.form.dart';
import 'package:app/modules/appointments/widgets/forms/appointment-create-issue.form.dart';
import 'package:app/modules/appointments/widgets/forms/appointment-create-providers.form.dart';
import 'package:app/modules/appointments/widgets/forms/appointment-create-services.form.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/providers/cars.provider.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'forms/appointment-create-datetime.form.dart';
import 'forms/appointment-create-issue.form.dart';
import 'forms/appointment-create-providers.form.dart';
import 'forms/appointment-create-select-car.form.dart';
import 'forms/appointment-create-services.form.dart';

final appointmentCarSelectionStateKey =
    new GlobalKey<AppointmentCreateSelectCarFormState>();
final appointmentServicesStateKey =
    new GlobalKey<AppointmentCreateServicesFormState>();
final appointmentIssuesStateKey =
    new GlobalKey<AppointmentCreateIssueFormState>();
final appointmentShopsStateKey =
    new GlobalKey<AppointmentCreateProvidersFormState>();
final appointmentDateTimeStateKey =
    new GlobalKey<AppointmentDateTimeFormState>();

class AppointmentCreateModal extends StatefulWidget {
  final Function createAppointment;
  final bool showCarSelection;
  final Car selectedCar;

  Map<int, dynamic> _stepStateData;

  AppointmentCreateModal(this.createAppointment, this.showCarSelection,
      [this.selectedCar]) {
    _generateStateData();
  }

  void _generateStateData() {
    if (!this.showCarSelection) {
      _stepStateData = {
        0: {"state": StepState.indexed, "active": true, "title": Text("")},
        1: {"state": StepState.disabled, "active": false, "title": Text("")},
        2: {"state": StepState.disabled, "active": false, "title": Text("")},
        3: {"state": StepState.disabled, "active": false, "title": Text("")},
      };
    } else {
      _stepStateData = {
        0: {"state": StepState.indexed, "active": true, "title": Text("")},
        1: {"state": StepState.disabled, "active": false, "title": Text("")},
        2: {"state": StepState.disabled, "active": false, "title": Text("")},
        3: {"state": StepState.disabled, "active": false, "title": Text("")},
        4: {"state": StepState.disabled, "active": false, "title": Text("")},
      };
    }
  }

  @override
  _AppointmentCreateModalState createState() => _AppointmentCreateModalState();
}

class _AppointmentCreateModalState extends State<AppointmentCreateModal> {
  static const FORM_HEIGHT_PERCENTAGE = .58;

  int _currentStepIndex = 0;
  bool isLastStep = false;
  List<Step> steps = [];

  FlatButton btnPrev;
  RaisedButton btnNext;

  ProviderServiceProvider providerServiceProvider;

  bool _initDone = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    providerServiceProvider.authUser = authProvider.authUser;

    if (widget.selectedCar != null) {
      providerServiceProvider.selectedCar = widget.selectedCar;
    }

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
      providerServiceProvider = Provider.of<ProviderServiceProvider>(context);
      _loadData();
    }
    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await providerServiceProvider.loadServices().then((_) async {
        if (widget.showCarSelection) {
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
        : _buildStepper(context);
  }

  Widget _buildStepper(BuildContext context) => Stepper(
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
            btnPrev = FlatButton(
              child: Text(S.of(context).general_back),
              onPressed: onStepCancel,
            ),
            btnNext = RaisedButton(
              elevation: 0,
              child: isLastStep
                  ? Text(S.of(context).general_add)
                  : Text(S.of(context).general_continue),
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

  List<Step> _buildSteps(BuildContext context) {
    if (widget.showCarSelection) {
      return [
        Step(
          isActive: widget._stepStateData[0]["active"],
          title: _currentStepIndex == 0
              ? Text(S.of(context).appointment_create_step0)
              : Text(''),
          content: AppointmentCreateSelectCarForm(
              key: appointmentCarSelectionStateKey),
          state: widget._stepStateData[0]['state'],
        ),
        Step(
            isActive: widget._stepStateData[1]['active'],
            title: _currentStepIndex == 1
                ? Text(S.of(context).appointment_create_step1)
                : Text(''),
            content: AppointmentCreateServicesForm(
              key: appointmentServicesStateKey,
              serviceItems: providerServiceProvider.serviceItems,
            ),
            state: widget._stepStateData[1]['state']),
        Step(
            isActive: widget._stepStateData[2]['active'],
            title: _currentStepIndex == 2
                ? Text(S.of(context).appointment_create_step2)
                : Text(''),
            content: AppointmentCreateIssueForm(key: appointmentIssuesStateKey),
            state: widget._stepStateData[2]['state']),
        Step(
            isActive: widget._stepStateData[3]['active'],
            title: _currentStepIndex == 3
                ? Text(S.of(context).appointment_create_step3)
                : Text(''),
            content: AppointmentCreateProvidersForm(
              key: appointmentShopsStateKey,
            ),
            state: widget._stepStateData[3]['state']),
        Step(
            isActive: _currentStepIndex == 4,
            title: widget._stepStateData[4]['active']
                ? Text(S.of(context).appointment_create_step4)
                : Text(''),
            content: AppointmentDateTimeForm(key: appointmentDateTimeStateKey),
            state: widget._stepStateData[4]['state'])
      ];
    } else {
      return [
        Step(
            isActive: widget._stepStateData[0]['active'],
            title: _currentStepIndex == 0
                ? Text(S.of(context).appointment_create_step1)
                : Text(''),
            content: AppointmentCreateServicesForm(
              key: appointmentServicesStateKey,
              serviceItems: providerServiceProvider.serviceItems,
            ),
            state: widget._stepStateData[0]['state']),
        Step(
            isActive: widget._stepStateData[1]['active'],
            title: _currentStepIndex == 1
                ? Text(S.of(context).appointment_create_step2)
                : Text(''),
            content: AppointmentCreateIssueForm(key: appointmentIssuesStateKey),
            state: widget._stepStateData[1]['state']),
        Step(
            isActive: widget._stepStateData[2]['active'],
            title: _currentStepIndex == 2
                ? Text(S.of(context).appointment_create_step3)
                : Text(''),
            content: AppointmentCreateProvidersForm(
              key: appointmentShopsStateKey,
            ),
            state: widget._stepStateData[2]['state']),
        Step(
            isActive: _currentStepIndex == 3,
            title: widget._stepStateData[3]['active']
                ? Text(S.of(context).appointment_create_step4)
                : Text(''),
            content: AppointmentDateTimeForm(key: appointmentDateTimeStateKey),
            state: widget._stepStateData[3]['state'])
      ];
    }
  }

  _next() {
    _resetStepTitles();

    if (widget.showCarSelection) {
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
    } else {
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
    if (!appointmentCarSelectionStateKey.currentState.valid()) {
    } else {
      setState(() {
        widget._stepStateData[_currentStepIndex]['state'] = StepState.complete;
        widget._stepStateData[_currentStepIndex + 1]['state'] =
            StepState.indexed;
        widget._stepStateData[_currentStepIndex + 1]['active'] = true;
        _goTo(_currentStepIndex + 1);
        isLastStep = false;
      });
    }
  }

  _servicesChecker() {
    if (!appointmentServicesStateKey.currentState.valid()) {
    } else {
      setState(() {
        widget._stepStateData[_currentStepIndex]['state'] = StepState.complete;
        widget._stepStateData[_currentStepIndex + 1]['state'] =
            StepState.indexed;
        widget._stepStateData[_currentStepIndex + 1]['active'] = true;
        _goTo(_currentStepIndex + 1);
        isLastStep = false;
      });
    }
  }

  _issuesChecker() async {
    if (!appointmentIssuesStateKey.currentState.valid()) {
    } else {
      try {
        await Provider.of<ProviderServiceProvider>(context, listen: false)
            .loadProviders();
      } catch (error) {
        if (error
            .toString()
            .contains(ProviderService.GET_PROVIDERS_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_get_providers, context);
        }
      }

      setState(() {
        widget._stepStateData[_currentStepIndex]['state'] = StepState.complete;
        widget._stepStateData[_currentStepIndex + 1]['state'] =
            StepState.indexed;
        widget._stepStateData[_currentStepIndex + 1]['active'] = true;
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
        widget._stepStateData[_currentStepIndex]['state'] = StepState.complete;
        widget._stepStateData[_currentStepIndex + 1]['state'] =
            StepState.indexed;
        widget._stepStateData[_currentStepIndex + 1]['active'] = true;
        _goTo(_currentStepIndex + 1);
        isLastStep = true;
      });
    }
  }

  _calendarChecker() {
    if (!appointmentDateTimeStateKey.currentState.valid()) {
    } else {
      setState(() {
        widget._stepStateData[_currentStepIndex]['state'] = StepState.complete;
        _submit();
      });
    }
  }

  _resetStepTitles() {
    for (int i = 0; i < widget._stepStateData.length; i++) {
      widget._stepStateData[i]['title'] = Text('');
    }
  }

  _back() {
    setState(() {
      if (_currentStepIndex > 0) {
        widget._stepStateData[_currentStepIndex]['state'] = StepState.disabled;
        widget._stepStateData[_currentStepIndex]['active'] = false;
        widget._stepStateData[_currentStepIndex - 1]['state'] =
            StepState.indexed;
        widget._stepStateData[_currentStepIndex - 1]['active'] = true;
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

  _submit() {
    AppointmentRequest appointmentRequest =
        providerServiceProvider.appointmentRequest();

    widget.createAppointment(appointmentRequest);
  }
}
