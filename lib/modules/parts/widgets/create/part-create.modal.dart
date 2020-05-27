import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/appointments/widgets/pick-up-form/image-selection.widget.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/services/car-make.service.dart';
import 'package:app/modules/parts/providers/part-create.provider.dart';
import 'package:app/modules/parts/widgets/create/part-create-car-details.widget.dart';
import 'package:app/modules/parts/widgets/create/part-create-info.widget.dart';
import 'package:app/modules/shared/widgets/image-picker.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/locale.manager.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartCreateModal extends StatefulWidget {
  final Function refreshState;

  PartCreateModal({Key key, this.refreshState}) : super(key: key);

  @override
  _PartCreateModalState createState() => _PartCreateModalState();
}

class _PartCreateModalState extends State<PartCreateModal> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _initDone = false;
  bool _isLoading = false;
  int _currentStepIndex = 0;

  PartCreateProvider _provider;

  List<Step> steps = [];

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
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0))),
            child: Theme(
              data: ThemeData(
                  accentColor: Theme.of(context).primaryColor,
                  primaryColor: Theme.of(context).primaryColor),
              child: _getContent(),
            ),
          ),
        )));
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<PartCreateProvider>(context);
      _provider.initialise();
      _provider.formState = _formKey;

      setState(() {
        _isLoading = true;
      });

      _loadData();
    }

    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _provider
          .loadCarBrands(CarQuery(language: LocaleManager.language(context)))
          .then((_) async {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(CarMakeService.LOAD_CAR_BRANDS_FAILED_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_load_car_brands, context);
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
              setState(() {
                if (file != null) {
                  if (index < _provider.request.files.length) {
                    _provider.request.files[index] = file;

                    if (_provider.request.files.length < _provider.maxFiles) {
                      _provider.request.files.add(null);
                    }
                  }
                }
              });
            }));
  }

  List<Step> _buildSteps(BuildContext context) {
    return [
      Step(
          isActive: _currentStepIndex == 0,
          title: Text(_currentStepIndex == 0
              ? S.of(context).part_create_step_title_1
              : ''),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  S.of(context).part_create_form_photos_title,
                  style: TextHelper.customTextStyle(
                      null, red, FontWeight.bold, 16),
                ),
                ImageSelectionWidget(
                    addImage: _addImage, files: _provider.request.files),
              ],
            ),
          ),
          state: StepState.indexed),
      Step(
          isActive: _currentStepIndex == 1,
          title: Text(_currentStepIndex == 1
              ? S.of(context).part_create_step_title_2
              : ''),
          content: PartCreateCarDetailsWidget(),
          state: StepState.indexed),
      Step(
          isActive: _currentStepIndex == 2,
          title: Text(_currentStepIndex == 2
              ? S.of(context).part_create_step_title_3
              : ''),
          content: PartCreateInfoWidget(),
          state: StepState.indexed),
    ];
  }

  _next() {
    switch (_currentStepIndex) {
      case 0:
        _goTo(1);
        break;
      case 1:
//        if (_provider.formState.currentState.validate()) {
//        }
        _goTo(2);
        break;
      case 2:
        if (_provider.formState.currentState.validate()) {
          _createPart();
        }
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

  _createPart() async {
    int providerId = Provider.of<Auth>(context).authUser.providerId;

    setState(() {
      _isLoading = true;
    });

    try {
      await _provider.addProviderItem(providerId).then((_) {
        widget.refreshState();
        Navigator.pop(context);
      });
    } catch (error) {
      if (error
          .toString()
          .contains(ProviderService.CREATE_PROVIDER_ITEM_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_create_provider_item, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
