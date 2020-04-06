import 'package:app/modules/appointments/model/request/appointment-request.model.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/appointments/widgets/appointment-create-modal.widget.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/models/request/car-request.model.dart';
import 'package:app/modules/cars/providers/car.provider.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:app/modules/cars/providers/cars.provider.dart';
import 'package:app/modules/cars/widgets/car-create-modal.dart';
import 'package:app/modules/cars/widgets/cars-list.dart';
import 'package:app/utils/locale.manager.dart';
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
  String route;
  var _initDone = false;
  var _isLoading = false;

  CarsState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<CarsProvider>(
      builder: (context, carsProvider, _) => Scaffold(
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
      Provider.of<CarsProvider>(context).loadCars().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _initDone = true;
    super.didChangeDependencies();
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
                return CarCreateModal(addCar: _addCar);
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
                return AppointmentCreateModal(_createAppointment, false, selectedCar);
              });
        });
  }

  void _filterCars(BuildContext ctx, String filterValue) {
    Provider.of<CarsProvider>(ctx).loadCars(filterValue: filterValue);
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

  _addCar(CarRequest carRequest) {
    Provider.of<CarsProvider>(context).addCar(carRequest).then((_) {
      Navigator.pop(context);
    });
  }

  _createAppointment(AppointmentRequest appointmentRequest) {
    Provider.of<AppointmentsProvider>(context)
        .createAppointment(appointmentRequest)
        .then((_) {
      Navigator.pop(context);
    });
  }
}
