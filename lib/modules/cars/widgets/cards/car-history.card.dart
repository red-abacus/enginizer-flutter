import 'package:app/modules/cars/models/recommendations/car-history.model.dart';
import 'package:app/modules/cars/models/recommendations/car-intervention.model.dart';
import 'package:app/modules/cars/providers/car.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarHistoryCard extends StatelessWidget {
  final CarHistory carHistory;
  final Function selectIntervention;

  CarHistoryCard({this.carHistory, this.selectIntervention});

  @override
  Widget build(BuildContext context) {
    CarProvider provider = Provider.of<CarProvider>(context);

    List<Widget> widgets = [_appointmentContainer()];

    for (int i = 0; i < carHistory.interventions.length; i++) {
      CarIntervention intervention = carHistory.interventions[i];
      widgets.add(_interventionContainer(
          intervention, provider.selectedInterventions.contains(intervention)));

      if (i != carHistory.interventions.length - 1) {
        widgets.add(Divider());
      }
    }
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: widgets,
      ),
    );
  }

  _appointmentContainer() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      color: gray_10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              carHistory.appointmentName,
              style: TextHelper.customTextStyle(color: red, weight: FontWeight.bold),
            ),
          ),
          Text(
            carHistory.appointmentScheduledDateTime != null
                ? DateUtils.stringFromDate(
                    carHistory.appointmentScheduledDateTime, 'dd MMMM yyyy')
                : '',
            style: TextHelper.customTextStyle(color: gray3),
          )
        ],
      ),
    );
  }

  _interventionContainer(CarIntervention intervention, bool selected) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: InkWell(
        onTap: () {
          selectIntervention(intervention);
        },
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                intervention.name,
                style: TextHelper.customTextStyle(
                    color: gray3, weight: FontWeight.bold, size: 14),
              ),
              Icon(selected ? Icons.check_box : Icons.check_box_outline_blank,
                  color: red)
            ],
          ),
        ),
      ),
    );
  }
}
