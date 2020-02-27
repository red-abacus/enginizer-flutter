import 'package:enginizer_flutter/generated/l10n.dart';
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
}

enum TankQuantity { FULL, HALF, THIRD, QUARTER, RESERV }
