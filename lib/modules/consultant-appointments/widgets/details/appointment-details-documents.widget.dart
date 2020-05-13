import 'package:app/modules/consultant-appointments/widgets/cards/appointment-document.card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsDocumentsWidget extends StatefulWidget {
  @override
  _AppointmentDetailsDocumentsWidgetState createState() {
    return _AppointmentDetailsDocumentsWidgetState();
  }
}

class _AppointmentDetailsDocumentsWidgetState
    extends State<AppointmentDetailsDocumentsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 10, right: 20, left: 20),
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return AppointmentDocumentCard();
              },
            ),
          ),
        )
      ],
    );
  }

  _content() {
    return Container();
  }
}
