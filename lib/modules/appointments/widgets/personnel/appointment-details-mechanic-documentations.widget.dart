import 'dart:convert';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/documentation/car-documentation-document.model.dart';
import 'package:app/modules/appointments/model/documentation/car-documentation-topic.model.dart';
import 'package:app/modules/appointments/providers/appointment-mechanic.provider.dart';
import 'package:app/modules/appointments/widgets/cards/appointment-documentation-topic.card.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/shared/widgets/pdf-viewer.widget.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/locale.manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:io';

class AppointmentDetailsMechanicDocumentationsWidget extends StatefulWidget {
  AppointmentDetailsMechanicDocumentationsWidget();

  @override
  _AppointmentDetailsMechanicDocumentationsWidgetState createState() {
    return _AppointmentDetailsMechanicDocumentationsWidgetState();
  }
}

class _AppointmentDetailsMechanicDocumentationsWidgetState
    extends State<AppointmentDetailsMechanicDocumentationsWidget> {
  AppointmentMechanicProvider _provider;

  CarDocumentationTopic _selectedCarDocumentationTopic;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    _provider =
        Provider.of<AppointmentMechanicProvider>(context, listen: false);

    List<CarDocumentationTopic> topics = _provider.topics;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : topics.isNotEmpty
            ? _buildTopicsWidget()
            : Center(
                child: Text(S
                    .of(context)
                    .appointment_details_documentation_topics_error));
  }

  _buildTopicsWidget() {
    return ListView.builder(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 40, top: 10),
        shrinkWrap: true,
        itemCount: _provider.topics.length,
        itemBuilder: (context, index) {
          return AppointmentDocumentationTopicCard(
            carDocumentationTopic: _provider.topics[index],
            selectedCarDocumentationTopic: _selectedCarDocumentationTopic,
            selectCarDocumentationTopic: _selectCarDocumentationTopic,
            selectCarDocument: _selectCarDocument,
          );
        });
  }

  _selectCarDocumentationTopic(
      CarDocumentationTopic carDocumentationTopic) async {
    if (this._selectedCarDocumentationTopic == carDocumentationTopic) {
      setState(() {
        this._selectedCarDocumentationTopic = null;
      });
    } else {
      if (carDocumentationTopic.document != null) {
        setState(() {
          this._selectedCarDocumentationTopic = carDocumentationTopic;
        });
      } else {
        setState(() {
          _isLoading = true;
        });

        try {
          await _provider
              .getCarDocumentationDocument(_provider.selectedAppointment.car.id,
                  LocaleManager.language(context), carDocumentationTopic)
              .then((value) {
            setState(() {
              this._selectedCarDocumentationTopic = carDocumentationTopic;
              _isLoading = false;
            });
          });
        } catch (error) {
          if (error
              .toString()
              .contains(CarService.CAR_DOCUMENTATION_DOCUMENT_EXCEPTION)) {
            FlushBarHelper.showFlushBar(
                S.of(context).general_error,
                S.of(context).exception_car_documentation_document_exception,
                context);
          }

          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  _selectCarDocument(CarDocumentationDocument document) async {
    setState(() {
      _isLoading = true;
    });

    File file = await createFileOfPdfUrl(document.value);

    if (file != null) {
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewer(
            name: document.description,
            pathPDF: file.path,
          ),
        ),
      );
    }
  }

  Future<File> createFileOfPdfUrl(String bytes) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    List<int> pdfBytes = base64.decode(bytes);
    File file = new File('$dir/test.pdf');
    await file.writeAsBytes(pdfBytes);
    return file;
  }
}
