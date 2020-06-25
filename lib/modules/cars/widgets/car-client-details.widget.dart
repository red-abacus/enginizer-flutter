import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car-fuel-graphic.response.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/widgets/text_widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarClientDetailsWidget extends StatelessWidget {
  final Car car;
  final CarFuelGraphicResponse carFuelGraphicResponse;
  final Function openModalAddFuelConsumption;
  final Function uploadCarImageListener;
  final Function showCameraDialog;

  CarClientDetailsWidget(
      {this.car,
      this.carFuelGraphicResponse,
      this.openModalAddFuelConsumption,
      this.uploadCarImageListener,
      this.showCameraDialog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _contentWidget(context),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 1,
        onPressed: () => openModalAddFuelConsumption(),
        child: Icon(Icons.add),
      ),
    );
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
}
