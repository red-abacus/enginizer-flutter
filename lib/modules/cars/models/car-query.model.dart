import 'package:enginizer_flutter/modules/cars/models/car-brand.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car-color.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car-cylinder-capacity.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car-fuel.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car-model.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car-power.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car-transmissions.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car-year.model.dart';

class CarQuery {
  CarBrand brand;
  CarModel model;
  CarYear year;
  CarFuelType fuelType;
  CarCylinderCapacity cylinderCapacity;
  CarPower power;
  CarTransmission transmission;
  CarColor color;

  CarQuery(
      {this.brand,
      this.model,
      this.year,
      this.fuelType,
      this.cylinderCapacity,
      this.power,
      this.transmission,
      this.color});
}
