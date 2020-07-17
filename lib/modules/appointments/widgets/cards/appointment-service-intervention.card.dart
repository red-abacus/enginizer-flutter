import 'package:app/modules/cars/models/recommendations/car-intervention-product.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentServiceInterventionCard extends StatelessWidget {
  final CarInterventionProduct carInterventionProduct;

  AppointmentServiceInterventionCard({this.carInterventionProduct});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Expanded(
              child: Text(
                carInterventionProduct.name,
                style: TextHelper.customTextStyle(color: red),
              ),
            )
          ],
        ),
      ),
    );
  }
}
