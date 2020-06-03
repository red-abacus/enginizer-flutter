import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CarDetailsPartsWidget extends StatelessWidget {
  final Car car;

  CarDetailsPartsWidget(
      {this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20, top: 20, right: 20),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(bottom: 100),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Image.network(
                      '${car.image}',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (car.brand?.name != null)
                        ? Padding(
                      padding:
                      EdgeInsets.only(left: 20, top: 20, right: 20),
                      child: TextWidget(
                        "${car.brand?.name}",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : Container(),
                    (car.year?.name != null && car.color?.name != null)
                        ? Padding(
                      padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                      child: TextWidget(
                        "${car.year?.name}, ${car.color?.translateColorName(context)}",
                        fontSize: 14,
                      ),
                    )
                        : Container(),
                    (car.power?.name != null && car.motor?.name != null)
                        ? Padding(
                        padding:
                        EdgeInsets.only(left: 20, right: 20, top: 25),
                        child: TextWidget(
                            "${car.power?.name}, ${car.motor?.name}"))
                        : Container(),
                    (car.mileage != null)
                        ? Padding(
                      padding:
                      EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: TextWidget(
                          "${NumberFormat.decimalPattern().format(car.mileage)} KM"),
                    )
                        : Container()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
