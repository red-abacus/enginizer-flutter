import 'package:app/modules/appointments/widgets/cards/appointment-service.intervention.card.dart';
import 'package:app/modules/cars/models/recommendations/car-intervention.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentServiceInterventionsCard extends StatelessWidget {
  final CarIntervention carIntervention;
  final CarIntervention selectedCarIntervention;
  final Function selectCarIntervention;

  AppointmentServiceInterventionsCard(
      {this.carIntervention,
      this.selectedCarIntervention,
      this.selectCarIntervention});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [_appointmentContainer()];

    if (selectedCarIntervention == carIntervention) {
      widgets.add(
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          shrinkWrap: true,
          itemCount: carIntervention.products.length,
          itemBuilder: (context, index) {
            return AppointmentServiceInterventionCard(
                carInterventionProduct: carIntervention.products[index]);
          },
        ),
      );
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
      onTap: () => selectCarIntervention(carIntervention),
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        color: gray_10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                carIntervention.name,
                style: TextHelper.customTextStyle(color: gray3),
              ),
            ),
            if (this.carIntervention.products.length > 0)
              Icon(this.carIntervention == this.selectedCarIntervention
                  ? Icons.arrow_drop_down
                  : Icons.arrow_drop_up),
          ],
        ),
      ),
    );
  }
}
