import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/appointments/providers/appointments.provider.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/appointment-create-modal.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:enginizer_flutter/modules/cars/providers/car.provider.dart';
import 'package:enginizer_flutter/modules/cars/providers/cars-make.provider.dart';
import 'package:enginizer_flutter/modules/cars/providers/cars.provider.dart';
import 'package:enginizer_flutter/modules/cars/widgets/car-create-modal.dart';
import 'package:enginizer_flutter/modules/cars/widgets/cars-list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Cars extends StatefulWidget {
  static const String route = '/cars';
  static final IconData icon = Icons.card_travel;
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
    Provider.of<CarsMakeProvider>(context).loadCarBrands();
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
                return CarCreateModal(
                    brands: Provider.of<CarsMakeProvider>(context).brands,
                    addCar: _addCar);
              });
        });
  }
  void _openAppointmentCreateModal(BuildContext ctx, Car car) {
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
                  serviceItems:
                  Provider.of<ProviderServiceProvider>(context, listen: false).serviceItems,
                  createAppointment: _createAppointment,
                );
              });
        });
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
        selectCar: _selectCar,
        openAppointmentCreateModal: _openAppointmentCreateModal);
  }
  _addCar(Car car) {
    Provider.of<CarsProvider>(context).addCar(car).then((_) {
      Navigator.pop(context);
    });
  }
  _createAppointment(Appointment appointment) {
    Provider.of<AppointmentsProvider>(context)
        .createAppointment(appointment)
        .then((_) {
      Navigator.pop(context);
    });
  }
}