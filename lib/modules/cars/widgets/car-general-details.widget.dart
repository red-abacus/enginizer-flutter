import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/widgets/text_widget.dart';
import 'package:app/utils/date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CarGeneralDetailsWidget extends StatelessWidget {
  final Car car;

  CarGeneralDetailsWidget({this.car});

  @override
  Widget build(BuildContext context) {
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
                (car.brand?.name != null)
                    ? Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, right: 20),
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
                    "${car.year?.name}, ${car.color.translateColorName(context)}",
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
                (car.vin != null)
                    ? Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextWidget('${S.of(context).cars_create_vin}: ${car.vin}'),
                )
                    : Container(),
                (car.registrationNumber != null)
                    ? Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextWidget("${car.registrationNumber}"),
                )
                    : Container(),
                (car.rcaExpireDate != null)
                    ? Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextWidget('${S.of(context).car_details_rca_availability} ${DateUtils.stringFromDate(car.rcaExpireDate, 'dd.MM.yyyy')}'),
                )
                    : Container(),
                (car.itpExpireDate != null)
                    ? Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextWidget('${S.of(context).car_details_itp_availability} ${DateUtils.stringFromDate(car.itpExpireDate, 'dd.MM.yyyy')}'),
                )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}