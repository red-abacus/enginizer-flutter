import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/enums/car-status.enum.dart';
import 'package:app/modules/cars/models/fuel/car-fuel-graphic-month.model.dart';
import 'package:app/modules/cars/models/fuel/car-fuel-graphic-year.model.dart';
import 'package:app/modules/cars/models/fuel/car-fuel-graphic.response.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/models/request/car-fuel-request.model.dart';
import 'package:app/modules/cars/widgets/text_widget.dart';
import 'package:app/modules/shared/managers/permissions/permissions-car.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/modules/shared/widgets/datepicker.widget.dart';
import 'package:app/presentation/custom_icons.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CarClientDetailsWidget extends StatefulWidget {
  final Car car;
  final CarFuelGraphicResponse carFuelGraphicResponse;
  final Function openModalAddFuelConsumption;
  final Function uploadCarImageListener;
  final Function showCameraDialog;
  final Function markAsSold;
  final Function sellCar;
  final Function rentCar;
  final Function downloadCarFuel;
  final CarFuelRequest carFuelRequest;

  CarClientDetailsWidget(
      {this.car,
      this.carFuelGraphicResponse,
      this.openModalAddFuelConsumption,
      this.uploadCarImageListener,
      this.showCameraDialog,
      this.markAsSold,
      this.sellCar,
      this.rentCar,
      this.carFuelRequest,
      this.downloadCarFuel});

  @override
  State<StatefulWidget> createState() {
    return _CarClientDetailsWidgetState();
  }
}

