import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/appointments/widgets/appointment-create-select-car-list.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/providers/cars.provider.dart';
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
  CarsProvider carsProvider;
  ProviderServiceProvider providerServiceProvider;

  @override
  Widget build(BuildContext context) {
    carsProvider = Provider.of<CarsProvider>(context);
    providerServiceProvider = Provider.of<ProviderServiceProvider>(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height * .55,
      child: Center(
        child: AppointmentCreateSelectCarList(
          cars: carsProvider.cars,
          selectCar: _selectCar,
          selectedCar: providerServiceProvider.selectedCar,
        ),
      ),
    );
  }

  void _selectCar(Car currentCar) {
    setState(() {
      if (providerServiceProvider.selectedCar == currentCar) {
        providerServiceProvider.selectedCar = null;
      } else {
        providerServiceProvider.selectedCar = currentCar;
      }
    });
  }

  bool valid() {
    return providerServiceProvider.selectedCar != null;
  }
}
