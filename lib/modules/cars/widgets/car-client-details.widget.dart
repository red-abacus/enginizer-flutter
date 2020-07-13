import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/enums/car-status.enum.dart';
import 'package:app/modules/cars/models/car-fuel-graphic.response.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/widgets/text_widget.dart';
import 'package:app/modules/shared/managers/permissions/permissions-car.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/presentation/custom_icons.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CarClientDetailsWidget extends StatelessWidget {
  final Car car;
  final CarFuelGraphicResponse carFuelGraphicResponse;
  final Function openModalAddFuelConsumption;
  final Function uploadCarImageListener;
  final Function showCameraDialog;
  final Function markAsSold;
  final Function sellCar;
  final Function rentCar;

  CarClientDetailsWidget(
      {this.car,
      this.carFuelGraphicResponse,
      this.openModalAddFuelConsumption,
      this.uploadCarImageListener,
      this.showCameraDialog,
      this.markAsSold,
      this.sellCar,
      this.rentCar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _contentWidget(context),
        floatingActionButton: _floatingActionButtons(context));
  }

  _contentWidget(BuildContext context) {
    return Material(
      elevation: 1,
      color: Colors.grey[200],
      borderRadius: new BorderRadius.circular(5.0),
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(10.0),
                    child: Container(
                        color: Colors.white,
                        child: uploadCarImageListener(car)),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (car.brand?.name != null && car.model?.name != null)
                        ? Padding(
                            padding:
                                EdgeInsets.only(top: 20, left: 20, right: 20),
                            child: TextWidget(
                              "${car.brand?.name} - ${car.model?.name} ",
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Container(),
                    (car.year?.name != null && car.color?.name != null)
                        ? Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: TextWidget(
                              '${car.year?.name}, ${car.color?.name}',
                              color: gray2,
                            ),
                          )
                        : Container(),
                    (car.power?.name != null && car.motor?.name != null)
                        ? _carDetailsContainer(
                            '${car.power?.name}CP, ${car.motor?.name}')
                        : Container(),
                    (car.mileage != null)
                        ? _carDetailsContainer('${car.mileage}KM')
                        : Container(),
                    (car.vin != null)
                        ? _carDetailsContainer('VIN: ${car.vin}')
                        : Container(),
                    (car.registrationNumber != null)
                        ? _carDetailsContainer('${car.registrationNumber}')
                        : Container(),
                    (car.rcaExpireDate != null)
                        ? _carDetailsContainer(
                            '${S.of(context).car_details_rca_availability}: ${DateUtils.stringFromDate(car.rcaExpireDate, 'dd.MM.yyyy')}')
                        : Container(),
                    (car.itpExpireDate != null)
                        ? _carDetailsContainer(
                            '${S.of(context).car_details_itp_availability}: ${DateUtils.stringFromDate(car.itpExpireDate, 'dd.MM.yyyy')}')
                        : Container(),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    showChart(context),
                  ],
                ),
              ],
            ),
            Container(
              alignment: Alignment.topRight,
              child: FlatButton(
                padding: EdgeInsets.all(30),
                splashColor: Theme.of(context).primaryColor,
                onPressed: () async {
                  showCameraDialog();
                },
                child: TextWidget(
                  'Upload Image',
                  color: Theme.of(context).accentColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _carDetailsContainer(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 5),
      child: TextWidget(
        text,
        color: gray2,
      ),
    );
  }

  showChart(BuildContext context) {
    var now = DateTime.now();
    var fromDate = DateTime(now.year, now.month - 1, now.day);

    List<DataPoint> points = getGraphicData();

    return Center(
      child: Container(
        color: Colors.red,
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
// TODO
//        child: BezierChart(
//          bezierChartScale: BezierChartScale.WEEKLY,
//          fromDate: fromDate,
//          toDate: now,
//          selectedDate: now,
//          series: [
//            BezierLine(label: "Consum", data: points),
//          ],
//          config: BezierChartConfig(
//            verticalIndicatorStrokeWidth: 3.0,
//            verticalIndicatorColor: Colors.black26,
//            showVerticalIndicator: true,
//            verticalIndicatorFixedPosition: false,
//            backgroundColor: Colors.red,
//            footerHeight: 35.0,
//          ),
//        ),
      ),
    );
  }

  List<DataPoint> getGraphicData() {
    List<DataPoint> dataPoints = [];
    dataPoints.clear();

    if (carFuelGraphicResponse?.labels != null &&
        carFuelGraphicResponse.labels.length > 0) {
      for (var i = 0; i < carFuelGraphicResponse.labels.length; i++) {
        if (carFuelGraphicResponse.datasets[i] != null &&
            carFuelGraphicResponse.labels[i] != null)
          dataPoints.add(DataPoint<DateTime>(
              value:
                  double.parse((carFuelGraphicResponse.datasets[i]).toString()),
              xAxis: DateTime(DateTime.now().year, DateTime.now().month - 1,
                  carFuelGraphicResponse.labels[i])));
      }
    }
    return dataPoints;
  }

  _floatingActionButtons(BuildContext context) {
    var buttons = List<SpeedDialChild>();

    if (PermissionsManager.getInstance()
            .hasAccess(MainPermissions.Cars, PermissionsCar.SELL_CAR) &&
        car.status == CarStatus.Pending) {
      buttons.add(SpeedDialChild(
          child: Icon(Custom.car_sell),
          foregroundColor: red,
          backgroundColor: Colors.white,
          label: S.of(context).general_sell,
          labelStyle: TextHelper.customTextStyle(
              color: Colors.grey, weight: FontWeight.bold, size: 16),
          onTap: () => sellCar(this.car)));
    }

    if (PermissionsManager.getInstance()
            .hasAccess(MainPermissions.Cars, PermissionsCar.RENT_CAR) &&
        car.status == CarStatus.Pending) {
      buttons.add(SpeedDialChild(
          child: Icon(Custom.car_rent),
          foregroundColor: red,
          backgroundColor: Colors.white,
          label: S.of(context).general_rent,
          labelStyle: TextHelper.customTextStyle(
              color: Colors.grey, weight: FontWeight.bold, size: 16),
          onTap: () => rentCar(this.car)));
    }

    buttons.add(SpeedDialChild(
        child: Icon(Icons.local_gas_station),
        foregroundColor: red,
        backgroundColor: Colors.white,
        label: S.of(context).car_add_fuel_consumption,
        labelStyle: TextHelper.customTextStyle(
            color: Colors.grey, weight: FontWeight.bold, size: 16),
        onTap: () => openModalAddFuelConsumption()));

    return SpeedDial(
      marginRight: 18,
      marginBottom: 20,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      visible: true,
      closeManually: false,
      curve: Curves.linear,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: S.of(context).estimator_open_menu,
      heroTag: 'open-menu-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: buttons,
    );
  }

/*
  Container(
        margin: EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (car.status == CarStatus.ForSell)
              FloatingActionButton.extended(
                heroTag: null,
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 1,
                onPressed: () => this.markAsSold(),
                label: Text(
                  S.of(context).car_mark_as_sold,
                  style:
                      TextHelper.customTextStyle(color: Colors.white, size: 12),
                ),
              ),
            if (car.status == CarStatus.ForSell) Spacer(),
            FloatingActionButton(
              heroTag: null,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 1,
              onPressed: () => openModalAddFuelConsumption(),
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
   */
}
