import 'package:app/modules/cars/models/recommendations/car-history.model.dart';
import 'package:app/modules/cars/models/recommendations/car-intervention.model.dart';
import 'package:app/modules/cars/providers/car.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'appointment-service-interventions.card.dart';

class AppointmentServiceHistoryCard extends StatelessWidget {
  final CarHistory carHistory;
  final CarHistory selectedCarHistory;
  final CarIntervention selectedCarIntervention;
  final Function selectCarHistory;
  final Function selectCarIntervention;

  AppointmentServiceHistoryCard(
      {this.carHistory,
      this.selectedCarHistory,
      this.selectCarHistory,
      this.selectedCarIntervention,
      this.selectCarIntervention});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [_appointmentContainer()];

    if (selectedCarHistory == carHistory) {
      widgets.add(ListView.builder(
          padding: EdgeInsets.only(left: 10),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: carHistory.interventions.length,
          itemBuilder: (context, index) {
            return AppointmentServiceInterventionsCard(
              carIntervention: carHistory.interventions[index],
              selectCarIntervention: this.selectCarIntervention,
              selectedCarIntervention: selectedCarIntervention,
            );
          }));
    }

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: widgets,
      ),
    );
  }

  _appointmentContainer() {
    return GestureDetector(
      onTap: () => selectCarHistory(carHistory),
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        color: gray_20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                carHistory.appointmentScheduledDateTime != null
                    ? DateUtils.stringFromDate(
                        carHistory.appointmentScheduledDateTime, 'dd MMMM yyyy')
                    : '',
                style: TextHelper.customTextStyle(color: gray3),
              ),
            ),
            if (this.carHistory.interventions.length > 0)
              Icon(this.carHistory == this.selectedCarHistory
                  ? Icons.arrow_drop_down
                  : Icons.arrow_drop_up),
          ],
        ),
      ),
    );
  }
}
