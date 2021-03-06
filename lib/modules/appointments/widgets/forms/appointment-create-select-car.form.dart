import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/appointments/widgets/appointment-create-select-car-list.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AppointmentCreateSelectCarForm extends StatefulWidget {
  AppointmentCreateSelectCarForm({Key key}) : super(key: key);

  @override
  AppointmentCreateSelectCarFormState createState() =>
      AppointmentCreateSelectCarFormState();
}

class AppointmentCreateSelectCarFormState
    extends State<AppointmentCreateSelectCarForm> {
  ProviderServiceProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<ProviderServiceProvider>(context);

    return AppointmentCreateSelectCarList(
      cars: _provider.cars,
      selectCar: _selectCar,
      selectedCar: _provider.selectedCar,
    );
  }

  void _selectCar(Car currentCar) {
    setState(() {
      if (_provider.selectedCar == currentCar) {
        _provider.selectedCar = null;
      } else {
        _provider.selectedCar = currentCar;
      }
    });
  }

  bool valid() {
    return _provider.selectedCar != null;
  }
}
