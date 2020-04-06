import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/models/request/car-request.model.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:app/modules/cars/widgets/forms/car-extra.form.dart';
import 'package:app/modules/cars/widgets/forms/car-make.form.dart';
import 'package:app/modules/cars/widgets/forms/car-technical.form.dart';
import 'package:app/utils/locale.manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final carMakeStateKey = new GlobalKey<CarMakeFormState>();
final carTechnicalStateKey = new GlobalKey<CarTechnicalFormState>();
final carExtraStateKey = new GlobalKey<CarExtraFormState>();

class CarCreateModal extends StatefulWidget {
  final Function addCar;

  CarCreateModal({this.addCar});

  @override
  _CarCreateModalState createState() => _CarCreateModalState();
}

class _CarCreateModalState extends State<CarCreateModal> {
  CarsMakeProvider _carsMakeProvider;
  int _currentStepIndex = 0;
  bool isLastStep = false;
  List<Step> steps = [];

  bool _initDone = false;
  bool _isLoading = false;

  Map<int, dynamic> _stepStateData = {
    0: {"state": StepState.indexed, "active": true},
    1: {"state": StepState.disabled, "active": false},
    2: {"state": StepState.disabled, "active": false},
  };

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _carsMakeProvider = Provider.of<CarsMakeProvider>(context);

      setState(() {
        _isLoading = true;
      });

      _carsMakeProvider
          .loadCarBrands(CarQuery(language: LocaleManager.language(context)))
          .then((_) {
        _carsMakeProvider.loadCarColors().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });

      _initDone = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    steps = _buildSteps(context);

    return FractionallySizedBox(
        heightFactor: .8,
        child: Container(
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
                    child: _getBodyContainer()),
              ),
            )));
  }

  _getBodyContainer() {
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
            FlatButton(
              child: Text(S.of(context).general_back),
              onPressed: onStepCancel,
            ),
            RaisedButton(
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
    return [
      Step(
          isActive: _stepStateData[0]['active'],
          title: Text(S.of(context).cars_create_step1),
          content: CarMakeForm(key: carMakeStateKey),
          state: _stepStateData[0]['state']),
      Step(
          isActive: _stepStateData[1]['active'],
          title: Text(S.of(context).cars_create_step2),
          content: CarTechnicalForm(key: carTechnicalStateKey),
          state: _stepStateData[1]['state']),
      Step(
          isActive: _stepStateData[2]['active'],
          title: Text(S.of(context).cars_create_step3),
          content: CarExtraForm(key: carExtraStateKey),
          state: _stepStateData[2]['state'])
    ];
  }

  _next() {
    switch (_currentStepIndex) {
      case 0:
        if (!carMakeStateKey.currentState.valid()) {
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
        if (!carTechnicalStateKey.currentState.valid()) {
          return;
        } else {
          setState(() {
            _stepStateData[_currentStepIndex]['state'] = StepState.complete;
            _stepStateData[_currentStepIndex + 1]['state'] = StepState.indexed;
            _stepStateData[_currentStepIndex + 1]['active'] = true;
            _goTo(_currentStepIndex + 1);
            isLastStep = true;
          });
        }
        break;
      case 2:
        if (!carExtraStateKey.currentState.valid()) {
          return;
        } else {
          setState(() {
            _submit();
          });
        }
    }
  }

  _back() {
    if (_currentStepIndex > 0) {
      _goTo(_currentStepIndex - 1);
    }
  }

  _goTo(stepIndex) {
    if (_stepStateData[stepIndex]['state'] == StepState.complete) {
      return;
    } else {
      setState(() {
        _currentStepIndex = stepIndex;
      });
    }
  }

  _submit() {
    var carRequest = CarRequest(
        carBrand: _carsMakeProvider.carMakeFormState['brand'],
        carModel: _carsMakeProvider.carMakeFormState['model'],
        carType: _carsMakeProvider.carTechnicalFormState['type'],
        carYear: _carsMakeProvider.carTechnicalFormState['year'],
        carFuelType: _carsMakeProvider.carTechnicalFormState['fuelType'],
        carColor: _carsMakeProvider.carTechnicalFormState['color'],
        carVariant: _carsMakeProvider.carTechnicalFormState['variant'],
        vin: _carsMakeProvider.carTechnicalFormState['vin'],
        registrationNumber:
        _carsMakeProvider.carExtraFormState['registrationNumber'],
        mileage: int.parse(_carsMakeProvider.carExtraFormState['mileage']),
        rcaExpiryDate: _carsMakeProvider.carExtraFormState['rcaExpiryDate'],
        itpExpiryDate: _carsMakeProvider.carExtraFormState['itpExpiryDate']);

    widget.addCar(carRequest);
  }
}
