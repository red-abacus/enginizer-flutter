import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:app/modules/cars/services/car-make.service.dart';
import 'package:app/modules/shared/widgets/alert-warning-dialog.dart';
import 'package:app/modules/shop/widgets/create-alert/shop-alert-create-identification.form.dart';
import 'package:app/modules/shop/widgets/create-alert/shop-alert-create-technical.form.dart';
import 'package:app/modules/shop/widgets/create-alert/shop-alert-preview.form.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/locale.manager.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopAlertCreateModal extends StatefulWidget {
  @override
  _ShopAlertCreateModalState createState() => _ShopAlertCreateModalState();
}

class _ShopAlertCreateModalState extends State<ShopAlertCreateModal> {
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

      _loadData();

      _initDone = true;
    }
    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _carsMakeProvider
          .loadCarBrands(CarQuery(language: LocaleManager.language(context)))
          .then((_) async {
        await _carsMakeProvider.loadCarColors().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(CarMakeService.LOAD_CAR_BRANDS_FAILED_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_load_car_brands, context);
      } else if (error
          .toString()
          .contains(CarMakeService.LOAD_CAR_COLOR_FAILED_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_load_car_colors, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    steps = _buildSteps(context);

    return FractionallySizedBox(
      heightFactor: .8,
      child: Container(
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(5.0),
          child: Scaffold(
            body: Container(
              decoration: new BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0))),
              child: Theme(
                  data: ThemeData(
                      accentColor: Theme.of(context).primaryColor,
                      primaryColor: Theme.of(context).primaryColor),
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Stack(
                          children: [
                            _buildStepper(context),
                            _buildBottomButtons()
                          ],
                        )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepper(BuildContext context) => Stepper(
      currentStep: _currentStepIndex,
      onStepContinue: _next,
      onStepCancel: _back,
      type: StepperType.horizontal,
      steps: steps,
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Container();
      });

  List<Step> _buildSteps(BuildContext context) {
    return [
      Step(
          isActive: _stepStateData[0]['active'],
          title: Text(S.of(context).cars_create_step1),
          content: ShopAlertCreateIdentificationForm(),
          state: _stepStateData[0]['state']),
      Step(
          isActive: _stepStateData[1]['active'],
          title: Text(S.of(context).cars_create_step2),
          content: ShopAlertCreateTechnicalForm(),
          state: _stepStateData[1]['state']),
      Step(
          isActive: _stepStateData[2]['active'],
          title: Text(S.of(context).general_preview),
          content: ShopAlertPreviewForm(),
          state: _stepStateData[2]['state']),
    ];
  }

  _next() {
    switch (_currentStepIndex) {
      case 0:
        setState(() {
          _stepStateData[_currentStepIndex]['state'] = StepState.complete;
          _stepStateData[_currentStepIndex + 1]['state'] = StepState.indexed;
          _stepStateData[_currentStepIndex + 1]['active'] = true;
          _goTo(_currentStepIndex + 1);
        });
        break;
      case 1:
        if (_carsMakeProvider.validShopAlert()) {
          _stepStateData[_currentStepIndex]['state'] = StepState.complete;
          _stepStateData[_currentStepIndex + 1]['state'] = StepState.indexed;
          _stepStateData[_currentStepIndex + 1]['active'] = true;
          isLastStep = true;
          _goTo(2);
        } else {
          AlertWarningDialog.showAlertDialog(context,
              S.of(context).general_warning, S.of(context).online_shop_alert);
        }
        break;
      case 2:
        _submit();
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

  _buildBottomButtons() {
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
            RaisedButton(
              elevation: 0,
              child: isLastStep
                  ? Text(S.of(context).general_add)
                  : Text(S.of(context).general_continue),
              textColor: Theme.of(context).cardColor,
              onPressed: _next,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: red,
            )
          ],
        ),
      ),
    );
  }

  _submit() {

  }
}
