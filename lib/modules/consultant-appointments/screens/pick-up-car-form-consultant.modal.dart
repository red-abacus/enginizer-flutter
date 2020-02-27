import 'dart:io';

import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/enums/tank-quantity.enum.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/providers/pick-up-car-form-consultant.provider.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/widgets/pick-up-form/image-selection.widget.dart';
import 'package:enginizer_flutter/modules/shared/widgets/custom-text-form-field.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PickUpCarFormConsultantModal extends StatefulWidget {
  PickUpCarFormConsultantModal({Key key}) : super(key: key);

  @override
  PickUpCarFormConsultantModalState createState() =>
      PickUpCarFormConsultantModalState();
}

class PickUpCarFormConsultantModalState
    extends State<PickUpCarFormConsultantModal> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _initDone = false;

  PickUpCarFormConsultantProvider _provider;

  @override
  Widget build(BuildContext context) {
    return Consumer<PickUpCarFormConsultantProvider>(
        builder: (context, provider, _) => FractionallySizedBox(
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
                  child: _content(),
                ),
              ),
            ))));
  }

  @override
  void didChangeDependencies() {
    _provider = Provider.of<PickUpCarFormConsultantProvider>(context);

    if (!_initDone) {
      _provider.resetParams();
    }

    if (_provider.files == null) {
      _provider.resetParams();
    }

    _initDone = true;
    super.didChangeDependencies();
  }

  _content() {
    return SingleChildScrollView(
        child: Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _addTitle(
                S.of(context).appointment_consultant_car_form_photos_title),
            ImageSelectionWidget(addImage: _addImage),
            _getForm(),
          ],
        ),
      ),
    ));
  }

  _addTitle(String title) {
    return Container(
      child: Text(
        title,
        style: TextHelper.customTextStyle(null, red, FontWeight.bold, 16),
      ),
    );
  }

  _getForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CustomTextFormField(
              labelText: S.of(context).appointment_consultant_car_form_real_km,
              listener: (value) {
                _provider.km = value;
              },
              currentValue: _provider.km,
              errorText:
                  S.of(context).appointment_consultant_car_form_real_km_error,
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: DropdownButtonFormField(
                hint: Text(
                    S.of(context).appointment_consultant_car_form_tank_quantity),
                items: _buildTankQuantityDropdownItems(),
                value: _provider.tankQuantity,
                validator: (value) {
                  if (value == null) {
                    return S
                        .of(context)
                        .appointment_consultant_car_form_tank_quantity_error;
                  } else {
                    return null;
                  }
                },
                onChanged: (newValue) {
                  setState(() {
                    _provider.tankQuantity = newValue;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<TankQuantity>> _buildTankQuantityDropdownItems() {
    List<DropdownMenuItem<TankQuantity>> quantityDropdownList = [];

    TankQuantityUtils.tankQuantities().forEach((tankQuantity) {
      quantityDropdownList.add(DropdownMenuItem(
          value: tankQuantity,
          child: Text(
              TankQuantityUtils.titleForTankQuantity(context, tankQuantity))));
    });

    return quantityDropdownList;
  }

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
      if (index < _provider.files.length) {
        _provider.files[index] = croppedFile;

        if (_provider.files.length < _provider.maxFiles) {
          _provider.files.add(null);
        }
      }
      ;
    });
  }
}
