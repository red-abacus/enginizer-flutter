import 'dart:io';
import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car-fuel-graphic.response.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/cars/widgets/forms/car-fuel-consumption.form.dart';
import 'package:app/utils/api_response.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/providers/car.provider.dart';
import 'package:app/modules/cars/widgets/text_widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/snack_bar.helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:image_cropper/image_cropper.dart';

class CarDetails extends StatefulWidget {
  final String route = '/car';

  Car model;

  @override
  State<StatefulWidget> createState() {
    return CarDetailsState();
  }
}

class CarDetailsState extends State<CarDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Car model;
  File uploadImage;
  CarProvider carProvider;

  var _initDone = false;
  var _isLoading = true;

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _loadData();
    }
    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
    });

    carProvider = Provider.of<CarProvider>(context);

    try {
      await carProvider.getCarDetails().then((_) async {
        await carProvider.getCarFuelConsumptionGraphic().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    } catch (error) {
      if (error.toString().contains(CarService.CAR_FUEL_EXCEPITON)) {
        SnackBarManager.showSnackBar(S.of(context).general_error,
            S.of(context).exception_get_car_fuel, _scaffoldKey.currentState);

        setState(() {
          _isLoading = false;
        });
      } else if (error.toString().contains(CarService.CAR_DETAILS_EXCEPTION)) {
        SnackBarManager.showSnackBar(S.of(context).general_error,
            S.of(context).exception_get_car_details, _scaffoldKey.currentState);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${carProvider.selectedCar?.brand?.name}'),
        iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : showCarDetails(carProvider.carDetails),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 1,
        onPressed: () => openModalAddFuelConsumption(context),
        child: Icon(Icons.add),
      ),
    );
  }

  showPicture(car) {
    return (uploadImage == null)
        ? Image.network(
            '${car.image}',
            fit: BoxFit.contain,
            height: MediaQuery.of(context).size.height * 0.3,
          )
        : Image.file(
            uploadImage,
            fit: BoxFit.contain,
            height: MediaQuery.of(context).size.height * 0.3,
          );
  }

  showCarDetails(Car car) {
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
                    showChart(),
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

  showChart() {
    var now = DateTime.now();
    var fromDate = DateTime(now.year, now.month - 1, now.day);

    List<DataPoint> points = getGraphicData();

    return Center(
      child: Container(
        color: Colors.red,
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        child: BezierChart(
          bezierChartScale: BezierChartScale.WEEKLY,
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
    dataPoints.clear();
    CarFuelGraphicResponse response = carProvider?.carFuelGraphicResponse;

    if (response?.labels != null && response.labels.length > 0) {
      for (var i = 0; i < response.labels.length; i++) {
        if (response.datasets[i] != null && response.labels[i] != null)
          dataPoints.add(DataPoint<DateTime>(
              value: double.parse((response.datasets[i]).toString()),
              xAxis: DateTime(DateTime.now().year, DateTime.now().month - 1,
                  response.labels[i])));
      }
    }
    return dataPoints;
  }

  showCameraDialog() {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) => Container(
              padding: EdgeInsets.only(top: 50, bottom: 50),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Open Camera"),
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                  RaisedButton(
                    child: Text("Open Gallery"),
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                ],
              ),
            ));
  }

  void openModalAddFuelConsumption(BuildContext ctx) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return CarFuelConsumptionForm(
                createFuelConsumption: _createCarConsumption);
          });
        });
  }

  Future getImage(ImageSource imageSource) async {
    var image = await ImagePicker.pickImage(source: imageSource);
    if (image != null) {
      setState(() {
        uploadImage = image;
      });
      cropImage(image);
    }
  }

  cropImage(image) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop image',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null)
      carProvider.uploadImage(croppedFile);
    else
      carProvider.uploadImage(image);
  }

  uploadCarImageListener(car) {
    switch (carProvider.uploadImageAPI.status) {
      case Status.LOADING:
        return Container(
            padding: EdgeInsets.all(10),
            child: Center(
                child: Container(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            )));
        break;
      case Status.ERROR:
//        return Text(carProvider.getCarFuelConsumptionAPI.toString());
        return showPicture(car);
        break;
      case Status.COMPLETED:
        return showPicture(car);
        break;
    }
  }

  _createCarConsumption() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await carProvider?.getCarFuelConsumptionGraphic()?.then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    catch(error) {
      if (error.toString().contains(CarService.CAR_FUEL_EXCEPITON)) {
        SnackBarManager.showSnackBar(S
            .of(context)
            .general_error,
            S
                .of(context)
                .exception_get_car_fuel, _scaffoldKey.currentState);
      }
    }
  }
}
