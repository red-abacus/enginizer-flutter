import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment-provider-type.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/model/response/service-providers-response.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:flutter/cupertino.dart';

class SelectPartsProviderProvider with ChangeNotifier {
  final AppointmentsService _appointmentsService =
      inject<AppointmentsService>();
  final ProviderService _providerService = inject<ProviderService>();

  AppointmentDetail selectedAppointmentDetails;

  AppointmentProviderType auctionType = AppointmentProviderType.Specific;
  List<ServiceProvider> serviceProviders = [];
  ServiceProviderResponse _serviceProviderResponse;

  int serviceProviderResponsePage = 0;

  ServiceProvider selectedServiceProvider;

  resetParams() {
    serviceProviderResponsePage = 0;
    auctionType = AppointmentProviderType.Specific;
    serviceProviders = [];
    selectedServiceProvider = null;
  }

  Future<List<ServiceProvider>> loadProviders() async {
    if (_serviceProviderResponse != null &&
        serviceProviderResponsePage >= _serviceProviderResponse.totalPages) {
      return null;
    }

    try {
      _serviceProviderResponse = await _providerService.getProviders(
          serviceNames: ['DISMANTLING_SHOP', 'PART_SHOP'],
          page: serviceProviderResponsePage);
      notifyListeners();
      this.serviceProviders.addAll(_serviceProviderResponse.items);
      serviceProviderResponsePage += 1;
      return this.serviceProviders;
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> requestAppointmentItems(
      int appointmentId, int providerId) async {
    try {
      bool response = await _appointmentsService.requestAppointmentItems(
          appointmentId, providerId);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }
}
