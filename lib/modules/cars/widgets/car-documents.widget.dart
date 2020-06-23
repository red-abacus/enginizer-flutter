import 'dart:io';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car-document.dart';
import 'package:app/modules/cars/models/recommendations/car-history.model.dart';
import 'package:app/modules/cars/providers/car.provider.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarDocumentsWidget extends StatefulWidget {
  final List<CarHistory> carHistory;

  CarDocumentsWidget({this.carHistory});

  @override
  State<StatefulWidget> createState() {
    return _CarDocumentsWidgetState();
  }
}

class _CarDocumentsWidgetState extends State<CarDocumentsWidget> {
  CarProvider _provider;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<CarProvider>(context);

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            margin: EdgeInsets.only(left: 10, top: 20, right: 10),
            child: Column(
              children: [
                _exhaustContainer(),
                _diagnosisContainer(),
                _generalVerificationContainer()
              ],
            ),
          );
  }

  _exhaustContainer() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () async {
          File file = await FilePicker.getFile(
            type: FileType.custom,
            allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
          );

          _loadDocument(CarDocument(file, S.of(context).car_create_exhaust_test));
        },
        child: Row(
          children: [
            Icon(
              Icons.attach_file,
              color: _provider.exhaust == null ? gray2 : red,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  S.of(context).car_create_exhaust_test,
                  style: TextHelper.customTextStyle(
                      color: _provider.exhaust != null ? red : gray2, size: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _diagnosisContainer() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () async {
          File file = await FilePicker.getFile(
            type: FileType.custom,
            allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
          );

          _loadDocument(CarDocument(file, S.of(context).car_create_diagnosis_protocol));
        },
        child: Row(
          children: [
            Icon(
              Icons.attach_file,
              color: _provider.diagnosisProtocol == null ? gray2 : red,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                S.of(context).car_create_diagnosis_protocol,
                style: TextHelper.customTextStyle(
                    color: _provider.diagnosisProtocol != null ? red : gray2,
                    size: 16),
              ),
            )
          ],
        ),
      ),
    );
  }

  _generalVerificationContainer() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () async {
          File file = await FilePicker.getFile(
            type: FileType.custom,
            allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
          );

          _loadDocument(CarDocument(
              file, S.of(context).car_create_general_car_verification));
        },
        child: Row(
          children: [
            Icon(
              Icons.attach_file,
              color: _provider.generalVerification == null ? gray2 : red,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                S.of(context).car_create_general_car_verification,
                style: TextHelper.customTextStyle(
                    color: _provider.generalVerification != null ? red : gray2,
                    size: 16),
              ),
            )
          ],
        ),
      ),
    );
  }

  _loadDocument(CarDocument document) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider.uploadDocument(_provider.carDetails.id, document).then((item){

      });
    }
    catch (error) {
      if (error.toString().contains(CarService.CAR_ADD_DOCUMENT_EXCEPTION)) {
        FlushBarHelper.showFlushBar(
            S.of(context).general_error,
            S.of(context).exception_add_car_document,
            context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
