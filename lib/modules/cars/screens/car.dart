import 'dart:io';
import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/cars/widgets/car-client-details.widget.dart';
import 'package:app/modules/cars/widgets/car-recommendations.widget.dart';
import 'package:app/modules/cars/widgets/forms/car-fuel-consumption.form.dart';
import 'package:app/utils/api_response.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/providers/car.provider.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';

class CarDetails extends StatefulWidget {
  final String route = '/car';

  Car model;

  @override
  State<StatefulWidget> createState() {
    return CarDetailsState();
  }
}

class CarDetailsState extends State<CarDetails>
    with SingleTickerProviderStateMixin {
  Car model;
  File uploadImage;
  CarProvider _provider;

  var _initDone = false;
  var _isLoading = true;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2, initialIndex: 0);

    _tabController.addListener(() {
      if (_tabController.index == 1) {
        _provider.selectedInterventions = [];
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

    _provider = Provider.of<CarProvider>(context);

    try {
      await _provider.getCarDetails().then((_) async {
        await _provider.getCarHistory(_provider.carDetails.id).then((_) async {
          await _provider.getCarFuelConsumptionGraphic().then((_) {
            setState(() {
              _isLoading = false;
            });
          });
        });
      });
    } catch (error) {
      if (error.toString().contains(CarService.CAR_FUEL_EXCEPITON)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_car_fuel, context);

        setState(() {
          _isLoading = false;
        });
      } else if (error.toString().contains(CarService.CAR_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_car_details, context);
      } else if (error.toString().contains(CarService.CAR_HISTORY_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_car_history, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_provider.selectedCar?.brand?.name}'),
        iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: S.of(context).car_details_title),
            Tab(text: S.of(context).car_service_recommendations_title),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildContent(),
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

  _buildContent() {
    List<Widget> list = [
      CarClientDetailsWidget(
        car: _provider.carDetails,
        carFuelGraphicResponse: _provider.carFuelGraphicResponse,
        openModalAddFuelConsumption: _openModalAddFuelConsumption,
        uploadCarImageListener: _uploadCarImageListener,
        showCameraDialog: _showCameraDialog,
      ),
      CarRecommendationsWidget(carHistory: _provider.carHistory)
    ];

    return TabBarView(
      controller: _tabController,
      children: list,
    );
  }

  _showCameraDialog() {
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

  _openModalAddFuelConsumption() {
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
      _provider.uploadImage(croppedFile);
    else
      _provider.uploadImage(image);
  }

  _uploadCarImageListener(car) {
    switch (_provider.uploadImageAPI.status) {
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
      await _provider?.getCarFuelConsumptionGraphic()?.then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error.toString().contains(CarService.CAR_FUEL_EXCEPITON)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_car_fuel, context);
      }
    }
  }
}
