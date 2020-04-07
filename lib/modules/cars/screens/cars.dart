import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/request/appointment-request.model.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/appointments/widgets/appointment-create-modal.widget.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/providers/car.provider.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:app/modules/cars/providers/cars.provider.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/cars/widgets/car-create-modal.dart';
import 'package:app/modules/cars/widgets/cars-list.dart';
import 'package:app/utils/snack_bar.helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cars extends StatefulWidget {
  static const String route = '/cars';
  static final IconData icon = Icons.directions_car;

  @override
  State<StatefulWidget> createState() {
    return CarsState(route: route);
  }
}

class CarsState extends State<Cars> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String route;
  var _initDone = false;
  var _isLoading = false;

  CarsState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<CarsProvider>(
      builder: (context, carsProvider, _) => Scaffold(
          key: _scaffoldKey,
          body: Center(child: _renderCars(_isLoading, carsProvider.cars)),
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 1,
            onPressed: () => _openCarCreateModal(context),
            child: Icon(Icons.add),
          )),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      _loadData();
    }
    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await Provider.of<CarsProvider>(context).loadCars().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error.toString().contains(CarService.CAR_GET_EXCEPTION)) {
        SnackBarManager.showSnackBar(S.of(context).general_error,
            S.of(context).exception_car_get, _scaffoldKey.currentState);

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _openCarCreateModal(BuildContext ctx) {
    Provider.of<CarsMakeProvider>(context).initParams();

    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return CarCreateModal();
          });
        });
  }

  void _openAppointmentCreateModal(BuildContext ctx, Car selectedCar) {
    Provider.of<ProviderServiceProvider>(context).initFormValues();

    Provider.of<ProviderServiceProvider>(context, listen: false).loadServices();

    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AppointmentCreateModal(
                _createAppointment, false, selectedCar);
          });
        });
  }

  Future<void> _filterCars(BuildContext ctx, String filterValue) async {
    try {
      await Provider.of<CarsProvider>(ctx).loadCars(filterValue: filterValue);
    }
    catch (error) {
      if (error.toString() == CarService.CAR_GET_EXCEPTION) {
        SnackBarManager.showSnackBar(S.of(context).general_error,
            S.of(context).exception_car_get, _scaffoldKey.currentState);
      }
    }
  }

  void _selectCar(BuildContext ctx, Car selectedCar) {
    Provider.of<CarProvider>(ctx).selectCar(selectedCar);
    Navigator.of(ctx).pushNamed(
      '/cars/details',
    );
  }

  _renderCars(bool _isLoading, List<Car> cars) {
    return _isLoading
        ? CircularProgressIndicator()
        : CarList(
            cars: cars,
            filterCars: _filterCars,
            selectCar: _selectCar,
            openAppointmentCreateModal: _openAppointmentCreateModal);
  }

  _createAppointment(AppointmentRequest appointmentRequest) {
    Provider.of<AppointmentsProvider>(context)
        .createAppointment(appointmentRequest)
        .then((_) {
      Navigator.pop(context);
    });
  }
}
