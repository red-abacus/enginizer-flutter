
import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-details.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/services/appointments.service.dart';
import 'package:enginizer_flutter/modules/appointments/services/provider.service.dart';
import 'package:enginizer_flutter/modules/auctions/models/request/work-estimate-request.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/work-estimate-details.model.dart';
import 'package:enginizer_flutter/modules/auctions/services/work-estimates.service.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/models/employee.dart';
import 'package:flutter/cupertino.dart';

class AppointmentConsultantProvider with ChangeNotifier {
  AppointmentsService appointmentsService = inject<AppointmentsService>();
  ProviderService providerService = inject<ProviderService>();
  WorkEstimatesService _workEstimatesService = inject<WorkEstimatesService>();

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

  Future<WorkEstimateDetails> createWorkEstimate(int appointmentId, int carId,
      int clientId, WorkEstimateRequest workEstimateRequest) async {
    Map<String, dynamic> content = workEstimateRequest.toCreateJson();

    WorkEstimateDetails workEstimateDetails =
        await _workEstimatesService.addNewWorkEstimate(content);
    notifyListeners();
    return workEstimateDetails;
  }
}
