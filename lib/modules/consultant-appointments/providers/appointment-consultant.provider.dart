
import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/consultant-appointments/models/employee.dart';
import 'package:flutter/cupertino.dart';

class AppointmentConsultantProvider with ChangeNotifier {
  AppointmentsService appointmentsService = inject<AppointmentsService>();
  ProviderService providerService = inject<ProviderService>();

  Appointment selectedAppointment;
  AppointmentDetail selectedAppointmentDetail;
  List<ServiceProviderItem> serviceProviderItems = [];

  List<Employee> employees = [];

  Future<AppointmentDetail> getAppointmentDetails(
      Appointment appointment) async {
    selectedAppointmentDetail =
        await this.appointmentsService.getAppointmentDetails(appointment.id);
    notifyListeners();
    return selectedAppointmentDetail;
  }

  Future<List<ServiceProviderItem>> getProviderServices(int id) async {
    var response = await appointmentsService.getServiceProviderItems(id);
    serviceProviderItems = response.items;
    notifyListeners();
    return serviceProviderItems;
  }

  Future<List<Employee>> getProviderEmployees(
      int providerId, String startDate, String endDate) async {
    this.employees = await providerService.getProviderEmployees(
        providerId, startDate, endDate);
    notifyListeners();
    return this.employees;
  }

  Future<Appointment> cancelAppointment(Appointment appointment) async {
    selectedAppointment =
        await this.appointmentsService.cancelAppointment(appointment.id);
    notifyListeners();
    return selectedAppointment;
  }
}
