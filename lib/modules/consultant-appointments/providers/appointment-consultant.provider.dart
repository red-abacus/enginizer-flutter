import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment-provider-type.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/model/response/service-providers-response.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/models/work-estimate-details.model.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:app/modules/consultant-appointments/models/employee.dart';
import 'package:flutter/cupertino.dart';

class AppointmentConsultantProvider with ChangeNotifier {
  final AppointmentsService appointmentsService = inject<AppointmentsService>();
  final ProviderService _providerService = inject<ProviderService>();
  final WorkEstimatesService _workEstimatesService =
      inject<WorkEstimatesService>();

  Appointment selectedAppointment;
  AppointmentDetail selectedAppointmentDetail;
  WorkEstimateDetails workEstimateDetails;
  List<ServiceProviderItem> serviceProviderItems = [];

  AppointmentProviderType appointmentProviderType =
      AppointmentProviderType.Specific;
  ServiceProviderResponse _serviceProviderResponse;
  List<ServiceProvider> serviceProviders = [];
  int serviceProviderResponsePage = 0;
  ServiceProvider selectedServiceProvider;

  List<Employee> employees = [];

  bool initDone = false;

  initialise() {
    initDone = false;
    selectedAppointment = null;
    selectedAppointmentDetail = null;
    serviceProviderItems = [];
    _serviceProviderResponse = null;
    appointmentProviderType = AppointmentProviderType.Specific;
    serviceProviderResponsePage = 0;
    serviceProviders = [];
    selectedServiceProvider = null;
  }

  Future<AppointmentDetail> getAppointmentDetails(
      Appointment appointment) async {
    try {
      selectedAppointmentDetail =
          await this.appointmentsService.getAppointmentDetails(appointment.id);
      notifyListeners();
      return selectedAppointmentDetail;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<ServiceProviderItem>> getProviderServices(int id) async {
    try {
      var response = await _providerService.getProviderServiceItems(id);
      serviceProviderItems = response.items;
      notifyListeners();
      return serviceProviderItems;
    } catch (error) {
      throw (error);
    }
  }

  Future<Appointment> cancelAppointment(Appointment appointment) async {
    try {
      selectedAppointment =
          await this.appointmentsService.cancelAppointment(appointment.id);
      notifyListeners();
      return selectedAppointment;
    } catch (error) {
      throw (error);
    }
  }

  Future<WorkEstimateDetails> getWorkEstimateDetails(int workEstimateId) async {
    try {
      workEstimateDetails = await this
          ._workEstimatesService
          .getWorkEstimateDetails(workEstimateId);
      notifyListeners();
      return workEstimateDetails;
    } catch (error) {
      throw (error);
    }
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
}
