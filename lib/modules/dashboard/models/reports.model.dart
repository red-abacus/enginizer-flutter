import 'package:app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class Reports {
  double itpCost;
  double productCost;
  double serviceCost;
  double insuranceCost;
  double fuelCost;

  Reports(
      {this.itpCost,
      this.productCost,
      this.serviceCost,
      this.insuranceCost,
      this.fuelCost});

  factory Reports.fromJson(Map<String, dynamic> json) {
    return Reports(
        itpCost: json['itpCost'] != null ? json['itpCost'] : 0.0,
        productCost: json['productCost'] != null ? json['productCost'] : 0.0,
        serviceCost: json['serviceCost'] != null ? json['serviceCost'] : 0.0,
        insuranceCost:
            json['insuranceCost'] != null ? json['insuranceCost'] : 0.0,
        fuelCost: json['fuelCost'] != null ? json['fuelCost'] : 0.0);
  }

  Map<String, dynamic> toJson(BuildContext context) {
    Map<String, double> dataMap = new Map();
    dataMap[S.of(context).dashboard_products] = this.productCost.toDouble();
    dataMap[S.of(context).dashboard_itp] = this.itpCost.toDouble();
    dataMap[S.of(context).dashboard_services] = this.serviceCost.toDouble();
    dataMap[S.of(context).dashboard_insurance] = this.insuranceCost.toDouble();
    dataMap[S.of(context).dashboard_fuel] = this.fuelCost.toDouble();
    return dataMap;
  }
}
