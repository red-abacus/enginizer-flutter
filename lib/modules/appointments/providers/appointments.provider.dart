import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/services/appointments.service.dart';
import 'package:flutter/widgets.dart';

class AppointmentsProvider with ChangeNotifier {
  List<Appointment> _appointments = [];
  List<ServiceItem> _serviceItems = [];

  Map<String, dynamic> serviceFormState = {'id': null, 'name': null};

  AppointmentsService appointmentsService = inject<AppointmentsService>();

  List<Appointment> get appointments {
    return _appointments;
  }

  Future<List<Appointment>> loadAppointments() async {
    var response = await this.appointmentsService.getAppointments();
    _appointments = response.items;

    notifyListeners();
    return _appointments;
  }

  Future<List<ServiceItem>> loadServices() async {
    _serviceItems = await appointmentsService.getServices();
    return _serviceItems;
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    var newAppointment = await this.appointmentsService.createAppointment(appointment);
    _appointments.add(newAppointment);
    notifyListeners();
    return newAppointment;
  }
}