class _CarClientDetailsWidgetState extends State<CarClientDetailsWidget> {
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
            Padding(
              padding: EdgeInsets.only(bottom: 60),
              child: Column(
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
                          child: widget.uploadCarImageListener(widget.car)),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (widget.car.brand?.name != null &&
                              widget.car.model?.name != null)
                          ? Padding(
                              padding:
                                  EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: TextWidget(
                                "${widget.car.brand?.name} - ${widget.car.model?.name} ",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Container(),
                      (widget.car.year?.name != null &&
                              widget.car.color?.name != null)
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: TextWidget(
                                '${widget.car.year?.name}, ${widget.car.color?.name}',
                                color: gray2,
                              ),
                            )
                          : Container(),
                      (widget.car.power?.name != null &&
                              widget.car.motor?.name != null)
                          ? _carDetailsContainer(
                              '${widget.car.power?.name}CP, ${widget.car.motor?.name}')
                          : Container(),
                      (widget.car.mileage != null)
                          ? _carDetailsContainer('${widget.car.mileage}KM')
                          : Container(),
                      (widget.car.vin != null)
                          ? _carDetailsContainer('VIN: ${widget.car.vin}')
                          : Container(),
                      (widget.car.registrationNumber != null)
                          ? _carDetailsContainer(
                              '${widget.car.registrationNumber}')
                          : Container(),
                      (widget.car.rcaExpireDate != null)
                          ? _carDetailsContainer(
                              '${S.of(context).car_details_rca_availability}: ${DateUtils.stringFromDate(widget.car.rcaExpireDate, 'dd.MM.yyyy')}')
                          : Container(),
                      (widget.car.itpExpireDate != null)
                          ? _carDetailsContainer(
                              '${S.of(context).car_details_itp_availability}: ${DateUtils.stringFromDate(widget.car.itpExpireDate, 'dd.MM.yyyy')}')
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      _chartButtons(context),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${S.of(context).car_details_average} ${widget.carFuelGraphicResponse.fuelConsumption} ${S.of(context).car_details_average_liters}',
                                textAlign: TextAlign.center,
                                style: TextHelper.customTextStyle(
                                    color: gray3, size: 16),
                              ),
                            )
                          ],
                        ),
                      ),
                      showChart(context),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              child: FlatButton(
                padding: EdgeInsets.all(30),
                splashColor: Theme.of(context).primaryColor,
                onPressed: () async {
                  widget.showCameraDialog();
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

  _chartButtons(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(right: 5),
                height: 60,
                child: BasicDateField(
                  dateTime: this.widget.carFuelRequest.startDate,
                  maxDate: this.widget.carFuelRequest.endDate,
                  labelText: S.of(context).dashboard_start_date,
                  onChange: (value) {
                    this.widget.carFuelRequest.startDate = value;

                    if (this.widget.downloadCarFuel != null) {
                      this.widget.downloadCarFuel();
                    }
                  },
                ),
              )),
          Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 5),
                height: 60,
                child: BasicDateField(
                  dateTime: this.widget.carFuelRequest.endDate,
                  minDate: this.widget.carFuelRequest.startDate,
                  maxDate: DateTime.now(),
                  labelText: S.of(context).dashboard_end_date,
                  onChange: (value) {
                    this.widget.carFuelRequest.endDate = value;

                    if (this.widget.downloadCarFuel != null) {
                      this.widget.downloadCarFuel();
                    }
                  },
                ),
              )),
        ],
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
        child: BezierChart(
          bezierChartScale: widget.carFuelGraphicResponse?.chartScale() ??
              BezierChartScale.WEEKLY,
          fromDate: fromDate,
          toDate: now,
          selectedDate: now,
          series: [
            BezierLine(label: "Consum", data: points),
          ],
          config: BezierChartConfig(
            verticalIndicatorStrokeWidth: 3.0,
            verticalIndicatorColor: Colors.black26,
            showVerticalIndicator: true,
            verticalIndicatorFixedPosition: false,
            backgroundColor: Colors.red,
            footerHeight: 35.0,
          ),
        ),
      ),
    );
  }

  List<DataPoint> getGraphicData() {
    List<DataPoint> dataPoints = [];

    for (CarFuelGraphicYear year
        in widget.carFuelGraphicResponse.carFuelGraphicInfo.years) {
      for (CarFuelGraphicMonth month in year.months) {
        for(int i=0; i<month.labels.length; i++) {
          if (i < month.datasets.length) {
            dataPoints.add(DataPoint<DateTime>(
                value: month.datasets[i],
                xAxis:
                DateTime(int.parse(year.year), int.parse(month.month), month.labels[i])));
          }
        }
      }
    }

    return dataPoints;
  }

  _floatingActionButtons(BuildContext context) {
    var buttons = List<SpeedDialChild>();

    if (PermissionsManager.getInstance()
            .hasAccess(MainPermissions.Cars, PermissionsCar.SELL_CAR) &&
        widget.car.status == CarStatus.Pending) {
      buttons.add(SpeedDialChild(
          child: Icon(Custom.car_sell),
          foregroundColor: red,
          backgroundColor: Colors.white,
          label: S.of(context).general_sell,
          labelStyle: TextHelper.customTextStyle(
              color: Colors.grey, weight: FontWeight.bold, size: 16),
          onTap: () => widget.sellCar(this.widget.car)));
    }

    if (PermissionsManager.getInstance()
            .hasAccess(MainPermissions.Cars, PermissionsCar.RENT_CAR) &&
        widget.car.status == CarStatus.Pending) {
      buttons.add(SpeedDialChild(
          child: Icon(Custom.car_rent),
          foregroundColor: red,
          backgroundColor: Colors.white,
          label: S.of(context).general_rent,
          labelStyle: TextHelper.customTextStyle(
              color: Colors.grey, weight: FontWeight.bold, size: 16),
          onTap: () => widget.rentCar(this.widget.car)));
    }

    if (widget.car.status == CarStatus.ForSell) {
      buttons.add(SpeedDialChild(
          child: Icon(Icons.attach_money),
          foregroundColor: red,
          backgroundColor: Colors.white,
          label: S.of(context).car_mark_as_sold,
          labelStyle: TextHelper.customTextStyle(
              color: Colors.grey, weight: FontWeight.bold, size: 16),
          onTap: () => this.widget.markAsSold()));
    }

    buttons.add(SpeedDialChild(
        child: Icon(Icons.local_gas_station),
        foregroundColor: red,
        backgroundColor: Colors.white,
        label: S.of(context).car_add_fuel_consumption,
        labelStyle: TextHelper.customTextStyle(
            color: Colors.grey, weight: FontWeight.bold, size: 16),
        onTap: () => widget.openModalAddFuelConsumption()));

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
}
