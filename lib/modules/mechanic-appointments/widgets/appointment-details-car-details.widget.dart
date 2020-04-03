import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/widgets/text_widget.dart';
import 'package:app/modules/mechanic-appointments/providers/appointment-mechanic.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppointmentDetailsCarDetails extends StatefulWidget {
  AppointmentDetailsCarDetails();

  @override
  AppointmentDetailsCarDetailsState createState() {
    return AppointmentDetailsCarDetailsState();
  }
}

class AppointmentDetailsCarDetailsState
    extends State<AppointmentDetailsCarDetails> {
  AppointmentMechanicProvider appointmentMechanicProvider;

  @override
  Widget build(BuildContext context) {
    appointmentMechanicProvider =
        Provider.of<AppointmentMechanicProvider>(context, listen: false);

    Car car = appointmentMechanicProvider.selectedAppointmentDetails?.car;

    return car != null
        ? _buildCarDetails(context, car)
        : Center(
            child: Text(S.of(context).appointment_details_car_details_error));
  }

  Widget _buildCarDetails(BuildContext context, Car car) {
    return Container(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
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
                (car.brand?.name != null && car.model?.name != null)
                    ? Padding(
                        padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                        child: TextWidget(
                          "${car.brand?.name} - ${car.model?.name} ",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Container(),
                (car.year?.name != null && car.color?.name != null)
                    ? Padding(
                        padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                        child: TextWidget(
                          "${car.year?.name}, ${_translateColorName(car.color?.name)}",
                          fontSize: 14,
                        ),
                      )
                    : Container(),
                (car.power?.name != null && car.motor?.name != null)
                    ? Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 25),
                        child: TextWidget(
                            "${car.power?.name}, ${car.motor?.name}"))
                    : Container(),
                (car.mileage != null)
                    ? Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: TextWidget(
                            "${NumberFormat.decimalPattern().format(car.mileage)} KM"),
                      )
                    : Container(),
                (car.registrationNumber != null)
                    ? Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: TextWidget("${car.registrationNumber}"),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _translateColorName(String colorName) {
    switch (colorName) {
      case 'COLOR_RED':
        return S.of(context).COLOR_RED;
      case 'COLOR_BLACK':
        return S.of(context).COLOR_BLACK;
      case 'COLOR_GREEN':
        return S.of(context).COLOR_GREEN;
      case 'COLOR_SILVER':
        return S.of(context).COLOR_SILVER;
      case 'COLOR_WHITE':
        return S.of(context).COLOR_WHITE;
      case 'COLOR_GRAY':
        return S.of(context).COLOR_GRAY;
      case 'COLOR_DARK_BLUE':
        return S.of(context).COLOR_DARK_BLUE;
      case 'COLOR_DARK_GRAY':
        return S.of(context).COLOR_DARK_GRAY;
      case 'COLOR_GOLD':
        return S.of(context).COLOR_GOLD;
      default:
        return '';
    }
  }
}
