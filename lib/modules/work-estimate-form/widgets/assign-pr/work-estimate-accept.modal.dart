import 'dart:math';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment/appointment-provider-type.dart';
import 'package:app/modules/work-estimate-form/enums/transport-request.model.dart';
import 'package:app/modules/work-estimate-form/enums/work-estimate-accept-state.enum.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate-accept.provider.dart';
import 'package:app/modules/work-estimate-form/widgets/assign-pr/work-estimate-accept-map.form.dart';
import 'package:app/modules/work-estimate-form/widgets/assign-pr/work-estimate-accept-service-providers.form.dart';
import 'package:app/modules/work-estimate-form/widgets/assign-pr/work-estimate-accept-transport.form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final workEstimateAcceptServiceProvidersKey =
    new GlobalKey<WorkEstimateAcceptServiceProvidersFormState>();

class WorkEstimateAcceptModal extends StatefulWidget {
  final Function acceptWorkEstimate;

  WorkEstimateAcceptModal({this.acceptWorkEstimate});

  @override
  _WorkEstimateAcceptModalState createState() =>
      _WorkEstimateAcceptModalState();
}

class _WorkEstimateAcceptModalState extends State<WorkEstimateAcceptModal> {
  int _currentStepIndex = 0;
  bool isLastStep = true;
  List<Step> steps = [];

  FlatButton btnPrev;
  RaisedButton btnNext;

  WorkEstimateAcceptProvider _provider;

  bool _initDone = false;
  bool _isLoading = false;

  Key _stepperKey = Key(Random.secure().nextDouble().toString());

  @override
  Widget build(BuildContext context) {
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
      _provider = Provider.of<WorkEstimateAcceptProvider>(context);
      _loadData();
    }
    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
//    try {
//      await _provider.loadServices().then((_) async {
//        if (_provider.selectedCar == null) {
//          await Provider.of<CarsProvider>(context).loadCars().then((_) {
//            setState(() {
//              _isLoading = false;
//            });
//          });
//        } else {
//          setState(() {
//            _isLoading = false;
//          });
//        }
//      });
//    } catch (error) {
//      if (error.toString().contains(ProviderService.GET_SERVICES_EXCEPTION)) {
//        FlushBarHelper.showFlushBar(S.of(context).general_error,
//            S.of(context).exception_get_services, context);
//      }
//
//      setState(() {
//        _isLoading = false;
//      });
//    }
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

    steps = [
      Step(
        isActive: _provider.stepStateData[0]["active"],
        title: _currentStepIndex == 0
            ? Text(S.of(context).estimator_accept_modal_step1_title)
            : Text(''),
        content: WorkEstimateAcceptTransportForm(refreshState: _refreshState),
        state: _provider.stepStateData[0]['state'],
      ),
    ];

    if (_provider.workEstimateAcceptState == WorkEstimateAcceptState.PickUp) {
      steps.add(Step(
        isActive: _provider.stepStateData[1]["active"],
        title: _currentStepIndex == 1
            ? Text(S.of(context).estimator_accept_modal_step2_title)
            : Text(''),
        content: WorkEstimateAcceptMapForm(),
        state: _provider.stepStateData[1]['state'],
      ));

      steps.add(Step(
        isActive: _provider.stepStateData[2]["active"],
        title: _currentStepIndex == 2
            ? Text(S.of(context).estimator_accept_modal_step3_title)
            : Text(''),
        content: WorkEstimateAcceptServiceProvidersForm(
            key: workEstimateAcceptServiceProvidersKey),
        state: _provider.stepStateData[2]['state'],
      ));
    }

    return steps;
  }

  _next() {
    _resetStepTitles();

    switch (_currentStepIndex) {
      case 0:
        _carChecker();
        break;
      case 1:
        _mapChecker();
        break;
      case 2:
        _serviceProviderChecker();
        break;
    }
  }

  _carChecker() {
    if (_provider.workEstimateAcceptState == WorkEstimateAcceptState.Personal) {
      _submit();
    } else if (_provider.workEstimateAcceptState ==
        WorkEstimateAcceptState.PickUp) {
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

  _mapChecker() {
    if (_provider.appointmentPosition.isValid()) {
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

  _serviceProviderChecker() async {
    if (workEstimateAcceptServiceProvidersKey.currentState.valid()) {
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

  _refreshState() {
    setState(() {
      isLastStep = false;
      _stepperKey = Key(Random.secure().nextDouble().toString());
    });
  }

  _submit() async {
    Navigator.pop(context);

    if (_provider.workEstimateAcceptState == WorkEstimateAcceptState.Personal) {
      widget.acceptWorkEstimate();
    } else {
      TransportRequest transportRequest = new TransportRequest(
          appointmentPosition: _provider.appointmentPosition,
          serviceProvider: _provider.appointmentProviderType ==
                  AppointmentProviderType.Specific
              ? _provider.selectedProvider
              : null);

      widget.acceptWorkEstimate(transportRequest: transportRequest);
    }
  }
}
