import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentCarCard extends StatelessWidget {
  final Car car;
  final Function selectCar;
  final Car selectedCar;

  AppointmentCarCard({this.car, this.selectCar, this.selectedCar});

  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Material(
          elevation: 1,
          color: Colors.white,
          borderRadius: new BorderRadius.circular(5.0),
          child: InkWell(
            splashColor: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
            onTap: () => selectCar(this.car),
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    '${car.image}',
                    fit: BoxFit.fitHeight,
                    height: 100,
                    width: 100,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text("${car.registrationNumber}",
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        height: 1.5)),
                              ),
                              if (this.car == this.selectedCar)
                                Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).accentColor,
                                  size: 24.0,
                                  semanticLabel: 'Selected car check',
                                ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${car.brand.name} ${car.year.name}",
                                style: TextHelper.customTextStyle(
                                    null, Colors.grey, null, 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
