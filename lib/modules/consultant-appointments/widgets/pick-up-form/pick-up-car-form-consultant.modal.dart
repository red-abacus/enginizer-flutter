import 'dart:io';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/consultant-appointments/providers/pick-up-car-form-consultant.provider.dart';
import 'package:app/modules/consultant-appointments/widgets/pick-up-form/image-selection.widget.dart';
import 'package:app/modules/consultant-appointments/widgets/pick-up-form/pick-up-car-form-employees.widget.dart';
import 'package:app/modules/consultant-appointments/widgets/pick-up-form/pick-up-car-form-information.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PickUpCarFormConsultantWidget extends StatefulWidget {
  final AppointmentDetail appointmentDetail;

  PickUpCarFormConsultantWidget({Key key, this.appointmentDetail})
      : super(key: key);

  @override
  _PickUpCarFormConsultantWidgetState createState() =>
      _PickUpCarFormConsultantWidgetState();
}

class _PickUpCarFormConsultantWidgetState
    extends State<PickUpCarFormConsultantWidget> {
  bool _initDone = false;
  bool _isLoading = false;
  int _currentStepIndex = 0;

  PickUpCarFormConsultantProvider _provider;

  List<Step> steps = [];

  @override
  Widget build(BuildContext context) {
    steps = _buildSteps(context);
    return _getContent();
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<PickUpCarFormConsultantProvider>(context);
      _provider.resetParams();

      setState(() {
        _isLoading = true;
      });

      _loadData();
    }

    if (_provider.receiveFormRequest.files == null) {
      _provider.resetParams();
    }

    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    String startDate = DateUtils.stringFromDate(DateTime.now(), 'dd/MM/yyyy');
    String endDate = startDate;

    String scheduleDateTime = widget.appointmentDetail.scheduledDate;

    if (scheduleDateTime.isNotEmpty) {
      DateTime dateTime = DateUtils.dateFromString(
          scheduleDateTime, AppointmentDetail.scheduledTimeFormat());

      if (dateTime != null) {
        startDate = DateUtils.stringFromDate(dateTime, 'dd/MM/yyyy');
        endDate = startDate;
      }
    }

    try {
      await _provider.getProviderEmployees(
          widget.appointmentDetail.serviceProvider.id, startDate, endDate).then((_) {
            setState(() {
              _isLoading = false;
            });
      });
    }
    catch (error) {
      if (error
          .toString()
          .contains(ProviderService.GET_PROVIDER_EMPLOYEES_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_provider_employees, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _getContent() {
    return _isLoading ? Center(child: CircularProgressIndicator()) : _buildStepper();
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
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      cropImage(index, image, context);
    }
  }

  cropImage(int index, image, BuildContext context) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop image',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    setState(() {
      if (index < _provider.receiveFormRequest.files.length) {
        _provider.receiveFormRequest.files[index] = croppedFile;

        if (_provider.receiveFormRequest.files.length < _provider.maxFiles) {
          _provider.receiveFormRequest.files.add(null);
        }
      }
    });
  }

  List<Step> _buildSteps(BuildContext context) {
    return [
      Step(
          isActive: _currentStepIndex == 0,
          title: Text(_currentStepIndex == 0
              ? S.of(context).appointment_receive_car_step_1
              : ''),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  S.of(context).appointment_consultant_car_form_photos_title,
                  style: TextHelper.customTextStyle(
                      null, red, FontWeight.bold, 16),
                ),
                ImageSelectionWidget(addImage: _addImage),
              ],
            ),
          ),
          state: StepState.indexed),
      Step(
          isActive: _currentStepIndex == 1,
          title: Text(_currentStepIndex == 1
              ? S.of(context).appointment_receive_car_step_2
              : ''),
          content: PickupCarFormInformationWidget(),
          state: StepState.indexed),
      Step(
          isActive: _currentStepIndex == 2,
          title: Text(_currentStepIndex == 2
              ? S.of(context).appointment_receive_car_step_3
              : ''),
          content: PickUpCarFormEmployeesWidget(),
          state: StepState.indexed)
    ];
  }

  _next() {
    switch (_currentStepIndex) {
      case 0:
        _goTo(1);
        break;
      case 1:
        if (_provider.informationFormState.currentState.validate()) {
          _goTo(2);
        }
        break;
      case 2:
        if (_provider.selectedTimeSerie != null) {
          _createReceiveForm();
        }
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

  _createReceiveForm() {
  }
}
