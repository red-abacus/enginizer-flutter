import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment-position.model.dart';
import 'package:app/modules/appointments/model/appointment/appointment-provider-type.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/model/response/service-providers-response.model.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/work-estimate-form/enums/work-estimate-accept-state.enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkEstimateAcceptProvider with ChangeNotifier {
  ProviderService _providerService = inject<ProviderService>();

  Map<int, dynamic> stepStateData;
  WorkEstimateAcceptState workEstimateAcceptState;
  AppointmentPosition appointmentPosition;

  List<ServiceProvider> serviceProviders = [];
  int _currentPage = 0;
  ServiceProviderResponse _serviceProviderResponse;
  final int _pageSize = 20;

  ServiceProvider selectedProvider;
  ServiceProviderItem pickupServiceItem;

  AppointmentProviderType appointmentProviderType;

  initialise() {
    selectedProvider = null;
    appointmentProviderType = AppointmentProviderType.Specific;
    pickupServiceItem = null;
    resetServiceProviderParams();

    workEstimateAcceptState = null;
    appointmentPosition = AppointmentPosition();

    stepStateData = {
      0: {"state": StepState.indexed, "active": true, "title": Text("")},
      1: {"state": StepState.disabled, "active": false, "title": Text("")},
      2: {"state": StepState.disabled, "active": false, "title": Text("")},
    };
  }

  resetServiceProviderParams() {
    serviceProviders = [];
    _currentPage = 0;
    _serviceProviderResponse = null;
  }

  Future<List<ServiceProvider>> loadProviders() async {
    if (_serviceProviderResponse != null) {
      if (_currentPage >= _serviceProviderResponse.totalPages) {
        return null;
      }
    }

    List<String> serviceNames = [pickupServiceItem.name];

    try {
      _serviceProviderResponse = await _providerService.getProviders(
          pageSize: _pageSize, page: _currentPage, serviceNames: serviceNames);
      serviceProviders.addAll(_serviceProviderResponse.items);
      _currentPage += 1;
      notifyListeners();
      return serviceProviders;
    } catch (error) {
      throw (error);
    }
  }
}
