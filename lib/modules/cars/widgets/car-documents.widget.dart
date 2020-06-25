import 'dart:convert';
import 'dart:io';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/auctions/enum/car-document-type.enum.dart';
import 'package:app/modules/cars/models/car-document.dart';
import 'package:app/modules/cars/models/recommendations/car-history.model.dart';
import 'package:app/modules/cars/providers/car.provider.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/shared/managers/permissions/permissions-car.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/modules/shared/widgets/image-viewer.widget.dart';
import 'package:app/modules/shared/widgets/pdf-viewer.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
  bool _initDone = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            margin: EdgeInsets.only(left: 10, top: 20, right: 10),
            child: Column(
              children: [
                _talonContainer(),
                if (PermissionsManager.getInstance().hasAccess(
                    MainPermissions.Cars, PermissionsCar.CREATE_CAR_EXTRA))
                  _exhaustContainer(),
                if (PermissionsManager.getInstance().hasAccess(
                    MainPermissions.Cars, PermissionsCar.CREATE_CAR_EXTRA))
                  _diagnosisContainer(),
                if (PermissionsManager.getInstance().hasAccess(
                    MainPermissions.Cars, PermissionsCar.CREATE_CAR_EXTRA))
                  _generalVerificationContainer()
              ],
            ),
          );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<CarProvider>(context);
      _loadData();
    }

    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider.getCarDocuments(_provider.carDetails.id).then((list) {
        for (CarDocument carDocument in list) {
          CarDocumentType type = CarDocumentTypeUtils.getType(carDocument.name);

          if (type != null) {
            switch (type) {
              case CarDocumentType.Talon:
                _provider.talon = carDocument;
                break;
              case CarDocumentType.GasTests:
                _provider.exhaust = carDocument;
                break;
              case CarDocumentType.Diagnosis:
                _provider.diagnosisProtocol = carDocument;
                break;
              case CarDocumentType.GeneralCheck:
                _provider.generalVerification = carDocument;
                break;
            }
          }
        }
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error.toString().contains(CarService.GET_CAR_DOCUMENTS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_car_documents, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _talonContainer() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () async {
          if (_provider.talon == null) {
            _getDocument(CarDocumentType.Talon);
          } else {
            _showDocument(_provider.talon);
          }
        },
        child: Row(
          children: [
            Icon(
              Icons.attach_file,
              color: _provider.talon == null ? gray2 : red,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  _provider.talon != null
                      ? _provider.talon.name
                      : S.of(context).car_create_talon,
                  style: TextHelper.customTextStyle(
                      color: _provider.talon != null ? red : gray2, size: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _exhaustContainer() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () async {
          if (_provider.exhaust == null) {
            _getDocument(CarDocumentType.GasTests);
          } else {
            _showDocument(_provider.exhaust);
          }
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
                  _provider.exhaust != null
                      ? _provider.exhaust.name
                      : S.of(context).car_create_exhaust_test,
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
          if (_provider.diagnosisProtocol == null) {
            _getDocument(CarDocumentType.Diagnosis);
          } else {
            _showDocument(_provider.diagnosisProtocol);
          }
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
                _provider.diagnosisProtocol != null
                    ? _provider.diagnosisProtocol.name
                    : S.of(context).car_create_diagnosis_protocol,
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
          if (_provider.generalVerification == null) {
            _getDocument(CarDocumentType.GeneralCheck);
          } else {
            _showDocument(_provider.generalVerification);
          }
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
                _provider.generalVerification != null
                    ? _provider.generalVerification.name
                    : S.of(context).car_create_general_car_verification,
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

  _getDocument(CarDocumentType type) async {
    File file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
    );

    if (file != null) {
      _loadDocument(CarDocument(file, CarDocumentTypeUtils.getName(type)));
    }
  }

  _showDocument(CarDocument document) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .getCarDocumentDetails(_provider.carDetails.id, document)
          .then((value) async {
        setState(() {
          _isLoading = false;
        });

        _showFile(value, document);
      });
    } catch (error) {
      if (error.toString().contains(CarService.CAR_ADD_DOCUMENT_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_car_document_details, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _showFile(String bytes, CarDocument carDocument) async {
    File file = await createFile(bytes, carDocument.fileName);

    // TODO - need to check image uploading / download
    // TODO - need to check pdf is not downloading
    // TODO - need to check doc file types

    switch (carDocument.getExtension()) {
      case 'pdf':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewer(
              pathPDF: file.path,
            ),
          ),
        );
        break;
      case 'jpg':
      case 'jpeg':
      case 'png':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewer(
              file: file,
              name: carDocument.name,
            ),
          ),
        );
        break;
    }
  }

  Future<File> createFile(String bytes, String name) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$name');
    await file.writeAsString(bytes);
    return file;
  }

  _loadDocument(CarDocument document) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .uploadDocument(_provider.carDetails.id, document)
          .then((item) {
        _loadData();
      });
    } catch (error) {
      if (error.toString().contains(CarService.CAR_ADD_DOCUMENT_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_add_car_document, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
