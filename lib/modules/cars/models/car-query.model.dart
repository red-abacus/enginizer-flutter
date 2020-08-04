import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-color.model.dart';
import 'package:app/modules/cars/models/car-cylinder-capacity.model.dart';
import 'package:app/modules/cars/models/fuel/car-fuel.model.dart';
import 'package:app/modules/cars/models/car-model.model.dart';
import 'package:app/modules/cars/models/car-power.model.dart';
import 'package:app/modules/cars/models/car-transmissions.model.dart';
import 'package:app/modules/cars/models/car-type.model.dart';
import 'package:app/modules/cars/models/car-year.model.dart';
import 'package:app/utils/locale.manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_launcher_icons/constants.dart';

class CarQuery {
  String language;
  CarBrand brand;
  CarModel model;
  CarType carType;
  CarYear year;
  CarFuelType fuelType;
  CarCylinderCapacity cylinderCapacity;
  CarPower power;
  CarTransmission transmission;
  CarColor color;

  CarQuery(
      {this.language,
      this.brand,
      this.model,
      this.carType,
      this.year,
      this.fuelType,
      this.cylinderCapacity,
      this.power,
      this.transmission,
      this.color});
}
