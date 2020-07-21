import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/work-estimate-form/models/provider-payment.model.dart';
import 'package:flutter/cupertino.dart';

class PaymentProvider with ChangeNotifier {
  static String RETURN_URL = 'https://mobile.autowass.payment.ro';

  AppointmentsService _appointmentsService = inject<AppointmentsService>();

  ProviderPayment providerPayment;
  int appointmentId;

  initialise() {
    providerPayment = null;
  }

  Future<ProviderPayment> getPaymentProvider(
      String returnUrl, int appointmentId) async {
    try {
      providerPayment =
          await _appointmentsService.getPaymentProvider(returnUrl, appointmentId);
      notifyListeners();
      return providerPayment;
    } catch (error) {
      throw (error);
    }
  }
}
