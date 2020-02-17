import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-details.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-item.dart';
import 'package:enginizer_flutter/modules/appointments/services/appointments.service.dart';
import 'package:flutter/cupertino.dart';

class AppointmentConsultantProvider with ChangeNotifier {
  AppointmentsService appointmentsService = inject<AppointmentsService>();

  Appointment selectedAppointment;
  AppointmentDetail selectedAppointmentDetail;
  List<ServiceProviderItem> serviceProviderItems = [];

  Future<AppointmentDetail> getAppointmentDetails(
      Appointment appointment) async {
    selectedAppointmentDetail =
        await this.appointmentsService.getAppointmentDetails(appointment.id);
    notifyListeners();
    return selectedAppointmentDetail;
  }

  Future<List<ServiceProviderItem>> getProviderServices(int id) async {
    var response =
        await appointmentsService.getServiceProviderItems(id);
    print("items ${response.items}");
    serviceProviderItems = response.items;
    notifyListeners();
    return serviceProviderItems;
  }
}
