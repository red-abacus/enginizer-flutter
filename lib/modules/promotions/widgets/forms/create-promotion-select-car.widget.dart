import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/widgets/appointment-create-select-car-list.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/promotions/providers/create-promotion.provider.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePromotionSelectCarWidget extends StatefulWidget {
  CreatePromotionSelectCarWidget({Key key}) : super(key : key);

  @override
  CreatePromotionSelectCarWidgetState createState() =>
      CreatePromotionSelectCarWidgetState();
}

class CreatePromotionSelectCarWidgetState
    extends State<CreatePromotionSelectCarWidget> {
  CreatePromotionProvider _provider;

  bool _initDone = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : AppointmentCreateSelectCarList(
            cars: _provider.cars,
            selectCar: _selectCar,
            selectedCar: _provider.createPromotionRequest.car,
          );
  }

  @override
  Future<void> didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<CreatePromotionProvider>(context);
      _loadData();
    }

    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider.getCars().then((list) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error.toString().contains(CarService.CAR_GET_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_car_get, context);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectCar(Car currentCar) {
    setState(() {
      if (_provider.createPromotionRequest.car == currentCar) {
        _provider.createPromotionRequest.car = null;
      } else {
        _provider.createPromotionRequest.car = currentCar;
      }
    });
  }

  bool valid() {
    return _provider.createPromotionRequest.car != null;
  }
}
