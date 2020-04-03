import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/utils/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarCard extends StatelessWidget {
  final Car car;
  final Function selectCar;
  final Function openAppointmentCreateModal;

  CarCard({this.car, this.selectCar, this.openAppointmentCreateModal});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Material(
          elevation: 1,
          color: Colors.white,
          borderRadius: new BorderRadius.circular(5.0),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              InkWell(
                splashColor: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
                onTap: () => this.selectCar(context, this.car),
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.network(
                        '${car.image}',
                        fit: BoxFit.fill,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${car.model.name} (${car.year.name})",
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${car.registrationNumber}",
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black87,
                                        fontSize: 14)),
                              ],
                            ),
                            SizedBox(height: 36),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _scheduleButton(context)
            ],
          ),
        ),
      );
    });
  }

  _scheduleButton(BuildContext context) {
    return AppConfig.of(context).enviroment == Enviroment.Dev
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FlatButton(
                  padding: EdgeInsets.all(0),
                  splashColor: Theme.of(context).primaryColor,
                  onPressed: () =>
                      {this.openAppointmentCreateModal(context, this.car)},
                  child: Text('SCHEDULE',
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                ),
              ],
            ),
          )
        : Container();
  }
}
