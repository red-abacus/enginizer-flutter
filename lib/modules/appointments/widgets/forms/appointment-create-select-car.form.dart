import 'package:enginizer_flutter/modules/appointments/widgets/appointment-create-select-car-list.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:enginizer_flutter/modules/cars/providers/car.provider.dart';
import 'package:enginizer_flutter/modules/cars/providers/cars.provider.dart';
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
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .55,
      child: Center(
        child: AppointmentCreateSelectCarList(
          cars: Provider.of<CarsProvider>(context, listen: false).cars,
          selectCar: _selectCar,
          selectedCar:
              Provider.of<CarProvider>(context, listen: false).selectedCar,
        ),
      ),
    );
  }

  void _selectCar(Car car) {
    setState(() {
      Provider.of<CarProvider>(context, listen: false).selectCar(car);
    });
  }

  bool valid() {
    return Provider.of<CarProvider>(context, listen: false).selectedCar != null;
  }
}
