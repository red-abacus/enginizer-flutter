import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/work-estimate-form/models/provider-payment.model.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:flutter/cupertino.dart';

class PaymentProvider with ChangeNotifier {
  AppointmentsService _appointmentsService = inject<AppointmentsService>();
  ProviderService _providerService = inject<ProviderService>();
  WorkEstimatesService _workEstimateService = inject<WorkEstimatesService>();

  static String RETURN_URL = 'https://mobile.autowass.payment.ro';

  ProviderPayment providerPayment;

  int appointmentId;
  int workEstimateId;

  initialise() {
    providerPayment = null;
    appointmentId = null;
    workEstimateId = null;
  }

  Future<bool> providerHasPayment(int providerId) async {
    try {
      bool response = await _providerService.providerHasPayment(providerId);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }

  Future<ProviderPayment> getAppointmentPayment(
      String returnUrl, int appointmentId) async {
    try {
      providerPayment = await _appointmentsService.getAppointmentPayment(
          returnUrl, appointmentId);
      notifyListeners();
      return providerPayment;
    } catch (error) {
      throw (error);
    }
  }

  Future<ProviderPayment> getWorkEstimatePayment(
      String returnUrl, int appointmentId) async {
    try {
       providerPayment = await _workEstimateService.getWorkEstimatePayment(
          returnUrl, appointmentId);
      notifyListeners();
      return providerPayment;
    } catch (error) {
      throw (error);
    }
  }
}
