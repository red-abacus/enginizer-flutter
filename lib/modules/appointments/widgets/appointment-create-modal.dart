import 'package:enginizer_flutter/generated/i18n.dart';
import 'package:enginizer_flutter/modules/appointments/model/request/appointment-request.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/forms/appointment-create-datetime.form.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/forms/appointment-create-issue.form.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/forms/appointment-create-providers.form.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/forms/appointment-create-services.form.dart';
import 'package:enginizer_flutter/modules/appointments/providers/appointments.provider.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:enginizer_flutter/modules/cars/providers/car.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  AppointmentCreateModal({this.createAppointment});

  @override
  _AppointmentCreateModalState createState() => _AppointmentCreateModalState();
}

class _AppointmentCreateModalState extends State<AppointmentCreateModal> {
  int _currentStepIndex = 0;
  bool isLastStep = false;
  List<Step> steps = [];

  Map<int, dynamic> _stepStateData = {
    0: {"state": StepState.indexed, "active": true, "title": Text("")},
    1: {"state": StepState.disabled, "active": false, "title": Text("")},
    2: {"state": StepState.disabled, "active": false, "title": Text("")},
    3: {"state": StepState.disabled, "active": false, "title": Text("")},
  };

  FlatButton btnPrev;
  RaisedButton btnNext;

  ProviderServiceProvider providerServiceProvider;
  AppointmentsProvider appointmentsProvider;

  @override
  Widget build(BuildContext context) {
    providerServiceProvider = Provider.of<ProviderServiceProvider>(context);
    appointmentsProvider = Provider.of<AppointmentsProvider>(context);

    steps = _buildSteps(context);

    return FractionallySizedBox(
        heightFactor: .8,
        child: Container(
          child: _buildStepper(context),
        ));
  }

  Widget _buildStepper(BuildContext context) => ClipRRect(
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
        child: Stepper(
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
            }),
      ),
    ),
  );

  List<Step> _buildSteps(BuildContext context) {
    return [
      Step(
          isActive: _stepStateData[0]['active'],
          title: _currentStepIndex == 0
              ? Text(S.of(context).appointment_create_step1)
              : Text(''),
          content: AppointmentCreateServicesForm(
            key: appointmentServicesStateKey,
            serviceItems: providerServiceProvider.serviceItems,
          ),
          state: _stepStateData[0]['state']),
      Step(
          isActive: _stepStateData[1]['active'],
          title: _currentStepIndex == 1
              ? Text(S.of(context).appointment_create_step2)
              : Text(''),
          content: AppointmentCreateIssueForm(key: appointmentIssuesStateKey),
          state: _stepStateData[1]['state']),
      Step(
          isActive: _stepStateData[2]['active'],
          title: _currentStepIndex == 2
              ? Text(S.of(context).appointment_create_step3)
              : Text(''),
          content: AppointmentCreateProvidersForm(
            key: appointmentShopsStateKey,
          ),
          state: _stepStateData[2]['state']),
      Step(
          isActive: _currentStepIndex == 3,
          title: _stepStateData[3]['active']
              ? Text(S.of(context).appointment_create_step4)
              : Text(''),
          content: AppointmentDateTimeForm(
              key: appointmentDateTimeStateKey,
              appointments: appointmentsProvider.appointments),
          state: _stepStateData[3]['state'])
    ];
  }

  _next() {
    _resetStepTitles();
    switch (_currentStepIndex) {
      case 0:
        if (!appointmentServicesStateKey.currentState.valid()) {
          return;
        } else {
          setState(() {
            _stepStateData[_currentStepIndex]['state'] = StepState.complete;
            _stepStateData[_currentStepIndex + 1]['state'] = StepState.indexed;
            _stepStateData[_currentStepIndex + 1]['active'] = true;
            _goTo(_currentStepIndex + 1);
            isLastStep = false;
          });
        }
        break;
      case 1:
        if (!appointmentIssuesStateKey.currentState.valid())
          return;
        else {
          ProviderServiceProvider provider = Provider.of<ProviderServiceProvider>(context, listen: false);
          List<int> serviceIds = [];

          for(ServiceItem serviceItem in provider.selectedServiceItems) {
            serviceIds.add(serviceItem.id);
          }

          print("service ids ${serviceIds}");

          provider.loadProvidersByServiceItems(serviceIds);

          setState(() {
            _stepStateData[_currentStepIndex]['state'] = StepState.complete;
            _stepStateData[_currentStepIndex + 1]['state'] = StepState.indexed;
            _stepStateData[_currentStepIndex + 1]['active'] = true;
            _goTo(_currentStepIndex + 1);
            isLastStep = false;
          });
        }
        break;
      case 2:
        if (!appointmentShopsStateKey.currentState.valid())
          return;
        else {
          setState(() {
            _stepStateData[_currentStepIndex]['state'] = StepState.complete;
            _stepStateData[_currentStepIndex + 1]['state'] = StepState.indexed;
            _stepStateData[_currentStepIndex + 1]['active'] = true;
            _goTo(_currentStepIndex + 1);
            isLastStep = true;
          });
        }
        break;
      case 3:
        if (!appointmentDateTimeStateKey.currentState.valid())
          return;
        else {
          setState(() {
            _stepStateData[_currentStepIndex]['state'] = StepState.complete;
            _submit();
          });
        }
        break;
    }
  }

  _resetStepTitles() {
    for (int i = 0; i < _stepStateData.length; i++) {
      _stepStateData[i]['title'] = Text('');
    }
  }

  _back() {
    setState(() {
      if (_currentStepIndex > 0) {
        _stepStateData[_currentStepIndex]['state'] = StepState.disabled;
        _stepStateData[_currentStepIndex]['active'] = false;
        _stepStateData[_currentStepIndex - 1]['state'] = StepState.indexed;
        _stepStateData[_currentStepIndex - 1]['active'] = true;
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
    AppointmentRequest appointmentRequest = providerServiceProvider.appointmentRequest();
    widget.createAppointment(appointmentRequest);
  }
}
