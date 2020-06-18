import 'package:app/modules/appointments/model/documentation/car-documentation-document.model.dart';
import 'package:app/modules/appointments/model/documentation/car-documentation-topic.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentDocumentationTopicCard extends StatelessWidget {
  final CarDocumentationTopic carDocumentationTopic;
  final CarDocumentationTopic selectedCarDocumentationTopic;
  final Function selectCarDocumentationTopic;
  final Function selectCarDocument;

  AppointmentDocumentationTopicCard(
      {this.carDocumentationTopic,
      this.selectedCarDocumentationTopic,
      this.selectCarDocumentationTopic,
      this.selectCarDocument});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [_topicContainer()];

    if (selectedCarDocumentationTopic == carDocumentationTopic) {
      widgets.add(_documentContainer(selectedCarDocumentationTopic.document));
    }

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: widgets,
      ),
    );
  }

  _topicContainer() {
    return GestureDetector(
      onTap: () => selectCarDocumentationTopic(carDocumentationTopic),
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        color: gray_20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                carDocumentationTopic.description,
                style: TextHelper.customTextStyle(color: gray3),
              ),
            ),
            Icon(
                this.carDocumentationTopic == this.selectedCarDocumentationTopic
                    ? Icons.arrow_drop_down
                    : Icons.arrow_drop_up),
          ],
        ),
      ),
    );
  }

  _documentContainer(CarDocumentationDocument document) {
    return GestureDetector(
      onTap: () => {selectCarDocument(document)},
      child: Container(
        padding: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                document.description,
                style: TextHelper.customTextStyle(
                    color: red, weight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
