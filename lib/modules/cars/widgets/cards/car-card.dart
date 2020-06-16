import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-car.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarCard extends StatelessWidget {
  final Car car;
  final Function selectCar;
  final Function openAppointmentCreateModal;
  final Function sellCar;
  final Function rentCar;

  CarCard(
      {this.car,
      this.selectCar,
      this.openAppointmentCreateModal,
      this.sellCar,
      this.rentCar});

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
                                Expanded(
                                  child: Text(
                                      "${car.model.name} (${car.year.name})",
                                      style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text("${car.registrationNumber}",
                                        style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black87,
                                            fontSize: 14)),
                                  ),
                                ),
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
    List<Widget> list = [];

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Cars, PermissionsCar.SELL_CAR)) {
      list.add(FlatButton(
        padding: EdgeInsets.all(0),
        splashColor: Theme.of(context).primaryColor,
        onPressed: () => {this.sellCar(this.car)},
        child: Text(S.of(context).general_sell.toUpperCase(),
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                fontSize: 14)),
      ));
    }

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Cars, PermissionsCar.RENT_CAR)) {
      list.add(FlatButton(
        padding: EdgeInsets.all(0),
        splashColor: Theme.of(context).primaryColor,
        onPressed: () => {this.rentCar(this.car)},
        child: Text(S.of(context).general_rent.toUpperCase(),
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                fontSize: 14)),
      ));
    }

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Cars, PermissionsCar.APPOINTMENT_CAR)) {
      list.add(FlatButton(
        padding: EdgeInsets.all(0),
        splashColor: Theme.of(context).primaryColor,
        onPressed: () => {this.openAppointmentCreateModal(context, this.car)},
        child: Text(S.of(context).general_schedule.toUpperCase(),
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                fontSize: 14)),
      ));
    }

    if (list.length == 1) {
      list.insert(0, Spacer());
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, children: list),
    );
  }
}
