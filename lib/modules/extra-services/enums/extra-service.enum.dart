import 'package:app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class ExtraServiceUtils {
  static String title(ExtraService extraService, BuildContext context) {
    switch (extraService) {
      case ExtraService.GasStation:
        return S.of(context).map_services_gas_station;
      case ExtraService.Atm:
        return S.of(context).map_services_atm;
      case ExtraService.Accommodation:
        return S.of(context).map_services_accommodation;
      case ExtraService.ServiceUnits:
        return S.of(context).map_services_service_auto;
    }

    return '';
  }

  static String value(ExtraService extraService) {
    switch (extraService) {
      case ExtraService.GasStation:
        return 'Gas stations';
      case ExtraService.Atm:
        return 'ATM';
      case ExtraService.Accommodation:
        return 'Accommodations';
      case ExtraService.ServiceUnits:
        return 'Service Auto';
    }

    return '';
  }

  static List<ExtraService> getList() {
    return [
      ExtraService.GasStation,
      ExtraService.Atm,
      ExtraService.Accommodation,
      ExtraService.ServiceUnits
    ];
  }
}

enum ExtraService { GasStation, Atm, Accommodation, ServiceUnits }
