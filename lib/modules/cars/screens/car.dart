import 'dart:io';
import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/cars/widgets/car-client-details.widget.dart';
import 'package:app/modules/cars/widgets/car-documents.widget.dart';
import 'package:app/modules/cars/widgets/car-recommendations.widget.dart';
import 'package:app/modules/cars/widgets/forms/car-fuel-consumption.form.dart';
import 'package:app/modules/shared/managers/permissions/permissions-car.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/modules/shared/widgets/image-picker.widget.dart';
import 'package:app/utils/api_response.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/providers/car.provider.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarDetails extends StatefulWidget {
  final String route = '/car';

  Car model;

  @override
  State<StatefulWidget> createState() {
    return CarDetailsState();
  }
}

class CarDetailsState extends State<CarDetails> with TickerProviderStateMixin {
  Car model;
  File uploadImage;
  CarProvider _provider;

  var _initDone = false;
  var _isLoading = true;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(
        vsync: this,
        length: PermissionsManager.getInstance()
                .hasAccess(MainPermissions.Cars, PermissionsCar.APPOINTMENT_CAR)
            ? 3
            : 2,
        initialIndex: 0);

    _tabController.addListener(() {
      if (_tabController.index == 2) {
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
        await _provider.getCarFuelConsumptionGraphic().then((_) async {
          _downloadCarHistory();
        });
      });
    } catch (error) {
      if (error.toString().contains(CarService.CAR_FUEL_EXCEPITON)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_car_fuel, context);
      } else if (error.toString().contains(CarService.CAR_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_car_details, context);
      }

      _downloadCarHistory();
    }
  }

  _downloadCarHistory() async {
    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Cars, PermissionsCar.APPOINTMENT_CAR)) {
      try {
        await _provider.getCarHistory(_provider.carDetails.id).then((_) async {
          setState(() {
            _isLoading = false;
          });
        });
      } catch (error) {
        if (error.toString().contains(CarService.CAR_HISTORY_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_car_history, context);
        }

        setState(() {
          _isLoading = false;
        });
      }
    } else {
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
            Tab(text: S.of(context).car_documents_title),
            if (PermissionsManager.getInstance().hasAccess(
                MainPermissions.Cars, PermissionsCar.APPOINTMENT_CAR))
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
      CarDocumentsWidget(),
    ];

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Cars, PermissionsCar.APPOINTMENT_CAR)) {
      list.add(CarRecommendationsWidget(carHistory: _provider.carHistory));
    }

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
        builder: (context) => ImagePickerWidget(imageSelected: (file) {
              if (file != null) {
                _provider.uploadImage(file);
              }
            }));
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
