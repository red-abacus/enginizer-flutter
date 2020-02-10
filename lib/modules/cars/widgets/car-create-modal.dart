import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/cars/models/car-brand.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car-query.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:enginizer_flutter/modules/cars/providers/cars-make.provider.dart';
import 'package:enginizer_flutter/modules/cars/widgets/forms/car-extra.form.dart';
import 'package:enginizer_flutter/modules/cars/widgets/forms/car-make.form.dart';
import 'package:enginizer_flutter/modules/cars/widgets/forms/car-technical.form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final carMakeStateKey = new GlobalKey<CarMakeFormState>();
final carTechnicalStateKey = new GlobalKey<CarTechnicalFormState>();
final carExtraStateKey = new GlobalKey<CarExtraFormState>();

class CarCreateModal extends StatefulWidget {
  final List<CarBrand> brands;
  final Function addCar;

  CarCreateModal({this.brands = const [], this.addCar});

  @override
  _CarCreateModalState createState() => _CarCreateModalState();
}

class _CarCreateModalState extends State<CarCreateModal> {
  CarsMakeProvider carMakeProvider;
  int _currentStepIndex = 0;
  bool isLastStep = false;
  List<Step> steps = [];

  Map<int, dynamic> _stepStateData = {
    0: {"state": StepState.indexed, "active": true},
    1: {"state": StepState.disabled, "active": false},
    2: {"state": StepState.disabled, "active": false},
  };

  @override
  Widget build(BuildContext context) {
    steps = _buildSteps(context);
    carMakeProvider = Provider.of<CarsMakeProvider>(context);
    carMakeProvider.loadCarBrands();
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
                }),
          ),
        ),
      );

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
          var carMakeState = carMakeProvider.carMakeFormState;
          carMakeProvider
              .loadCarCylinderCapacity(CarQuery(
                  brand: carMakeState['brand'],
                  model: carMakeState['model'],
                  year: carMakeState['year'],
                  fuelType: carMakeState['fuelType']))
              .then((_) => {
                    setState(() {
                      _stepStateData[_currentStepIndex]['state'] =
                          StepState.complete;
                      _stepStateData[_currentStepIndex + 1]['state'] =
                          StepState.indexed;
                      _stepStateData[_currentStepIndex + 1]['active'] = true;
                      _goTo(_currentStepIndex + 1);
                      isLastStep = false;
                    })
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
    var car = Car(
        brand: carMakeProvider.carMakeFormState['brand'],
        model: carMakeProvider.carMakeFormState['model'],
        year: carMakeProvider.carMakeFormState['year'],
        fuelType: carMakeProvider.carMakeFormState['fuelType'],
        motor: carMakeProvider.carTechnicalFormState['cylinderCapacity'],
        power: carMakeProvider.carTechnicalFormState['power'],
        transmission: carMakeProvider.carTechnicalFormState['transmission'],
        color: carMakeProvider.carTechnicalFormState['color'],
        vin: carMakeProvider.carTechnicalFormState['vin'],
        registrationNumber:
            carMakeProvider.carExtraFormState['registrationNumber'],
        mileage: carMakeProvider.carExtraFormState['mileage'],
        rcaExpireDate: carMakeProvider.carExtraFormState['rcaExpiryDate'],
        itpExpireDate: carMakeProvider.carExtraFormState['itpExpiryDate']);

    widget.addCar(car);
  }
}
