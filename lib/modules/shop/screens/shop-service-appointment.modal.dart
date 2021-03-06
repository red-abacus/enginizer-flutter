import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/promotions/services/promotion.service.dart';
import 'package:app/modules/shop/enums/shop-appointment-type.enum.dart';
import 'package:app/modules/shop/providers/shop-appointment.provider.dart';
import 'package:app/modules/shop/widgets/service/shop-service-appointment-cars.widget.dart';
import 'package:app/modules/shop/widgets/service/shop-service-appointment-pickup-map.widget.dart';
import 'package:app/modules/shop/widgets/service/shop-service-appointment-return-map.widget.dart';
import 'package:app/modules/shop/widgets/service/shop-service-appointment-scheduler.widget.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopServiceAppointmentModal extends StatefulWidget {
  @override
  _ShopServiceAppointmentModalState createState() =>
      _ShopServiceAppointmentModalState();
}

class _ShopServiceAppointmentModalState
    extends State<ShopServiceAppointmentModal> {
  bool _initDone = false;
  bool _isLoading = false;

  int _currentStepIndex = 0;
  bool _isLastStep = false;
  List<Step> _steps = [];

  Map<int, dynamic> _stepStateData = {
    0: {"state": StepState.indexed, "active": true},
    1: {"state": StepState.disabled, "active": false},
    2: {"state": StepState.disabled, "active": false},
    3: {"state": StepState.disabled, "active": false},
  };

  ShopAppointmentProvider _provider;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: .8,
        child: Scaffold(
          body: Container(
            child: ClipRRect(
              child: Container(
                decoration:
                    new BoxDecoration(color: Theme.of(context).cardColor),
                child: Theme(
                    data: ThemeData(
                        accentColor: Theme.of(context).primaryColor,
                        primaryColor: Theme.of(context).primaryColor),
                    child: _buildContent(context)),
              ),
            ),
          ),
        ));
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<ShopAppointmentProvider>(context);

      setState(() {
        _isLoading = true;
      });

      _loadData();
      _initDone = true;
    }

    super.didChangeDependencies();
  }

  _buildContent(BuildContext context) {
    _steps = _buildSteps(context);

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _contentWidget();
  }

  _loadData() async {
    try {
      await _provider.loadCars().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error.toString().contains(CarService.CAR_GET_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_car_get, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Step> _buildSteps(BuildContext context) {
    List<Step> steps = [
      Step(
          isActive: _stepStateData[0]['active'],
          title: Text(_currentStepIndex == 0
              ? S.of(context).online_shop_appointment_step_1_title
              : ''),
          content: ShopServiceAppointmentCarsWidget(
              searchCars: _searchCars, selectCar: _selectCar),
          state: _stepStateData[0]['state'])
    ];

    switch (_provider.shopItem.getShopAppointmentType()) {
      case ShopAppointmentType.Simple:
        steps.addAll([
          Step(
              isActive: _stepStateData[1]['active'],
              title: Text(_currentStepIndex == 1
                  ? S.of(context).online_shop_appointment_step_4_title
                  : ''),
              content: ShopServiceAppointmentSchedulerWidget(),
              state: _stepStateData[1]['state'])
        ]);
        break;
      case ShopAppointmentType.Location:
        steps.addAll([
          Step(
              isActive: _stepStateData[1]['active'],
              title: Text(_currentStepIndex == 1
                  ? S.of(context).online_shop_appointment_step_5_title
                  : ''),
              content: ShopServiceAppointmentPickupMapWidget(),
              state: _stepStateData[1]['state']),
          Step(
              isActive: _stepStateData[2]['active'],
              title: Text(_currentStepIndex == 2
                  ? S.of(context).online_shop_appointment_step_6_title
                  : ''),
              content: ShopServiceAppointmentReturnMapWidget(),
              state: _stepStateData[2]['state']),
          Step(
              isActive: _stepStateData[3]['active'],
              title: Text(_currentStepIndex == 3
                  ? S.of(context).online_shop_appointment_step_4_title
                  : ''),
              content: ShopServiceAppointmentSchedulerWidget(),
              state: _stepStateData[3]['state'])
        ]);
        break;
      case ShopAppointmentType.Rca:
        // TODO
        break;
    }
    return steps;
  }

  _contentWidget() {
    return Stack(
      children: <Widget>[_buildStepper(), _bottomButtonsWidget()],
    );
  }

  Widget _buildStepper() => Stepper(
      currentStep: _currentStepIndex,
      onStepContinue: _next,
      onStepCancel: _back,
      onStepTapped: (step) => _goTo(step),
      type: StepperType.horizontal,
      steps: _steps,
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
            FlatButton(
              child: Text(S.of(context).general_back),
              onPressed: _back,
            ),
            FlatButton(
              child: _isLastStep
                  ? Text(S.of(context).general_create)
                  : Text(S.of(context).general_continue),
              onPressed: _next,
            )
          ],
        ),
      ),
    );
  }

  _next() {
    switch (_provider.shopItem.getShopAppointmentType()) {
      case ShopAppointmentType.Simple:
        switch (_currentStepIndex) {
          case 0:
            if (_provider.selectedCar != null) {
              _stepStateData[_currentStepIndex]['state'] = StepState.complete;
              _stepStateData[_currentStepIndex + 1]['state'] =
                  StepState.indexed;
              _stepStateData[_currentStepIndex + 1]['active'] = true;
              _goTo(_currentStepIndex + 1);
              _isLastStep = true;
            }
            break;
          case 1:
            _stepStateData[_currentStepIndex]['state'] = StepState.complete;
            _stepStateData[_currentStepIndex + 1]['state'] = StepState.indexed;
            _stepStateData[_currentStepIndex + 1]['active'] = true;
            _submit();
            break;
        }
        break;
        break;
      case ShopAppointmentType.Location:
        switch (_currentStepIndex) {
          case 0:
            if (_provider.selectedCar != null) {
              _stepStateData[_currentStepIndex]['state'] = StepState.complete;
              _stepStateData[_currentStepIndex + 1]['state'] =
                  StepState.indexed;
              _stepStateData[_currentStepIndex + 1]['active'] = true;
              _goTo(_currentStepIndex + 1);
              _isLastStep = false;
            }
            break;
          case 1:
            _stepStateData[_currentStepIndex]['state'] = StepState.complete;
            _stepStateData[_currentStepIndex + 1]['state'] = StepState.indexed;
            _stepStateData[_currentStepIndex + 1]['active'] = true;
            _goTo(_currentStepIndex + 1);
            _isLastStep = false;
            break;
          case 2:
            if (_provider.pickupPosition.latLng != null) {
              _stepStateData[_currentStepIndex]['state'] = StepState.complete;
              _stepStateData[_currentStepIndex + 1]['state'] =
                  StepState.indexed;
              _stepStateData[_currentStepIndex + 1]['active'] = true;
              _goTo(_currentStepIndex + 1);
              _isLastStep = true;
            }
            break;
          case 3:
            if (_provider.returnPosition.latLng != null) {
              _stepStateData[_currentStepIndex]['state'] = StepState.complete;
              _submit();
            }
            break;
        }
        break;
      case ShopAppointmentType.Rca:
        break;
    }
  }

  _back() {
    if (_currentStepIndex > 0) {
      _stepStateData[_currentStepIndex]['state'] = StepState.disabled;
      _stepStateData[_currentStepIndex]['active'] = false;
      _stepStateData[_currentStepIndex - 1]['state'] = StepState.indexed;
      _stepStateData[_currentStepIndex - 1]['active'] = true;
      _goTo(_currentStepIndex - 1);
      _isLastStep = false;
    } else {
      Navigator.of(context).pop();
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

  _submit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .usePromotion(_provider.getUsePromotionRequest())
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      });
    } catch (error) {
      if (error.toString().contains(PromotionService.USE_PROMOTION_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_use_promotion, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _searchCars(String searchString) {
    _provider.selectedCar = null;
    _provider.searchString = searchString;
    _loadData();
  }

  _selectCar(Car car) {
    setState(() {
      _provider.selectedCar = car;
    });
  }
}
