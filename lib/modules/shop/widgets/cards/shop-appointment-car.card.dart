import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopAppointmentCarCard extends StatelessWidget {
  final Car car;
  final Function selectCar;
  final Car selectedCar;

  ShopAppointmentCarCard({this.car, this.selectCar, this.selectedCar});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: gray_80,
              offset: Offset(1.0, 1.0),
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Container(
          child: Material(
            color: Colors.white,
            child: InkWell(
              splashColor: Theme.of(context).primaryColor,
              onTap: () => this.selectCar(car),
              child: ClipRRect(
                child: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _imageContainer(),
                      _textContainer(),
                      _statusContainer(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  _imageContainer() {
    return Container(
      padding: EdgeInsets.all(10),
      width: 120,
      height: 100,
      child: Image.network(
        '${car.image}',
        fit: BoxFit.fitWidth,
      ),
    );
  }

  _textContainer() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        height: 80,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text('${car?.brand?.name}',
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 14)),
                Text('${car?.year?.name}',
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 12)),
                SizedBox(height: 10),
              ],
            ),
            Positioned(
              child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: Text('${car?.registrationNumber}',
                      style: TextStyle(
                          color: Colors.black87,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          fontSize: 12))),
            ),
          ],
        ),
      ),
    );
  }

  _statusContainer(BuildContext context) {
    return selectedCar == car ? Container(
      margin: EdgeInsets.only(right: 10),
      child: Icon(Icons.check_circle, color: red),
    ) : Container();
  }
}
