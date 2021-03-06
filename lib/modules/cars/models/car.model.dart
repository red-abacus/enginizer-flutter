import 'package:app/modules/cars/enums/car-status.enum.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-color.model.dart';
import 'package:app/modules/cars/models/car-cylinder-capacity.model.dart';
import 'package:app/modules/cars/models/fuel/car-fuel.model.dart';
import 'package:app/modules/cars/models/car-model.model.dart';
import 'package:app/modules/cars/models/car-power.model.dart';
import 'package:app/modules/cars/models/car-transmissions.model.dart';
import 'package:app/modules/cars/models/car-year.model.dart';
import 'package:app/utils/string.utils.dart';
import 'package:intl/intl.dart';

class Car {
  int id;
  String image;
  CarBrand brand;
  CarModel model;
  CarYear year;
  CarFuelType fuelType;
  CarCylinderCapacity motor;
  CarPower power;
  CarTransmission transmission;
  CarColor color;
  String vin;
  String registrationNumber;
  int mileage;
  DateTime itpExpireDate;
  DateTime rcaExpireDate;
  String fuelConsumption;
  int ownerId;
  int providerId;
  CarStatus status;

  Car(
      {this.id,
      this.image,
      this.brand,
      this.model,
      this.color,
      this.fuelType,
      this.motor,
      this.transmission,
      this.power,
      this.year,
      this.itpExpireDate,
      this.rcaExpireDate,
      this.vin,
      this.registrationNumber,
      this.mileage,
      this.fuelConsumption,
      this.ownerId,
      this.providerId,
      this.status});

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
        id: json['id'],
        image: json['image'],
        brand: json['brand'] != null ? CarBrand.fromJson(json['brand']) : null,
        model: json['model'] != null ? CarModel.fromJson(json['model']) : null,
        color: json['color'] != null ? CarColor.fromJson(json['color']) : null,
        fuelType: json['fuelType'] != null
            ? CarFuelType.fromJson(json['fuelType'])
            : null,
        motor: json['motor'] != null
            ? CarCylinderCapacity.fromJson(json['motor'])
            : null,
        transmission: json['transmission'] != null
            ? CarTransmission.fromJson(json['transmission'])
            : null,
        power: json['power'] != null ? CarPower.fromJson(json['power']) : null,
        year: json['year'] != null ? CarYear.fromJson(json['year']) : null,
        itpExpireDate: json['itpExpireDate'] != null
            ? DateFormat('dd/MM/yyyy').parse(json['itpExpireDate'])
            : null,
        rcaExpireDate: json['rcaExpireDate'] != null
            ? DateFormat('dd/MM/yyyy').parse(json['rcaExpireDate'])
            : null,
        vin: json['vin'] != null ? json['vin'] : '',
        registrationNumber: json['registrationNumber'] != null ? json['registrationNumber'] : '',
        mileage: json['mileage'] != null ? json['mileage'] : 0,
        fuelConsumption: json['fuelConsumption'] != null ? json['fuelConsumption'] : '',
        ownerId: json['ownerId'] != null ? json['ownerId'] : null,
        providerId: json['providerId'] != null ? json['providerId'] : null,
        status: json['status'] != null
            ? CarStatusUtils.statusFromString(json['status'])
            : null);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'image': image,
      'brand': brand.toJson(),
      'model': model.toJson(),
      'year': year.toJson(),
      'fuelType': fuelType.toJson(),
      'motor': motor.toJson(),
      'power': power.toJson(),
      'transmission': transmission.toJson(),
      'color': color.toJson(),
      'vin': vin,
      'registrationNumber': registrationNumber,
      'mileage': mileage,
      'itpExpireDate': itpExpireDate.toIso8601String(),
      'rcaExpireDate': rcaExpireDate.toIso8601String(),
      'fuelConsumption': fuelConsumption,
    };

    if (id != null) {
      propMap.putIfAbsent('id', () => id);
    }

    if (ownerId != null) {
      propMap.putIfAbsent('ownerid', () => ownerId);
    }

    if (providerId != null) {
      propMap.putIfAbsent('providerId', () => providerId);
    }

    return propMap;
  }

  bool filtered(String value) {
    var filtered = false;

    if (registrationNumber != null) {
      filtered = StringUtils.containsIgnoreCase(registrationNumber, value);
    }

    if (model != null) {
      if (model.name != null) {
        filtered =
            filtered || StringUtils.containsIgnoreCase(model.name, value);
      }
    }

    return filtered;
  }

  bool canEdit() {
    return status != CarStatus.Sold;
  }
}
