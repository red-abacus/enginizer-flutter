import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-details.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/modules/appointments/services/appointments.service.dart';
import 'package:enginizer_flutter/modules/appointments/services/provider.service.dart';
import 'package:enginizer_flutter/modules/auctions/models/auction.model.dart';
import 'package:flutter/cupertino.dart';

class AuctionConsultantProvider with ChangeNotifier {
  AppointmentsService appointmentsService = inject<AppointmentsService>();
  ProviderService providerService = inject<ProviderService>();

  Auction selectedAuction;
  AppointmentDetail appointmentDetails;

  Future<AppointmentDetail> getAppointmentDetails(int appointmentId) async {
    appointmentDetails =
    await this.appointmentsService.getAppointmentDetails(appointmentId);
    notifyListeners();
    return appointmentDetails;
  }


  Future<ServiceProvider> getServiceProviderDetails(int providerId) async {
    return await this.providerService.getProviderDetails(providerId);
  }
}
