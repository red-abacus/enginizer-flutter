import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-color.model.dart';
import 'package:app/modules/cars/models/car-fuel.model.dart';
import 'package:app/modules/cars/models/car-model.model.dart';
import 'package:app/modules/cars/models/car-type.model.dart';
import 'package:app/modules/cars/models/car-variant.model.dart';
import 'package:app/modules/cars/models/car-year.model.dart';

class CarRequest {
  CarBrand carBrand;
  CarModel carModel;

  CarType carType;
  CarYear carYear;
  CarFuelType carFuelType;
  CarColor carColor;
  CarVariant carVariant;
  String vin;
  String registrationNumber;
  int mileage;

  DateTime rcaExpiryDate;
  bool rcaNotification;
  DateTime itpExpiryDate;
  bool itpNotification;

  CarRequest(
      {this.carBrand,
      this.carModel,
      this.carType,
      this.carYear,
      this.carFuelType,
      this.carColor,
      this.carVariant,
      this.vin,
      this.registrationNumber,
      this.mileage,
      this.rcaExpiryDate,
      this.rcaNotification,
      this.itpExpiryDate,
      this.itpNotification});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'make': carBrand.toJson(),
      'type': carModel.toJson(),
      'typeDetails': carType.toJson(),
      'year': carYear.toJson(),
      'fuelType': carFuelType.toJson(),
      'color': carColor.toJson(),
      'variant': carVariant.toJson(),
      'vin': vin,
      'registrationNumber': registrationNumber,
      'mileage': mileage,
      'itpExpireDate': itpExpiryDate.toIso8601String(),
      'rcaExpireDate': rcaExpiryDate.toIso8601String(),
    };

    return propMap;
  }
}
