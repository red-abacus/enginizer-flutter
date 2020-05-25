import 'package:app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class TankQuantityUtils {
  static String titleForTankQuantity(
      BuildContext context, TankQuantity tankQuantity) {
    switch (tankQuantity) {
      case TankQuantity.FULL:
        return S.of(context).appointment_consultant_car_form_tank_quantity_full;
      case TankQuantity.HALF:
        return S.of(context).appointment_consultant_car_form_tank_quantity_half;
      case TankQuantity.THIRD:
        return S
            .of(context)
            .appointment_consultant_car_form_tank_quantity_third;
      case TankQuantity.QUARTER:
        return S
            .of(context)
            .appointment_consultant_car_form_tank_quantity_quarter;
      case TankQuantity.RESERV:
        return S
            .of(context)
            .appointment_consultant_car_form_tank_quantity_reserv;
    }

    return '';
  }

  static List<TankQuantity> tankQuantities() {
    return [
      TankQuantity.FULL,
      TankQuantity.HALF,
      TankQuantity.THIRD,
      TankQuantity.QUARTER,
      TankQuantity.RESERV
    ];
  }

  static int quantity(TankQuantity quantity) {
    switch (quantity) {
      case TankQuantity.FULL:
        return 100;
      case TankQuantity.HALF:
        return 50;
      case TankQuantity.THIRD:
        return 33;
      case TankQuantity.QUARTER:
        return 25;
      case TankQuantity.RESERV:
        return 0;
    }
  }
}

enum TankQuantity { FULL, HALF, THIRD, QUARTER, RESERV }
